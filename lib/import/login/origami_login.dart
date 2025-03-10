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
  final TextEditingController _forgotController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? lastPressed;
  bool isPass = true;
  bool _forgot = false;

  @override
  void initState() {
    super.initState();
    Translate();
    loadCredentials();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkDeviceType(context);
      getDeviceInfo(context);
    });
    _forgotController.addListener(() {
      forgot_mail = _forgotController.text;
      print("Current text: ${_forgotController.text}");
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _forgotController.dispose();
    super.dispose();
  }

  // ฟังก์ชันในการบันทึกข้อมูล
  Future<void> saveCredentials(username, password) async {
    var box = await Hive.openBox('userBox');
    // บันทึกข้อมูลลงใน Box
    await box.put('username', username);
    await box.put('password', password);
  }

  Future<void> loadCredentials() async {
    var box = await Hive.openBox('userBox');

    if (widget.num == 1) {
      await box.clear();
    }

    String? username = box.get('username') ?? '';
    String? password = box.get('password') ?? '';

    setState(() {
      _usernameController.text = username ?? '';
      _passwordController.text = password ?? '';
    });

    if (username!.isNotEmpty && password!.isNotEmpty && widget.num == 0) {
      _login();
    }

    print('Username: $username');
    print('Password: $password');
  }

  Future<void> checkDeviceType(BuildContext? context) async {
    try {
      // รีเซ็ตค่าตัวแปรทั้งหมด
      isAndroid = false;
      isTablet = false;
      isIPad = false;
      isIPhone = false;

      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        isAndroid = true;

        final shortestSide = context != null
            ? MediaQuery.of(context).size.shortestSide
            : WidgetsBinding.instance.platformDispatcher.views.first
                    .physicalSize.shortestSide /
                WidgetsBinding
                    .instance.platformDispatcher.views.first.devicePixelRatio;

        isTablet = shortestSide >= 600; // เช็คว่าเป็น Tablet หรือไม่

        if (isTablet) {
          isAndroid = false; // ถ้าเป็น Tablet ให้ reset ค่า isAndroid
        }
      } else if (Platform.isIOS) {
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        final model = iosInfo.model?.toLowerCase() ?? '';

        if (model.contains("ipad")) {
          isIPad = true;
          isTablet = true; // ถ้าเป็น iPad ให้ตั้งค่า isTablet = true
        } else if (model.contains("iphone")) {
          isIPhone = true;
        }
      }

      // ถ้าเป็น iPad ให้ตั้งค่าอื่นๆ เป็น false
      if (isIPad) {
        isAndroid = false;
        isIPhone = false;
        isTablet = false; // ทำให้ตัวแปรอื่นๆ เป็น false เมื่อเป็น iPad
      }

      print(
          'isAndroid: $isAndroid, isIPhone: $isIPhone, isTablet: $isTablet, isIPad: $isIPad');
    } catch (e) {
      print("Error checking device type: $e");
    }
  }

  Future<void> getDeviceInfo(BuildContext context) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

          print("📱 Android Device Info:");
          print("Brand: ${androidInfo.brand}");
          print("Model: ${androidInfo.model}");
          print("Android Version: ${androidInfo.version.release}");
          print(isTablet ? "📲 เป็น Tablet" : "📱 เป็น Phone");
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          bool isIPad = iosInfo.model.toLowerCase().contains("ipad");

          print("🍏 iOS Device Info:");
          print("Model: ${iosInfo.model}");
          print("System Name: ${iosInfo.systemName}");
          print("iOS Version: ${iosInfo.systemVersion}");
          print(isIPad ? "📲 เป็น iPad" : "📱 เป็น iPhone");
        }
      } else {
        print("❌ ไม่รองรับอุปกรณ์นี้");
      }
    } catch (e) {
      print("⚠️ Error checking device type: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (!didPop) {
          final now = DateTime.now();
          final maxDuration = Duration(seconds: 2);
          final isWarning =
              lastPressed == null || now.difference(lastPressed!) > maxDuration;

          if (isWarning) {
            lastPressed = now;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Press back again to exit',
                  style: TextStyle(fontFamily: 'Arial', color: Colors.white),
                ),
                duration: maxDuration,
              ),
            );
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SizedBox.expand(
            // กำหนดให้เต็มจอ
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logoOrigami/default_bg.png'),
                  fit: BoxFit.cover, // ปรับให้รูปเต็มหน้าจอ
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: SingleChildScrollView(
                  child: _forgot ? _forgotWidget() : _loginWidget(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.width * ((isAndroid || isIPhone) ?0.5:0.3),
          width: MediaQuery.of(context).size.width * ((isAndroid || isIPhone) ?0.6:0.3), // ทำให้ขนาดภาพปรับตามหน้าจอ
          constraints: const BoxConstraints(maxWidth: 400), // จำกัดขนาดไม่ให้ใหญ่เกินไป
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/logoOrigami/origami_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        _isLoading
            ? Center(
          child: LoadingAnimationWidget.horizontalRotatingDots(
            size: 75,
            color: Colors.white,
          ),
        )
            : Column(
          children: [
            Text(
              'Origami',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 60,
              ),
            ),
            Text(
              'System',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white70,
                fontWeight: FontWeight.w700,
                fontSize: 90,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_usernameController, 'Username', Icons.person),
              const SizedBox(height: 18),
              _buildPasswordField(),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _onForgotPasswordPressed,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_open, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Forgot Pwd?',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLoginButton(),
              const SizedBox(height: 30), // ป้องกันปุ่มล้นขอบล่าง
            ],
          ),
        ),
      ],
    );
  }

  void _onForgotPasswordPressed() {
    setState(() => _forgot = true);
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, IconData icon) {
    return TextFormField(
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z0-9@#%&*_!$^(),.?":;{}|<>-]')),
      ],
      style: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
        prefixIcon: Icon(icon, color: Color(0xFF555555)),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: isPass,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z0-9@#%&*_!$^(),.?":;{}|<>-]')),
      ],
      style: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: 'Password',
        hintStyle: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
        prefixIcon: Icon(Icons.lock, color: Color(0xFF555555)),
        suffixIcon: IconButton(
          onPressed: () => setState(() => isPass = !isPass),
          icon: Icon(
              isPass ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
          color: Color(0xFF555555),
          iconSize: 18,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          backgroundColor: Colors.red,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _login,
        child: Text(
          'LOGIN',
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

  Future<void> _login() async {
    // _loadSelectedRadio();
    String username = _usernameController.text;
    String password = _passwordController.text;
    // _saveCredentials(username, password);
    saveCredentials(username, password);
    if (username.isEmpty && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both email and password.',
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              )),
        ),
      );
      return;
    } else if (username.isNotEmpty && password.isNotEmpty) {
      _fetchLogin(username, password);
    }
  }

  Widget _forgotWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.width * ((isTablet || isIPad) ?0.3:0.5),
          width: MediaQuery.of(context).size.width * ((isTablet || isIPad) ?0.3:0.6), // ทำให้ขนาดภาพปรับตามหน้าจอ
          constraints: const BoxConstraints(maxWidth: 400), // จำกัดขนาดไม่ให้ใหญ่เกินไป
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            'assets/images/logoOrigami/origami_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                'Forgot your password?',
                style: TextStyle(
                  fontFamily: 'Arial',
                  color: Colors.white,
                  fontSize: (isTablet || isIPad) ? 50 : 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '    Please enter your email address to request a password reset.',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Colors.orange.shade50,
                    fontSize: (isIPad || isTablet) ? 24 : 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _forgotController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-Z0-9@#%&*_!$^(),.?":;{}|<>-]')),
                ],
                style: const TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  hintStyle: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
                  prefixIcon: Icon(Icons.email, color: Color(0xFF555555)),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(1),
                    foregroundColor: Colors.red,
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _fetchForgetMail(),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 60, right: 60, bottom: 12, top: 12),
                    child: Text(
                      'SEND',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    _forgot = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.chevron_left, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Return to login.',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Future<void> _fetchLogin(String username, String password) async {
    final uri = Uri.parse('$host/api/origami/signin.php');
    final response = await http.post(
      uri,
      body: {
        // 'username': 'chakrit@trandar.com',
        // 'password': '@HengL!ke08',
        'username': username,
        'password': password,
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
        final Employee employee1 = employee.first;
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
              style: TextStyle(
                fontFamily: 'Arial',
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
              style: TextStyle(
                fontFamily: 'Arial',
                color: Colors.white,
              )),
        ),
      );
    }
  }

  String forgot_mail = '';
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
              style: TextStyle(
                fontFamily: 'Arial',
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
  final String emp_id;
  final String emp_code;
  final String emp_name;
  final String emp_avatar;
  final String comp_id;
  final String comp_description;
  final String comp_logo;
  final String dept_id;
  final String dept_description;
  final String dna_id;
  final String dna_name;
  final String dna_color;
  final String dna_logo;
  final String password_verify;

  const Employee({
    required this.emp_id,
    required this.emp_code,
    required this.emp_name,
    required this.emp_avatar,
    required this.comp_id,
    required this.comp_description,
    required this.comp_logo,
    required this.dept_id,
    required this.dept_description,
    required this.dna_id,
    required this.dna_name,
    required this.dna_color,
    required this.dna_logo,
    required this.password_verify,
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
