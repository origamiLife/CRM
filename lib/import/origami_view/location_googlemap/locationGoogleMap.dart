import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:origamilift/import/import.dart';

class LocationGoogleMap extends StatefulWidget {
  const LocationGoogleMap({super.key, required this.latLng});
  final Function(LatLng?) latLng;
  @override
  _LocationGoogleMapState createState() => _LocationGoogleMapState();
}

class _LocationGoogleMapState extends State<LocationGoogleMap> {
  late GoogleMapController mapController;
  LatLng? _selectedLocation; // สำหรับเก็บตำแหน่งที่เลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9900),
        title: Text('Select location',style: TextStyle(
                fontFamily: 'Arial',
          color: Colors.white,
        ),),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            onTap: (LatLng location) {
              setState(() {
                _selectedLocation = location; // เก็บตำแหน่งที่ผู้ใช้แตะ
                widget.latLng(location);
              });
              Navigator.pop(context);
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(13.73409854731179, 100.62710791826248),
              zoom: 10,
            ),
            markers: _selectedLocation != null
                ? {
              Marker(
                markerId: MarkerId('selected-location'),
                position: _selectedLocation!,
              ),
            }
                : {},
          ),
          if (_selectedLocation != null)
            Positioned(
              bottom: 50,
              left: 20,
              child: Text(
                'Selected Position: \nLat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
