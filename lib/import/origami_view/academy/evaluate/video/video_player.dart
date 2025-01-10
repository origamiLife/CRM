// import 'package:http/http.dart' as http;
// import '../../../login/origami_login.dart';
// import '../../academy.dart';
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'dart:async';
// import 'package:video_player/video_player.dart';
//
// class NetworkVideoPlayer extends StatefulWidget {
//   final String videoUrl;
//   final Employee employee;
//   final AcademyRespond academy;
//   final String Function(String) videoView;
//   final String Authorization;
//   const NetworkVideoPlayer({
//     Key? key,
//     required this.videoUrl,
//     required this.employee,
//     required this.academy,
//     required this.videoView, required this.Authorization,
//   }) : super(key: key);
//
//   @override
//   _NetworkVideoPlayerState createState() => _NetworkVideoPlayerState();
// }
//
// class _NetworkVideoPlayerState extends State<NetworkVideoPlayer> {
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isLoading = true;
//   String? _errorMessage;
//   int? _pausedSeconds; // ตัวแปรสำหรับบันทึกเวลาหยุดเฉพาะค่าวินาที
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }
//
//   Future<void> _initializePlayer() async {
//     _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
//     _videoPlayerController.addListener(_videoPlayerListener); // เพิ่ม listener
//     try {
//       await _videoPlayerController.initialize();
//       String strTime = "70";
//       int? inTime = int.parse(strTime);
//       await _videoPlayerController
//           .seekTo(Duration(seconds: inTime)); // กำหนดให้เริ่มต้นที่วินาทีที่ 10
//       setState(() {
//         _chewieController = ChewieController(
//           videoPlayerController: _videoPlayerController,
//           autoPlay: false,
//           looping: false,
//           zoomAndPan: true,
//           showControls: true, // แสดงปุ่มควบคุมพื้นฐาน
//           // customControls: CustomControls(), // ใช้ CustomControls เพื่อควบคุมการแสดงปุ่ม
//           aspectRatio: _videoPlayerController.value.aspectRatio,
//           errorBuilder: (context, errorMessage) {
//             return Center(
//               child: Text(
//                 errorMessage,
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           },
//         );
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to load video: $e';
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _videoPlayerListener() {
//     if (_videoPlayerController.value.isPlaying == false) {
//       // ตรวจสอบถ้าวิดีโอหยุดเล่น
//       if (_videoPlayerController.value.isPlaying == false) {
//         // ตรวจสอบถ้าวิดีโอหยุดเล่น
//         setState(() {
//           _pausedSeconds = _videoPlayerController
//               .value.position.inSeconds; // บันทึกเฉพาะค่าวินาทีที่หยุด
//         });
//         widget.videoView(_pausedSeconds.toString());
//         print(
//             'Paused at second: $_pausedSeconds'); // แสดงค่าวินาทีที่หยุดใน console หรือเก็บค่านี้ไว้ใช้
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController.removeListener(_videoPlayerListener); // ลบ listener
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: Text(
//             'Network Video Player',
//             style: GoogleFonts.openSans(
//               color: Colors.white,
//             ),
//           ),
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back_ios_new_sharp,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.pop(context); // ย้อนกลับไปยังหน้าก่อนหน้า
//             },
//           ),
//         ),
//         body: Center(
//           child: _isLoading
//               ? CircularProgressIndicator()
//               : _errorMessage != null
//                   ? Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           _errorMessage!,
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: _initializePlayer,
//                           child: Text('Retry'),
//                         ),
//                       ],
//                     )
//                   : Chewie(
//                       controller: _chewieController!,
//                     ),
//         ),
//       ),
//     );
//   }
// }
//
// // สร้าง custom controls ที่ห้ามข้ามวิดีโอ
// class CustomControls extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final chewieController = ChewieController.of(context);
//     final videoPlayerController = chewieController!.videoPlayerController;
//
//     return Container(
//       color: Colors.black54,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           IconButton(
//             icon: Icon(Icons.play_arrow, color: Colors.white),
//             onPressed: () {
//               videoPlayerController.value.isPlaying
//                   ? videoPlayerController.pause()
//                   : videoPlayerController.play();
//             },
//           ),
//           Text(
//             '${videoPlayerController.value.position.inSeconds} / ${videoPlayerController.value.duration.inSeconds} seconds',
//             style: TextStyle(color: Colors.white),
//           ),
//           // ลบหรือไม่แสดงปุ่มข้าม/กรอ
//           SizedBox(width: 48), // เพิ่มช่องว่างแทนปุ่ม rewind
//           SizedBox(width: 48), // เพิ่มช่องว่างแทนปุ่ม forward
//         ],
//       ),
//     );
//   }
// }
