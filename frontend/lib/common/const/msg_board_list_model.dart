class MsgBoardListModel {
  final String id, category, title, preview, heart, comment, favorite;

  MsgBoardListModel(this.id, this.category, this.title, this.preview,
      this.heart, this.comment, this.favorite);
  // MsgBoardListModel.fromJson(Map<String, dynamic> json)
  // : id = json['id'],
  //   category = json['category'],
  //   title = json['title'],
  //   heart = json['heart'],
  //   comment = json['comment'],
  //   favorite = json['favorite'];
}
