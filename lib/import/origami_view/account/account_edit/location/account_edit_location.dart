import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';
import 'package:path/path.dart' as path;
import 'package:geolocator/geolocator.dart';

import '../../account_screen.dart';
class AccountEditLocation extends StatefulWidget {
  const AccountEditLocation({
    Key? key,
    required this.employee, required this.account,

  }) : super(key: key);
  final Employee employee;
  final ModelAccount account;

  @override
  _AccountEditLocationState createState() => _AccountEditLocationState();
}

class _AccountEditLocationState extends State<AccountEditLocation> {
  TextEditingController _mapMarkerLocationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    showDate();
    _mapMarkerLocationController.addListener(() {
      print("Current text: ${_mapMarkerLocationController.text}");
    });
  }

  @override
  void dispose() {
    _mapMarkerLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: _logoInformation()),
    );
  }

  Widget _logoInformation() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Map Location',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 22,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 8),
            _mapLocation(),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _mapLocation() {
    return Column(
      children: [
        Column(
          children: [
            Container(
              child: _image != null
                  ? Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.file(
                              _image!,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Icon(
                                      Icons.cancel_outlined,
                                      color: Colors.white,
                                    ),
                                    Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : InkWell(
                onTap: () => _pickImage(ImageSource.camera),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        child: Center(
                          child: Icon(Icons.camera_alt,
                              color: Colors.grey, size: 100),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            _textController('Map marker', _mapMarkerLocationController, true, Icons.location_history),
          ],
        ),
      ],
    );
  }

  final ImagePicker _picker = ImagePicker();
  String _base64Image = '';
  String latitude = '';
  String longitude = '';
  File? _image;
  bool _isStamping = false;

  Future<void> _pickImage(ImageSource source) async {
    if (_isStamping) return;
    _isStamping = true;

    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(
        directory.path,
        'my_image_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      final file = File(image.path);
      final imageBytes = await file.readAsBytes();
      final base64String = base64Encode(imageBytes);

      setState(() {
        _image = file;
        _base64Image = base64String;
        latitude = '${userPosition?.latitude}';
        longitude = '${userPosition?.longitude}';

      });
      print('Latitude: $latitude');
      print('Longitude: $longitude');
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      _isStamping = false;
    }
  }

  LatLng? _selectedLocation;
  Widget _textController(String text, controller, bool key, IconData numbers) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Arial',
              color: Color(0xFF555555),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: controller,
              readOnly: key,
              maxLines: null,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                isDense: true,
                fillColor:
                key == false ? Colors.grey.shade100 : Colors.grey.shade300,
                labelStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                hintText: '',
                hintStyle: TextStyle(
                  fontFamily: 'Arial',
                  color: Color(0xFF555555),
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade100,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: key == false
                        ? Colors.orange.shade300
                        : Colors.grey.shade100,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                prefixIcon: Icon(numbers, color: Colors.black54),
              ),
              style: TextStyle(
                fontFamily: 'Arial',
                // color: Color(0xFF555555),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _selectedDateEnd = DateTime.now();
  String startDate = '';
  String endDate = '';
  void showDate() {
    DateFormat formatter = DateFormat('yyyy/MM/dd');
    startDate = formatter.format(_selectedDateEnd);
    endDate = formatter.format(_selectedDateEnd);
  }

}

class ModelType {
  String id;
  String name;
  ModelType({required this.id, required this.name});
}
