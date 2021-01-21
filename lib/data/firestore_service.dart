import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/data/models/notes.dart';

class FirestoreService {
  static final FirestoreService _firestoreService =
      FirestoreService._internal();
  FirebaseFirestore _db = FirebaseFirestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  Stream<List<Note>> getNotes() {
    return _db.collection('notes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Note.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addNote(Note note) {
    return _db.collection('notes').add(note.toMap());
  }

  Future<void> deleteNote(String uid) {
    return _db.collection('notes').doc(uid).delete();
  }

  Future<void> updateNote(Note note) {
    return _db.collection('notes').doc(note.uid).update(note.toMap());
  }
}
