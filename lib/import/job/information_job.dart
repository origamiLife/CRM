import 'package:http/http.dart' as http;
import '../import.dart';
import 'job.dart';

class Information extends StatefulWidget {
  const Information({super.key, required this.personal});
  final PersonalData personal;

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 1;
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<TabItem> items = [
    TabItem(
      icon: Icons.check,
      title: 'Persons',
    ),
    TabItem(
      icon: Icons.person_2,
      title: 'Interested',
    ),
    TabItem(
      icon: Icons.close,
      title: 'Not Interrested',
    ),
  ];

  Widget _getContentWidget() {
    switch (_selectedIndex) {
      case 0:
        return _buildTextPage('Interrested');
      case 1:
        return persernalData();
      case 2:
        return _buildTextPage('Not Interrested');
      default:
        return _buildTextPage('ERROR!');
    }
  }

  Widget _buildTextPage(String text) {
    return Center(
      child: Text(
        text,
        style: GoogleFonts.openSans(
          fontSize: 18.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Personal Information',
          style: GoogleFonts.openSans(
            fontSize: 22,
            color: Colors.orange,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.orange,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _getContentWidget(),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        iconSize: 18,
        animated: true,
        titleStyle: TextStyle(
          fontFamily: 'Arial',
        ),
        backgroundColor: Colors.white,
        color: Colors.grey.shade400,
        colorSelected: Color(0xFFFF9900),
        indexSelected: _selectedIndex,
        // paddingVertical: 25,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget persernalData() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: 5,
          itemBuilder: (context, index, _) {
            return _buildCarouselItem(widget.personal, index);
          },
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 1.1,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 3),
            enlargeCenterPage: true,
            enableInfiniteScroll: true, // false ปิดใช้งานการเลื่อนที่ไม่สิ้นสุด
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: _currentIndex,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
        // Positioned(
        //   top: 16.0,
        //   child: AnimatedSmoothIndicator(
        //     activeIndex: _currentIndex,
        //     count: 5,
        //     effect: const ScrollingDotsEffect(
        //       activeDotColor: Colors.amber,
        //       dotColor: Colors.white,
        //       dotWidth: 35,
        //       dotHeight: 10,
        //       spacing: 16,
        //     ),
        //     onDotClicked: _carouselController.animateToPage,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildCarouselItem(PersonalData personal, int index) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(
            personal.profile_avatar,
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(top: 220),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: _buildOther(personal, index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOther(PersonalData personal, int itemIndex) {
    return Column(
      children: [
        if (itemIndex == 0)
          eduWidget(
              personal.personal_name,
              'ที่อยู่ : ${personal.province_name}',
              'น้ำหนัก : ${personal.personal_weight} ส่วนสูง : ${personal.personal_height}',
              itemIndex)
        else if (itemIndex == 1)
          (personal.edu_data.isEmpty)
              ? eduWidget(
                  'ระดับการศึกษา : -', 'คณะ : -', 'มหาวิทยาลัย : -', itemIndex)
              : eduWidget(
                  'ระดับการศึกษา : ${personal.edu_data.first.level}',
                  'คณะ : ${personal.edu_data.first.major}',
                  'มหาวิทยาลัย : ${personal.edu_data.first.academy}',
                  itemIndex)
        else if (itemIndex == 2)
          eduWidget('สถานะการทำงาน : ${personal.current_status}',
              'บริษัท : ${personal.work_company}', '', itemIndex)
        else if (itemIndex == 3)
          eduWidget('ทักษะความสามารถ : ${personal.province_name}', 'ภาษา : ',
              '', itemIndex)
        else if (itemIndex == 4)
          eduWidget('กรุ๊ปเลือด : ', 'สถานะ : ', '', itemIndex)
      ],
    );
  }

  Widget eduWidget(String title, String subtitle, String extra, int itemIndex) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  title,
                  style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.openSans(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              if (extra != '')
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    extra,
                    style:
                        GoogleFonts.openSans(color: Colors.white, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              showModalBottomSheet<void>(
                barrierColor: Colors.black12,
                backgroundColor: Colors.orange.shade300,
                context: context,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0), // ปรับค่าความโค้งที่นี่
                  ),
                ),
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return _showModal(itemIndex);
                },
              );
            });
          },
          icon: Icon(
            Icons.expand_circle_down,
            size: 35,
            color: Colors.white,
          ),
        )
      ],
    );
  }

  Widget _showModal(int itemIndex) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ให้ขนาดพอดีกับเนื้อหา
        children: [
          // AppBar(
          //   backgroundColor: Colors.white,
          //   elevation: 0,
          //   title: Text(
          //     'ข้อมูลส่วนบุคคล',
          //     style: GoogleFonts.openSans(
          //       fontSize: 20.0,
          //       color: Colors.black,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   centerTitle: true,
          //   automaticallyImplyLeading: false, // ไม่ให้มีปุ่ม back
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              'ข้อมูลส่วนบุคคล',
              style: GoogleFonts.openSans(
                fontSize: 20.0,
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 8),
          _personal(widget.personal, itemIndex),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _personal(PersonalData personal, int itemIndex) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow('ชื่อ', personal.personal_name),
            _infoRow('เพศ', personal.personal_gender),
            _infoRow('อายุ', personal.personal_age.toString()),
            _infoRow('น้ำหนัก', personal.personal_weight.toString()),
            _infoRow('ส่วนสูง', personal.personal_height.toString()),
            _infoRow(
                'จังหวัด',
                personal.province_name.isNotEmpty
                    ? personal.province_name
                    : '-'),
            Divider(thickness: 1, color: Colors.amber),
            _infoRow('สถานะปัจจุบัน', personal.current_status),
            _infoRow('บริษัท',
                personal.work_company.isNotEmpty ? personal.work_company : '-'),
            _infoRow(
                'ตำแหน่งงาน',
                personal.work_position.isNotEmpty
                    ? personal.work_position
                    : '-'),
            _infoRow('ประสบการณ์', personal.current_status ?? '-'),
            Divider(thickness: 1, color: Colors.amber),
          ],
        ),
      ),
    );
  }

  /// Widget สำหรับแสดงข้อมูลแถวเดียว (Label - Value)
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label : ',
            style: GoogleFonts.openSans(
              fontSize: 16.0,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.openSans(
                fontSize: 14,
                color: Colors.grey,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
