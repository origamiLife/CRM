import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:origamilift/import/import.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    required this.num,
    required this.popPage,
  }) : super(key: key);
  final int num;
  final int popPage;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailforgotController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _login() async {
    // _loadSelectedRadio();
    String username = _usernameController.text;
    String password = _passwordController.text;
    // _saveCredentials(username, password);
    saveCredentials(username,password);
    if (username.isEmpty && password.isEmpty) {
      // Show error message if username or password is empty
      //*********************************************************
      // if (_formKey.currentState!.validate()) {
      //   String email = _usernameController.text;
      //   String password = _passwordController.text;
      //   Fluttertoast.showToast(msg: 'Logged in as $email');
      // }
      //*********************************************************
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both email and password.',
              style: GoogleFonts.openSans(
                color: Colors.white,
              )),
        ),
      );
      return;
    } else if (username.isNotEmpty && password.isNotEmpty) {
      final uri = Uri.parse('https://www.origami.life/api/origami/signin.php');
      final response = await http.post(
        uri,
        body: {
          'username': username, //chakrit@trandar.com
          'password': password, //@HengL!ke08
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          final String Authorization = jsonResponse['Authorization'];
          final List<dynamic> employeeJson = jsonResponse['employee_data'];
          List<Employee> employee = [];
          setState(() {
            employee =
                employeeJson.map((json) => Employee.fromJson(json)).toList();
          });
          setState(() {
            _isLoading = true;
          });
          await Future.delayed(Duration(seconds: 1));
          final Employee employee1 = employee[0];
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => OrigamiPage(
                employee: employee1,
                popPage: widget.popPage,
                Authorization: Authorization,
              ),
            ),
          );
        } else {
          final String error_message = jsonResponse['message'];
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                error_message, // 'Email or Password is incorrect, please try again',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status Code Error!',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                )),
          ),
        );
      }
    }
  }

  Future<void> _saveCredentials(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  Future<void> _loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    (widget.num == 1)?prefs.clear():Container();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';
    setState(() {
      _usernameController.text = username;
      _passwordController.text = password;
    });
    if (username.isNotEmpty && password.isNotEmpty) {
      (widget.num == 0)?_login():prefs.clear();
    }
  }

  // ฟังก์ชันในการบันทึกข้อมูล
  Future<void> saveCredentials(username,password) async {
    var box = await Hive.openBox('userBox');
    // บันทึกข้อมูลลงใน Box
    await box.put('username', username);
    await box.put('password', password);
  }

  Future<void> loadCredentials() async {
    var box = await Hive.openBox('userBox');
    if(widget.num == 1){
      box.clear();
      _usernameController.clear();
      _passwordController.clear();
    }
    String? username = box.get('username');
    String? password = box.get('password');
    setState(() {
      _usernameController.text = username??'';
      _passwordController.text = password??'';
    });
    if (username!.isNotEmpty && password!.isNotEmpty) {
      if(widget.num == 0){
        _login();
      }else{
        box.clear();
        _usernameController.clear();
        _passwordController.clear();
      }
    }
    print('Username: $username');
    print('Password: $password');
  }


  _loadSelectedRadio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedRadio = prefs.getInt('selectedRadio') ?? 2;
      Translate();
    });
  }

  String forgot_mail = '';
  @override
  void initState() {
    super.initState();
    Translate();
    _loadSelectedRadio();
    loadCredentials();
    // _loadCredentials();
    _emailforgotController.addListener(() {
      forgot_mail = _emailforgotController.text;
      print("Current text: ${_emailforgotController.text}");
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailforgotController.dispose();
    super.dispose();
  }

  DateTime? lastPressed;
  bool isPass = true;
  bool _forgot = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // เช็คว่ามีการกดปุ่มย้อนกลับครั้งล่าสุดหรือไม่ และเวลาห่างจากปัจจุบันมากกว่า 2 วินาทีหรือไม่
        final now = DateTime.now();
        final maxDuration = Duration(seconds: 2);
        final isWarning =
            lastPressed == null || now.difference(lastPressed!) > maxDuration;

        if (isWarning) {
          // ถ้ายังไม่ได้กดสองครั้งภายในเวลาที่กำหนด ให้แสดง SnackBar แจ้งเตือน
          lastPressed = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Press back again to exit',
                style: GoogleFonts.openSans(
                  color: Colors.white,
                ),
              ),
              duration: maxDuration,
            ),
          );
          return false; // ไม่ออกจากแอป
        }
        // ถ้ากดปุ่มย้อนกลับสองครั้งภายในเวลาที่กำหนด ให้ออกจากแอป
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                    AssetImage('assets/images/logoOrigami/default_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24,right: 24),
                    child: (_forgot == false)?_loginWidget():_forgotWidget(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'version 1.0.2',
                  style: GoogleFonts.openSans(
                    color: Color(0xFF555555),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _loginWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 400,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: 400,
              child: Image.asset(
                'assets/images/logoOrigami/ogm_logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        _isLoading
            ? Center(
          child: LoadingAnimationWidget
              .staggeredDotsWave(
            size: 75,
            color: Colors.amber,
          ),
        )
            : Container(),
        SizedBox(height: 16),
        Container(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'[a-zA-Z0-9@#%&*_!$%^(),.?":;{}|<>-]')), // เฉพาะตัวอักษรภาษาอังกฤษและช่องว่าง
                  ],
                  controller: _usernameController,
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: GoogleFonts.openSans(
                      color: Colors.white,
                    ),
                    hintStyle: GoogleFonts.openSans(
                      color: Colors.white,
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFF9900),
                        width: 1.0,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(
                            0xFFFF9900), // ตั้งสีขอบเมื่อตัวเลือกถูกปิดใช้งาน
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(
                            0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                        width: 1.0,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(
                            0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                        width: 1.0,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'[a-zA-Z0-9@#%&*_!$%^(),.?":;{}|<>-]')), // เฉพาะตัวอักษรภาษาอังกฤษและช่องว่าง
                  ],
                  controller: _passwordController,
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                  ),
                  obscureText: isPass,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: GoogleFonts.openSans(
                      color: Colors.white,
                    ),
                    hintStyle: GoogleFonts.openSans(
                      color: Colors.white,
                    ),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    suffixIcon: Container(
                      alignment: Alignment.centerRight,
                      width: 10,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                (isPass == true)
                                    ? isPass = false
                                    : isPass = true;
                              });
                            },
                            icon: Icon(isPass
                                ? Icons.remove_red_eye
                                : Icons
                                .remove_red_eye_outlined),
                            color: Colors.white,
                            iconSize: 18),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFF9900),
                        width: 1.0,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(
                            0xFFFF9900), // ตั้งสีขอบเมื่อตัวเลือกถูกปิดใช้งาน
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(
                            0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                        width: 1.0,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(
                            0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                        width: 1.0,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _forgot = true;
                        });
                      },
                      child: Padding(
                        padding:
                        const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.end,
                          children: [
                            Icon(Icons.lock_open,
                                color: Colors.white,
                                size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Forgot Pwd?',
                              style:
                              GoogleFonts.openSans(
                                color: Colors.white,
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(1),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: _login,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 60,
                          right: 60,
                          bottom: 14,
                          top: 14),
                      child: Text(
                        'LOGIN',
                        style: GoogleFonts.openSans(
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _forgotWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150,
          height: 150,
          child: Image.asset(
            'assets/images/logoOrigami/ogm_logo.png',
            fit: BoxFit.cover,
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                'Forgot your password?',
                style:
                GoogleFonts.openSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '    Please enter your email address to request a password reset.',
                  style:
                  GoogleFonts.openSans(
                    color: Colors.orange.shade50,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailforgotController,
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: GoogleFonts.openSans(
                      color: Colors.white,
                    ),
                    hintStyle: GoogleFonts.openSans(
                      color: Colors.white,
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFFF9900),
                        width: 1.0,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Color(
                            0xFFFF9900), // ตั้งสีขอบเมื่อตัวเลือกถูกปิดใช้งาน
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(
                            0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
                        width: 1.0,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(
                            0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
                        width: 1.0,
                      ),
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(1),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () => _fetchForgetMail(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 60,
                        right: 60,
                        bottom: 14,
                        top: 14),
                    child: Text(
                      'SEND',
                      style: GoogleFonts.openSans(
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _forgot = false;
                      });
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
                        children: [
                          Icon(Icons.chevron_left,
                              color: Colors.white,
                              size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Return to login.',
                            style:
                            GoogleFonts.openSans(
                              color: Colors.white,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _listItem() {
    return FractionallySizedBox(
      heightFactor: 1,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black12,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: SizedBox()),
                      Container(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          'assets/images/logoOrigami/ogm_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                        style: GoogleFonts.openSans(
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF9900),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 60, right: 60, bottom: 16, top: 16),
                            child: Text(
                              'Log in',
                              style: GoogleFonts.openSans(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: _login,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 60, right: 60, bottom: 16, top: 16),
                            child: Text(
                              'Contact',
                              style: GoogleFonts.openSans(
                                color: Color(0xFF555555),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16, bottom: 16, left: 30, right: 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://t3.ftcdn.net/jpg/02/92/36/80/360_F_292368014_9EgJRdKkquD0THERDS3ZqEj94WsSoHAo.jpg",
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchForgetMail() async {
    final uri = Uri.parse("$host/api/origami/forgot_password.php");
    final response = await http.post(
      uri,
      body: {
        'email': forgot_mail,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == false) {
        final message = jsonResponse['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message,
              style: GoogleFonts.openSans(
                color: Colors.white,
              ),
            ),
          ),
        );
      }
    } else {
      throw Exception('Failed to load projects');
    }
  }

}

class Employee {
  final String? emp_id;
  final String? emp_code;
  final String? emp_name;
  final String? emp_avatar;
  final String? comp_id;
  final String? comp_description;
  final String? comp_logo;
  final String? dept_id;
  final String? dept_description;
  final String? dna_id;
  final String? dna_name;
  final String? dna_color;
  final String? dna_logo;
  final String? password_verify;

  const Employee({
    this.emp_id,
    this.emp_code,
    this.emp_name,
    this.emp_avatar,
    this.comp_id,
    this.comp_description,
    this.comp_logo,
    this.dept_id,
    this.dept_description,
    this.dna_id,
    this.dna_name,
    this.dna_color,
    this.dna_logo,
    this.password_verify,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      emp_id: json['emp_id'] ?? '',
      emp_code: json['emp_code'] ?? '',
      emp_name: json['emp_name'] ?? '',
      emp_avatar: json['emp_avatar'] ?? '',
      comp_id: json['comp_id'] ?? '',
      comp_description: json['comp_description'] ?? '',
      comp_logo: json['comp_logo'] ?? '',
      dept_id: json['dept_id'] ?? '',
      dept_description: json['dept_description'] ?? '',
      dna_id: json['dna_id'] ?? '',
      dna_name: json['dna_name'] ?? '',
      dna_color: json['dna_color'] ?? '',
      dna_logo: json['dna_logo'] ?? '',
      password_verify: json['password_verify'] ?? '',
    );
  }
}

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
          MediaQuery.of(context).size.width < 1200;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;
}
