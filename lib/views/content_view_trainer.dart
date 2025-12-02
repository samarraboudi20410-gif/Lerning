import 'package:flutter/material.dart';
import '../controllers/content_controller.dart';
import '../models/content_model.dart';
import 'add_content_view.dart';

class ContentView extends StatefulWidget {
  final String lessonId;
  const ContentView({required this.lessonId, Key? key}) : super(key: key);

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Contenus"),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _contents.length,
        itemBuilder: (context, index) {
          final content = _contents[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                content.type,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                content.data,
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () async {
                  await _controller.deleteContent(content.id);
                  _loadContents();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddContentView(lessonId: widget.lessonId),
          ),
        ).then((_) => _loadContents()),
      ),
    );
  }
}
