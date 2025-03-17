import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

import 'line/chat_list.dart';

class ChatView extends StatefulWidget {
  const ChatView({
    Key? key,
    required this.employee, required this.pageInput, required this.Authorization,
  }) : super(key: key);
  final Employee employee;
  final String pageInput;
  final String Authorization;
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  void initState() {
    super.initState();
  }

  // void line_oa() {
  //   // LineSDK.instance.setup('YOUR_CHANNEL_ID');
  //   runApp(LineOA());
  // }

  int _selectedIndex = 0;
  Widget _bodySwitch() {
    switch (_selectedIndex) {
      case 0:
        return ChatList(selectedIndex: _selectedIndex,);
      case 1:
        return ChatList(selectedIndex: _selectedIndex,);
      case 2:
        return ChatList(selectedIndex: _selectedIndex,);
      default:
        return Container(
          alignment: Alignment.center,
          child: Text(
            'ERROR!',
            style: TextStyle(
                fontFamily: 'Arial',
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  InkWell(
                    onTap: (){
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        _selectedIndex = 0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://www.rocket.in.th/wp-content/uploads/2023/03/%E0%B8%AA%E0%B8%A3%E0%B8%B8%E0%B8%9B-Line-Official-Account.png'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        _selectedIndex = 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://www.computerhope.com/jargon/f/facebook-messenger.png'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/640px-WhatsApp.svg.png'),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: _bodySwitch()
        ),
      ),
    );

  }
}
