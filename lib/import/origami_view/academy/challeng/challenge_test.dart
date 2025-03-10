import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/origami_view/academy/challeng/challenge_menu.dart';
import 'package:origamilift/import/origami_view/academy/challeng/summary_scores.dart';

import '../../../import.dart';
import '../evaluate/curriculum/curriculum.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({
    super.key,
    required this.employee,
    required this.Authorization,
    required this.initialMinutes,
    required this.getchallenge,
  });
  final Employee employee;
  final String Authorization;
  final double initialMinutes;
  final GetChallenge getchallenge;
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final CarouselSliderController _controller = CarouselSliderController();
  String _oneChoice = '';
  String timer_start = '';
  String timer_end = '';
  bool oneShot = true;

  // กำหนดค่าตัวเลือกเริ่มต้นให้ติ๊กไว้ 2 ข้อ
  // Set<String> _manyChoiceSet = {'1', '2'}; // ระบุ choice_id ที่ต้องการเลือกไว้ก่อน
  Set<String> _manyChoiceSet = {};
  Timer? timer;
  double _progress = 0.0; // เริ่มต้นที่ 100%
  double _progressValue = 0.8; // ค่าความคืบหน้า
  String getStatus = '';

  @override
  void initState() {
    super.initState();
    oneShot = true;
    fetchStartChallenge();
    fetchCheckAllChallenge();
    getStatus = widget.getchallenge.challenge_status;

    // fetchResult();
  }

  // นับเวลาถอยหลัง
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_progress > 0 &&
            (getStatus == 'doing' || getStatus == 'not_start')) {
          _progress--;
          print("เวลาคงเหลือ: $_progress วินาที");
        } else {
          print("หมดเวลา");
          _progress = 0;
          timer.cancel();

          fetchCheckAllChallenge();
          fetchFinishChallenge();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SummaryScores(
                employee: widget.employee,
                Authorization: widget.Authorization,
                initialMinutes: widget.initialMinutes,
                challenge: widget.getchallenge,
                questionList: questionList,
                isQuestion: checkAllChallenge,
              ),
            ),
          );
        }
      });
      // print("เวลาคงเหลือ: $_progress วินาที");
    });
  }

  // หมดเวลา
  // void _timeOutNextPage() {
  //   QuickAlert.show(
  //     context: context,
  //     type: QuickAlertType.info,
  //     width: MediaQuery.of(context).size.width > 600 ? 590 : 400,
  //     customAsset: 'assets/images/busienss1.jpg',
  //     widget: SizedBox(
  //       height: 100, // กำหนดความสูงของรูป
  //       child: Image.network(
  //           'https://images.ctfassets.net/unrdeg6se4ke/42cuIBOAntDgaG1GinrKHs/e424890c6ae3ed84021e247011ca949c/summary-1366x446-1.jpg'),
  //     ),
  //     title: '$timeoutTS!',
  //     text: '$timeoutMessageTH',
  //     // autoCloseDuration: const Duration(seconds: 2),
  //     showConfirmBtn: true,
  //     barrierDismissible: false, // ปิดการแตะออกนอกกรอบ
  //     onCancelBtnTap: () {
  //       Navigator.pop(context);
  //     },
  //     onConfirmBtnTap: () {
  //       fetchFinishChallenge();
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => SummaryScores(
  //             employee: widget.employee,
  //             Authorization: widget.Authorization,
  //             initialMinutes: widget.initialMinutes,
  //             challenge: widget.getchallenge,
  //             questionList: questionList,
  //             isQuestion: checkAllChallenge,
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // สิ้นสุดการทดสอบ

  void showCustomDialog(
      BuildContext context, List<CheckAllChallenge> isQuestion) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                '$WarnTS!', // Title of the dialog
                style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              // SizedBox(height: ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 600 ? 590 : 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image (similar to customAsset)
                      Image.asset(
                        'https://images.ctfassets.net/unrdeg6se4ke/42cuIBOAntDgaG1GinrKHs/e424890c6ae3ed84021e247011ca949c/summary-1366x446-1.jpg',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$failureMessageTS',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _showDialog(isQuestion);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // Confirm Button
            TextButton(
              onPressed: () {
                fetchFinishChallenge();
                fetchCheckAllChallenge();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SummaryScores(
                      employee: widget.employee,
                      Authorization: widget.Authorization,
                      initialMinutes: widget.initialMinutes,
                      challenge: widget.getchallenge,
                      questionList: questionList,
                      isQuestion: checkAllChallenge,
                    ),
                  ),
                );
              },
              child: Text(
                'Success',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                  // fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void finishNextpage(List<CheckAllChallenge> isQuestion) {
    if (_oneChoice.isNotEmpty || _manyChoiceSet.isNotEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        width: MediaQuery.of(context).size.width > 600 ? 590 : 400,
        customAsset: 'assets/images/busienss1.jpg',
        widget: SizedBox(
          height: 100,
          child: Image.network(
            'https://images.ctfassets.net/unrdeg6se4ke/42cuIBOAntDgaG1GinrKHs/e424890c6ae3ed84021e247011ca949c/summary-1366x446-1.jpg',
          ),
        ),
        title: '$WarnTS!',
        text: '$failureMessageTS',
        confirmBtnText: 'Success',
        cancelBtnText: 'Close',
        showConfirmBtn: true,
        barrierDismissible: false,
        onCancelBtnTap: () {
          Navigator.pop(context);
          _showDialog(isQuestion);
        },
        onConfirmBtnTap: () {
          fetchFinishChallenge();
          fetchCheckAllChallenge();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SummaryScores(
                employee: widget.employee,
                Authorization: widget.Authorization,
                initialMinutes: widget.initialMinutes,
                challenge: widget.getchallenge,
                questionList: questionList,
                isQuestion: checkAllChallenge,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showFullScreenImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // ปิด Dialog เมื่อแตะที่รูป
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error);
              },
            ),
          ),
        );
      },
    );
  }

  void _mainDateTime(GetChallenge challenge, String timerStart) {
    if (timerStart.isEmpty) {
      print("Invalid start time.");
      return;
    }

    try {
      DateFormat format = DateFormat("yyyy/MM/dd HH:mm:ss"); // ใช้ / แทน -
      DateTime startTime = format.parse(timerStart).toUtc(); // แปลงเป็น UTC
      DateTime now = DateTime.now().toUtc();

      int durationMinutes = int.tryParse(challenge.challenge_duration) ?? 0;
      DateTime endTime = startTime.add(Duration(minutes: durationMinutes));

      // คำนวณเวลาคงเหลือ
      double remainingSeconds = endTime.difference(now).inSeconds.toDouble();
      _progress = remainingSeconds > 0 ? remainingSeconds : 0;

      print("เวลาเริ่มต้น: $startTime");
      print("เวลาสิ้นสุด: $endTime");
      print("คงเหลือ: $_progress วินาที");

      startTimer();
    } catch (e) {
      print("Error parsing date: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // question_no = question_list.first;
    _progressValue = _progress / (widget.initialMinutes * 60);
    // print("เวลาปัจจุบัน: $_progressValue นาที");
    return PopScope(
      canPop: true, // ป้องกันการออกจากหน้าก่อนเรียก fetchStatus()
      onPopInvoked: (didPop) async {
        // fetchFinishChallenge();
      },
      child: (getStatus == 'doing' || getStatus == 'not_start')
          ? Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                // elevation: 1,
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFFFF9900),
                title: RichText(
                  text: TextSpan(
                    text: '$timeTS: ',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: (isIPad || isTablet) ? 38 : 28,
                      color: Colors.white, // สีส้มสำหรับ 'Time:'
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '${formatTime(_progress.toInt())}', // ส่วนข้อความที่เหลือ
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: (isIPad || isTablet) ? 38 : 28,
                          color: Colors.white, // สีแดงสำหรับเวลา
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon:
                      Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrigamiPage(
                            employee: widget.employee,
                            Authorization: widget.Authorization,
                            popPage: 2,
                            page: 'challenge'),
                      ),
                    );
                  },
                ),
                // leading: Icon(null),
              ),
              body: _getContentWidget(),
            )
          : Scaffold(backgroundColor: Colors.white, body: _loadingWidget()),
    );
  }

  Widget _getContentWidget() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(isIPad || isTablet ? 24 : 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  LinearProgressIndicator(
                    value: widget.initialMinutes * 60,
                    backgroundColor: Colors.grey.shade300,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.grey.shade300),
                    minHeight: 10,
                  ),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.orange.shade100,
                        Colors.orange.shade300,
                        Colors.orange.shade500
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: LinearProgressIndicator(
                      value: _progressValue,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            FutureBuilder<QuestionData?>(
              future: fetchQuestionData(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return _loadingWidget();
                } else {
                  final questionList = snapshot.data!;
                  return _contentWidget(questionList);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFFFF9900)),
          SizedBox(width: 12),
          Text(
            '$loadingTS...',
            style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF555555)),
          ),
        ],
      ),
    );
  }

  Widget _contentWidget(QuestionData questionData) {
    return Expanded(
      child: FutureBuilder<List<CheckAllChallenge>>(
          future: fetchCheckAllChallenge(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _loadingWidget();
            } else {
              final isQuestion = snapshot.data!;
              checkAllChallenge = isQuestion;
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _questionRow(questionData),
                          if (isIPad || isTablet) SizedBox(height: 28),
                          _imageCarousel(questionData),
                          SizedBox(height: 8),
                          _choice(questionData.question.choice, isQuestion,
                              questionData.question.choice_choose),
                          SizedBox(height: 8),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Align(
                          //     alignment: Alignment.centerRight,
                          //     child: Container(
                          //       padding: EdgeInsets.all(5),
                          //       decoration: BoxDecoration(
                          //         color: Colors.orange.shade200,
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //       child: Text(
                          //         'ความคืบหน้า : 50%',
                          //         style: TextStyle(
                          //             fontFamily: 'Arial',
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.w600,
                          //             color: Colors.white),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  _actionButtons(questionData, isQuestion),
                ],
              );
            }
          }),
    );
  }

  Widget _questionRow(QuestionData questionData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Q${questionData.question.question_seq}. ',
          style: TextStyle(
              fontFamily: 'Arial',
              fontSize: (isIPad || isTablet) ? 32 : 18,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w700),
        ),
        Flexible(
          child: Text(
            questionData.question.question_text,
            style: TextStyle(
                fontFamily: 'Arial',
                fontSize: (isIPad || isTablet) ? 24 : 16,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
            maxLines: 10,
          ),
        ),
      ],
    );
  }

  Widget _imageCarousel(QuestionData questionData) {
    if (questionData.question.question_image.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 24),
            onPressed: () {
              _controller.previousPage();
            },
          ),
          Expanded(
            child: CarouselSlider.builder(
              itemCount: questionData.question.question_image.length,
              carouselController: _controller,
              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: false,
                autoPlayInterval: Duration(seconds: 5),
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  int currentIndex = 0;
                  setState(() {
                    currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: isIPad || isTablet ? 24 : 12),
                  child: GestureDetector(
                    onTap: () {
                      _showFullScreenImage(
                          questionData.question.question_image[index]);
                    },
                    child: Image.network(
                      questionData.question.question_image[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.error);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 24),
            onPressed: () {
              _controller.nextPage();
            },
          ),
        ],
      );
    }
    return SizedBox();
  }

  Widget _actionButtons(
      QuestionData questionData, List<CheckAllChallenge> isQuestion) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _actionButton("${skipTS}", () {
            if (questionData.question.question_seq !=
                questionList.length.toString()) {
              int index = int.parse(questionData.question.question_seq);
              question_first = questionList[index];
              // fetchStartChallenge();
            }
          }),
          IconButton(
              onPressed: () {
                _showDialog(isQuestion);
              },
              icon: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.window_sharp,
                    color: Colors.white,
                  ))),
          // (isYChoice == false)
          //     ?
          _actionButton(
              (questionData.question.question_seq ==
                      questionList.length.toString())
                  ? "${FinishTS}"
                  : "${nextTS}", () {
            if (questionData.question.choice_choose == []) {
            } else {
              if (_oneChoice != '') {
                if (questionData.question.question_seq ==
                    questionList.length.toString()) {
                  int index = int.parse(questionData.question.question_seq) - 1;
                  question_first = questionList[index];
                  fetchSend(_oneChoice, questionList[index]);
                  finishNextpage(isQuestion);
                } else {
                  int index = int.parse(questionData.question.question_seq) - 1;
                  int index2 = int.parse(questionData.question.question_seq);
                  question_first = questionList[index2];

                  fetchSend(_oneChoice, questionList[index]);
                  showIconDialog(context, choice_correct);
                }
              }
            }
          })
          // : _actionButton(
          //     (questionData.question.question_seq ==
          //             questionList.length.toString())
          //         ? "finish"
          //         : "", () {
          //     if (questionData.question.question_seq ==
          //         questionList.length.toString()) {
          //       int index =
          //           int.parse(questionData.question.question_seq) - 1;
          //       question_first = questionList[index];
          //       fetchSend(_oneChoice);
          //       finishNextpage(isQuestion);
          //     }
          //   }),
        ],
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.only(right: 8, left: 8, top: 4, bottom: 4),
        decoration: BoxDecoration(
          color: Colors.orange.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontFamily: 'Arial',
              fontSize: (isIPad || isTablet) ? 24 : 16,
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  String choice_correct = '';
  Widget _choice(List<Choice> choiceList, List<CheckAllChallenge> isQuestion,
      List<ChoiceChoose> choice_choose) {
    return Card(
      elevation: 0,
      child: Column(
        children: List.generate(choiceList.length, (index1) {
          final isSelected =
              _manyChoiceSet.contains(choiceList[index1].choice_id);
          final choice = choiceList[index1];
          return Row(
            children: [
              Expanded(
                child:
                    // nChoice(choice, isSelected, isQuestion)
                    (choice_choose.isEmpty ||
                            choice_choose.first.choice_no.isEmpty)
                        ? nChoice(choice, isSelected, isQuestion)
                        : yChoice(
                            choice, isSelected, isQuestion, choice_choose),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  bool isYChoice = false;
  int choiceNo = 1;

// ปรับปรุงฟังก์ชัน yChoice
  Widget yChoice(Choice choice, bool isSelected,
      List<CheckAllChallenge> isQuestion, List<ChoiceChoose> choice_choose) {
    isYChoice = true;
    Color borderColor = Colors.white;
    if (choice.choice_no == choice_choose.first.choice_no) {
      if (choice_choose.first.choice_correct == "0") {
        borderColor = const Color(0xFFEE546C); // สีแดง
      } else {
        borderColor = const Color(0xFF00C789); // สีเขียว
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF1F7F0),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
            color: borderColor, width: 2), // ใช้ borderColor ตามเงื่อนไข
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        title: Row(
          children: [
            Expanded(
              child: Text(
                choice.choice_text,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: (isIPad || isTablet) ? 24 : 16,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (choice.choice_correct == "1")
              Icon(Icons.check_circle, color: Colors.green)
          ],
        ),
        leading: (choiceNo > 1)
            ? manyChoice(choice, isSelected, isQuestion)
            : Radio<String>(
                value: choice.choice_no,
                groupValue: choice_choose.first.choice_no,
                hoverColor: Color(0xFF555555),
                activeColor: Color(0xFF555555),
                onChanged: (String? value) {},
              ),
      ),
    );
  }

  // bool isYChoice = false;
  // Widget yChoice(Choice choice, bool isSelected,
  //     List<CheckAllChallenge> isQuestion, List<ChoiceChoose> choice_choose) {
  //   isYChoice = true;
  //   Color borderColor = Colors.white;
  //   if (choice.choice_no == choice_choose.first.choice_no) {
  //     if (choice_choose.first.choice_correct == "0") {
  //       borderColor = const Color(0xFFEE546C); // สีแดง
  //     } else {
  //       borderColor = const Color(0xFF00C789); // สีเขียว
  //     }
  //   }
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Color(0xFFF1F7F0),
  //       borderRadius: BorderRadius.circular(4),
  //       border: Border.all(
  //           color: borderColor, width: 2), // ใช้ borderColor ตามเงื่อนไข
  //     ),
  //     child: ListTile(
  //       contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
  //       title: Row(
  //         children: [
  //           Expanded(
  //             child: Text(
  //               choice.choice_text,
  //               style: TextStyle(
  //                 fontFamily: 'Arial',
  //                 fontSize: (isIPad || isTablet) ? 24 : 16,
  //                 color: Color(0xFF555555),
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //           if (choice.choice_correct == "1")
  //             Icon(Icons.check_circle, color: Colors.green)
  //         ],
  //       ),
  //       leading: (choiceNo > 1)
  //           ? manyChoice(choice, isSelected, isQuestion)
  //           : Radio<String>(
  //               value: choice.choice_no,
  //               groupValue: choice_choose.first.choice_no,
  //               hoverColor: Color(0xFF555555),
  //               activeColor: Color(0xFF555555),
  //               onChanged: (String? value) {},
  //             ),
  //     ),
  //   );
  // }

  // ยังไม่ทำ
  Widget nChoice(
      Choice choice, bool isSelected, List<CheckAllChallenge> isQuestion) {
    isYChoice = false;
    Color borderColor = (_oneChoice == choice.choice_id || isSelected)
        ? Color(0xFF00C789)
        : Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF1F7F0),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF1F7F0),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          title: Text(
            choice.choice_text,
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: (isIPad || isTablet) ? 24 : 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          leading: (choiceNo > 1)
              ? manyChoice(choice, isSelected, isQuestion)
              : Radio<String>(
                  value: choice.choice_id,
                  groupValue: _oneChoice,
                  hoverColor: Color(0xFF555555),
                  activeColor: Color(0xFF555555),
                  onChanged: (String? value) {
                    setState(() {
                      _oneChoice = value!;
                      choice_correct = choice.choice_correct;
                    });
                  },
                ),
        ),
      ),
    );
  }

  // มากกว่า 1 ข้อ
  Widget manyChoice(
      Choice choice, bool isSelected, List<CheckAllChallenge> isQuestion) {
    // isYChoice = false;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            // Remove the choice from the set when deselected
            _manyChoiceSet.remove(choice.choice_id);
          } else {
            // Add the choice to the set if not selected and under the limit
            if (_manyChoiceSet.length < choiceNo) {
              _manyChoiceSet.add(choice.choice_id);
            } else {
              // Optional: Provide feedback if limit reached
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('You can select up to choice no choices')),
              );
            }
          }
          print(choice.choice_id);
          print(_manyChoiceSet);
          print(_manyChoiceSet.isNotEmpty);
        });
      },
      child: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected ? Color(0xFF00C789) : Color(0xFF555555),
      ),
    );
  }

  void _showDialog(List<CheckAllChallenge> isQuestion) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black54,
            ),
            child: AlertDialog(
              contentPadding: EdgeInsets.zero, // ลบ Padding ด้านใน
              content: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$challengeSectionTS",
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: (isAndroid || isIPhone) ? 20 : 30,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF555555),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "$questionTS: ${isQuestion.length}",
                              style: TextStyle(
                                fontFamily: 'Arial',
                                fontSize: (isAndroid || isIPhone) ? 16 : 24,
                                color: Color(0xFF555555),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 22),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.8,
                              ),
                              child: Wrap(
                                  spacing: (isAndroid || isIPhone) ? 8 : 16,
                                  runSpacing: (isAndroid || isIPhone) ? 8 : 16,
                                  children:
                                      List.generate(isQuestion.length, (index) {
                                    final dataQ = isQuestion[index];
                                    Color cardColor;
                                    if (dataQ.question_status == 'Y') {
                                      cardColor = Color(0xFF00C789);
                                    } else if (dataQ.question_status == 'N') {
                                      cardColor = Color(0xFFEE546C);
                                    } else {
                                      cardColor = Color(0xFFC0C4CC);
                                    }
                                    return InkWell(
                                      onTap: () {
                                        if ((dataQ.question_status != 'Y') ||
                                            (dataQ.question_status != 'N')) {
                                          question_first = questionList[index];
                                          // fetchStartChallenge();
                                          Navigator.pop(dialogContext);
                                        }
                                      },
                                      child: Container(
                                        height:
                                            (isAndroid || isIPhone) ? 40 : 80,
                                        width:
                                            (isAndroid || isIPhone) ? 40 : 80,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 16
                                                : 20,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    );
                                  })),
                            ),
                            SizedBox(height: 22),
                            // about => status
                            Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        color: Color(0xFF00C789),
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          '$correctTS',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 14
                                                : 20,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        color: Color(0xFFEE546C),
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          '$incorrectTS',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 14
                                                : 20,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        color: Color(0xFFC0C4CC),
                                      ),
                                      SizedBox(width: 8),
                                      Flexible(
                                        child: Text(
                                          '$noResultTS',
                                          style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: (isAndroid || isIPhone)
                                                ? 14
                                                : 20,
                                            color: Color(0xFF555555),
                                            fontWeight: FontWeight.w700,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(dialogContext);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4, top: 4),
                          child: Icon(
                            Icons.clear,
                            size: (isAndroid || isIPhone) ? 22 : 45,
                            color: Colors.red,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showIconDialog(BuildContext context, String choice_correct) {
    final isCheck = (choice_correct == "1") ? true : false;
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิดด้วยการแตะด้านนอก
      builder: (BuildContext context) {
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.of(context).pop(); // ปิด Dialog อัตโนมัติใน 0.5 วินาที
        });

        return Dialog(
          backgroundColor: Colors.transparent, // ให้พื้นหลังโปร่งใส
          elevation: 0, // ไม่มีเงา
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 10), // ใช้เวลา 0.3 วินาที
            builder: (context, value, child) {
              return Transform.scale(
                scale: value, // ค่อย ๆ ขยายขนาด
                child: child,
              );
            },
            child: Icon(
              isCheck
                  ? Icons.check_circle_outline
                  : Icons.highlight_remove_sharp, // ไอคอนที่ต้องการแสดง
              color: isCheck ? Color(0xFF00C789) : Color(0xFFEE546C), // สีไอคอน
              size: 80, // ขนาดไอคอน
            ),
          ),
        );
      },
    );
  }

  //----------------- 2.1 start-challenge------------------------------------------------------------

  List<String> questionList = [];
  bool isLoading = false;
  int total_point_all = 0;
  String question_first = '';

  Future<void> fetchStartChallenge() async {
    final uri = Uri.parse("$host/api/origami/challenge/start-challenge.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.getchallenge.challenge_id,
          'request_id': widget.getchallenge.request_id,
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to load challenge data. Status code: ${response.statusCode}');
      }

      final jsonResponse = json.decode(response.body);
      String timerStart = jsonResponse['timer_start']?.toString() ?? '';
      String questionFirst = jsonResponse['question_first']?.toString() ?? '';

      if (questionFirst == '') {
        print('questionFirst1 : $questionFirst');
        print("Retrying fetchNextChallenge, timer_start is empty.$timerStart");
        await Future.delayed(
            Duration(seconds: 2)); // ป้องกันการเรียกซ้ำเร็วเกินไป
        return fetchStartChallenge();
      } else {
        print('questionFirst2 : $questionFirst');
        // ตรวจสอบและแปลง `question_list` เป็น List<String>
        List<String> tempQuestionList = [];
        if (jsonResponse['question_list'] is List) {
          tempQuestionList = List<String>.from(jsonResponse['question_list']);
        } else {
          print("Warning: question_list is not a valid list.");
        }

        setState(() {
          questionList = tempQuestionList;
          total_point_all = questionList.length;
          print('Updated questionList: $questionList');

          if (oneShot == true) {
            question_first = questionFirst;
            _mainDateTime(widget.getchallenge, timerStart);
            oneShot = false;
            print("Final question_first: $question_first");
          }
        });
      }
    } catch (e) {
      print('Error fetching challenge data: $e');
    }
  }

  List<CheckAllChallenge> checkAllChallenge = [];
  Future<List<CheckAllChallenge>> fetchCheckAllChallenge() async {
    final uri = Uri.parse("$host/api/origami/challenge/get-question-no.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.getchallenge.challenge_id,
          'request_id': widget.getchallenge.request_id,
          'question_no': question_first,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        // เข้าถึงข้อมูลในคีย์ 'instructors'
        final List<dynamic> challengeJson = jsonResponse['challenge_data'];
        // แปลงข้อมูลจาก JSON เป็น List<Instructor>
        checkAllChallenge = challengeJson
            .map((json) => CheckAllChallenge.fromJson(json))
            .toList();
        print(checkAllChallenge);
        return challengeJson
            .map((json) => CheckAllChallenge.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Failed to load question data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching question data: $e');
      throw Exception('Error fetching question data: $e');
    }
  }

  //------------------3.1 get-question-----------------------------------------------------------

  Future<QuestionData?> fetchQuestionData() async {
    if (question_first.isEmpty) {
      await fetchStartChallenge(); // ดึง Challenge ก่อน
      if (question_first.isEmpty)
        return null; // ถ้ายังไม่มี question_first ก็จบเลย
    }

    final uri = Uri.parse("$host/api/origami/challenge/get-question.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.getchallenge.challenge_id,
          'request_id': widget.getchallenge.request_id,
          'question_no': question_first,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('question_data') &&
            jsonResponse['question_data'] != null) {
          return QuestionData.fromJson(jsonResponse['question_data']);
        } else {
          print('No question data found in response.');
          return null;
        }
      } else {
        throw Exception(
            'Failed to load question data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching question data: $e');
      return null;
    }
  }

  //------------------ 3.2 send-answer-----------------------------------------------------------

  String next_question = '';
  Future<void> fetchSend(String choices, String question_no) async {
    final uri = Uri.parse("$host/api/origami/challenge/send-answer.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.getchallenge.challenge_id,
          'request_id': widget.getchallenge.request_id,
          'question_no': question_no,
          'choices[0]': choices,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
        } else {
          throw Exception('Empty response data');
        }
      } else {
        throw Exception(
            'Failed to load challenge data, status code: ${response.statusCode}');
      }
    } catch (e) {
      // จับข้อผิดพลาดต่างๆ เช่น การเชื่อมต่อ API หรือการแปลง JSON
      throw Exception('Error fetching challenge data: $e');
    }
  }

  //----------------- 3.3 finish-challenge------------------------------------------------------------

  Future<void> fetchFinishChallenge() async {
    final uri = Uri.parse("$host/api/origami/challenge/finish-challenge.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.getchallenge.challenge_id,
          'request_id': widget.getchallenge.request_id,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        if (jsonResponse.isNotEmpty) {
        } else {
          throw Exception('Empty response data');
        }
      } else {
        throw Exception(
            'Failed to load challenge data, status code: ${response.statusCode}');
      }
    } catch (e) {
      // จับข้อผิดพลาดต่างๆ เช่น การเชื่อมต่อ API หรือการแปลง JSON
      throw Exception('Error fetching challenge data: $e');
    }
  }
}

