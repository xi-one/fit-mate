class Post {
  final String? id;
  final String? title;
  final String? contents;
  final DateTime? datetime;
  final String? userId;
  final String? sports;
  final String? location;
  final String? numOfRecruits;
  final String? numOfParticipants;
  final bool? isRecruiting;

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
    this.isRecruiting,
  );
}
