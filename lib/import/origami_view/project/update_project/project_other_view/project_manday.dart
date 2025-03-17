import 'package:origamilift/import/import.dart';

class ProjectManday extends StatefulWidget {
  const ProjectManday({
    Key? key,
  }) : super(key: key);

  @override
  _ProjectMandayState createState() => _ProjectMandayState();
}

class _ProjectMandayState extends State<ProjectManday> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _limitMandayController = TextEditingController();
  TextEditingController _valueMandayController = TextEditingController();
  String _search = "";
  int _change = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _search = _searchController.text;
      print("Current text: ${_searchController.text}");
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Manday',
            style: TextStyle(
                fontFamily: 'Arial',
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _getContentWidget(),
    );
  }

  Widget _getContentWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _searchController,
            keyboardType: TextInputType.text,
            style: TextStyle(
                fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
            ),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              hintText: 'Search...',
              hintStyle:
                  TextStyle(
                fontFamily: 'Arial',fontSize: 14, color: Color(0xFF555555)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Color(0xFFFF9900),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 8),
          child: Row(
            children: [
              Row(
                children: [
                  Text(
                    'Limit Manday : ',
                    maxLines: 2,
                    style: TextStyle(
                fontFamily: 'Arial',
                      fontSize: 16,
                      color: Color(0xFF555555),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10),
              Expanded(child: _LimitController('', _limitMandayController)),
              SizedBox(width: 10),
              Container(
                height: 38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(1),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                  child: Center(
                    child: Text(
                      'Save',
                      style: TextStyle(
                fontFamily: 'Arial',
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {
                  setState(() {
                    (_change == 0) ? _change = 1 : _change = 0;
                  });
                },
                child: Icon(Icons.change_circle_outlined))),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
                children: List.generate(6, (index) {
              return Card(
                color: Colors.white,
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 0,
                                  offset: Offset(0, 3), // x, y
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey,
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        '$host/uploads/employee/5/employee/19777.jpg?v=1729754401',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                _TextController('manday', _valueMandayController),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: (_change == 0)
                              ? _linearPercent()
                              : Container(child: _circularPercent()),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })),
          ),
        ),
      ],
    );
  }

  Widget _linearPercent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.center,
          children: [
            Text(
              'Jirapat Jangsawang',
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.center,
          children: [
            Text(
              'Charge: ',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF555555),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(10),
                child: Stack(
                  children: [
                    LinearProgressIndicator(
                      value: 0.3,
                      minHeight:15,
                      backgroundColor: Colors.grey[300],
                      borderRadius:BorderRadius.all(Radius.circular(100)),
                      valueColor:
                      AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF9900)),
                    ),
                    Center(
                      child: Text(
                        '30.0 %',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.center,
          children: [
            Text(
              'No-Charge: ',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF555555),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                    BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      minHeight:15,
                      backgroundColor: Colors.grey[300],
                      borderRadius:BorderRadius.all(Radius.circular(100)),
                      valueColor:
                      AlwaysStoppedAnimation<Color>(
                          Colors.blue),
                    ),
                  ),
                  Center(
                    child: Text(
                      '50.0 %',
                      style: TextStyle(
                fontFamily: 'Arial',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment:
          CrossAxisAlignment.center,
          children: [
            Text(
              'Total: ',
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF555555),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(10),
                child:
                Stack(
                  children: [
                    LinearProgressIndicator(
                      value: 0.9,
                      backgroundColor: Colors.grey[300],
                      minHeight:15,
                      borderRadius:BorderRadius.all(Radius.circular(100)),
                      valueColor:
                      AlwaysStoppedAnimation<Color>(
                          Color(0xFF555555)),
                    ),
                    Center(
                      child: Text(
                        '90.0 %',
                        style: TextStyle(
                fontFamily: 'Arial',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _circularPercent() {
    return Center(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 3), // x, y
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircularPercentIndicator(
                    radius: 25,
                    lineWidth: 4.0,
                    percent: 0.30,
                    center: new Text("30%"),
                    progressColor: Color(0xFFFF9900),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Charge: 30.00',
                    style: TextStyle(
                fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.yellow.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 3), // x, y
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircularPercentIndicator(
                    radius: 25,
                    lineWidth: 4.0,
                    percent: 0.60,
                    center: new Text("60%"),
                    progressColor: Colors.yellow,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'No-Charge: 60.00',
                    style: TextStyle(
                fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 0,
                    offset: Offset(0, 3), // x, y
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircularPercentIndicator(
                    radius: 25,
                    lineWidth: 4.0,
                    percent: 0.90,
                    center: new Text("90%"),
                    progressColor: Colors.green,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Total: 90.00',
                    style: TextStyle(
                fontFamily: 'Arial',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF555555),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _LimitController(String title, controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
                fontFamily: 'Arial',
        color: Color(0xFF555555),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        hintText: title,
        hintStyle: TextStyle(
                fontFamily: 'Arial',fontSize: 14, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // ขอบสีส้มตอนที่โฟกัส
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _TextController(String title, controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
                fontFamily: 'Arial',
        color: Color(0xFF555555),
        fontSize: 14,
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        hintText: title,
        hintStyle: TextStyle(
                fontFamily: 'Arial',fontSize: 14, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // ขอบสีส้มตอนที่ไม่ได้โฟกัส
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey, // ขอบสีส้มตอนที่โฟกัส
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
