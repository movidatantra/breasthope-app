// lib/app/modules/home/views/home_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanker_payudara/app/controllers/auth_controller.dart';
import 'package:kanker_payudara/app/modules/profile/views/profile_view.dart';
import 'package:kanker_payudara/app/modules/exercise/views/exercise_view.dart';
import 'package:kanker_payudara/app/modules/history/views/history_view.dart';
import 'package:kanker_payudara/app/modules/selfcheck/views/selfcheck_view.dart';
import 'package:kanker_payudara/app/routes/app_pages.dart';
import 'package:kanker_payudara/app/modules/infografis/views/infografis_view.dart'; // ✅ Tambah ini

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final authController = Get.find<AuthController>();
  int _selectedIndex = 0;

  List<Widget> get _pages => [
        HomePageContent(),
        const ProfileView(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE91E63), Color(0xFFFFC1E3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.pink.shade300,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  HomePageContent({super.key});
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    color: Colors.white,
                    child: ListTile(
                      leading: const Icon(Icons.waving_hand,
                          color: Color.fromARGB(255, 187, 103, 131), size: 36),
                      title: const Text(
                        "Selamat Datang!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 79, 8, 134),
                        ),
                      ),
                      subtitle: Text(
                        authController.userName.value,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset('assets/image/home.png', height: 150),
                    const SizedBox(height: 12),
                    const Text(
                      "Langkah Kecil untuk\nKesehatan yang Besar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const SelfcheckView());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text("Mulai Periksa Payudara Sendiri"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _menuItem(
                icon: Icons.article_outlined,
                title: "Artikel dan Tips",
                subtitle: "Artikel kesehatan, tips & info lainnya",
                onTap: () {
                  Get.toNamed(Routes.ARTIKEL);
                },
              ),
              const SizedBox(height: 16),
              _menuItem(
                icon: Icons.fitness_center_outlined,
                title: "Rekomendasi Gerakan Senam",
                subtitle: "Panduan gerakan untuk pencegahan Limpedema",
                onTap: () {
                  Get.to(() => const ExerciseView());
                },
              ),
              const SizedBox(height: 16),
              _menuItem(
                icon: Icons.history,
                title: "History",
                subtitle: "Lihat riwayat deteksi, log aktivitas, note SADARI",
                onTap: () {
                  Get.to(() => const HistoryView());
                },
              ),
              const SizedBox(height: 16),
              _menuItem(
                icon: Icons.bar_chart,
                title: "Infografis",
                subtitle: "Visualisasi data & informasi penting",
                onTap: () {
                  Get.to(() => const InfografisWebView());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 36, color: const Color.fromARGB(255, 233, 30, 206)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
