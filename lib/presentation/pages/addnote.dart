import 'package:firebase_crud/data/firestore_service.dart';
import 'package:firebase_crud/data/models/notes.dart';
import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  final Note note;

  const AddNotePage({Key key, this.note}) : super(key: key);
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _titleController;
  TextEditingController _descriptionController;
  FocusNode _descriptionNode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleController = TextEditingController(
        text: widget.note != null ? widget.note.title : '');
    _descriptionController = TextEditingController(
        text: widget.note != null ? widget.note.description : '');
    _descriptionNode = FocusNode();
  }

  get isEditMode {
    widget.note != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note != null ? 'Edit Note' : 'Add Note'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                  validator: (val) => val.isEmpty || val == null
                      ? "Title cannot be empty"
                      : null,
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_descriptionNode);
                  },
                  decoration: InputDecoration(
                    labelText: 'Add title',
                    labelStyle: TextStyle(color: Colors.yellow[700]),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                  validator: (val) => val.isEmpty || val == null
                      ? "Description cannot be empty"
                      : null,
                  controller: _descriptionController,
                  focusNode: _descriptionNode,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Add description',
                    labelStyle: TextStyle(color: Colors.yellow[700]),
                    border: OutlineInputBorder(),
                  )),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                color: Theme.of(context).accentColor,
                child: Text(
                  widget.note != null ? 'Update' : 'Save',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    try {
                      if (widget.note != null) {
                        Note note = Note(
                            description: _descriptionController.text,
                            title: _titleController.text,
                            uid: widget.note.uid);
                        await FirestoreService().updateNote(note);
                      } else {
                        Note note = Note(
                          description: _descriptionController.text,
                          title: _titleController.text,
                        );
                        await FirestoreService().addNote(note);
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      print(e.toString());
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
