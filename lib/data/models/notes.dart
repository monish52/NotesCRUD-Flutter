class Note {
  final String title;
  final String description;
  final String uid;

  Note({this.title, this.description, this.uid});

  Note.fromMap(Map<String, dynamic> data, String uid)
      : title = data["title"],
        description = data["description"],
        uid = uid;

  Map<String, dynamic> toMap() {
    return {"title": title, "description": description};
  }
}
