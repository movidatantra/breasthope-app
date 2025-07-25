import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/assesmen_controller.dart';
import 'tutorial_video_view.dart';

class GerakanSenam {
  final String nama;
  final String imageAsset;
  final Color warna;
  final String youtubeUrl;
  final String deskripsi;

  GerakanSenam(
    this.nama,
    this.imageAsset,
    this.warna, {
    required this.youtubeUrl,
    required this.deskripsi,
  });
}

final List<GerakanSenam> gerakanList = [
  GerakanSenam(
    "Neck Lymphatic Massage",
    "assets/image/Neck Massage Instruction Illustration.png",
    Colors.blue,
    youtubeUrl: "https://youtu.be/jsR2t7A1Ci8",
    deskripsi:
        "Pijat lembut area leher untuk membantu aliran getah bening dan mengurangi pembengkakan.",
  ),
  GerakanSenam(
    "Shoulder Lymphatic Massage",
    "assets/image/G1.png",
    Colors.pink,
    youtubeUrl: "https://youtu.be/hEiog1Mg7bc",
    deskripsi:
        "Pijat area bahu untuk memperlancar sirkulasi getah bening dan meredakan ketegangan.",
  ),
  GerakanSenam(
    "Straight Arm",
    "assets/image/G2.png",
    Colors.orange,
    youtubeUrl: "https://youtu.be/eDob1IeS0bQ",
    deskripsi:
        "Gerakan meluruskan lengan ke depan untuk meregangkan otot bahu dan lengan atas.",
  ),
  GerakanSenam(
    "Triceps Stretch",
    "assets/image/G3.png",
    Colors.black,
    youtubeUrl: "https://youtu.be/BsQBsbemH-Q",
    deskripsi:
        "Regangkan otot trisep untuk mengurangi kekakuan dan meningkatkan fleksibilitas.",
  ),
  GerakanSenam(
    "Deep Breathing",
    "assets/image/G1.png",
    Colors.purple,
    youtubeUrl: "https://youtu.be/T7FPzgf1hwU",
    deskripsi:
        "Teknik pernapasan dalam untuk membantu relaksasi dan meningkatkan oksigenasi tubuh.",
  ),
  GerakanSenam(
    "Shoulder Retraction Stretch",
    "assets/image/G1.png",
    Colors.teal,
    youtubeUrl: "https://youtu.be/4reoPukpQSY",
    deskripsi:
        "Tarik bahu ke belakang untuk melatih postur tubuh dan memperkuat otot punggung atas.",
  ),
  GerakanSenam(
    "Shoulder Circles",
    "assets/image/G1.png",
    Colors.redAccent,
    youtubeUrl: "https://youtu.be/kHeqrqhcdEU",
    deskripsi:
        "Putaran bahu membantu meningkatkan mobilitas sendi bahu secara keseluruhan.",
  ),
  GerakanSenam(
    "Sideways Arm Up",
    "assets/image/G1.png",
    Colors.brown,
    youtubeUrl: "https://youtu.be/c4tduLUhTZQ",
    deskripsi:
        "Gerakan mengangkat tangan ke samping untuk memperkuat otot deltoid dan meningkatkan jangkauan gerak.",
  ),
];

class ExerciseListView extends StatelessWidget {
  const ExerciseListView({super.key});

  @override
  Widget build(BuildContext context) {
    final assesmenController = Get.find<AssesmenController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Senam Pencegahan Limfedema",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Obx(() {
        final hasilGerakan = gerakanList
            .where((g) => assesmenController.gerakanTampil.contains(g.nama))
            .toList();

        return ListView.builder(
          itemCount: hasilGerakan.length,
          itemBuilder: (context, index) {
            final item = hasilGerakan[index];
            return Card(
              color: item.warna,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Image.asset(item.imageAsset, width: 60),
                title: Text(
                  item.nama,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                subtitle: Text(
                  item.deskripsi,
                  style: const TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Get.to(() => TutorialVideoView(gerakan: item));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
