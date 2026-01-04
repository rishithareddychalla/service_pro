import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 45% of screen height for the expanded header
    final double headerHeight = MediaQuery.of(context).size.height * 0.45;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: headerHeight,
            pinned: true, // Header stays visible as a toolbar when collapsed
            backgroundColor: const Color(0xFFF5F7FA), // Fallback color
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/login_screen_image.png',
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay for text readability if needed, or just the text
                  Positioned(
                    bottom: 60, // Position text slightly above the bottom sheet
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Home',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Log in to book your next service instantly.',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Leading skip button? Or actions?
            actions: [
               TextButton(
               onPressed: () {
                 // TODO: Skip logic
               },
               child: Text(
                 'Skip',
                 style: GoogleFonts.inter(
                   fontSize: 14,
                   fontWeight: FontWeight.w500,
                   color: Colors.white,
                 ),
               ),
            ),
            ],
          ),
          
          // Form Content
          SliverToBoxAdapter(
            child: Container(
              // Negative margin to pull it UP over the image? 
              // Standard approach: just let it scroll. 
              // To get the "Rounded Top" look over the image, we can wrap thisContainer in a Transform 
              // or just rely on the design being sequential. 
              // If we want it to LOOK like it's overlapping the bottom of the image, we can transform translate up.
              transform: Matrix4.translationValues(0, -30, 0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    // Phone Number Label
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Country',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 7,
                          child: Text(
                            'Phone Number',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Phone Inputs
                    Row(
                      children: [
                        // Country Code
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: CountryCodePicker(
                              onChanged: (country) {},
                              initialSelection: 'US',
                              favorite: const ['+1', 'US'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              padding: EdgeInsets.zero,
                              textStyle: GoogleFonts.inter(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Phone Number Field
                        Expanded(
                          flex: 7,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '555-0123',
                                hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              style: GoogleFonts.inter(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Email Input
                    RichText(
                      text: TextSpan(
                        text: 'Email Address ',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
                        children: [
                          TextSpan(
                            text: '(Optional)',
                            style: GoogleFonts.inter(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'name@example.com',
                          hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        style: GoogleFonts.inter(fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Verify Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                           Navigator.of(context).push(
                             MaterialPageRoute(builder: (context) => const DashboardScreen()),
                           );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A73E8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Send Verification Code',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: GoogleFonts.inter(color: Colors.grey.shade500),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey.shade300)),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Social Buttons
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.apple, color: Colors.black, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'Continue with Apple',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Custom Google Icon since it's not in standard Icons
                           SizedBox(
                             width: 24,
                             height: 24,
                             child: Center(
                               child: Text('G', style: GoogleFonts.poppins(fontSize:20, fontWeight: FontWeight.bold, color: Colors.blue)),
                             ), // Placeholder for Google Logo
                             // Ideally use an asset: Image.asset('assets/icons/google.png', width: 24),
                           ),
                          const SizedBox(width: 8),
                          Text(
                            'Continue with Google',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40), // Extra space for scrolling/overscroll
                    
                    // Terms
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'By continuing, you agree to our ',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500),
                          children: [
                            TextSpan(
                              text: 'Terms of Service',
                              style: GoogleFonts.inter(color: Colors.blue.shade700, fontWeight: FontWeight.w500),
                            ),
                            const TextSpan(text: ' and\n'),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: GoogleFonts.inter(color: Colors.blue.shade700, fontWeight: FontWeight.w500),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
