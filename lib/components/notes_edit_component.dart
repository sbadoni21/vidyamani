import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteEditScreen extends StatefulWidget {
  final String noteId;
  final String? initialTitle;
  final String? initialText;


  NoteEditScreen({
    required this.noteId,
    required this.initialTitle,
    required this.initialText,
 
  });

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  late TextEditingController titleController;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    textController = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () async {
              await saveEditedNote();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration:
                  InputDecoration(hintText: 'Title', border: InputBorder.none),
            ),
            SizedBox(height: 16),
            TextField(
                controller: textController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: 'Text', border: InputBorder.none)),
          ],
        ),
      ),
    );
  }

  Future<void> saveEditedNote() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('notes')
        .doc(widget.noteId)
        .update({
      'title': titleController.text,
      'text': textController.text,
      'timestamp' : Timestamp.now()
    });
  }
}