class QuestionData {
  final Question question;

  QuestionData({required this.question});

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      question: Question.fromJson(json['question']),
    );
  }
}

class Question {
  final String id;
  final String challenge_id;
  final String question_no;
  final String question_text;
  final String question_image;
  final String show_answer;
  final String question_seq;
  final List<ChoiceChoose> choice_choose;
  final List<Choice> choice;
  final String correct;

  Question({
    required this.id,
    required this.challenge_id,
    required this.question_no,
    required this.question_text,
    required this.question_image,
    required this.show_answer,
    required this.question_seq,
    required this.choice_choose,
    required this.choice,
    required this.correct,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      challenge_id: json['challenge_id'] ?? '',
      question_no: json['question_no'] ?? '',
      question_text: json['question_text'] ?? '',
      question_image: json['question_image'] ?? '',
      show_answer: json['show_answer'] ?? '',
      question_seq: json['question_seq'] ?? '',
      choice_choose: (json['choice_choose'] as List?)
              ?.map((e) => ChoiceChoose.fromJson(e))
              .toList() ??
          [],
      choice:
          (json['choice'] as List?)?.map((e) => Choice.fromJson(e)).toList() ??
              [],
      correct: json['correct'] ?? '',
    );
  }
}

class Choice {
  final String choice_id;
  final String choice_no;
  final String choice_text;
  final String choice_image;
  final String choice_correct;

