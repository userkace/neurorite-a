import 'package:flutter/material.dart';

class Note {
  String title;
  String content;

  Note({required this.title, required this.content});

  Note.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
  };
}

class NotePage extends StatefulWidget {
  final Note? note;

  const NotePage({super.key, this.note});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  String _initialTitle = '';
  String _initialContent = '';@override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _initialTitle = _titleController.text;
    _initialContent = _contentController.text;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: 'Enter your title',
              hintStyle: TextStyle(color: Colors.black54),
              border: InputBorder.none,
            ),
          ),
          leading: IconButton(icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              if (_titleController.text != _initialTitle ||
                  _contentController.text != _initialContent) {
                final shouldSave = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Unsaved Changes'),
                    content: const Text('Do you want to save this note?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Pop dialog
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );

                if (shouldSave == true) {
                  _saveNote();
                }
              }
                // Navigator.of(context).pop();
              },
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'save') {
                  _saveNote();
                } else if (value == 'delete') {
                  _deleteNote();
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: 'save',
                    child: ListTile(
                      leading: const Icon(Icons.save_rounded),
                      title: const Text('Save'),
                      onTap: () {Navigator.pop(context, 'save');
                      },
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete_forever_rounded),
                      title: Text('Delete'),
                    ),
                  ),
                ];
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: TextField(
            controller: _contentController,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Enter your note',
              border: InputBorder.none,
            ),
          ),
        ),),
    );
  }

  void _saveNote() {
    if (_titleController.text.isNotEmpty) {
      Navigator.pop(
        context,
        Note(
          title: _titleController.text,
          content: _contentController.text,
        ),
      );
    }
  }

  void _deleteNote() {
    if (widget.note != null) {
      Navigator.pop(context, 'delete'); // Signal to delete the note
    } else {
      Navigator.pop(context); // Just go back if it's a new note
    }
  }
}


