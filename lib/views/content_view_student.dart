import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/content_controller.dart';
import '../models/content_model.dart';
import 'dart:io';
import 'dart:typed_data';
import 'quiz_view_student.dart';

class ContentViewStudent extends StatefulWidget {
  final String lessonId;
  final String moduleId;

  const ContentViewStudent({
    required this.lessonId,
    required this.moduleId,
    super.key,
  });

  @override
  State<ContentViewStudent> createState() => _ContentViewStudentState();
}

class _ContentViewStudentState extends State<ContentViewStudent> {
  final ContentController _controller = ContentController();
  List<Content> _contents = [];
  Map<String, bool> _completed = {};

  @override
  void initState() {
    super.initState();
    _loadContents();
  }

  void _loadContents() async {
    final contents = await _controller.getContents(widget.lessonId);
    setState(() {
      _contents = contents;
      for (var c in contents) {
        _completed[c.id] = false;
      }
    });
  }

  Future<String> downloadPdf(String url) async {
    final ref = FirebaseStorage.instance.refFromURL(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    final Uint8List? data = await ref.getData();
    if (data == null) throw Exception("Impossible de récupérer le PDF");
    await file.writeAsBytes(data, flush: true);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    bool allCompleted = _completed.values.every((v) => v);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contenus de la leçon"),
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

                // Affichage selon le type de contenu
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
                        final uri = Uri.parse(content.data);
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
                            height: 400,
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Type: ${content.type}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        contentWidget,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("Terminé"),
                            Checkbox(
                              value: _completed[content.id] ?? false,
                              onChanged: (value) {
                                setState(() {
                                  _completed[content.id] = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: allCompleted ? Colors.green : Colors.grey,
        onPressed: allCompleted
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizViewStudent(moduleId: widget.moduleId),
                  ),
                );
              }
            : null, // bouton désactivé si toutes les leçons ne sont pas cochées
        child: const Icon(Icons.quiz),
      ),
    );
  }
}
