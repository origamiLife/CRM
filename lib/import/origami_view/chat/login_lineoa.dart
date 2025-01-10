// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../login/origami_login.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart';
//
// import 'line/chat_whats.dart';
// import 'line/chat_list.dart';
//
// // void main() {
// //   // ตั้งค่า LINE SDK โดยใช้ Channel ID ของคุณ
// //   LineSDK.instance.setup('YOUR_CHANNEL_ID').then((_) {
// //     print('LINE SDK is Prepared');
// //   });
// //   runApp(LineOAPage());
// // }
//
// class LoginLine extends StatefulWidget {
//   @override
//   _LoginLineState createState() => _LoginLineState();
// }
//
// class _LoginLineState extends State<LoginLine> {
//   String _userId = '';
//   String _userName = '';
//   int _selectedIndex = 0;
//   var _userEmail;
//
//   // ฟังก์ชันสำหรับการล็อกอิน
//   Future<void> _loginWithLine() async {
//     try {
//       final result = await LineSDK.instance.login(
//         scopes: ["profile", "openid", "email"],
//       );
//
//       setState(() {
//         _userId = result.userProfile!.userId;
//         _userName = result.userProfile!.displayName;
//         _userEmail = result.accessToken!.idToken!;
//       });
//
//       print('User ID: $_userId');
//       print('User Name: $_userName');
//       print('User Email: $_userEmail');
//     } catch (e) {
//       print('Login failed: $e');
//     }
//   }
//
//   bool isChat = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         color: Colors.white,
//         child: (isChat == false)
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: Container(
//                       child: Image.network(
//                         "https://lineforbusiness.com/files/%E0%B8%A7%E0%B8%B4%E0%B8%98%E0%B8%B5%E0%B8%81%E0%B8%B2%E0%B8%A3%E0%B8%AA%E0%B8%A3%E0%B9%89%E0%B8%B2%E0%B8%87%20LINE%20OA.jpg",
//                         fit: BoxFit.fill,
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(top: 15),
//                     child: Row(children: <Widget>[
//                       Expanded(
//                         child: Container(
//                           margin: const EdgeInsets.only(
//                               top: 0, bottom: 10, right: 10, left: 10),
//                           child: ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.all(1),
//                               foregroundColor: Colors.white,
//                               backgroundColor: Color.fromRGBO(0, 185, 0, 1),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                             child: Column(
//                               children: <Widget>[
//                                 Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: <Widget>[
//                                       Image.network(
//                                         'https://firebasestorage.googleapis.com/v0/b/messagingapitutorial.appspot.com/o/line_logo.png?alt=media&token=80b41ee6-9d77-45da-9744-2033e15f52b2',
//                                         width: 50,
//                                         height: 50,
//                                       ),
//                                       Container(
//                                         color: Colors.black12,
//                                         width: 2,
//                                         height: 40,
//                                       ),
//                                       Expanded(
//                                         child: Center(
//                                             child: Text("เข้าสู่ระบบด้วย LINE",
//                                                 style: TextStyle(
//                                                     fontSize: 17,
//                                                     fontWeight:
//                                                         FontWeight.bold))),
//                                       )
//                                     ])
//                               ],
//                             ),
//                             onPressed: () {
//                               // _loginWithLine();
//                               setState(() {
//                                 (isChat == false)?isChat = true:isChat = false;
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ]),
//                   ),
//                   SizedBox(height: 20),
//                   if (_userId.isNotEmpty) ...[
//                     Text('User ID: $_userId'),
//                     Text('User Name: $_userName'),
//                     Text('User Email: $_userEmail'),
//                   ]
//                 ],
//               )
//             : Container(
//           color: Colors.white,
//             child: ChatList(selectedIndex: _selectedIndex,),
//         ),
//       ),
//       // Center(
//       //   child: Column(
//       //     mainAxisAlignment: MainAxisAlignment.center,
//       //     children: [
//       //       ElevatedButton(
//       //         onPressed: _loginWithLine,
//       //         child: Text('Login with LINE'),
//       //       ),
//       //       SizedBox(height: 20),
//       //       if (_userId.isNotEmpty) ...[
//       //         Text('User ID: $_userId'),
//       //         Text('User Name: $_userName'),
//       //         Text('User Email: $_userEmail'),
//       //       ]
//       //     ],
//       //   ),
//       // ),
//     );
//   }
// }
