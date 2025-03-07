class DiaryModel {
  int? id;
  String title;
  String description;
  String emoji;

  DiaryModel({
    this.id,
    required this.title,
    required this.description,
    required this.emoji,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'emoji': emoji,
    };
  }

  factory DiaryModel.fromMap(Map<String, dynamic> map) {
    return DiaryModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      emoji: map['emoji'],
    );
  }
}
