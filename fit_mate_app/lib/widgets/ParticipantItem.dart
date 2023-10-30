import 'package:fit_mate_app/providers/ParticipantService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticipantItem extends StatelessWidget {
  final id;
  const ParticipantItem(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final participants =
        Provider.of<ParticipantService>(context, listen: false).items;
    final participantIndex =
        participants.indexWhere((participant) => participant.id == id);
    final participant = participants[participantIndex];

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: CircleAvatar(
          backgroundColor: Color(0xffe6e6e6),
          child: Icon(
            Icons.person,
            color: Color(0xffcccccc),
          ),
        ),
      ),
      title: Text(
        participant.name!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
