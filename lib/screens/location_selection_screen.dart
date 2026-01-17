import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/service_request_model.dart';
import 'dashboard_screen.dart';
import 'booking_confirmation_screen.dart';

class LocationSelectionScreen extends StatefulWidget {
  final String requestId;

  const LocationSelectionScreen({super.key, required this.requestId});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  // State
  String? _selectedAddress = "Home"; // Default selection
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  LatLng _currentCenter = const LatLng(40.7128, -74.0060); // Default to NYC
  bool _isLoadingLocation = false;

  // Mock Saved Addresses
  final List<Map<String, dynamic>> _savedAddresses = [
    {
      "label": "Home",
      "address": "123 Main St, Apt 4B, New York, NY",
      "icon": Icons.home,
    },
    {
      "label": "Office",
      "address": "456 Tech Blvd, Suite 200, New York",
      "icon": Icons.work,
    },
    {
      "label": "Parents' House",
      "address": "789 Maple Ave, Brooklyn, NY",
      "icon": Icons.favorite,
    },
  ];

  void _confirmLocation() {
    // Instead of immediately "completing" the request, we navigate to the confirmation screen
    // The actual "booking" or update logic would likely move to the next screen or stay here if this was the final step.
    // Based on user request "When the user taps on the confirm location it should navigate to the Booking Confirmation Screen"
    
     Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationScreen(
          locationAddress: _getSelectedAddressDetail(),
          locationCoordinates: _currentCenter,
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // check if services enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
         if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled.')));
          setState(() => _isLoadingLocation = false);
         }
         return;
      }

      var status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        final newCenter = LatLng(position.latitude, position.longitude);
        
        setState(() {
          _currentCenter = newCenter;
          _isLoadingLocation = false;
           // If using "Current Location", clear saved selection
           _selectedAddress = null; 
        });
        
        _mapController.move(newCenter, 15.0);

      } else {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission denied')));
           setState(() => _isLoadingLocation = false);
        }
      }
    } catch (e) {
      debugPrint("Error getting location: $e");
      if (mounted) {
         setState(() => _isLoadingLocation = false);
      }
    }
  }

  String _getSelectedAddressDetail() {
    if (_selectedAddress == null) {
      return "Current Location (${_currentCenter.latitude.toStringAsFixed(4)}, ${_currentCenter.longitude.toStringAsFixed(4)})";
    }
     final savedOne = _savedAddresses.firstWhere(
      (element) => element['label'] == _selectedAddress,
      orElse: () => {"address": "Unknown Location"},
    );
    return savedOne['address'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Location',
          style: GoogleFonts.inter(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Where do you need the service?',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1D1E),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.search, color: Colors.grey),
                        hintText: 'Search for a new address',
                        hintStyle: GoogleFonts.inter(color: Colors.grey.shade500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Current Location Logic
                  GestureDetector(
                    onTap: _getCurrentLocation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: _isLoadingLocation 
                                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.my_location, color: Colors.blue),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Use current location',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  'Enable location services',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.chevron_right, color: Colors.blue),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Map View
                  Container(
                    height: 180,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                       border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Stack(
                      children: [
                         FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _currentCenter,
                            initialZoom: 13.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.rishitha.servicepro',
                            ),
                             MarkerLayer(
                              markers: [
                                Marker(
                                  point: _currentCenter,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Current Area',
                                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Saved Addresses Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saved Addresses',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1D1E),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Edit',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Saved Addresses List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _savedAddresses.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final address = _savedAddresses[index];
                      final isSelected = _selectedAddress == address['label'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAddress = address['label'];
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue.shade50 : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected 
                              ? Border.all(color: Colors.blue) 
                              : Border.all(color: Colors.transparent),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(address['icon'], color: Colors.grey.shade700, size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address['label'],
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1A1D1E),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      address['address'],
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.radio_button_checked, color: Colors.blue)
                              else
                                const Icon(Icons.radio_button_off, color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  // Add New Address Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text("Add New Address"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey.shade300),
                        foregroundColor: Colors.grey.shade700,
                        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          
          // Confirm Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
               color: Colors.white,
               border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: ElevatedButton(
              onPressed: _confirmLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(
                'Confirm Location',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
