import 'package:flutter/material.dart';
import 'package:menu/models/event.dart';
import 'package:menu/models/message.dart';

class Chat extends StatefulWidget {
  final Event event;

  const Chat({Key? key, required this.event}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final bottomBarHeight = 60.0;
  List<Message> messages = [
    Message(eid: '1', message: 'hi', timestamp: DateTime.now(), senderId: '2'),
    Message(eid: '1', message: 'hi', timestamp: DateTime.now(), senderId: '3'),
    Message(eid: '1', message: 'hi', timestamp: DateTime.now(), senderId: '2'),
    Message(eid: '1', message: 'hi', timestamp: DateTime.now(), senderId: '3'),
    Message(eid: '1', message: 'hi', timestamp: DateTime.now(), senderId: '2'),
    Message(eid: '1', message: 'hi', timestamp: DateTime.now(), senderId: '3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/2,
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height/2 - bottomBarHeight,
            child: ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (messages[index].senderId != '2'
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].senderId != "2"
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
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
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
}
