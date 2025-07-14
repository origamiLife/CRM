import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';

import '../import.dart';

class EmailSenderPage extends StatefulWidget {
  @override
  _EmailSenderPageState createState() => _EmailSenderPageState();
}

class _EmailSenderPageState extends State<EmailSenderPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  // ฟังก์ชันเปิด Gmail พร้อมกรอกข้อมูลอีเมล
  // Future<void> _sendEmail(BuildContext context) async {
  //   final Uri emailUri = Uri(
  //     scheme: 'https',
  //     host: 'yourwebsite.com',
  //     path: _emailCtrl.text.trim(),
  //     queryParameters: {
  //       'subject': _nameCtrl.text.trim(),
  //       'body': _messageCtrl.text.trim(),
  //     },
  //   );
  //
  //   print('Email URI: $emailUri');
  //
  //   if (await canLaunchUrl(emailUri)) {
  //     await launchUrl(webUri, mode: LaunchMode.externalApplication);
  //   } else {
  //     print('ไม่สามารถเปิดแอปอีเมลได้');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('ไม่สามารถเปิดแอปอีเมลได้')),
  //     );
  //   }
  // }

  Future<void> openEmailApp({
    required String toEmail,
    String? subject,
    String? body,
  }) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: toEmail,
      queryParameters: {
        if (subject != null) 'subject': subject,
        if (body != null) 'body': body,
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri, mode: LaunchMode.externalApplication);
    } else {
      print('ไม่สามารถเปิดแอปอีเมลได้');
    }
  }


  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ส่งข้อความไป Gmail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'เรื่อง'),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'หัวเรื่อง' : null,
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                    labelText: 'อีเมลผู้รับ'),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'กรุณาใส่อีเมลให้ถูกต้อง'
                    : null,
              ),
              TextFormField(
                controller: _messageCtrl,
                decoration: const InputDecoration(labelText: 'ข้อความ'),
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'กรุณาใส่ข้อความ' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  openEmailApp(
                    toEmail: _emailCtrl.text.trim(),
                    subject: _nameCtrl.text.trim(),
                    body: _messageCtrl.text.trim(),
                  );
                },
                child: Text('ส่งอีเมล'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
