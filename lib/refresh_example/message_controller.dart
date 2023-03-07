import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  List<MessageItem> data = <MessageItem>[].obs;

  initData() async {
    await 3.delay(() {});
    data.assignAll([
      MessageItem(
        content: "你好...................asdasdasdasdasdasdasdasdasda",
        isMe: true,
        author: "我",
        url: "",
      ),
      MessageItem(
        content:
            "eem.....................................................................",
        isMe: false,
        author: "对方",
        url:
            "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1718395925,3485808025&fm=27&gp=0.jpg",
      ),
      MessageItem(
        content: "吃饭了没有?????????????",
        isMe: false,
        author: "对方",
        url:
            "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1718395925,3485808025&fm=27&gp=0.jpg",
      )
    ]);
  }

  addData() {
    data.add(MessageItem(
      content: "Xxxxxxxxxxxxxx",
      isMe: true,
      author: "我",
      url: myUrl,
    ));
    data.add(MessageItem(
      content: "...........",
      isMe: false,
      author: "对方",
      url:
          "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1718395925,3485808025&fm=27&gp=0.jpg",
    ));
    data.add(MessageItem(
        content: "吃饭了没有?????????????",
        isMe: false,
        author: "对方",
        url:
            "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1718395925,3485808025&fm=27&gp=0.jpg"));
  }

  @override
  void onInit() {
    initData();
    super.onInit();
  }
}

class MessageItem extends StatelessWidget {
  final String content;
  final String author;
  final bool isMe;
  final String url;

  MessageItem(
      {required this.content,
      required this.author,
      required this.isMe,
      required this.url});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Wrap(
        textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(url),
            radius: 20.0,
          ),
          Container(width: 15.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 25.0,
                width: 222.0,
                alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                child: Text(
                  author,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  minWidth: 100.0,
                  minHeight: 100.0,
                  maxWidth: 222.0,
                ),
                alignment: isMe ? Alignment.topRight : Alignment.topLeft,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  content,
                  style: TextStyle(color: Colors.black),
                ),
                padding: EdgeInsets.all(10.0),
              )
            ],
          )
        ],
      ),
    );
  }
}

const String myUrl =
    "https://avatars1.githubusercontent.com/u/19425362?s=400&u=1a30f9fdf71cc9a51e20729b2fa1410c710d0f2f&v=4";
