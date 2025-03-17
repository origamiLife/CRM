import 'package:origamilift/import/import.dart';
import 'package:origamilift/import/origami_view/need/need_view/need_detail.dart';


class PriorityOther extends StatefulWidget {
  const PriorityOther({
    super.key, required this.priority, required this.callbackId,
  });
  final List<PriorityData> priority;
  final String Function(String) callbackId;

  @override
  State<PriorityOther> createState() => PriorityOtherState();
}

class PriorityOtherState extends State<PriorityOther> {

  bool is_priority = false;
  String editpriorityText = '';
  String priorityId = '';
  PriorityData? _selectedPriority;

  @override
  Widget build(BuildContext context) {
    if (is_priority == true) {
      editpriorityText = _selectedPriority?.priority_name ?? '';
      priorityId = _selectedPriority?.priority_id ?? '';
      widget.callbackId(priorityId ?? '');
    }
    return Container(
      height: 48,
      // width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        border: Border.all(
          color: Color(0xFFFF9900),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<PriorityData>(
              isExpanded: true,
              hint: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      // color: Color(int.parse(
                      //     '0xFF${this.detailItem?.priorityColor??''}')),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    (is_priority == true)?
                    editpriorityText:widget.priority[0].priority_name??'',
                    style:
                    TextStyle(
                fontFamily: 'Arial',fontSize: 14, color: Color(0xFF555555)),
                  ),
                  // Spacer(),
                  // Icon(Icons.arrow_drop_down)
                ],
              ),
              value: _selectedPriority,
              style: TextStyle(
                fontFamily: 'Arial',fontSize: 14, color: Color(0xFF555555)),
              underline: Container(
                height: 1,
                color: Colors.transparent,
              ),
              items: widget.priority.map((PriorityData priority) {
                return DropdownMenuItem<PriorityData>(
                  value: priority,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 6),
                            child: Container(
                              // color: Color(int.parse(
                              //     '0xFF${this.detailItem?.priorityColor??''}')),
                              padding: EdgeInsets.only(
                                  top: 14, bottom: 14, left: 2, right: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: (priority.priority_name == 'Low')
                                    ?Colors.green
                                    :(priority.priority_name == 'Medium')
                                    ?Colors.yellow
                                    :(priority.priority_name == 'High')
                                    ?Color(0xFFFF9900)
                                    :(priority.priority_name == 'Very high')
                                    ?Colors.redAccent
                                    :Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            priority.priority_name ?? '',
                            style: TextStyle(
                fontFamily: 'Arial',
                              fontSize: 14,
                              color: Color(0xFF555555),
                            ),
                          ),
                          // Spacer(),
                          // Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (PriorityData? newValue) {
                setState(() {
                  is_priority = true;
                  _selectedPriority = newValue;
                });
              },
              iconStyleData: IconStyleData(
                icon: Icon(Icons.arrow_drop_down),
                iconEnabledColor: Color(0xFF555555),
                iconDisabledColor: Color(0xFF555555),
                iconSize: 24,
              ),
              dropdownStyleData: DropdownStyleData(
                elevation: 1,
                decoration: BoxDecoration(
                  color: Colors.white, // สีพื้นหลังของเมนู dropdown
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
              ),
              // buttonStyleData: ButtonStyleData(
              //   height: 50,
              //   decoration: BoxDecoration(
              //     color: Colors.white, // สีพื้นหลังของปุ่ม
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   padding: EdgeInsets.symmetric(horizontal: 16),
              // ),
            ),
          ),
        ),
      ),
    );
  }

}