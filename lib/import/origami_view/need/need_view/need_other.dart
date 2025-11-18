import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import '../need_view/need_detail.dart';

class NeedOther extends StatefulWidget {
  const NeedOther(
      {Key? key,
        required this.callback,
        required this.employee,
        required this.callbackId})
      : super(key: key);
  final Function(String) callback;
  final Function(String) callbackId;
  final Employee employee;
  @override
  _NeedOtherState createState() => _NeedOtherState();
}

class _NeedOtherState extends State<NeedOther> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}
