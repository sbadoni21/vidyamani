import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/components/addnotes_component.dart';
import 'package:vidyamani/components/notes_Card_component.dart';
import 'package:vidyamani/components/notes_edit_component.dart';
import 'package:vidyamani/components/search_bar.dart';
import 'package:vidyamani/utils/static.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class MyNotes extends StatefulWidget {
  const MyNotes({Key? key}) : super(key: key);

  @override
  State<MyNotes> createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  final logger = Logger(
    printer: PrettyPrinter(),
  );
  final CollectionReference notesCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController _searchController = TextEditingController();

  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Notes'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(_firebaseAuth.currentUser!.uid)
                      .collection('notes')
                      .snapshots(),
                ),
              );
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          elevation: 5.0,
          backgroundColor: bgColor,
          foregroundColor: Colors.white,
          shape: CircleBorder(),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNoteScreen()),
          );
        },
        child: Icon(Icons.add, size: 24),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(_firebaseAuth.currentUser!.uid)
            .collection('notes')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            children: [
              for (var document in snapshot.data!.docs)
                Dismissible(
                  key: Key(document.id),
                  confirmDismiss: (direction) async {
                    return await showDeleteConfirmation(context);
                  },
                  onDismissed: (direction) {
                    deleteNote(document.id);
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: bgColor,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteEditScreen(
                            noteId: document.id,
                            initialTitle: document['title'],
                            initialText: document['text'],
                          ),
                        ),
                      );
                    },
                    child: NoteCard(
                      title: document['title'],
                      text: document['text'],
                      timestamp: document['timestamp'],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<bool?> showDeleteConfirmation(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Are you sure you want to delete this note?"),
              SizedBox(height: 16),
              CircularCountDownTimer(
                duration: 5,
                isReverse: true,
                width: 40,
                height: 40,
                ringColor: Colors.black,
                fillColor: Colors.red,
                strokeWidth: 5.0,
                onComplete: () {
                  Navigator.of(context).pop(true);
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("Delete"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void deleteNote(String noteId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .collection('notes')
        .doc(noteId)
        .delete()
        .then((value) {})
        .catchError((error) {});
  }
}

class NoteSearchDelegate extends SearchDelegate {
  final Stream<QuerySnapshot> stream;

  NoteSearchDelegate({required this.stream});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSearchResults(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSearchResults(context, query);
  }

  Widget buildSearchResults(BuildContext context, String query) {
    return StreamBuilder(
      stream: stream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final filteredNotes = snapshot.data!.docs.where((note) {
          final title = note['title'].toString().toLowerCase();
          final text = note['text'].toString().toLowerCase();
          return title.contains(query.toLowerCase()) ||
              text.contains(query.toLowerCase());
        }).toList();

        return ListView(
          children: filteredNotes.map((note) {
            return ListTile(
              title: Container(
                child: NoteCard(
                  title: note['title'],
                  text: note['text'],
                  timestamp: note['timestamp'],
                ),
              ),
              onTap: () {
                // Handle the navigation to the specific note here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteEditScreen(
                      noteId: note.id,
                      initialText: note['text'],
                      initialTitle: note["title"],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
