import 'package:fit_mate_app/model/TokenHistory.dart';
import 'package:fit_mate_app/providers/ParticipantService.dart';
import 'package:fit_mate_app/providers/TokenHistoryService.dart';
import 'package:fit_mate_app/providers/UserService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticipantItem extends StatelessWidget {
  final id;
  final writerId;
  final VoidCallback onRefresh;
  const ParticipantItem(this.id, this.writerId,
      {required this.onRefresh, super.key});

  @override
  Widget build(BuildContext context) {
    final participants =
        Provider.of<ParticipantService>(context, listen: false).items;
    final participantIndex =
        participants.indexWhere((participant) => participant.id == id);
    var participant = participants[participantIndex];

    return ListTile(
      leading: participant.imgUrl != null
          ? Image.network(
              participant.imgUrl!,
              height: 200,
            )
          : Icon(
              Icons.person,
              color: Color(0xffcccccc),
            ),
      title: Text(
        participant.name!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: writerId == id ||
              writerId !=
                  Provider.of<UserService>(context, listen: false).userId
          ? Text("")
          : !(participant.isRewarded!)
              ? TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('참여확인'),
                        content: Text(
                          '해당 핏메이트와 함께 운동을 즐기셨습니까?',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              '취소',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text(
                              '확인',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                            onPressed: () async {
                              onRefresh();
                              Navigator.of(ctx).pop(true);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text("참여확인"),
                )
              : Text(
                  "보상 완료",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
    );
  }
}
