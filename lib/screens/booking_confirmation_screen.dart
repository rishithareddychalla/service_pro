import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'payment_screen.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String locationAddress;
  final LatLng locationCoordinates;

  const BookingConfirmationScreen({
    super.key,
    required this.locationAddress,
    required this.locationCoordinates,
  });

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final MapController _mapController = MapController();
  
  // Mock data for "Pros" nearby
  final List<LatLng> _nearbyPros = [
    const LatLng(40.7150, -74.0090),
    const LatLng(40.7200, -74.0020),
    const LatLng(40.7088, -74.0150),
  ];

  // State variables for editable fields
  late String _displayAddress;
  late String _displayTime;

  @override
  void initState() {
    super.initState();
    _displayAddress = widget.locationAddress;
    _displayTime = "Today, 2:30 PM - 3:30 PM";
  }

  Future<void> _editLocation() async {
    TextEditingController controller = TextEditingController(text: _displayAddress);
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Service Location"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Enter full address",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _displayAddress = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _editTime() async {
    // Pick Date
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (date == null) return;

    // Pick Time
    if(!mounted) return;
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 14, minute: 30),
    );
    if (time == null) return;

    // Format string (Simplified for demo)
    final String dateStr = "${date.month}/${date.day}";
    final String timeStr = time.format(context);
    // Add 1 hour for end time simply
    final int endHour = (time.hour + 1) % 24;
    final TimeOfDay endTime = TimeOfDay(hour: endHour, minute: time.minute);
    final String endTimeStr = endTime.format(context);

    setState(() {
      _displayTime = "$dateStr, $timeStr - $endTimeStr";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Full Screen Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.locationCoordinates,
              initialZoom: 14.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.rishitha.servicepro',
              ),
              MarkerLayer(
                markers: [
                  // User Location
                  Marker(
                    point: widget.locationCoordinates,
                    width: 50,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.circle, color: Colors.blue, size: 20),
                      ),
                    ),
                  ),
                  // Nearby Pros
                  ..._nearbyPros.asMap().entries.map((entry) {
                    final isFemale = entry.key % 2 == 0;
                    return Marker(
                      point: entry.value,
                      width: 45,
                      height: 45,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              image: DecorationImage(
                                image: NetworkImage(isFemale
                                    ? 'https://randomuser.me/api/portraits/women/${entry.key + 10}.jpg'
                                    : 'https://randomuser.me/api/portraits/men/${entry.key + 10}.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border:
                                    Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),

          // 2. Back Button & Overlay Controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  // "Finding nearby pros..." Pill
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Finding nearby pros...',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.55, 
            minChildSize: 0.5,
            maxChildSize: 0.55, // Fixed height for now based on design
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       // Drag Handle
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Service Location
                      _buildInfoRow(
                        icon: Icons.location_on,
                        title: "SERVICE LOCATION",
                        value: _displayAddress,
                        hasEdit: true,
                        onEdit: _editLocation,
                        iconColor: Colors.blue,
                        iconBg: Colors.blue.shade50,
                      ),
                      const Divider(height: 32),

                      // Time
                      _buildInfoRow(
                        icon: Icons.access_time_filled,
                        title: "TIME",
                        value: _displayTime,
                        hasEdit: true,
                        onEdit: _editTime,
                        iconColor: Colors.blue,
                        iconBg: Colors.blue.shade50,
                      ),
                      const SizedBox(height: 24),

                      // Service Item Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                      'https://images.unsplash.com/photo-1581092921461-eab62e47a71e?q=80&w=2670&auto=format&fit=crop'), // Placeholder AC img
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Standard A/C Servicing",
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1A1D1E),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.person, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        "1 Pro",
                                        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.circle, size: 4, color: Colors.grey),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Est. 1 hr",
                                        style: GoogleFonts.inter(fontSize: 13, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "\$50.00",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A1D1E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Payment Method
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      "VISA",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      "Personal •••• 4242",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF1A1D1E),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 16),
                                ],
                              ),
                             ),
                             TextButton(
                              onPressed: (){},
                              style: TextButton.styleFrom(
                                visualDensity: VisualDensity.compact,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                              ),
                              child: Text(
                                "Promo code",
                                style: GoogleFonts.inter(
                                  fontSize: 14, 
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF1A73E8),
                                ),
                              ),
                             )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Confirm Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PaymentScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A73E8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Confirm Booking",
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      Text(
                        "By confirming, you agree to our Terms of Service and Cancellation Policy. Professionals nearby will be notified.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required bool hasEdit,
    VoidCallback? onEdit,
    required Color iconColor,
    required Color iconBg,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1D1E),
                ),
              ),
            ],
          ),
        ),
        if (hasEdit)
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              "Edit",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A73E8),
              ),
            ),
          ),
      ],
    );
  }
}
