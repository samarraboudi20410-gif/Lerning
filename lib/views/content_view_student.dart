import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../controllers/content_controller.dart';
import '../models/content_model.dart';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';

class ContentViewStudent extends StatefulWidget {
  final String lessonId;

  const ContentViewStudent({required this.lessonId, super.key});

  @override
  State<ContentViewStudent> createState() => _ContentViewStudentState();
}

class _ContentViewStudentState extends State<ContentViewStudent> {
  final ContentController _controller = ContentController();
  List<Content> _contents = [];

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  void _loadContents() async {
    final contents = await _controller.getContents(widget.lessonId);
    setState(() => _contents = contents);
  }

  // Fonction pour télécharger le PDF depuis Firebase Storage
  Future<String> downloadPdf(String url) async {
    final ref = FirebaseStorage.instance.refFromURL(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    final Uint8List? data = await ref.getData();
    if (data == null)
      throw Exception("Impossible de récupérer les données du PDF");
    await file.writeAsBytes(data, flush: true);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contenu de la leçon"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _contents.isEmpty
          ? const Center(child: Text("Aucun contenu disponible"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _contents.length,
              itemBuilder: (context, index) {
                final content = _contents[index];
                Widget contentWidget;

                switch (content.type) {
                  case 'text':
                    contentWidget = Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        content.data,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                    break;

                  case 'image':
                    contentWidget = Image.network(content.data);
                    break;

                  case 'video':
                    contentWidget = InkWell(
                      onTap: () async {
                        final uri = Uri.parse(
                          content.data,
                        ); // ton lien youtu.be
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Impossible d'ouvrir le lien"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Regarder la vidéo",
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
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Erreur: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Text('Erreur lors du téléchargement');
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

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(
                      "Type: ${content.type}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: contentWidget,
                  ),
                );
              },
            ),
    );
  }
}

// Widget pour YouTube
class YouTubeVideoWidget extends StatefulWidget {
  final String videoUrl;
  const YouTubeVideoWidget({required this.videoUrl, super.key});

  @override
  _YouTubeVideoWidgetState createState() => _YouTubeVideoWidgetState();
}

class _YouTubeVideoWidgetState extends State<YouTubeVideoWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blueAccent,
    );
  }
}
