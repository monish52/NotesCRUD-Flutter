import 'package:firebase_crud/data/firestore_service.dart';
import 'package:firebase_crud/data/models/notes.dart';
import 'package:firebase_crud/presentation/pages/addnote.dart';
import 'package:firebase_crud/presentation/pages/note_details.dart';
import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: StreamBuilder(
        stream: FirestoreService().getNotes(),
        builder: (BuildContext context, AsyncSnapshot<List<Note>> snapshot) {
          if (snapshot.hasError || (!snapshot.hasData)) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Note note = snapshot.data[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                        ),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddNotePage(note: note),
                            )),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                        ),
                        onPressed: () => _deleteNode(context, note.uid),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => NoteDetailsPage(
                                  note: note,
                                )));
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[300],
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddNotePage()));
        },
      ),
    );
  }

  void _deleteNode(BuildContext context, String uid) async {
    if (await _showConfirmationDialog(context)) {
      try {
        await FirestoreService().deleteNote(uid);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        content: Text('Are you sure you want to delete?'),
        actions: <Widget>[
          FlatButton(
            child: Text('Delete'),
            onPressed: () => Navigator.pop(context, true),
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }
}
