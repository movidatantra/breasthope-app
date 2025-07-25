import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:get/get.dart';
import 'pose_detection_view.dart';
import 'exercise_list_view.dart';

class TutorialVideoView extends StatefulWidget {
  final GerakanSenam gerakan;

  const TutorialVideoView({super.key, required this.gerakan});

  @override
  State<TutorialVideoView> createState() => _TutorialVideoViewState();
}

class _TutorialVideoViewState extends State<TutorialVideoView> {
  late YoutubePlayerController _youtubeController;

  @override
  void initState() {
    final videoId = YoutubePlayer.convertUrlToId(widget.gerakan.youtubeUrl)!;

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(controller: _youtubeController),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Tutorial: ${widget.gerakan.nama}",
                style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.pink,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  player,
                  const SizedBox(height: 20),
                  Text(
                    "Deskripsi:",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.gerakan.deskripsi,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      _youtubeController.pause();
                      Get.to(() =>
                          PoseDetectionView(namaGerakan: widget.gerakan.nama));
                    },
                    icon: const Icon(Icons.fitness_center),
                    label: const Text("Lanjutkan ke Deteksi"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
