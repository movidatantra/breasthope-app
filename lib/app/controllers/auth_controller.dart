import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kanker_payudara/app/modules/history/controllers/history_controller.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final baseUrl = 'https://b1b0f5bd8b81.ngrok-free.app';

  static const _clientId =
      '343645304952-eitv56ilddlmotcli22nhl2nbg0og2b2.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = kIsWeb
      ? GoogleSignIn(scopes: ['email'])
      : GoogleSignIn(
          scopes: ['email'],
          serverClientId: _clientId,
        );

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final box = GetStorage();

  var isLoggedIn = false.obs;
  var isLoading = false.obs;

  var userName = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var role = 'General'.obs;
  var profilePicture = ''.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final verifyOtpController = TextEditingController();
  final newPassController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (box.read('token') != null) _restoreSession();
  }

  Future<void> login(String mail, String pass) async {
    try {
      isLoading.value = true;
      final String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$mail:$pass'));
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Authorization': basicAuth},
      );
      isLoading.value = false;

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        _persistSession(data);
        Get.offAllNamed(Routes.HOME);
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.find<HistoryController>().fetchHistory();
        });
      } else if (res.statusCode == 403) {
        Get.snackbar('Verifikasi', data['message']);
        Get.toNamed('/verify-email', arguments: {'email': mail});
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        isLoading.value = false;
        return;
      }

      final googleAuth = await account.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        isLoading.value = false;
        Get.snackbar('Error', 'ID-token Google kosong');
        return;
      }

      final res = await http.post(
        Uri.parse('$baseUrl/login_google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );
      isLoading.value = false;

      if (res.statusCode == 200) {
        _persistSession(jsonDecode(res.body));
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Gagal',
          jsonDecode(res.body)['message'] ?? 'Login Google gagal (server)',
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Password & konfirmasi tidak cocok');
      return;
    }

    try {
      isLoading.value = true;
      final res = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'phone': phoneController.text,
        }),
      );
      isLoading.value = false;

      final data = jsonDecode(res.body);
      if (res.statusCode == 201) {
        Get.snackbar('Berhasil', data['message'] ?? 'Registrasi berhasil');
        Get.toNamed('/verify-email', arguments: {
          'email': emailController.text,
        });
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> verifyEmail({required String email, required String otp}) async {
    try {
      isLoading.value = true;
      final res = await http.post(
        Uri.parse('$baseUrl/verify_email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      isLoading.value = false;

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        Get.snackbar('Sukses', data['message'] ?? 'Email diverifikasi');
        _persistSession(data);
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'OTP salah / kadaluarsa');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> resetPassword(String mail) async {
    try {
      isLoading.value = true;
      final res = await http.post(
        Uri.parse('$baseUrl/forgot_password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': mail}),
      );
      isLoading.value = false;

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        Get.snackbar('Berhasil', data['message']);
        Get.toNamed('/reset-password', arguments: {'email': mail});
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Permintaan reset gagal');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> confirmResetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      final res = await http.post(
        Uri.parse('$baseUrl/reset_password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        }),
      );
      isLoading.value = false;

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        Get.snackbar('Berhasil', data['message']);
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'OTP salah / kadaluarsa');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    String? newPassword,
  }) async {
    final token = box.read('token');
    if (token == null) {
      Get.snackbar('Error', 'Token hilang – login kembali');
      return;
    }

    try {
      final res = await http.put(
        Uri.parse('$baseUrl/update_profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'phone': phone,
          if (newPassword != null && newPassword.isNotEmpty)
            'password': newPassword,
        }),
      );

      if (res.statusCode == 200) {
        userName.value = name;
        phoneNumber.value = phone;
        box
          ..write('name', name)
          ..write('phone', phone);
        Get.snackbar('Sukses', 'Profil diperbarui');
      } else {
        Get.snackbar(
            'Gagal', jsonDecode(res.body)['message'] ?? 'Gagal update');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteAccount() async {
    final token = box.read('token');
    if (token == null) {
      Get.snackbar('Error', 'Token hilang – login kembali');
      return;
    }

    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/delete_account'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode == 200) {
        logout();
        Get.snackbar('Sukses', 'Akun dihapus');
      } else {
        Get.snackbar('Gagal', jsonDecode(res.body)['message'] ?? 'Gagal hapus');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void logout() async {
    final token = box.read('token');

    // 1. Catat logout ke server
    if (token != null) {
      try {
        final res = await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (res.statusCode == 200) {
          print('✅ Logout dicatat ke server');
        } else {
          print('⚠️ Gagal catat logout: ${res.body}');
        }
      } catch (e) {
        print('❌ Error saat catat logout: $e');
      }
    }

    // 2. Hapus sesi lokal
    box.erase();
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();

    isLoggedIn.value = false;
    userName.value =
        email.value = phoneNumber.value = profilePicture.value = '';
    role.value = 'General';

    Get.offAllNamed(Routes.LOGIN);
  }

  void _persistSession(Map<String, dynamic> data) {
    box
      ..write('token', data['access_token'])
      ..write('name', data['name'] ?? '')
      ..write('email', data['email'] ?? '')
      ..write('phone', data['phone'] ?? '')
      ..write('role', data['role'] ?? 'General')
      ..write('profilePicture', data['profile_picture'] ?? '');
    _restoreSession();
  }

  void _restoreSession() {
    userName.value = box.read('name') ?? '';
    email.value = box.read('email') ?? '';
    phoneNumber.value = box.read('phone')?.toString() ?? '';
    role.value = box.read('role') ?? 'General';
    profilePicture.value = box.read('profilePicture') ?? '';
    isLoggedIn.value = true;
  }
}
