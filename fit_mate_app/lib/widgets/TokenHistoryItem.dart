import 'package:fit_mate_app/providers/TokenHistoryService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TokenHistoryItem extends StatelessWidget {
  final id;
  const TokenHistoryItem(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final history =
        Provider.of<TokenHistoryService>(context, listen: false).items;
    final historyIndex = history.indexWhere((history) => history.id == id);
    final historyItem = history[historyIndex];

    return ListTile(
      title: Text(
        historyItem.content!,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: (DateTime.now().day - historyItem.date!.day >= 1)
          ? Text(DateFormat('MM/dd').format(historyItem.date!))
          : Text(DateFormat('HH:mm').format(historyItem.date!)),
      trailing: Text(historyItem.amount!),
    );
  }
}
