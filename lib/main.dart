import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'import/import.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'import/origami_view/language/translate.dart';
import 'import/origami_view/language/translate_page.dart';

String hostWeb = 'https://www.origami.life';
String hostDev = 'https://www.origami.life';
String token = 'ori20#17gami';
String tokenMD5 = 'aeb674f8c49dd404dabc759f81f15918';
int selectedRadio = 2;
// bool isAndroid = false;
// bool isTablet = false;
// bool isIPad = false;
// bool isIPhone = false;
// bool isMobile = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // รอการ initialize
  // เตรียมข้อมูลสำหรับ Locale ภาษาไทย
  await initializeDateFormatting('th', null);
  // ตั้งค่า Hive
  var appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  await Hive.openBox('userBox');
  await initializeNotification();
  await platformAndroid();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

Future<void> platformAndroid() async {
  // ในฟังก์ชัน initializeNotification() หรือหลังจากนั้น
  if (Platform.isAndroid) {
    // ขอสิทธิ์แสดง Notification
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted =
          await androidImplementation.requestNotificationsPermission();
      // คุณอาจต้องจัดการกรณีที่ผู้ใช้ไม่อนุญาต
    }
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotification() async {
  // 1. ตั้งค่า Timezone (สำคัญสำหรับการตั้งเวลา)
  // tz.initializeTimeZones();
  // โหลด timezone database
  tz.initializeTimeZones();

  // ดึง timezone ที่ต้องการ
  final location = tz.getLocation('Asia/Bangkok');

  // ตั้ง timezone default
  tz.setLocalLocation(location);

  // 2. ตั้งค่าเฉพาะ Android (กำหนดไอคอนที่จะแสดง)
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // 3. ตั้งค่าเฉพาะ iOS/macOS (สามารถกำหนดการขอสิทธิ์ได้ที่นี่)
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // 4. รวมการตั้งค่าทั้งหมด
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  // 5. Initialize
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // กำหนด Callback เมื่อผู้ใช้แตะ Notification (ตอนแอปเปิดอยู่)
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) async {
      // โค้ดที่คุณต้องการให้ทำงานเมื่อแตะ
    },
    // กำหนด Callback เมื่อผู้ใช้แตะ Notification (ตอนแอปปิดอยู่/Background)
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();

  selectedRadio = prefs.getInt('selectedRadio') ?? 2;
  notiHour = prefs.getInt('notiHour') ?? 0;
  notiMinute = prefs.getInt('notiMinute') ?? 0;
  selectedNoti = prefs.getInt('selectedNoti') ?? 0;
  Translate();
}

// ต้องเป็น Top-level หรือ Static function สำหรับ Background Notification
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // จัดการการตอบสนองเมื่อแอปไม่ได้ทำงานอยู่ (Background/Terminated)
}

Position? userPosition;

