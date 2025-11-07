import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key, required this.employee}) : super(key: key);
  final Employee employee;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _oldPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  bool _showOld = false;
  bool _showNew = true;
  bool _showConfirm = true;

  @override
  void initState() {
    super.initState();
    showDate();
    _oldPasswordController.addListener(() {
      setState(() {
        _oldPassword = _oldPasswordController.text;
      });
    });
    _newPasswordController.addListener(() {
      setState(() {
        _newPassword = _newPasswordController.text;
        _validatePassword(_newPassword);
      });
    });
    _confirmPasswordController.addListener(() {
      setState(() {
        _confirmPassword = _confirmPasswordController.text;
      });
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  DateTime _selectedDateEnd = DateTime.now();
  String showlastDay = '';
  void showDate() {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    showlastDay = formatter.format(_selectedDateEnd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "   Choose a strong password and don't reuse it for other accounts.",
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 16,
                          color: Color(0xFF555555),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  'Change Password',
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    color: Color(0xFF555555),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 16),
                                _buildPasswordField('Old password', false,
                                    _oldPasswordController, Icons.person),
                                // _TextFormField('Old password', _showOld,
                                //     _oldPasswordController),
                                SizedBox(height: 16),
                                _buildPasswordField('New password', _showNew,
                                    _newPasswordController, Icons.lock),
                                // _TextFormField('New password', _showNew,
                                //     _newPasswordController),
                                _Condition(_hasMin, 'At least 8 characters long'),
                                _Condition(_hasUpper,
                                    'At least one uppercase English letter'),
                                _Condition(_hasLower,
                                    'At least one lowercase English letter'),
                                _Condition(
                                    _hasSpecial, 'At least 1 special character'),
                                SizedBox(height: 8),
                                _buildPasswordField('Confirm password', _showConfirm,
                                    _confirmPasswordController, Icons.lock),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: _buildButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(12),
          backgroundColor: Colors.red,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
        onPressed: () {
          if (isValid && _oldPassword == _newPassword ||
              _oldPassword == _confirmPassword) {
            showDialog(
              context: context, // Assuming context is available
              barrierColor: Colors.black54,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Invalid Password"),
                  content: Text(
                      "The new password must be different from your old password. Please enter the new password again."),
                  actions: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade400,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.shade200,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Ok',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'The new password must be different from your old password. Please enter the new password again.',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    color: Colors.white,
                  ),
                ),
              ),
            );
          } else if (isValid && _newPassword == _confirmPassword) {
            _showCustomChangeDialog();
          }
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

  // Widget _TextFormField(String title, bool showPass, controller) {
  //   return SizedBox(
  //     width: 350,
  //     child: TextFormField(
  //       controller: controller,
  //       style: TextStyle(
  //         fontFamily: 'Arial',
  //         color: Color(0xFF555555),
  //       ),
  //       obscureText: showPass,
  //       decoration: InputDecoration(
  //         filled: true,
  //         fillColor: Colors.white,
  //         contentPadding: const EdgeInsets.symmetric(
  //           horizontal: 10,
  //           vertical: 10,
  //         ),
  //         labelText: title,
  //         labelStyle: TextStyle(
  //           fontFamily: 'Arial',
  //           color: Color(0xFF555555),
  //         ),
  //         hintStyle: TextStyle(
  //           fontFamily: 'Arial',
  //           color: Color(0xFF555555),
  //         ),
  //         prefixIcon: Icon(
  //           Icons.lock,
  //           color: Color(0xFF555555),
  //         ),
  //         suffixIcon: Container(
  //           alignment: Alignment.centerRight,
  //           width: 10,
  //           child: Center(
  //             child: IconButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     (showPass == true) ? showPass = false : showPass = true;
  //                   });
  //                 },
  //                 icon: Icon(showPass
  //                     ? Icons.remove_red_eye
  //                     : Icons.remove_red_eye_outlined),
  //                 color: Color(0xFF555555),
  //                 iconSize: 18),
  //           ),
  //         ),
  //         border: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: Color(0xFFFF9900),
  //             width: 1.0,
  //           ),
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         disabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide(
  //             color: Color(0xFFFF9900), // ตั้งสีขอบเมื่อตัวเลือกถูกปิดใช้งาน
  //             width: 1,
  //           ),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: Color(0xFFFF9900), // ขอบสีส้มตอนที่ไม่ได้โฟกัส
  //             width: 1.0,
  //           ),
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(
  //             color: Color(0xFFFF9900), // ขอบสีส้มตอนที่โฟกัส
  //             width: 1.0,
  //           ),
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //       ),
  //       onChanged: (value) {
  //         if (controller == _newPasswordController) _validatePassword(value);
  //       },
  //     ),
  //   );
  // }

  Widget _buildPasswordField(
      String title, bool isPass, controller, IconData icon) {
    return TextFormField(
      controller: controller,
      obscureText: isPass,
      inputFormatters: [
        FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z0-9@#%&*_!$^(),.?":;{}|<>-]')),
      ],
      style: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: title,
        hintStyle: TextStyle(fontFamily: 'Arial', color: Color(0xFF555555)),
        prefixIcon: Icon(icon, color: Color(0xFF555555)),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      // onChanged: (value) {
      //   if (controller == _newPasswordController) _validatePassword(value);
      // },
    );
  }

  Widget _Condition(bool isTrue, String title) {
    return Container(
      width: 350,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            (isTrue)
                ? Icon(Icons.check_circle_rounded, color: Colors.green)
                : Icon(Icons.circle_outlined, color: Color(0xFF555555)),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Arial',
                fontSize: 14,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValid = false;

  void _validatePassword(String text) {
    setState(() {
      _hasMin = _hasMinLength(text);
      _hasUpper = _hasUpperCase(text);
      _hasLower = _hasLowerCase(text);
      _hasSpecial = _hasSpecialCharacter(text);
      isValid = _hasMinLength(text) &&
          _hasUpperCase(text) &&
          _hasLowerCase(text) &&
          _hasSpecialCharacter(text);
    });
  }

  bool _hasMin = false;
  bool _hasUpper = false;
  bool _hasLower = false;
  bool _hasSpecial = false;
  bool _hasMinLength(String text) => text.length >= 8;
  bool _hasUpperCase(String text) => text.contains(RegExp(r'[A-Z]'));
  bool _hasLowerCase(String text) => text.contains(RegExp(r'[a-z]'));
  bool _hasSpecialCharacter(String text) =>
      text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  Future<void> _fetchChangePassword() async {
    final uri = Uri.parse("$hostDev/api/origami/change_password.php");
    final response = await http.post(
      uri,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'emp_id': widget.employee.emp_id,
        'comp_id': widget.employee.comp_id,
        'password': _newPassword,
        'password_ex': _oldPassword,
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == false) {
        final message = jsonResponse['message'];
        // setState(() {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) =>
        //           OrigamiPage(employee: widget.employee, popPage: 10),
        //     ),
        //   );
        // });
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
      } else {
        _oldPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        _hasMin = false;
        _hasUpper = false;
        _hasLower = false;
        _hasSpecial = false;
        final message = jsonResponse['message'];
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OrigamiPage(employee: widget.employee, popPage: 10),
            ),
          );
        });
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

  void _showCustomChangeDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Change Password',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Please confirm your password change.',
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 16,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Container(
              width: MediaQuery.of(context).size.width * 0.35,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
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
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  _fetchChangePassword();
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // Confirm Button
          ],
        );
      },
    );
  }
}
