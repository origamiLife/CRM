import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

int selectedNoti = 0;
int notiHour = 0;
int notiMinute = 0;

class TranslatePage extends StatefulWidget {
  const TranslatePage({Key? key, required this.employee}) : super(key: key);
  final Employee employee;
  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  TextEditingController _hourController = TextEditingController();
  TextEditingController _minuteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSelectedRadio();
    if(notiHour == 0){
      _hourController.text = '';
    }else{
      _hourController.text = notiHour.toString();
    }

    if(notiMinute == 0){
      _minuteController.text = '';
    }else{
      _minuteController.text = notiMinute.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _hourController.dispose();
    // _minuteController.dispose();
  }

  // โหลดค่าที่บันทึกไว้
  _loadSelectedRadio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRadio = prefs.getInt('selectedRadio') ?? 2;
      Translate();
    });
  }

  // type 0 = Translate , 1 = notiHour , 2 = notiMinute
  // บันทึกค่าเมื่อมีการเปลี่ยนแปลง
  _handleRadioValueChange(int? value, int type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type == 0) {
      setState(() {
        selectedRadio = value!;
        prefs.setInt('selectedRadio', selectedRadio);
        Translate();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(
              num: 0,
              popPage: 3,
              begin:false,
            ),
          ),
        );
      });
    } else {
      setState(() {
        // selectedNoti = value!;
        if(type == 1){
          notiHour = value!;
          prefs.setInt('notiHour', notiHour);
          prefs.setInt('selectedNoti', selectedNoti);
        }else if(type == 2){
          notiMinute = value!;
          prefs.setInt('notiMinute', notiMinute);
          prefs.setInt('selectedNoti', selectedNoti);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Flag_of_the_United_Kingdom_%281-2%29.svg/1200px-Flag_of_the_United_Kingdom_%281-2%29.svg.png',
                          // width: 200,
                          height: 100,
                        ),
                        TextButton(
                          onPressed: () {
                            _handleRadioValueChange(2,0);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (selectedRadio == 2)
                                  ? Icon(
                                Icons.radio_button_on,
                                color: Color(0xFFFF9900),
                              )
                                  : Icon(
                                Icons.radio_button_off,
                                color: Color(0xFFFF9900),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'English',
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Color(0xFF555555)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        // Image.network(
                        //   'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/Flag_of_Thailand_%28non-standard_colours%29.svg/180px-Flag_of_Thailand_%28non-standard_colours%29.svg.png',
                        //   // width: 200,
                        //   height: 100,
                        // ),
                        // TextButton(
                        //   // style:ButtonStyle(shadowColor:Color(colors.)),
                        //   onPressed: () {
                        //     // _handleRadioValueChange(1,0);
                        //   },
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       // (selectedRadio == 1)
                        //       //     ? Icon(
                        //       //         Icons.radio_button_on,
                        //       //         color: Color(0xFFFF9900),
                        //       //       )
                        //       //     : Icon(
                        //       //         Icons.radio_button_off,
                        //       //         color: Color(0xFFFF9900),
                        //       //       ),
                        //       Icon(
                        //         Icons.radio_button_off,
                        //         color: Colors.grey,
                        //       ),
                        //       SizedBox(
                        //         width: 8,
                        //       ),
                        //       Text(
                        //         'ภาษาไทย',
                        //         style: TextStyle(
                        //             fontFamily: 'Arial',
                        //             fontSize: 16,
                        //             color: Color(0xFF555555)),
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Divider(),
            ),
            // Row(
            //   children: [
            //     Expanded(
            //       child: _textController('Hour', _hourController,
            //           false, Icons.numbers),
            //     ),
            //     SizedBox(width: 16),
            //     Expanded(
            //       child: _textController('Minute', _minuteController,
            //           false, Icons.numbers),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 16),
            // SaveButton()
          ],
        ),
      ),
    );
  }

  Widget _textController(String text, controller, bool key, IconData numbers) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              readOnly: key,
              minLines: 1,
              maxLines: null,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.grey.shade50,
                labelStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                hintText: '',
                hintStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: key == false
                        ? Colors.orange.shade300
                        : Colors.grey.shade100,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                // prefixIcon: Icon(numbers, color: Colors.black54),
              ),
              style: TextStyle(
                fontFamily: 'Arial',
                color: key ? Colors.black87 : Color(0xFF555555),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget SaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          backgroundColor: Colors.red,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
        onPressed: (){
          if(_hourController.text == '') {
            _hourController.text = '0';
          }
          _handleRadioValueChange(int.parse(_hourController.text),1);
          if(_minuteController.text == '') {
            _minuteController.text = '0';
          }
          _handleRadioValueChange(int.parse(_minuteController.text),2);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrigamiPage(employee: widget.employee, popPage: 3),
            ),
          );
        },
        child: Text(
          'Send',
          style: TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
