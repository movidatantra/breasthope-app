import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart' as cam;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as thum;

class ExerciseDeteksiController extends GetxController {
  late Interpreter interpreter;
  List<String> labels = [];

  cam.CameraController? cameraController;
  List<cam.CameraDescription> cameras = [];
  int selectedCameraIndex = 0;
  final isCameraInitialized = false.obs;

  final predictedLabel = 'unknown'.obs;
  final predictionConfidence = 0.0.obs;
  final showLandmarks = RxList<PoseLandmark>();
  final repetitions = <String, int>{}.obs;

  Timer? detectionTimer;
  final mode = ''.obs;
  final pickedVideo = Rxn<File>();

  final poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );

  final box = GetStorage();
  final apiUrl = 'https://b1b0f5bd8b81.ngrok-free.app/pose_history';

  String lastDetected = '';
  bool isDetected = false;

  @override
  void onInit() {
    super.onInit();
    loadModel();
  }

  @override
  void onClose() {
    stopCamera();
    interpreter.close();
    poseDetector.close();
    detectionTimer?.cancel();
    super.onClose();
  }

  Future<void> loadModel() async {
    try {
      interpreter =
          await Interpreter.fromAsset('assets/image/models/model.tflite');
      final labelData =
          await rootBundle.loadString('assets/image/labels/label.txt');
      labels = labelData.split('\n').where((e) => e.trim().isNotEmpty).toList();
      for (var label in labels) {
        repetitions[label] = 0;
      }
      debugPrint('✅ Model loaded: \${labels.length} labels');
    } catch (e) {
      debugPrint('❌ Failed to load model: \$e');
    }
  }

  Future<void> startCamera() async {
    try {
      mode.value = 'camera';
      cameras = await cam.availableCameras();
      selectedCameraIndex = cameras
          .indexWhere((c) => c.lensDirection == cam.CameraLensDirection.back);
      await initializeCamera(selectedCameraIndex);
    } catch (e) {
      debugPrint('❌ Error starting camera: \$e');
    }
  }

  Future<void> initializeCamera(int index) async {
    try {
      final selectedCamera = cameras[index];
      cameraController = cam.CameraController(
        selectedCamera,
        cam.ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: cam.ImageFormatGroup.yuv420,
      );
      await cameraController!.initialize();
      isCameraInitialized.value = true;
      debugPrint('📷 Camera initialized');

      detectionTimer =
          Timer.periodic(Duration(seconds: 2), (_) => captureAndPredict());
    } catch (e) {
      debugPrint('❌ Failed to initialize camera: \$e');
    }
  }

  Future<void> stopCamera() async {
    detectionTimer?.cancel();
    await cameraController?.dispose();
    cameraController = null;
    isCameraInitialized.value = false;
    predictedLabel.value = 'unknown';
    predictionConfidence.value = 0.0;
    showLandmarks.clear();
  }

  Future<void> captureAndPredict() async {
    if (cameraController == null || !cameraController!.value.isInitialized)
      return;
    try {
      final picture = await cameraController!.takePicture();
      final inputImage = InputImage.fromFile(File(picture.path));
      final result = await getPosePrediction(inputImage);

      if (result != null) {
        predictedLabel.value = result['label'];
        predictionConfidence.value = result['confidence'];
        showLandmarks.assignAll(result['landmarks']);

        if (predictedLabel.value == lastDetected) {
          if (!isDetected) {
            repetitions[predictedLabel.value] =
                (repetitions[predictedLabel.value] ?? 0) + 1;
            isDetected = true;
          }
        } else {
          isDetected = false;
        }
        lastDetected = predictedLabel.value;

        await saveToHistory(predictedLabel.value);
      } else {
        predictedLabel.value = 'Tidak terdeteksi';
        predictionConfidence.value = 0.0;
        showLandmarks.clear();
      }
    } catch (e) {
      debugPrint('❌ Error during detection: \$e');
    }
  }

  Future<Map<String, dynamic>?> getPosePrediction(InputImage inputImage) async {
    try {
      final poses = await poseDetector.processImage(inputImage);
      if (poses.isEmpty) return null;

      final pose = poses.first;
      final input = <double>[];

      for (var lmType in PoseLandmarkType.values) {
        final lm = pose.landmarks[lmType];
        input.addAll(lm != null ? [lm.x, lm.y] : [0.0, 0.0]);
      }

      while (input.length < 132) {
        input.addAll(List.filled(2, 0.0));
      }

      final reshapedInput = List.generate(
        1,
        (_) => List.generate(
          11,
          (i) => List.generate(6, (j) {
            final idx = (i * 6 + j) * 2;
            return [input[idx], input[idx + 1]];
          }),
        ),
      );

      final outputTensor = interpreter.getOutputTensor(0);
      final output =
          List.generate(1, (_) => List.filled(outputTensor.shape[1], 0.0));
      interpreter.run(reshapedInput, output);

      final predictions = output[0];
      final maxValue = predictions.reduce((a, b) => a > b ? a : b);
      final maxIndex = predictions.indexOf(maxValue);
      final label = (maxIndex >= 0 && maxIndex < labels.length)
          ? labels[maxIndex]
          : 'unknown';

      return {
        'label': label,
        'confidence': maxValue,
        'landmarks': pose.landmarks.values.toList(),
      };
    } catch (e) {
      debugPrint('❌ Error during pose prediction: \$e');
      return null;
    }
  }

  Future<void> saveToHistory(String label) async {
    final token = box.read('token');
    if (token == null) {
      debugPrint("❌ Token tidak ditemukan");
      return;
    }

    final double akurasi = predictionConfidence.value * 100;
    final int repetisi = repetitions[label] ?? 0;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'label': label,
          'mode': mode.value,
          'akurasi': akurasi,
          'repetisi': repetisi,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ History berhasil disimpan.");
      } else {
        debugPrint("❌ Gagal simpan history: ${response.statusCode}");
        debugPrint("📝 Pesan: ${response.body}");
      }
    } catch (e) {
      debugPrint("❌ Error simpan history: $e");
    }
  }

  Future<void> pickVideo() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickVideo(source: ImageSource.gallery);

      if (picked == null) return;

      pickedVideo.value = File(picked.path);
      mode.value = 'upload';

      predictedLabel.value = 'Analisis belum didukung untuk video';
      predictionConfidence.value = 0.0;
    } catch (e) {
      debugPrint('❌ Gagal memproses video: \$e');
      rethrow;
    }
  }

  void resetMode() {
    mode.value = '';
    predictedLabel.value = 'unknown';
    predictionConfidence.value = 0.0;
    pickedVideo.value = null;
    repetitions.clear();
    stopCamera();
  }

  Future<void> switchCamera() async {
    if (cameras.isEmpty) cameras = await cam.availableCameras();
    selectedCameraIndex = (selectedCameraIndex + 1) % cameras.length;
    await stopCamera();
    await initializeCamera(selectedCameraIndex);
  }
}
