import 'package:elearningapplication/views/content_detail_page.dart';
import 'package:elearningapplication/views/quiz_questions_page.dart';
import 'package:flutter/material.dart';
import '../controllers/content_controller.dart';
import '../models/content_model.dart';

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

  @override
  Widget build(BuildContext context) {
    bool allCompleted = _completed.values.every((v) => v);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lesson Contents"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _contents.isEmpty
          ? const Center(child: Text("No content available"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _contents.length,
              itemBuilder: (context, index) {
                final content = _contents[index];

                return InkWell(
                  onTap: () {
                    // Naviguer vers la page de détail du contenu
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContentDetailPage(content: content),
                      ),
                    );
                  },
                  child: Card(
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
                          Text(
                            content.type == 'text'
                                ? content.data
                                : "Tap to view",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Done"),
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
                  ),
                );
              },
            ),
      floatingActionButton: SizedBox(
        width: 180, // largeur du bouton
        height: 50,
        child: FloatingActionButton.extended(
          backgroundColor: allCompleted ? Colors.green : Colors.grey,
          onPressed: allCompleted
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          QuizQuestionsPage(quizId: widget.moduleId),
                    ),
                  );
                }
              : null,
          icon: const Icon(Icons.quiz),
          label: const Text(
            "Take the  quiz",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
