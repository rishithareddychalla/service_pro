import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Color
          Container(color: const Color(0xFFF5F7FA)),
          
          // Hero Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                   BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                   )
                ]
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/servicepro_onboarding.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Trust Indicator
          Positioned(
            top: 60,
            left: 30,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SAFETY FIRST',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        'Verified Pros',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1D1E),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Content Layer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   // Pagination Dots (Decoration)
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Container(width: 24, height: 6, decoration: BoxDecoration(color: Colors.blue.shade600, borderRadius: BorderRadius.circular(3))),
                       const SizedBox(width: 6),
                       Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3))),
                       const SizedBox(width: 6),
                       Container(width: 6, height: 6, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(3))),
                     ],
                   ),
                   const SizedBox(height: 30),

                  // Headline
                  Text(
                    'Expert Help at\nYour Doorstep',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1D1E),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Subtext
                  Text(
                    'Book top-rated professionals for cleaning, repairs, and more in just a few taps.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.of(context).push(
                           MaterialPageRoute(builder: (context) => const LoginScreen()),
                         );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E8), // Google Blue
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        shadowColor: Colors.blue.withOpacity(0.5),
                      ).copyWith(
                        elevation: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.pressed)) return 0;
                          return 8;
                        }),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
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
                  const SizedBox(height: 20),
                  
                  // Login Link
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to Login
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A73E8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Skip Button Top Right
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
               onPressed: () {},
               child: Text(
                 'Skip',
                 style: GoogleFonts.inter(
                   fontSize: 14,
                   fontWeight: FontWeight.bold,
                   color: Colors.grey.shade600,
                 ),
               ),
            ),
          ),
        ],
      ),
    );
  }
}
