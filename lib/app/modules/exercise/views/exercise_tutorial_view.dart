import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:kanker_payudara/app/modules/exercise/views/exercise_asessment_view.dart';

class ExerciseTutorialView extends StatefulWidget {
  const ExerciseTutorialView({super.key});

  @override
  State<ExerciseTutorialView> createState() => _ExerciseTutorialViewState();
}

class _ExerciseTutorialViewState extends State<ExerciseTutorialView> {
  final List<Map<String, String>> tutorialSteps = [
    {
      'title': 'Tutorial Senam Pencegahan Limfedema',
      'video':
          'https://youtu.be/8i7qj4To0Hk?si=cvQ__vHEzj4DjYzm', // Ganti dengan ID video kamu
      'description': '''
Senam Pencegahan Limfedema ini merupakan rangkaian gerakan yang dirancang secara khusus untuk mencegah terjadinya limfedema — kondisi pembengkakan jaringan akibat akumulasi cairan limfa, yang sering dialami oleh pasien kanker payudara pasca operasi atau terapi.

Video ini diperagakan langsung oleh tenaga medis profesional, yaitu perawat dari Rumah Sakit Kanker Dharmais, guna memberikan contoh gerakan yang benar, aman, dan sesuai standar rehabilitasi medis.

Seluruh gerakan telah disusun agar dapat dilakukan secara mandiri di rumah, tanpa memerlukan alat khusus, dengan fokus pada peningkatan sirkulasi limfa, menjaga fleksibilitas sendi, serta mengurangi risiko komplikasi lebih lanjut.

📝 Catatan:
- Lakukan secara perlahan dan teratur.
- Hentikan bila terasa nyeri atau tidak nyaman.
- Konsultasikan dengan tenaga medis sebelum memulai apabila memiliki kondisi kesehatan tertentu.
'''
    }
  ];

  late PageController _pageController;
  late List<YoutubePlayerController> _youtubeControllers;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _youtubeControllers = tutorialSteps.map((step) {
      final videoId = YoutubePlayer.convertUrlToId(step['video']!)!;
      return YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _youtubeControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('TUTORIAL SENAM', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: tutorialSteps.length,
        itemBuilder: (context, index) {
          final step = tutorialSteps[index];
          final youtubeController = _youtubeControllers[index];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  step['title']!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                YoutubePlayer(
                  controller: youtubeController,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.pinkAccent,
                  progressColors: const ProgressBarColors(
                    playedColor: Colors.pinkAccent,
                    handleColor: Colors.pink,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  step['description']!,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 30),
                if (index == tutorialSteps.length - 1)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => const AssesmenView());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'MULAI PENILAIAN',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
