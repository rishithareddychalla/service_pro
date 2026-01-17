import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dashboard_screen.dart';

class ServiceTrackingScreen extends StatefulWidget {
  const ServiceTrackingScreen({super.key});

  @override
  State<ServiceTrackingScreen> createState() => _ServiceTrackingScreenState();
}

class _ServiceTrackingScreenState extends State<ServiceTrackingScreen> {
  final MapController _mapController = MapController();
  
  final LatLng _userLocation = const LatLng(34.0522, -118.2437); // Example: Los Angeles
  final LatLng _proLocation = const LatLng(34.0622, -118.2537);  // Example: Nearby

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Full Screen Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation,
              initialZoom: 13.5,
               interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.rishitha.servicepro',
              ),
              // Route Line
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: [_userLocation, _proLocation],
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // User Location
                  Marker(
                    point: _userLocation,
                    width: 60,
                    height: 60,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                          ),
                          child: const Text('12 min', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                         const SizedBox(height: 4),
                         Container(
                          width: 32,
                          height: 32,
                           decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Center(
                            child: Icon(Icons.circle, color: Colors.blue, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Pro Location
                  Marker(
                    point: _proLocation,
                    width: 50,
                    height: 50,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  'https://randomuser.me/api/portraits/women/44.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(BorderSide(color: Colors.white)),
                            ),
                            child: const Icon(Icons.local_shipping, size: 10, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // 2. Status Header Pill
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 16),
                       child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashboardScreen()), (route) => false),
                        ),
                      ),
                     ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.circle, color: Colors.green, size: 12),
                            const SizedBox(width: 8),
                            Text(
                              'On the way',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                       Padding(
                       padding: const EdgeInsets.only(right: 16),
                       child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz, color: Colors.black),
                          onPressed: () {},
                        ),
                      ),
                     ),
                   ],
                ),
              ),
            ),
          ),

          // 3. Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.60,
            minChildSize: 0.55,
            maxChildSize: 0.60,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
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
                      
                      // ETA Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Arriving in 12 mins",
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1D1E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Latest update: 2:30 PM",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                           Container(
                             padding: const EdgeInsets.all(12),
                             decoration: BoxDecoration(
                               color: Colors.blue.shade50,
                               shape: BoxShape.circle,
                             ),
                             child: const Icon(Icons.access_time_filled, color: Colors.blue),
                           ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Pro Details Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                             Container(
                               width: 56,
                               height: 56,
                               decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 border: Border.all(color: Colors.white, width: 2),
                                 image: const DecorationImage(
                                   image: NetworkImage('https://randomuser.me/api/portraits/women/44.jpg'),
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
                                     "Michael Chang",
                                     style: GoogleFonts.inter(
                                       fontSize: 16,
                                       fontWeight: FontWeight.bold,
                                       color: const Color(0xFF1A1D1E),
                                     ),
                                   ),
                                   Row(
                                     children: [
                                       Text(
                                         "Senior Technician",
                                         style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                                       ),
                                       const SizedBox(width: 4),
                                       const Icon(Icons.star, color: Colors.amber, size: 12),
                                       Text(
                                         " 4.9",
                                         style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                                       ),
                                     ],
                                   ),
                                   const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.verified_user, size: 10, color: Colors.green),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Vaccinated",
                                            style: GoogleFonts.inter(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                 ],
                               ),
                             ),
                             Row(
                               children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
                                      onPressed: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    child: IconButton(
                                      icon: const Icon(Icons.phone, color: Colors.white),
                                      onPressed: () {},
                                    ),
                                  ),
                               ],
                             )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Progress Stepper
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Current Status", style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
                          Text("Step 3 of 4", style: GoogleFonts.inter(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildStepBar(isActive: true, isCompleted: true),
                          const SizedBox(width: 4),
                          _buildStepBar(isActive: true, isCompleted: true),
                          const SizedBox(width: 4),
                          _buildStepBar(isActive: true, isCompleted: false),
                          const SizedBox(width: 4),
                          _buildStepBar(isActive: false, isCompleted: false),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("Confirmed", style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                           Text("Assigned", style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                           Text("On the Way", style: GoogleFonts.inter(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                           Text("Working", style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
                         ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Divider(),
                      ),

                      // Location Details
                      _buildDetailRow(
                        icon: Icons.location_on, 
                        title: "SERVICE LOCATION", 
                        subtitle: "1248 W 5th St, Los Angeles"
                      ),
                      const SizedBox(height: 20),
                      _buildDetailRow(
                        icon: Icons.design_services, 
                        title: "SERVICE DETAILS", 
                        subtitle: "Standard A/C Servicing",
                        trailing: TextButton(
                          onPressed: (){},
                          child: Text("View Order", style: GoogleFonts.inter(color: Colors.blue, fontWeight: FontWeight.bold)),
                        )
                      ),

                      const SizedBox(height: 32),
                      TextButton(
                        onPressed: (){
                           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DashboardScreen()), (route) => false);
                        },
                        child: Text(
                          "Cancel Service", 
                          style: GoogleFonts.inter(
                            color: Colors.red, 
                            fontSize: 16, 
                            fontWeight: FontWeight.w600
                          ),
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

  Widget _buildStepBar({required bool isActive, required bool isCompleted}) {
    return Expanded(
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: isActive || isCompleted ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }

  Widget _buildDetailRow({required IconData icon, required String title, required String subtitle, Widget? trailing}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey, letterSpacing: 0.5)),
              const SizedBox(height: 4),
              Text(subtitle, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }
}
