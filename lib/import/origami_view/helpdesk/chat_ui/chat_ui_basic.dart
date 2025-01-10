import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ChatUiBasic extends StatefulWidget {
  @override
  _ChatUiBasicState createState() => _ChatUiBasicState();
}

class _ChatUiBasicState extends State<ChatUiBasic> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm'); // รูปแบบวันที่และเวลา
  final ChatUser currentUser = ChatUser(
    id: "123",
    firstName: "Jirapat",
    lastName: "Jangsawang",
    // profileImage: "https://placekitten.com/200/200",
  );

  final ChatUser otherUser = ChatUser(
    id: "456",
    firstName: "Support",
    lastName: "",
  );

  List<ChatMessage> chatMessages = [];

  @override
  void initState() {
    super.initState();
    // Initialize messages in initState
    chatMessages = [
      ChatMessage(
        text: "Hello! How can I help you?",
        createdAt: DateTime.now(),
        user: otherUser,
      ),
      ChatMessage(
        text: "I have a question about your service.",
        createdAt: DateTime.now().subtract(Duration(minutes: 1)),
        user: currentUser,
      ), //00CFC8
    ];
  }

  void onSend(ChatMessage message) {
    setState(() {
      chatMessages.add(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade200, // สีพื้นหลังของหน้าจอแชท
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Color(0xFFFF9900),
        backgroundColor: Colors.white,
        title: Text(
          'HelpDesk',
          style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold, color: Color(0xFFFF9900)),
        ),
      ),
      body: Container(
        child: DashChat(
          currentUser: currentUser,
          messages: chatMessages,
          onSend: (ChatMessage message) async {
            setState(() {
              chatMessages.insert(0, message); // Insert new message at the top
            });
            // Scroll to the bottom after sending a message
            _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );

            // // ส่งข้อความไปยังเซิร์ฟเวอร์
            // final response = await http.post(
            //   Uri.parse('https://example.com/api/send_message'),
            //   body: {'text': message.text, 'userId': currentUser.id},
            // );
            // if (response.statusCode != 200) {
            //   // จัดการข้อผิดพลาด
            // }
          },
          inputOptions: InputOptions(
            textController: _messageController,
            alwaysShowSend: true,
            sendOnEnter: true,
            sendButtonBuilder: (send) {
              return Row(
                children: [
                  InkWell(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          // จัดการรูปภาพที่เลือก
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.photo, color: Colors.orange),
                      )),
                  InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.paperclip,
                            color: Colors.orange),
                      )),
                  // IconButton(
                  //   icon: Icon(Icons.send, color: Colors.orange), // เปลี่ยนสีของไอคอนที่นี่
                  //   onPressed: send,
                  // ),
                ],
              );
            },
            inputToolbarStyle: BoxDecoration(
              color: Colors.white, // ตั้งค่าสีพื้นหลังที่นี่
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            inputDecoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              // labelText: 'Message',
              labelStyle: GoogleFonts.openSans(
                color: Colors.grey,
              ),
              hintText: "Write a message...",
              hintStyle: GoogleFonts.openSans(
                color: Colors.grey,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFFF9900),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(
                  color:
                      Color(0xFFFF9900), // ตั้งสีขอบเมื่อตัวเลือกถูกปิดใช้งาน
                  width: 1,
                ),
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
          messageOptions: MessageOptions(
            showCurrentUserAvatar : true,
            showOtherUsersAvatar : true,
            showOtherUsersName : true,
            showTime: true, // เปิดการแสดงเวลา
            // avatarBuilder: (date) {
            //   // กำหนดรูปแบบเพิ่มเติม หรือข้อความพิเศษในวันที่
            //   return Center(
            //     child: Container(
            //       margin: const EdgeInsets.symmetric(vertical: 8.0),
            //       padding: const EdgeInsets.all(8.0),
            //       decoration: BoxDecoration(
            //         color: Colors.orange,
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       child: Text(
            //         DateFormat('EEEE, dd MMMM yyyy').format(date), // เช่น "Monday, 26 November 2024"
            //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   );
            // },
            timeFormat: DateFormat('HH:mm'), // กำหนดรูปแบบเวลา (เช่น 14:30)
            // messageTimeBuilder: (dateTime, message) {
            //   final formattedTime = 'Yesterday';
            //   return Text(
            //     formattedTime,
            //     style: TextStyle(fontSize: 14, color: Colors.grey),
            //   );
            // },
            currentUserContainerColor:
                Color(0xFF00CFC8), // สีฟองข้อความของผู้ใช้งานปัจจุบัน
            containerColor: Colors.grey.shade200, // สีฟองข้อความของผู้ใช้อื่น
            textColor: Color(0xFF555555), // สีข้อความของผู้ใช้อื่น
            // currentUserTextColor: Colors.white, // สีข้อความของผู้ใช้งานปัจจุบัน
          ),
          messageListOptions: MessageListOptions(
            scrollController:
                _scrollController, // ใช้ MessageListOptions เพื่อกำหนด scrollController
          ),
        ),
      ),
    );
  }

  String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));

    if (dateTime.day == yesterday.day &&
        dateTime.month == yesterday.month &&
        dateTime.year == yesterday.year) {
      return "Yesterday";
    } else if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return DateFormat('HH:mm').format(dateTime);
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    }
  }
}
