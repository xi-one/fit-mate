class Participant {
  final String? id;
  final String? name;
  final String? imgUrl;
  final String? postId;

  Participant({this.id, this.name, this.imgUrl, this.postId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Participant &&
          runtimeType == other.runtimeType &&
          id == other.id;
}
