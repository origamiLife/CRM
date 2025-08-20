import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

@HiveType(typeId: 0)
class CallLogModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String position;
  @HiveField(3)
  String tel;
  @HiveField(4)
  String callNumber;
  @HiveField(5)
  int duration;
  @HiveField(6)
  String callTime;
  @HiveField(7)
  String callType;

  CallLogModel({
    required this.id,
    required this.name,
    required this.position,
    required this.tel,
    required this.callNumber,
    required this.duration,
    required this.callTime,
    required this.callType,
  });
}

class CallLogModel2 extends HiveObject {
  // @HiveField(0)
  final String phoneNumber;
  // @HiveField(1)
  final DateTime callTime;
  // @HiveField(2)
  final String callStatus;

  CallLogModel2({
    required this.phoneNumber,
    required this.callTime,
    required this.callStatus,
  });
}

class TicketWithCutAndDashedLine extends StatelessWidget {
  const TicketWithCutAndDashedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipPath(
                        clipper: _TicketClipper(),
                        child: Container(
                          width: 300,
                          height: 550,
                          color: Colors.indigo,
                          padding: const EdgeInsets.all(16),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("🎫 บัตรผ่าน", style: TextStyle(color: Colors.white, fontSize: 24)),
                              SizedBox(height: 10),
                              Text("เข้างาน Developer Conf", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      // เส้นปะ
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _DashedLinePainter(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // Card ที่อยู่ด้านล่าง
                      Container(
                        margin: const EdgeInsets.only(top: 100), // ดันให้ card อยู่ใต้ครึ่งล่างของรูป
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 100.0, bottom: 16, left: 16, right: 16),
                            child: Column(
                              children: const [
                                Text(
                                  "ชื่อรายการ",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8),
                                Text("รายละเอียดเพิ่มเติมของเนื้อหาใน card"),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // รูปภาพที่อยู่ซ้อนด้านบน
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 200,
                          height: 150,
                          child: Image.network(
                            'https://example.com/image.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double notchRadius = 20;
    double notchY = size.height * 0.75; // จุดที่เว้า 3/4 ของความสูง

    Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, notchY - notchRadius);
    path.arcToPoint(
      Offset(size.width, notchY + notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false, // โค้งเว้าเข้า
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, notchY + notchRadius);
    path.arcToPoint(
      Offset(0, notchY - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double y = size.height * 0.75;
    double dashWidth = 5;
    double dashSpace = 5;
    double startX = 0;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
