import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_content_view.dart';

class ContentViewTrainer extends StatelessWidget {
  final String lessonId;
  const ContentViewTrainer({required this.lessonId, super.key});

  void _deleteContent(String contentId) async {
    await FirebaseFirestore.instance
        .collection('contents')
        .doc(contentId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contenus"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('contents')
            .where('lessonId', isEqualTo: lessonId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final contents = snapshot.data!.docs;
          if (contents.isEmpty)
            return const Center(child: Text("Aucun contenu"));

          return ListView.builder(
            itemCount: contents.length,
            itemBuilder: (context, index) {
              final content = contents[index];
              IconData icon;
              switch (content['type']) {
                case 'video':
                  icon = Icons.video_library;
                  break;
                case 'pdf':
                  icon = Icons.picture_as_pdf;
                  break;
                default:
                  icon = Icons.text_snippet;
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Icon(icon, color: Colors.blueAccent),
                  title: Text(content['data']),
                  subtitle: Text(content['type']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteContent(content.id),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 30),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddContentView(lessonId: lessonId),
            ),
          );
        },
      ),
    );
  }
}
