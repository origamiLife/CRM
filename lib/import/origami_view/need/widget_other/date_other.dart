import 'package:intl/intl.dart';
import 'package:origamilift/import/import.dart';

class DateOther extends StatefulWidget {
  const DateOther({
    super.key, required this.firstDay, required this.lastDay, required this.getfirstDay, required this.getlastDay,
  });
  final String getfirstDay;
  final String getlastDay;
  final String Function(String) firstDay;
  final String Function(String) lastDay;

  @override
  State<DateOther> createState() => DateOtherState();
}

class DateOtherState extends State<DateOther> {
  String showfirstDay = '';
  String showlastDay = '';

  @override
  void initState() {
    super.initState();
    showfirstDay = widget.getfirstDay;
    showlastDay = widget.getlastDay;
  }

  DateTime _selectedDate = DateTime.now();
  Future<void> _requestDate(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.teal,
            colorScheme: ColorScheme.light(
              primary: Color(0xFFFF9900),
              onPrimary: Colors.white,
              onSurface: Colors.teal,
            ),
            dialogBackgroundColor: Colors.teal[50],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                      DateFormat formatter = DateFormat('dd/MM/yyyy');
                      widget.firstDay(formatter.format(_selectedDate));
                      showfirstDay =  formatter.format(_selectedDate);

                    });
                    Navigator.pop(context);
                  },
                ),
                // TextButton(
                //   child: Text('Close',
                //     style: TextStyle(
                // fontFamily: 'Arial',
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.teal),
                //   ),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // SizedBox(height: 16,),
              ],
            ),
          ),
        );
      },
    );
  }

  DateTime _selectedDateEnd = DateTime.now();
  Future<void> _requestDateEnd(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.teal,
            colorScheme: ColorScheme.light(
              primary: Color(0xFFFF9900),
              onPrimary: Colors.white,
              onSurface: Colors.teal,
            ),
            dialogBackgroundColor: Colors.teal[50],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarDatePicker(
                  initialDate: _selectedDateEnd,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDateEnd = newDate;
                      DateFormat formatter = DateFormat('dd/MM/yyyy');
                      widget.lastDay(formatter.format(_selectedDateEnd));
                      showlastDay =  formatter.format(_selectedDateEnd);
                    });
                    Navigator.pop(context);
                  },
                ),
                // TextButton(
                //   child: Text('Close',
                //     style: TextStyle(
                // fontFamily: 'Arial',
                //         fontSize: 18,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.teal),
                //   ),
                //   onPressed: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // SizedBox(height: 16,),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$Date : ',
          style: TextStyle(
                fontFamily: 'Arial',fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16),
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFFFF9900),
                  width: 1.0,
                ),
              ),
              child: InkWell(
                onTap: () {
                  _requestDate(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        showfirstDay,
                        style: TextStyle(
                fontFamily: 'Arial',
                            fontSize: 14,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Icon(Icons.calendar_month,color: Color(0xFF555555),),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16, right: 16),
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFFFF9900),
                  width: 1.0,
                ),
              ),
              child: InkWell(
                onTap: () {
                  _requestDateEnd(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        showlastDay,
                        style: TextStyle(
                fontFamily: 'Arial',
                            fontSize: 14,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Icon(Icons.calendar_month,color: Color(0xFF555555),),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}