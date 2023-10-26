class Post {
  final String? id;
  final String? title;
  final String? contents;
  final DateTime? datetime;
  final String? userId;
  final String? sports;
  final String? location;
  final int? numOfRecruits;
  final int? numOfParticipants;

  Post(
    this.id,
    this.title,
    this.contents,
    this.datetime,
    this.userId,
    this.sports,
    this.location,
    this.numOfRecruits,
    this.numOfParticipants,
  );
}