Future<void> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // ตรวจสอบว่าเปิดบริการ location หรือยัง
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // ถ้ายังไม่เปิด
    print('Location services are disabled.');
    return;
  }

  // ขอสิทธิ์ location
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied');
    return;
  }

  // ได้สิทธิ์แล้ว อ่านตำแหน่ง
  userPosition = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  print(userPosition?.latitude);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Origami Platform',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Theme.of(context).colorScheme.inversePrimary,
          brightness: Brightness.light,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Arial',
            fontSize: 72,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Arial',
            fontSize: 28,
          ),
        ),
      ),
      home: const LoginPage(
        num: 0, // num 1 ยังไม่ได้ login
        popPage: 5,
        company_id: 0,
        begin: false,
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.num,
    required this.popPage,
    this.company_id,
    this.begin,
  });
  final int num;
  final int popPage;
  final int? company_id;
  final bool? begin;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? lastPressed;
  bool isPass = true;
  bool _loadbegin = true;
  int countPage = 0;
  String _passload = '';

  @override
  void initState() {
    super.initState();
    countPage = widget.num;
    print('_begin ::: $_loadbegin');
    print(widget.popPage);
    print(widget.company_id);
    // _fetchComponent();
    Translate();
    loadCredentials();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   checkDeviceType(context);
    //   getDeviceInfo(context: context);
    // });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getDeviceInfo(context: context);
    // });
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

    if (countPage == 1) {
      await box.clear();
    }

    String? username = box.get('username') ?? '';
    String? password = box.get('password') ?? '';

    setState(() {
      _usernameController.text = username ?? '';
      _passwordController.text = password ?? '';
    });

    if (username?.isNotEmpty == true && password?.isNotEmpty == true) {
      _login();
    } else {
      countPage = 1;

    }
    _passload = password??'';
    print('Username: $username');
    // print('Password: $password');
  }

  void _loadBegin() {
    Future.delayed(Duration(seconds: 2));
    _loadbegin = true;
    print('loadingBegin ::: $_loadbegin');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
            onPopInvoked: (didPop) {
              if (!didPop) {
                final now = DateTime.now();
                final maxDuration = Duration(seconds: 2);
                final isWarning = lastPressed == null ||
                    now.difference(lastPressed!) > maxDuration;

                if (isWarning) {
                  lastPressed = now;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        exitApp2TS,
                        style: const TextStyle(
                            fontFamily: 'Arial', color: Colors.white),
                      ),
                      duration: maxDuration,
                    ),
                  );
                } else {
                  SystemNavigator.pop();
                }
              }
            },
            child: _loadbegin == false
                ? _loading()
                : Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: backgroudComponent.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(backgroudComponent),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/logoOrigami/default_bg.png'),
                                  fit: BoxFit.cover,
                                ) // หรือใช้ภาพจาก assets แทน
                          ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'version: 1.0.2+10',
                          style: TextStyle(
                            fontFamily: 'Arial',
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    LayoutBuilder(builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: _loginWidget(constraints)),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _loading() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.white,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  'https://www.origami.life/images/ogm_logo.png?v=1759716751369', // ใส่โลโก้
                  width: MediaQuery.of(context).size.width * 0.5,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container();
                  },
                ),
                SizedBox(height: 16),
                // Container(
                //   // color: Colors.white,
                //   child: Center(
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         const Text(
                //           'Loading...',
                //           style: TextStyle(
                //             fontFamily: 'Arial',
                //             color: Colors.white54,
                //             fontWeight: FontWeight.w700,
                //             fontSize: 30,
                //           ),
                //         ),
                //         LoadingAnimationWidget.horizontalRotatingDots(
                //           size: 65,
                //           color: Colors.white54,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginWidget(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Center(
        child: Container(
          // width: constraints.maxWidth * ((!isMobile) ? 0.85 : 0.55),
          decoration: BoxDecoration(
            // color: Colors.black12,
            borderRadius: BorderRadius.circular(20),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black12,
            //     blurRadius: 10,
            //     offset: Offset(0, 4),
            //   )
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                'https://www.origami.life/images/ogm_logo.png?v=1759716751369', // ใส่โลโก้
                width: constraints.maxWidth * 0.6,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    // color: Colors.transparent,
                    child: Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        size: 65,
                        color: Colors.orange,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              SizedBox(height: constraints.maxWidth * 0.04),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                        _usernameController, 'Username', Icons.person),
                    const SizedBox(height: 18),
                    _buildPasswordField(),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _showCustomForgotDialog(),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_outline,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Forgot Pwd?',
                              style: TextStyle(
                                fontFamily: 'Arial',
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
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
          ),
        ),
      ),
    );
  }

  void _showCustomForgotDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Forgot your password?',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Please enter your email address to request a password reset.',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _forgotController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9@._-]')),
                  ],
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Color(0xFF555555),
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      fontFamily: 'Arial',
                      color: Color(0xFF999999),
                    ),
                    prefixIcon: Icon(Icons.email, color: Color(0xFF555555)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.orange.shade400,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.shade200,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  if (_forgotController.text.isEmpty ||
                      !_forgotController.text.contains("@")) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Please enter a valid email address."),
                      ),
                    );
                    return;
                  }
                  Navigator.pop(context);
                  _fetchForgetMail();
                },
                child: Text(
                  'Send',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
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

  void _showFullScreenImage(List<Employee> employeeList) {
    showDialog(
      context: context,
      barrierDismissible: true, // ✅ อนุญาตให้แตะนอก dialog เพื่อปิด
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
                child: Text(
                  'Select the location you want to access.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              // // ✅ ปุ่มปิด dialog
              // Align(
              //   alignment: Alignment.topRight,
              //   child: IconButton(
              //     icon: const Icon(Icons.close, color: Colors.grey),
              //     onPressed: () => Navigator.pop(context),
              //   ),
              // ),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: employeeList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final employee = employeeList[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() async {
                          Navigator.pop(context);
                          await Future.delayed(const Duration(milliseconds: 400));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrigamiPage(
                                employee: employee,
                                company_id: widget.company_id ?? 0,
                                popPage: widget.popPage,
                              ),
                            ),
                          );
                        });
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.network(
                                  employee.comp_logo,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.info_outline_rounded, size: 40),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                employee.comp_name ?? 'Unknown',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    saveCredentials(username, password);

    if (username.isEmpty || password.isEmpty) {
      String errorMessage = '';
      if (username.isEmpty && password.isEmpty) {
        errorMessage = 'Please enter your username and password.';
      } else if (username.isEmpty) {
        errorMessage = 'Please enter your username.';
      } else {
        errorMessage = 'Please enter your password.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(fontFamily: 'Arial', color: Colors.white),
          ),
          backgroundColor: Colors.black87,
        ),
      );
      return;
    }

    // เรียก API login
    await _fetchLogin(username, password);
  }

  Future<void> _fetchLogin(String username, String password) async {
    final uri = Uri.parse('$hostDev/api/origami/signin.php');
    try {
      final response = await http.post(
        uri,
        body: {
          'username': username.trim(),
          'password': password.trim(),
          'auth_password': token,
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> employeeJson = jsonResponse['employee_data'] ?? [];
        if (jsonResponse['status'] == 200) {
          setState(() {
            _loadbegin = false;
            _isLoading = true;
          });
          final employeeList = employeeJson
              .map<Employee>((json) => Employee.fromJson(json))
              .toList();
          if (countPage == 1 && employeeList.length >= 2) {
            _showFullScreenImage(employeeList);
          } else {
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrigamiPage(
                  employee: employeeList[widget.company_id ?? 0],
                  company_id: widget.company_id ?? 0,
                  popPage: widget.popPage,
                ),
              ),
            );
          }
        } else {
          final String errorMessage = jsonResponse['message'] ?? 'Login failed';
          _showErrorSnackbar('Invalid user or password');
        }
      } else {
        _showErrorSnackbar('Invalid user or password');
      }
    } catch (e, stacktrace) {
      print('Login Exception: $e');
      print(stacktrace);
      _showErrorSnackbar('An error occurred. Please try again later.');
    }
  }

  String forgot_mail = '';
  Future<void> _fetchForgetMail() async {
    final uri = Uri.parse("$hostDev/api/origami/forgot_password.php");
    try {
      final response = await http.post(
        uri,
        body: {
          'email': forgot_mail.trim(),
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == false) {
          _showErrorSnackbar('An error occurred');
        } else {
          _showSuccessSnackbar('Please check your email.');
        }
      } else {
        throw Exception('Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _fetchForgetMail: $e');
      _showErrorSnackbar('Failed to send email. Please try again.');
    }
  }

  String backgroudComponent = '';

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
          ),
        ),
        // backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Arial',
            color: Colors.white,
          ),
        ),
        // backgroundColor: Colors.green,
      ),
    );
  }
}