  Choice({
    required this.choice_id,
    required this.choice_no,
    required this.choice_text,
    required this.choice_image,
    required this.choice_correct,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      choice_id: json['choice_id'] ?? '',
      choice_no: json['choice_no'] ?? '',
      choice_text: json['choice_text'] ?? '',
      choice_image: json['choice_image'] ?? '',
      choice_correct: json['choice_correct'] ?? '',
    );
  }
}

class ChoiceChoose {
  final String choice_no;
  final String choice_correct;

  ChoiceChoose({
    required this.choice_no,
    required this.choice_correct,
  });

  factory ChoiceChoose.fromJson(Map<String, dynamic> json) {
    return ChoiceChoose(
      choice_no: json['choice_no'],
      choice_correct: json['choice_correct'],
    );
  }
}

class TopChallenge {
  final List<TopUser> topUsers;

  TopChallenge({required this.topUsers});

  factory TopChallenge.fromJson(Map<String, dynamic> json) {
    return TopChallenge(
      topUsers: (json['top_challenge'] as List?)
              ?.map((user) => TopUser.fromJson(user))
              .toList() ??
          [],
    );
  }
}

class TopUser {
  final String avatar;
  final String firstname;
  final String lastname;
  final String point;
  final String time_used;
  final String emp_id;

  TopUser({
    required this.avatar,
    required this.firstname,
    required this.lastname,
    required this.point,
    required this.time_used,
    required this.emp_id,
  });

  factory TopUser.fromJson(Map<String, dynamic> json) {
    return TopUser(
      avatar: json['avatar'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      point: json['point'] ?? '',
      time_used: json['time_used'] ?? '',
      emp_id: json['emp_id'] ?? '',
    );
  }
}

class CheckAllChallenge {
  final String question_seq;
  final String question_no;
  final String question_status;

  CheckAllChallenge({
    required this.question_seq,
    required this.question_no,
    required this.question_status,
  });

  factory CheckAllChallenge.fromJson(Map<String, dynamic> json) {
    return CheckAllChallenge(
      question_seq: json['question_seq'] ?? '',
      question_no: json['question_no'] ?? '',
      question_status: json['question_status'] ?? '',
    );
  }
}
