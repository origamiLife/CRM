import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import '../../../../import.dart';
import '../challenge_menu.dart';
import '../challenge_test.dart';

class FinishedChoiceChallenge extends StatefulWidget {
  FinishedChoiceChallenge({
    super.key,
    required this.employee,
    required this.Authorization,
    required this.challenge,
    required this.questionList,
    required this.isQuestion,
    required this.question_no,
    required this.Qno,
  });
  final Employee employee;
  final String Authorization;
  final GetChallenge challenge;
  final List<String> questionList;
  final List<CheckAllChallenge> isQuestion;
  final String question_no;
  final String Qno;
  @override
  _FinishedChoiceChallengeState createState() =>
      _FinishedChoiceChallengeState();
}

class _FinishedChoiceChallengeState extends State<FinishedChoiceChallenge> {
  final CarouselSliderController _controller = CarouselSliderController();
  String? _oneChoice;

  // กำหนดค่าตัวเลือกเริ่มต้นให้ติ๊กไว้ 2 ข้อ
  // Set<String> _manyChoiceSet = {'1', '2'}; // ระบุ choice_id ที่ต้องการเลือกไว้ก่อน
  // Set<String> _manyChoiceSet = {};
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 1,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFFFF9900),
        title: Row(
          children: [
            Flexible(
              child: Text(
                '$AnswersExamTS',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(isIPad || isTablet ? 24 : 16),
        child: SingleChildScrollView(
          child: FutureBuilder<QuestionData>(
            future: fetchQuestionData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
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
              } else {
                final questionList = snapshot.data!;
                return _contentWidget(questionList);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _contentWidget(QuestionData questionData) {
    final isQuestion = widget.isQuestion;
    return Column(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              _questionRow(questionData),
              if (isIPad || isTablet) SizedBox(height: 28),
              _imageCarousel(questionData),
              SizedBox(height: 8),
              _choice(questionData.question.choice, isQuestion,
                  questionData.question.choice_choose),
              SizedBox(height: 8),
            ],
          ),
        ),
        SizedBox(),
        // _actionButtons(questionData, isQuestion),
      ],
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    _showDialog(widget.isQuestion);
                  },
                  icon: Icon(Icons.window_sharp)),
            ],
          ),
        ],
      ),
    );
  }

  Set<String> _manyChoiceSet = {};
  String choice_correct = '';

  Widget _choice(
      List<Choice> choiceList,
      List<CheckAllChallenge> isQuestion,
      List<ChoiceChoose> choice_choose) {
    return Card(
      elevation: 0,
      child: Column(
        children: List.generate(choiceList.length, (index1) {
          final isSelected = _manyChoiceSet.contains(choiceList[index1].choice_id);
          final choice = choiceList[index1];
          return Row(
            children: [
              Expanded(
                child: (choice_choose.isEmpty
                    || choice_choose.first.choice_no.isEmpty)
                    ? nChoice(choice, isSelected, isQuestion)
                    : yChoice(choice, isSelected, isQuestion, choice_choose),
              ),
            ],
          );
        }),
      ),
    );
  }


  bool isYChoice = false;
  int choiceNo = 1;

// ปรับปรุงฟังก์ชัน yChoice
  Widget yChoice(Choice choice, bool isSelected,
      List<CheckAllChallenge> isQuestion, List<ChoiceChoose> choice_choose ) {
    isYChoice = true;
    Color borderColor = Colors.white;
    if (choice.choice_no == choice_choose.first.choice_no) {
      if(choice_choose.first.choice_correct == "0"){
        borderColor = const Color(0xFFEE546C); // สีแดง
      }else{
        borderColor = const Color(0xFF00C789); // สีเขียว
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF1F7F0),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor, width: 2), // ใช้ borderColor ตามเงื่อนไข
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
            if(choice.choice_correct == "1")Icon(Icons.check_circle,color: Colors.green)
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

  Widget nChoice(
      Choice choice, bool isSelected, List<CheckAllChallenge> isQuestion) {
    isYChoice = false;
    Color borderColor = Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF1F7F0),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor, width: 2), // ใช้ borderColor ตามเงื่อนไข
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
            if(choice.choice_correct == "1")Icon(Icons.check_circle,color: Colors.green)
          ],
        ),
        leading: (choiceNo > 1)
            ? manyChoice(choice, isSelected, isQuestion)
            : Radio<String>(
          value: choice.choice_id,
          groupValue: _oneChoice,
          hoverColor: Color(0xFF555555),
          activeColor: Color(0xFF00C789),
          onChanged: (String? value) {},
        ),
      ),
    );
  }

  Widget manyChoice(
      Choice choice, bool isSelected, List<CheckAllChallenge> isQuestion) {
    isYChoice = false;
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
                                        // question_no = questionList[index];
                                        // fetchNextChallenge();
                                        Navigator.pop(dialogContext);
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
                                          'No Result',
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

  Future<QuestionData> fetchQuestionData() async {
    final uri = Uri.parse("$host/api/origami/challenge/get-question.php");
    try {
      final response = await http.post(
        uri,
        headers: {'Authorization': 'Bearer ${widget.Authorization}'},
        body: {
          'comp_id': widget.employee.comp_id,
          'emp_id': widget.employee.emp_id,
          'challenge_id': widget.challenge.challenge_id,
          'request_id': widget.challenge.request_id,
          'question_no': widget.question_no,
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        // Debug: ตรวจสอบ response
        // print("Response: ${response.body}");

        if (jsonResponse.containsKey('question_data') &&
            jsonResponse['question_data'] != null) {
          return QuestionData.fromJson(jsonResponse['question_data']);
        } else {
          throw Exception('No question data found in response.');
        }
      } else {
        throw Exception(
            'Failed to load question data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching question data: $e');
      throw Exception('Error fetching question data: $e');
    }
  }
}
