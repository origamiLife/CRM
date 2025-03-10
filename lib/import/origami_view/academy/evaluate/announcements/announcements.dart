// import 'package:academy/welcome_to_academy/export.dart';
// import 'package:http/http.dart' as http;
//
// class Announcements extends StatefulWidget {
//   Announcements({super.key,});
//
//   @override
//   _AnnouncementsState createState() => _AnnouncementsState();
// }
//
// class _AnnouncementsState extends State<Announcements> {
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Text(
//           'NotFoundData',
//           style: TextStyle(fontFamily: 'Arial',
//             fontSize: 16.0,
//             color: const Color(0xFF555555),
//             fontWeight: FontWeight.w700,
//           ),
//           overflow: TextOverflow.ellipsis,
//           maxLines: 1,
//         ));
//     //   Padding(
//     //   padding: const EdgeInsets.all(16),
//     //   child: SingleChildScrollView(
//     //     child: Column(
//     //       children: List.generate(1, (index) {
//     //         return Column(
//     //           children: [
//     //             Card(
//     //               color: Colors.white,
//     //               elevation: 0,
//     //               child: InkWell(
//     //                 child: Container(
//     //                   padding: EdgeInsets.all(20),
//     //                   decoration: BoxDecoration(
//     //                     color: Colors.white,
//     //                     borderRadius: BorderRadius.circular(20),
//     //                   ),
//     //                   child: Row(
//     //                     children: [
//     //                       Image.network(
//     //                         'https://webcodeft.com/wp-content/uploads/2021/11/dummy-user.png',
//     //                         width: 90,
//     //                         height: 100,
//     //                         fit: BoxFit.fill,
//     //                       ),
//     //                       SizedBox(
//     //                         width: 8,
//     //                       ),
//     //                       Expanded(
//     //                         child: Column(
//     //                           crossAxisAlignment: CrossAxisAlignment.start,
//     //                           children: [
//     //                             SingleChildScrollView(
//     //                               scrollDirection: Axis.horizontal,
//     //                               child: Row(
//     //                                 children: [
//     //                                   Icon(Icons.note_alt,color: Colors.amber,),
//     //                                   SizedBox(width: 4,),
//     //                                   Text(
//     //                                     'รบกวนแสดงความคิดเห็น',
//     //                                     style: TextStyle(fontFamily: 'Arial',
//     //                                       fontSize: 20.0,
//     //                                       color: Colors.amber,
//     //                                       fontWeight: FontWeight.w700,
//     //                                     ),
//     //                                     overflow: TextOverflow.ellipsis,
//     //                                     maxLines: 1,
//     //                                   ),
//     //                                 ],
//     //                               ),
//     //                             ),
//     //                             SizedBox(height: 8,),
//     //                             Text(
//     //                               'รบกวนแสดงความคิดเห็น ที่มีต่อคอร์สหลังเรียนจบ',
//     //                               style: TextStyle(fontFamily: 'Arial',
//     //                                 color: Color(0xFF555555),
//     //                               ),
//     //                               overflow: TextOverflow.ellipsis,
//     //                               maxLines: 3,
//     //                             ),
//     //                           ],
//     //                         ),
//     //                       ),
//     //                     ],
//     //                   ),
//     //                 ),
//     //               ),
//     //             ),
//     //             SizedBox(
//     //               height: 8,
//     //             ),
//     //           ],
//     //         );
//     //       }),
//     //     ),
//     //   ),
//     // );
//   }
//
// }
//
// class Announcement {
//   final String announceId;
//   final String announceSubject;
//   final String announceDesc;
//   final String announceDate;
//   final String empPic;
//   final int count;
//
//   Announcement({
//     required this.announceId,
//     required this.announceSubject,
//     required this.announceDesc,
//     required this.announceDate,
//     required this.empPic,
//     required this.count,
//   });
//
//   factory Announcement.fromJson(Map<String, dynamic> json) {
//     return Announcement(
//       announceId: json['announce_id'],
//       announceSubject: json['announce_subject'],
//       announceDesc: json['announce_desc'],
//       announceDate: json['announce_date'],
//       empPic: json['emp_pic'],
//       count: json['count'],
//     );
//   }
// }