class Employee {
  final String emp_id;
  final String emp_code;
  final String emp_name;
  final String emp_avatar;
  final String comp_id;
  final String comp_name;
  final String comp_logo;
  final String dept_name;
  final String dna_color;
  final String password_verify;
  final String pass_pro;
  final String endpoint;

  const Employee({
    required this.emp_id,
    required this.emp_code,
    required this.emp_name, // ชื่อ
    required this.emp_avatar, // รูปภาพ
    required this.comp_id,
    required this.comp_name,
    required this.comp_logo,
    required this.dept_name,
    required this.dna_color,
    required this.password_verify,
    required this.pass_pro,
    required this.endpoint,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    // String avatarPath = json['emp_avatar'] ?? '';
    // String logoPath = json['comp_logo'] ?? '';
    // String fullAvatar = avatarPath.isNotEmpty
    //     ? "${avatarPath.replaceAll("\\", "/")}"
    //     : '';
    // String fullLogo =
    //     logoPath.isNotEmpty ? "${logoPath.replaceAll("\\", "/")}" : '';
    return Employee(
      comp_id: json['comp_id'] ?? '',
      emp_id: json['emp_id'] ?? '',
      emp_code: json['emp_code'] ?? '',
      emp_name: json['emp_name'] ?? '',
      emp_avatar: json['emp_avatar'] ?? '',
      comp_name: json['comp_name'] ?? '',
      comp_logo: json['comp_logo'] ?? '',
      dept_name: json['dept_name'] ?? '',
      dna_color: json['dna_color'] ?? '',
      password_verify: json['password_verify'] ?? '',
      pass_pro: json['pass_pro'] ?? '',
      endpoint: json['endpoint'] ?? '',
    );
  }
}
