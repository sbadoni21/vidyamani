import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  final CollectionReference notesCollection = FirebaseFirestore.instance
      .collection('users'); // Adjust collection name accordingly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Save the note to Firestore
              saveNote();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              decoration:
                  InputDecoration(hintText: 'Add Notes Here', border: InputBorder.none),
            ),
          ],
        ),
      ),
    );
  }

  void saveNote() {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid);

    userDoc.get().then((doc) {
      if (doc.exists) {
        final Timestamp timestamp = Timestamp.now();

        notesCollection
            .doc(_firebaseAuth.currentUser!.uid)
            .collection('notes')
            .add({
          'title': titleController.text,
          'text': textController.text,
          'timestamp': timestamp,
        });
      }
    });
  }
}
