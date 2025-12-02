import 'package:flutter/material.dart';
import '../controllers/content_controller.dart';
import '../models/content_model.dart'; // Assure-toi que le fichier s'appelle content_model.dart

class ContentViewStudent extends StatefulWidget {
  final String lessonId;

  const ContentViewStudent({required this.lessonId, super.key});

  @override
  State<ContentViewStudent> createState() => _ContentViewStudentState();
}

class _ContentViewStudentState extends State<ContentViewStudent> {
  final ContentController _controller = ContentController();
  List<Content> _contents = [];

  void _loadContents() async {
    final contents = await _controller.getContents(widget.lessonId);
    setState(() => _contents = contents);
  }

  @override
  void initState() {
    super.initState();
    _loadContents();
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

                // Affiche différemment selon le type de contenu
                Widget contentWidget;
                switch (content.type) {
                  case 'text':
                    contentWidget = Text(content.data);
                    break;
                  case 'video':
                    contentWidget = Text(
                      "Video URL: ${content.data}",
                    ); // Tu peux remplacer par un player vidéo
                    break;
                  case 'image':
                    contentWidget = Image.network(content.data);
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
