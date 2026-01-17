import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackingScreen extends StatelessWidget {
  final String professionalName;

  const TrackingScreen({super.key, required this.professionalName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tracking",
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map, size: 80, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              "Tracking $professionalName",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Your professional is on the way!",
              style: GoogleFonts.inter(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
