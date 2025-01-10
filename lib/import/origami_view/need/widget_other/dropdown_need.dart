import 'package:origamilift/import/import.dart';

class DropdownNeed extends StatefulWidget {
  const DropdownNeed({
    super.key, required this.title, required this.textTitle, required this.onTap,
  });
  final String title;
  final String textTitle;
  final VoidCallback onTap;

  @override
  State<DropdownNeed> createState() => DropdownNeedState();
}

class DropdownNeedState extends State<DropdownNeed> {

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(
              color: Color(0xFFFF9900),
              width: 1.0,
            ),
          ),
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      (widget.title == "")
                          ? widget.textTitle
                          : widget.title,
                      style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: (widget.textTitle == "")?Colors.black38:Color(0xFF555555)),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Icon(Icons.arrow_drop_down_outlined,color: Color(0xFF555555),),
                ],
              ),
            ),
          ),
        ));
  }
}