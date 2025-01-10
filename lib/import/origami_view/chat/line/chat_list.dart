import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../language/translate.dart';
import 'chat_whats.dart';

class ChatList extends StatefulWidget {
  ChatList({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);
  final int selectedIndex;

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  TextEditingController _searchController = TextEditingController();
  bool step = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Divider(),
              (widget.selectedIndex == 2)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Start chatting',
                          style: GoogleFonts.openSans(
                            color: Color(0xFF555555),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Message privately with your 2 WhatApp contact, \nno matter what device they use.',
                          style: GoogleFonts.openSans(
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: List.generate(1, (index) {
                            return Padding(
                              padding: EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/640px-WhatsApp.svg.png'),
                                          backgroundColor: Colors.green,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          'Your Notes',
                                          style: GoogleFonts.openSans(
                                            color: Color(0xFF555555),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              'https://dev.origami.life/uploads/employee/185_20170727151718.png'),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          '.Earth.🌏..',
                                          style: GoogleFonts.openSans(
                                            color: Color(0xFF555555),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.all(8),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Color(0xFFFF9900),
                                  width: 1.0,
                                ),
                              ),
                              child: TextFormField(
                                  controller: _searchController,
                                  keyboardType: TextInputType.text,
                                  style: GoogleFonts.openSans(
                                      color: Color(0xFF555555), fontSize: 14),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                    hintText: '$Search...',
                                    hintStyle: GoogleFonts.openSans(
                                        fontSize: 14, color: Color(0xFF555555)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Color(0xFFFF9900),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                  ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            (widget.selectedIndex == 0)
                                ? Container()
                                : (widget.selectedIndex == 1)
                                    ? Row(
                                        children: List.generate(1, (index) {
                                          return Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 28,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                'https://www.computerhope.com/jargon/f/facebook-messenger.png'),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        'Your Notes',
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color:
                                                              Color(0xFF555555),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 16,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 28,
                                                        backgroundImage:
                                                            NetworkImage(
                                                                'https://dev.origami.life/uploads/employee/185_20170727151718.png'),
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        '.Earth.🌏..',
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color:
                                                              Color(0xFF555555),
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      )
                                    : Container(),
                            Column(
                              children: List.generate(2, (index) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 12),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ChatWhats()),
                                      );
                                    },
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment :Alignment.centerRight,
                                          child: Text(
                                            '16.15 น.',
                                            style: GoogleFonts.openSans(
                                              fontSize:12,
                                              color: Colors.grey.shade400,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 12),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 24,
                                                backgroundImage: NetworkImage(
                                                    'https://dev.origami.life/uploads/employee/185_20170727151718.png'),
                                              ),
                                              SizedBox(width: 8),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '.Earth.🌏..',
                                                      style: GoogleFonts.openSans(
                                                        color: Color(0xFF555555),
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            'สำหรับข้อมูลเพิ่มเติมเกี่ยวกับสถานะการอัปเดตของรุ่น SDK แต่ละรุ่นที่เกี่ยวข้องกับข้างต้น โปรดดูที่หมายเหตุรุ่นSDK ของ LINE Messaging API',
                                                            style: GoogleFonts.openSans(
                                                              color: Colors.grey.shade400,
                                                            ),
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(4),
                                                          child: Card(
                                                              color: Colors.green,
                                                              child: Container(
                                                                padding: EdgeInsets.all(6),
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),

                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
