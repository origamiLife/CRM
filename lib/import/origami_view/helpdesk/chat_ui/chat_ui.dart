import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

class ChatBubbles extends StatefulWidget {
  const ChatBubbles({
    Key? key,
    required this.employee,
    required this.Authorization,
    required this.pageInput,
  }) : super(key: key);
  final Employee employee;
  final String Authorization;
  final String pageInput;

  @override
  _ChatBubblesState createState() => _ChatBubblesState();
}

class _ChatBubblesState extends State<ChatBubbles> {
  TextEditingController _messageController = TextEditingController();
  String _message = '';
  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      _message = _messageController.text;
      print("Current text: ${_messageController.text}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Color(0xFFFF9900),
        backgroundColor: Colors.white,
        title: Text(
          'HelpDesk',
          style: TextStyle(
                fontFamily: 'Arial',
              fontWeight: FontWeight.bold, color: Color(0xFFFF9900)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 12,
                        ),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              DateFormat('d MMM เวลา HH.mm น.', 'th').format(now),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _isMe(),
                    SizedBox(height: 8),
                    _isSupport2(),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: TextFormField(
                        controller: _messageController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                fontFamily: 'Arial',
                          color: Color(0xFF555555),
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          hintText: 'Write a message...',
                          hintStyle: TextStyle(
                fontFamily: 'Arial',
                              fontSize: 14, color: Color(0xFF555555)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.solidPaperPlane,
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
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: InkWell(
                      child: Icon(
                        FontAwesomeIcons.paperclip,
                        color: Colors.orange,
                        // size: 24,
                      ),
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 16),
                    child: InkWell(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          // จัดการรูปภาพ เช่น อัปโหลดหรือเพิ่มในข้อความ
                          print('Selected image path: ${image.path}');
                        } else {
                          print('No image selected.');
                        }
                      },
                      child: Icon(
                        FontAwesomeIcons.image,
                        color: Colors.orange,
                        // size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _isMe() {
    return Column(
        children: List.generate(3, (index) {
      return Row(
        children: [
          Expanded(
            flex: 1,
              child: SizedBox()),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF00CFC8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'This trailing comma makes auto-formatting nicer for build methods.',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          DateFormat('HH:mm').format(DateTime.now()),
                          style: TextStyle(
                fontFamily: 'Arial',
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade400,
            child: CircleAvatar(
              radius: 21,
              backgroundColor: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  '$host/uploads/employee/5/employee/19777.jpg?v=1730343291',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      );
    }));
  }

  Widget _isSupport2(){
    return Column(
        children: List.generate(1, (index) {
          return Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey.shade400,
                child: CircleAvatar(
                  radius: 21,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      '$host/uploads/employee/5/employee/19777.jpg?v=1730343291',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IT Support',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                'Perform crisis management and save practical checklists as canned responses so agents can go step-by-step, find the root of the issue, and resolve tickets quicker.',
                                style: TextStyle(
                fontFamily: 'Arial',
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  DateFormat('HH:mm').format(DateTime.now()),
                                  style: TextStyle(
                fontFamily: 'Arial',
                                    fontSize: 12,
                                    color: Color(0xFF555554),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 1,
                  child: SizedBox()),
            ],
          );
        }));
  }

}
