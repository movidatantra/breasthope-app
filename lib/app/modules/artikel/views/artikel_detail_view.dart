import 'package:flutter/material.dart';

class ArtikelDetailView extends StatelessWidget {
  final Map<String, dynamic> artikel;
  const ArtikelDetailView({super.key, required this.artikel});

  @override
  Widget build(BuildContext context) {
    final imageUrl = artikel['imageUrl']; // optional, bisa null
    final tanggal =
        artikel['tanggal_publish']?.toString().split('T').first ?? '';
    final sumber = artikel['sumber'] ?? 'Tidak diketahui';

    return Scaffold(
      appBar: AppBar(
        title: Text(artikel['judul'] ?? 'Detail Artikel'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar (jika tersedia)
              if (imageUrl != null && imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      color: const Color.fromARGB(255, 70, 24, 24),
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Judul
              Text(
                artikel['judul'] ?? 'Tanpa Judul',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Sumber dan Tanggal
              Row(
                children: [
                  Text('Sumber: $sumber'),
                  const Spacer(),
                  Text(tanggal),
                ],
              ),
              const Divider(height: 20),

              // Isi Artikel
              Text(
                artikel['isi'] ?? 'Konten tidak tersedia.',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
