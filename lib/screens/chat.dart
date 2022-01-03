import 'package:flutter/material.dart';
import 'package:menu/models/event.dart';
import 'package:menu/models/message.dart';
import 'package:menu/models/user.dart';
import 'package:menu/services/database.dart';
import 'package:provider/provider.dart';

class Chat extends StatefulWidget {
  final BuildContext context;
  final Event event;

  const Chat(this.context, {Key? key, required this.event}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final messageController = TextEditingController();
  final FirestoreDb _db = FirestoreDb.instance;

  final bottomBarHeight = 60.0;

  @override
  Widget build(BuildContext context) {
    String eid = Provider.of<User>(widget.context, listen: true).uid;
    Stream<List<Message>> messagesStream = _db.getEventMessages(widget.event.eid);

    return StreamBuilder<List<Message>>(
      stream: messagesStream,
      builder: (context, snapshot) {
        List<Message>? messages = snapshot.data;
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height / 2,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Align(alignment: Alignment.topCenter, child: Text("Chat"),),
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 2 - bottomBarHeight,
                child: ListView.builder(
                  itemCount: messages?.length ?? 0,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      padding:
                      const EdgeInsets.only(
                          left: 14, right: 14, top: 10, bottom: 10),
                      child: Align(
                        alignment: (messages![index].senderId != eid
                            ? Alignment.topLeft
                            : Alignment.topRight),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (messages[index].senderId != eid
                                ? Colors.grey.shade200
                                : Colors.blue[200]),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            messages[index].message,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: bottomBarHeight,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          decoration: const InputDecoration(
                              hintText: "Write message...",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          Message msg = Message(eid: widget.event.eid,
                              senderId: eid,
                              message: messageController.text,
                              timestamp: DateTime.now());
                          _db.sendMessage(msg);
                          messageController.text = "";
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 18,
                        ),
                        backgroundColor: Colors.blue,
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
