class Participant {
  final String? id;
  final String? name;
  final String? imgUrl;
  final String? postId;
  final bool? isRewarded;

  Participant({this.id, this.name, this.imgUrl, this.postId, this.isRewarded});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Participant &&
          runtimeType == other.runtimeType &&
          id == other.id;
}
