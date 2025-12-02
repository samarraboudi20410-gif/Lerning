import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../controllers/content_controller.dart';
import '../models/content_model.dart';

class AddContentView extends StatefulWidget {
  final String lessonId;
  const AddContentView({required this.lessonId, Key? key}) : super(key: key);

  @override
  State<AddContentView> createState() => _AddContentViewState();
}

class _AddContentViewState extends State<AddContentView> {
  final _typeController = TextEditingController();
  final _dataController = TextEditingController();
  final ContentController _controller = ContentController();

  void _addContent() async {
    if (_typeController.text.isEmpty || _dataController.text.isEmpty) return;

    final content = Content(
      id: const Uuid().v4(),
      lessonId: widget.lessonId,
      type: _typeController.text,
      data: _dataController.text,
    );

    await _controller.addContent(content);
    Navigator.pop(context); // Retour à ContentView
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Ajouter Contenu"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    labelText: "Type (text/video/pdf)",
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _dataController,
                  decoration: const InputDecoration(
                    labelText: "Data / Link",
                    prefixIcon: Icon(Icons.link),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _addContent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Ajouter Contenu",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
