import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../language/translate.dart';

class ChatWhats extends StatefulWidget {
  @override
  _ChatWhatsState createState() => _ChatWhatsState();
}

class _ChatWhatsState extends State<ChatWhats> {
  final TextEditingController _controller = TextEditingController();

  final List<ChatMessage> _messages = [];
  bool step = false;
  @override
  void initState() {
    super.initState();
    if (step == false) {
      _handleSubmit(
          "สวัสดี คุณ .Earth.🌏..\nนี่คือบัญชีทางการของ Jirapat Dev.\nขอบคุณที่เป็นเพื่อนกับเรา(moon wink)\n\nเราจะส่งข่าวสารล่าสุดผ่านบัญชีทางการนี้เป็นระยะ(love letter)\nเตรียมรับได้เลย!(gift)(stars)");
      step = true;
    }
  }

  void _handleSubmit(String text) {
    if (text.isNotEmpty) {
      setState(() {
        if (step == true) {
          _messages.add(ChatMessage(
            text: text,
            isMe: true,
            imageUrl: null, // ใส่ URL ของภาพโปรไฟล์ที่นี่ถ้าต้องการ
          ));
        }
        _messages.add(ChatMessage(
          text: '$text',
          isMe: false,
          imageUrl:
              'https://dev.origami.life/uploads/employee/185_20170727151718.png', // URL โปรไฟล์
        ));
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('.Earth.🌏..'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new), // เปลี่ยนไอคอนที่นี่
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: _ChatWhats(),
        ),
      ),
    );
  }

  Widget _ChatWhats() {
    return Container(
      // color: Colors.white,
      child: Column(
        children: <Widget>[
          Divider(
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ChatBubble(message: _messages[index]),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {},
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 48,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter your message',
                        hintStyle: GoogleFonts.openSans(
                          color: const Color(0xFF555555),
                        ),
                        labelStyle: GoogleFonts.openSans(
                          color: const Color(0xFF555555),
                        ),
                        enabledBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey, width: 1.2),
                        ),
                        border: InputBorder.none,
                        suffixIcon: Container(
                          alignment: Alignment.centerRight,
                          width: 10,
                          child: Center(
                            child: IconButton(
                                onPressed: () {
                                  // _searchController.clear();
                                },
                                icon: const Icon(Icons.insert_emoticon_outlined,size: 25,),
                                color: Colors.grey,),
                          ),
                        ),
                      ),
                      onSubmitted: _handleSubmit,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmit(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isMe && message.imageUrl != null)
            CircleAvatar(
              backgroundImage: NetworkImage(message.imageUrl!),
            ),
          SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: message.isMe ? Colors.blueAccent : Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                  topLeft: message.isMe ? Radius.circular(12) : Radius.circular(4),
                  topRight: message.isMe ? Radius.circular(4) : Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Text(
                message.text,
                style: GoogleFonts.openSans(
                  color: message.isMe ? Colors.white : Color(0xFF555555),
                ),
                // overflow: TextOverflow.ellipsis,
                // maxLines: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String? imageUrl; // ใช้สำหรับการแสดงภาพโปรไฟล์

  ChatMessage({
    required this.text,
    required this.isMe,
    this.imageUrl,
  });
}
