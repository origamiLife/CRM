// import 'package:flutter/material.dart';
//
// class CustomChatView extends StatelessWidget {
//   final List<String> messages;
//   final TextEditingController messageController = TextEditingController();
//
//   CustomChatView({Key? key, required this.messages}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Custom Chat View'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return ChatMessage(message: messages[index]);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(hintText: 'Type a message'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () {
//                     // Handle send message logic
//                     if (messageController.text.isNotEmpty) {
//                       print('Sending: ${messageController.text}');
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChatMessage extends StatelessWidget {
//   final String message;
//
//   const ChatMessage({Key? key, required this.message}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(message),
//       tileColor: Colors.blueAccent.shade100,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       contentPadding: EdgeInsets.all(8),
//     );
//   }
// }