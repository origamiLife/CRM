import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:origamilift/import/import.dart';

String host = 'https://dev.origami.life';
int selectedRadio = 2;
bool isAndroid = false;
bool isTablet = false;
bool isIPad = false;
bool isIPhone = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ใช้สำหรับรอการ initialize
  await initializeDateFormatting(
      'th', null); // เตรียมข้อมูลสำหรับ Locale ภาษาไทย
  var appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  await Hive.openBox('userBox'); // เปิด Box สำหรับเก็บข้อมูล

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      title: 'Origami',
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
            fontWeight: FontWeight.bold,
          ),
          //GoogleFonts.oswald
          titleLarge: TextStyle(
            fontFamily: 'Arial',
            fontSize: 28,
          ),
        ),
      ),
      home: const LoginPage(num: 0, popPage: 0),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ));
  }
}
