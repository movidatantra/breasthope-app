import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanker_payudara/app/modules/artikel/views/artikel_detail_view.dart';
import '../controllers/artikel_controller.dart'; // pastikan path benar

/* -------------------------------------------------------------------------- */
/*                               ARTIKEL VIEW                                 */
/* -------------------------------------------------------------------------- */

class ArtikelView extends GetView<ArtikelController> {
  const ArtikelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Artikel dan Tips',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: Get.back,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.artikelList.isEmpty) {
          return const Center(child: Text("Tidak ada artikel."));
        } else {
          return ListView.builder(
            itemCount: controller.artikelList.length,
            itemBuilder: (_, index) =>
                ArtikelTile(artikel: controller.artikelList[index]),
          );
        }
      }),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                               ARTIKEL TILE                                 */
/* -------------------------------------------------------------------------- */

class ArtikelTile extends StatelessWidget {
  final Map<String, dynamic> artikel;
  const ArtikelTile({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(Icons.article, color: Colors.pink, size: 36),
        title: Text(
          artikel['judul'] ?? 'Tanpa Judul',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        // subtitle: Text(
        //   artikel['ringkasan']?.toString().trim().isNotEmpty == true
        //       ? artikel['ringkasan']
        //       : 'Ringkasan tidak tersedia.',
        //   style: const TextStyle(fontSize: 14, color: Colors.black54),
        //   maxLines: 2,
        //   overflow: TextOverflow.ellipsis,
        // ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Get.to(() => ArtikelDetailView(artikel: artikel)),
      ),
    );
  }
}
