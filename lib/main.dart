import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'import/import.dart';

String hostDev = 'https://dev.origami.life';
String host = 'https://www.origami.life';
String authorization = 'ori20#17gami';
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

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Origami CRM',
      theme: ThemeData(
        useMaterial3: false,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Theme.of(context).colorScheme.inversePrimary,
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
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
  });
  final int num;
  final int popPage;
  final int? company_id;

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
  bool _forgot = false;
  bool _begin = false;
  int countPage = 0;

  @override
  void initState() {
    super.initState();
    countPage = widget.num;
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

    print('Username: $username');
    // print('Password: $password');
  }

  // Future<void> checkDeviceType(BuildContext? context) async {
  //   try {
  //     // รีเซ็ตค่าตัวแปรทั้งหมด
  //     isAndroid = false;
  //     isTablet = false;
  //     isIPad = false;
  //     isIPhone = false;
  //
  //     if (Platform.isAndroid) {
  //       DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //       isAndroid = true;
  //
  //       final shortestSide = context != null
  //           ? MediaQuery.of(context).size.shortestSide
  //           : WidgetsBinding.instance.platformDispatcher.views.first
  //                   .physicalSize.shortestSide /
  //               WidgetsBinding
  //                   .instance.platformDispatcher.views.first.devicePixelRatio;
  //
  //       isTablet = shortestSide >= 600; // เช็คว่าเป็น Tablet หรือไม่
  //
  //       if (isTablet) {
  //         isAndroid = false; // ถ้าเป็น Tablet ให้ reset ค่า isAndroid
  //       }
  //     } else if (Platform.isIOS) {
  //       final deviceInfo = DeviceInfoPlugin();
  //       final iosInfo = await deviceInfo.iosInfo;
  //       final model = iosInfo.model?.toLowerCase() ?? '';
  //
  //       if (model.contains("ipad")) {
  //         isIPad = true;
  //         isTablet = true; // ถ้าเป็น iPad ให้ตั้งค่า isTablet = true
  //       } else if (model.contains("iphone")) {
  //         isIPhone = true;
  //       }
  //     }
  //
  //     // ถ้าเป็น iPad ให้ตั้งค่าอื่นๆ เป็น false
  //     if (isIPad) {
  //       isAndroid = false;
  //       isIPhone = false;
  //       isTablet = false; // ทำให้ตัวแปรอื่นๆ เป็น false เมื่อเป็น iPad
  //     }
  //
  //     print(
  //         'isAndroid: $isAndroid, isIPhone: $isIPhone, isTablet: $isTablet, isIPad: $isIPad');
  //   } catch (e) {
  //     print("Error checking device type: $e");
  //   }
  // }

  // Future<void> getDeviceInfo({BuildContext? context}) async {
  //   try {
  //     final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //
  //     if (Platform.isAndroid) {
  //       AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  //
  //       // ใช้ MediaQuery ถ้ามี context
  //       bool isTablet = false;
  //       if (context != null) {
  //         isTablet = MediaQuery.of(context).size.shortestSide >= 600;
  //       } else {
  //         // ใช้ WidgetsBinding ถ้าไม่มี context (เช่นเรียกใน initState)
  //         final shortestSide =
  //             WidgetsBinding.instance.window.physicalSize.shortestSide /
  //                 WidgetsBinding.instance.window.devicePixelRatio;
  //         isTablet = shortestSide >= 600;
  //       }
  //
  //       debugPrint("📱 Android Device Info:");
  //       debugPrint("Brand: ${androidInfo.brand}");
  //       debugPrint("Model: ${androidInfo.model}");
  //       debugPrint("Android Version: ${androidInfo.version.release}");
  //       debugPrint(isTablet ? "📲 เป็น Tablet" : "📱 เป็น Phone");
  //     } else if (Platform.isIOS) {
  //       IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
  //
  //       // ตรวจสอบว่าเป็น iPad
  //       bool isIPad = iosInfo.model.toLowerCase().contains("ipad");
  //
  //       debugPrint("🍏 iOS Device Info:");
  //       debugPrint("Model: ${iosInfo.model}");
  //       debugPrint("System Name: ${iosInfo.systemName}");
  //       debugPrint("iOS Version: ${iosInfo.systemVersion}");
  //       debugPrint(isIPad ? "📲 เป็น iPad🍏" : "📲 เป็น iPhone🍏");
  //       if (isAndroid == true || isIPhone == true) {
  //         isMobile = true;
  //       } else {
  //         isMobile = false;
  //       }
  //     } else {
  //       debugPrint("❌ ไม่รองรับอุปกรณ์นี้");
  //     }
  //   } catch (e) {
  //     debugPrint("⚠️ Error checking device type: $e");
  //   }
  // }

  Future<void> _loadBegin() async {
    await Future.delayed(Duration(seconds: 5));
    _begin = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_begin == false && _isLoading) {
      _loadBegin();
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    image: backgroudComponent.isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage(backgroudComponent),
                      fit: BoxFit.cover,
                    )
                        : DecorationImage(
                      image: AssetImage('assets/images/logoOrigami/default_bg.png'),
                      fit: BoxFit.cover,
                    ) // หรือใช้ภาพจาก assets แทน
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Image.asset(
                    'assets/images/logoOrigami/origami_logo.png', // ใส่โลโก้
                    width: MediaQuery.of(context).size.width * 0.3,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container();
                    },
                  ),
                  SizedBox(height: 16),
                  Container(
                    // color: Colors.white,
                    child: Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        size: 65,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
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
                    '$exitApp2TS',
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
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: backgroudComponent.isNotEmpty
                        ? DecorationImage(
                      image: NetworkImage(backgroudComponent),
                      fit: BoxFit.cover,
                    )
                        : DecorationImage(
                      image: AssetImage('assets/images/logoOrigami/default_bg.png'),
                      fit: BoxFit.cover,
                    ) // หรือใช้ภาพจาก assets แทน
                  ),
                ),
                LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: _forgot
                            ? _forgotWidget(constraints)
                            : _loginWidget(constraints)),
                  );
                }),
              ],
            ),
          ),
        ),
      );
    }
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
              // if (isMobile)
              //   Image.network(
              //     logoComponent, // ใส่โลโก้
              //     width: 300,
              //     fit: BoxFit.contain,
              //     errorBuilder: (context, error, stackTrace) {
              //       return Container(
              //         color: Colors.transparent,
              //         child: Center(
              //           child: LoadingAnimationWidget.horizontalRotatingDots(
              //             size: 65,
              //             color: Colors.orange,
              //           ),
              //         ),
              //       );
              //     },
              //   )
              // else
              //   Image.network(
              //     logoComponent, // ใส่โลโก้
              //     width: 400,
              //     fit: BoxFit.contain,
              //     errorBuilder: (context, error, stackTrace) {
              //       return Container(
              //         color: Colors.transparent,
              //         child: Center(
              //           child: LoadingAnimationWidget.horizontalRotatingDots(
              //             size: 65,
              //             color: Colors.orange,
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // if (isMobile)
              Image.asset(
                'assets/images/logoOrigami/origami_logo.png', // ใส่โลโก้
                width: constraints.maxWidth * 0.4,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.transparent,
                    child: Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        size: 65,
                        color: Colors.orange,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24),
              // Image.network(
              //   logoComponent, // ใส่โลโก้
              //   width: 300,
              //   fit: BoxFit.contain,
              //   errorBuilder: (context, error, stackTrace) {
              //     return Container(
              //       color: Colors.transparent,
              //       child: Center(
              //         child: LoadingAnimationWidget.horizontalRotatingDots(
              //           size: 65,
              //           color: Colors.orange,
              //         ),
              //       ),
              //     );
              //   },
              // ),
              Text(
                'Origami CRM',
                style: const TextStyle(
                  fontFamily: 'Arial',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 55,
                ),
              ),
              // Text(
              //   titleComponent,
              //   style: const TextStyle(
              //     fontFamily: 'Arial',
              //     color: Colors.white,
              //     fontWeight: FontWeight.w500,
              //     fontSize: 40,
              //   ),
              // ),

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
                        onPressed: _onForgotPasswordPressed,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_open,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '$forgotPwdTS',
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

  void _onForgotPasswordPressed() {
    setState(() => _forgot = true);
  }

  Widget _forgotWidget(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Center(
        child: Container(
          width: constraints.maxWidth * 0.85,
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
              Image.asset(
                'assets/images/logoOrigami/origami_logo.png', // ใส่โลโก้
                width: constraints.maxWidth * 0.4,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.transparent,
                    child: Center(
                      child: LoadingAnimationWidget.horizontalRotatingDots(
                        size: 65,
                        color: Colors.orange,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 24),
              // Container(
              //   // color: Colors.white,
              //   width: MediaQuery.of(context).size.width * 0.5,
              //   child: Image.network(
              //     logoComponent, // ใส่โลโก้
              //     width: MediaQuery.of(context).size.width * 0.5,
              //     fit: BoxFit.contain,
              //     errorBuilder: (context, error, stackTrace) {
              //       return Container();
              //     },
              //   ),
              // ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      '$messageforgotPwdTS',
                      style: TextStyle(
                        fontFamily: 'Arial',
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '    $messageRestPwdTS',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          color: Colors.orange.shade50,
                          fontSize: 16,
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
                      style: TextStyle(
                          fontFamily: 'Arial', color: Color(0xFF555555)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            fontFamily: 'Arial', color: Color(0xFF555555)),
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
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 60, right: 60, bottom: 12, top: 12),
                          child: Text(
                            '$sendTS',
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
                            Icon(Icons.chevron_left,
                                color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '$returnLoginTS',
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
          ),
        ),
      ),
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
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: _login,
        child: Text(
          '$loginTS',
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
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'เลือกสถานที่ที่ต้องการเข้าใช้งาน',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: employeeList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final employee = employeeList[index];
                    return GestureDetector(
                      onTap: () async {
                        Navigator.pop(context); // ปิด Dialog ก่อนเปลี่ยนหน้า
                        await Future.delayed(const Duration(milliseconds: 500));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrigamiPage(
                              employee: employee,
                              Authorization: authorization,
                              popPage: widget.popPage,
                              company_id: index,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            employee.comp_logo,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image),
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


  // void _showFullScreenImage(List<Employee> employee) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     barrierColor: Colors.black87,
  //     builder: (context) {
  //       return Dialog(
  //           backgroundColor: Colors.white,
  //           insetPadding: EdgeInsets.all(18), // ขยายเต็มจอ
  //           child: GridView.builder(
  //               padding: const EdgeInsets.all(8),
  //               shrinkWrap: true,
  //               physics: const NeverScrollableScrollPhysics(),
  //               itemCount: employee.length,
  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 2, // 2 รูปต่อแถว
  //                 crossAxisSpacing: 8,
  //                 mainAxisSpacing: 8,
  //                 childAspectRatio: 1, // อัตราส่วนกว้าง/สูง (ปรับได้ตามต้องการ)
  //               ),
  //               itemBuilder: (context, index) {
  //                 return GestureDetector(
  //                     onTap: () async {
  //                       await Future.delayed(Duration(seconds: 1));
  //                       Navigator.pushReplacement(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => OrigamiPage(
  //                             employee: employee[index],
  //                             Authorization: authorization,
  //                             popPage: widget.popPage,
  //                             company_id: index,
  //                           ),
  //                         ),
  //                       );
  //                       // Navigator.pop(context); // ปิด Dialog เมื่อแตะที่รูป
  //                     },
  //                     child: Card(
  //                       child: Image.network(
  //                         employee[index].comp_logo,
  //                         fit: BoxFit.contain,
  //                         width: 50,
  //                         height: 50,
  //                         errorBuilder: (context, error, stackTrace) {
  //                           return Icon(Icons.error);
  //                         },
  //                       ),
  //                     ),
  //                 );
  //               }));
  //     },
  //   );
  // }

  Future<void> _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    saveCredentials(username, password);

    if (username.isEmpty || password.isEmpty) {
      String errorMessage = '';
      if (username.isEmpty && password.isEmpty) {
        errorMessage = 'กรุณากรอกชื่อผู้ใช้และรหัสผ่าน';
      } else if (username.isEmpty) {
        errorMessage = 'กรุณากรอกชื่อผู้ใช้';
      } else {
        errorMessage = 'กรุณากรอกรหัสผ่าน';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: const TextStyle(fontFamily: 'Arial', color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // เรียก API login
    await _fetchLogin(username, password);
  }


  Future<void> _fetchLogin(String username, String password) async {
    final uri = Uri.parse('$host/api/origami/signin.php');

    try {
      final response = await http.post(
        uri,
        body: {
          'auth_password': 'ori20#17gami',
          'username': username.trim(),
          'password': password.trim(),
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 200) {
          final List<dynamic> employeeJson = jsonResponse['employee_data'] ?? [];

          if (employeeJson.isEmpty) {
            throw Exception('No employee data found.');
          }

          final List<Employee> employeeList = employeeJson
              .map<Employee>((json) => Employee.fromJson(json))
              .toList();

          setState(() {
            _isLoading = true;
          });

          if (countPage == 1 && employeeList.length >= 2) {
            _showFullScreenImage(employeeList);
          } else {
            await Future.delayed(const Duration(seconds: 1));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => OrigamiPage(
                  employee: employeeList[widget.company_id ?? 0],
                  Authorization: authorization,
                  company_id: widget.company_id ?? 0,
                  popPage: widget.popPage,
                ),
              ),
            );
          }
        } else {
          final String errorMessage = jsonResponse['message'] ?? 'Login failed';
          _showErrorSnackbar(errorMessage);
        }
      } else {
        _showErrorSnackbar('Server error (${response.statusCode})');
      }
    } catch (e, stacktrace) {
      print('Login Exception: $e');
      print(stacktrace);
      _showErrorSnackbar('An error occurred. Please try again later.');
    }
  }

  String forgot_mail = '';
  Future<void> _fetchForgetMail() async {
    final uri = Uri.parse("$host/api/origami/forgot_password.php");
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
          _showErrorSnackbar(jsonResponse['message'] ?? 'An error occurred');
        } else {
          _showSuccessSnackbar(jsonResponse['message'] ?? 'Please check your email.');
        }
      } else {
        throw Exception('Server returned status ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _fetchForgetMail: $e');
      _showErrorSnackbar('Failed to send email. Please try again.');
    }
  }


  // String logoComponent = '';
  // String titleComponent = '';
  String backgroudComponent = '';
  // Future<void> _fetchComponent() async {
  //   final uri = Uri.parse("$host/api/origami/e-learning/component.php");
  //
  //   try {
  //     final response = await http.post(
  //       uri,
  //       body: {
  //         'auth_password': authorization,
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //
  //       if (jsonResponse['status'] == 200) {
  //         setState(() {
  //           logoComponent = jsonResponse['logo'] ?? '';
  //           titleComponent = jsonResponse['title'] ?? '';
  //           backgroudComponent = jsonResponse['backgroud'] ?? '';
  //         });
  //       } else {
  //         _showErrorSnackbar(jsonResponse['message'] ?? 'Component not found.');
  //       }
  //     } else {
  //       throw Exception('Server returned status ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error in _fetchComponent: $e');
  //     _showErrorSnackbar('Failed to load components. Please try again.');
  //   }
  // }

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
    required this.endpoint,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      emp_id: json['emp_id'] ?? '',
      emp_code: json['emp_code'] ?? '',
      emp_name: json['emp_name'] ?? '',
      emp_avatar: json['emp_avatar'] ?? '',
      comp_id: json['comp_id'] ?? '',
      comp_name: json['comp_name'] ?? '',
      comp_logo: json['comp_logo'] ?? '',
      dept_name: json['dept_name'] ?? '',
      dna_color: json['dna_color'] ?? '',
      password_verify: json['password_verify'] ?? '',
      endpoint: json['endpoint'] ?? '',
    );
  }
}
