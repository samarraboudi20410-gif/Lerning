import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../models/content_model.dart';

class ContentDetailPage extends StatelessWidget {
  final Content content;

  const ContentDetailPage({required this.content, super.key});

  Future<String> downloadPdf(String url) async {
    final ref = FirebaseStorage.instance.refFromURL(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');
    final Uint8List? data = await ref.getData();
    if (data == null) throw Exception("Failed to download PDF");
    await file.writeAsBytes(data, flush: true);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    Widget contentWidget;

    switch (content.type) {
      case 'text':
        contentWidget = Text(
          content.data,
          style: const TextStyle(fontSize: 16),
        );
        break;

      case 'image':
        contentWidget = Image.network(content.data);
        break;

      case 'video':
        contentWidget = InkWell(
          onTap: () async {
            final uri = Uri.parse(content.data);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Cannot open link")));
            }
          },
          child: const Text(
            "Watch Video",
            style: TextStyle(
              color: Colors.blueAccent,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        break;

      case 'pdf':
        contentWidget = FutureBuilder<String>(
          future: downloadPdf(content.data),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('Error downloading PDF');
            } else {
              return SizedBox(
                height: 500,
                child: PDFView(
                  filePath: snapshot.data!,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                ),
              );
            }
          },
        );
        break;

      default:
        contentWidget = Text(content.data);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(content.type.toUpperCase()),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: contentWidget,
      ),
    );
  }
}
