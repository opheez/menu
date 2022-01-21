import 'package:flutter/material.dart';
import 'package:menu/components/requestForm.dart';
import 'package:menu/models/event.dart';
import 'package:menu/screens/eventDetails.dart';
import 'package:menu/services/database.dart';
import 'package:provider/provider.dart';
import 'package:menu/models/user.dart';

class RequestTile extends StatelessWidget {
  final Event event;
  final Map request;
  final FirestoreDb _db = FirestoreDb.instance;
  static const double iconSize = 15;

  RequestTile({Key? key, required this.event, required this.request})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              request.toString(),
              overflow: TextOverflow.fade,
              maxLines: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    height: iconSize,
                    width: iconSize,
                    child: IconButton(
                        onPressed: () {
                          _db.ackRequest(event, request, true);
                        },
                        padding: const EdgeInsets.all(1),
                        iconSize: iconSize,
                        icon: const Icon(Icons.check))),
                SizedBox(
                  height: iconSize,
                  width: iconSize,
                  child: IconButton(
                      onPressed: () {
                        _db.ackRequest(event, request, false);
                      },
                      padding: const EdgeInsets.all(1),
                      iconSize: iconSize,
                      icon: const Icon(Icons.clear)),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
