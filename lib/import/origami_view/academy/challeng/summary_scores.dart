//
// import 'package:origamilift/import/origami_view/academy/challeng/summary/finished_challenge.dart';
// import 'package:origamilift/import/origami_view/academy/challeng/summary/my_challenge.dart';
//
// import '../../../import.dart';
// import 'challenge_menu.dart';
// import 'challenge_test.dart';
//
// class SummaryScores extends StatefulWidget {
//   const SummaryScores({
//     super.key,
//     required this.employee,
//     required this.Authorization,
//     required this.initialMinutes,
//     required this.challenge,
//     required this.questionList,
//     required this.isQuestion,
//   });
//   final Employee employee;
//   final String Authorization;
//   final double initialMinutes;
//   final GetChallenge challenge;
//   final List<String> questionList;
//   final List<CheckAllChallenge> isQuestion;
//
//   @override
//   _SummaryScoresState createState() => _SummaryScoresState();
// }
//
// class _SummaryScoresState extends State<SummaryScores> {
//   String _duration = '';
//   int _selectedIndex = 0;
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     minutes();
//   }
//
//   void minutes() {
//     int minutes = widget.initialMinutes.toInt();
//     Duration duration = Duration(minutes: minutes);
//
//     _duration = '${duration.inHours.toString().padLeft(2, '0')}:'
//         '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
//         '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
//     print(_duration); // 01:30:00
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         elevation: 1,
//         foregroundColor: Colors.white,
//         backgroundColor: Color(0xFFFF9900),
//         title: Text(
//           summaryTS,
//           style: TextStyle(
//             fontFamily: 'Arial',
//             fontSize: 28,
//             color: Colors.white,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => OrigamiPage(
//                   employee: widget.employee,
//                   Authorization: widget.Authorization, popPage: 2,page:'challenge'
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Container(
//               color: Colors.grey.shade100, height: 4, width: double.infinity),
//           // DefaultTabController(
//           //   animationDuration: Duration(milliseconds: 300),
//           //   length: 2,
//           //   initialIndex: 0,
//           //   child: Padding(
//           //     padding: const EdgeInsets.symmetric(horizontal: 16),
//           //     child: TabBar(
//           //       tabs: [
//           //         Tab(
//           //           text: myChallengeTS,
//           //         ),
//           //         Tab(
//           //           text: finishedChallengeTS,
//           //         ),
//           //       ],
//           //       labelStyle:TextStyle(
//           //         fontFamily: 'Arial',
//           //         fontSize: (isAndroid || isIPhone)?14:28,
//           //         fontWeight: FontWeight.w500,
//           //         color: Color(0xFF556785),
//           //       ),
//           //       labelColor: Color(0xFF555555),
//           //       unselectedLabelColor: Colors.grey.shade400,
//           //       indicator: MaterialIndicator(
//           //         height: 5,
//           //         topLeftRadius: 8,
//           //         topRightRadius: 8,
//           //         horizontalPadding: 50,
//           //         tabPosition: TabPosition.bottom,
//           //         color: Color(0xFF555555),
//           //       ),
//           //       onTap: _onItemTapped,
//           //     ),
//           //   ),
//           // ),
//           // SizedBox(height: 8),
//           // Container(color:Colors.grey.shade100,height: 4,width: double.infinity),
//           Expanded(
//             child: _selectedIndex == 0
//                 ? MyChallenge(
//                     employee: widget.employee,
//                     Authorization: widget.Authorization,
//                     duration: _duration,
//                     challenge: widget.challenge,
//                     questionList: widget.questionList,
//                     isQuestion: widget.isQuestion,
//                   )
//                 : FinishedChallenge(
//                     employee: widget.employee,
//                     Authorization: widget.Authorization,
//                     challenge: widget.challenge,
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
