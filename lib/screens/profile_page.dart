import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFF2A1B17);
    const cardColor = Color(0xFF4A342E);
    const accentColor = Color(0xFFD86C2F);
    const textColorPrimary = Color(0xFFEDE3DB);
    const textColorSecondary = Color(0xFFBFAF9F);

    return Scaffold(
      backgroundColor: baseColor,
      appBar: NeumorphicAppBar(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: textColorPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 1.1,
          ),
        ),
        color: baseColor,
        iconTheme: const IconThemeData(color: accentColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile picture with edit icon
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    depth: 6,
                    boxShape: NeumorphicBoxShape.circle(),
                    color: baseColor,
                    shadowLightColor: Colors.orange.shade200.withOpacity(0.3),
                    shadowDarkColor: Colors.black87,
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: accentColor,
                    child: Text(
                      'U',
                      style: GoogleFonts.poppins(
                        color: baseColor,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                NeumorphicButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Change photo tapped')),
                    );
                  },
                  style: NeumorphicStyle(
                    color: cardColor,
                    boxShape: NeumorphicBoxShape.circle(),
                    depth: 2,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.camera_alt, color: accentColor, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Username',
              style: GoogleFonts.poppins(
                color: textColorPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'user@example.com',
              style: GoogleFonts.poppins(
                color: textColorPrimary.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            // Profile actions
            NeumorphicButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit Profile tapped')),
                );
              },
              style: NeumorphicStyle(
                color: accentColor,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                depth: 4,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                child: Text(
                  'Edit Profile',
                  style: GoogleFonts.poppins(
                    color: baseColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Divider
            Divider(color: textColorSecondary.withOpacity(0.2)),
            const SizedBox(height: 14),
            // More profile info
            _ProfileInfoRow(
              icon: Icons.cake,
              label: 'Birthday',
              value: 'Jan 1, 2000',
              color: accentColor,
            ),
            _ProfileInfoRow(
              icon: Icons.flag,
              label: 'Country',
              value: 'USA',
              color: accentColor,
            ),
            _ProfileInfoRow(
              icon: Icons.fitness_center,
              label: 'Goal',
              value: 'Stay Fit',
              color: accentColor,
            ),
            const SizedBox(height: 24),
            // Settings & logout
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NeumorphicButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings tapped')),
                    );
                  },
                  style: NeumorphicStyle(
                    color: cardColor,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 2,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    child: Row(
                      children: [
                        Icon(Icons.settings, color: accentColor),
                        const SizedBox(width: 8),
                        Text(
                          'Settings',
                          style: GoogleFonts.poppins(
                            color: textColorPrimary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                NeumorphicButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: cardColor,
                        title: Text('Log Out', style: GoogleFonts.poppins(color: accentColor)),
                        content: Text('Are you sure you want to log out?', style: GoogleFonts.poppins(color: textColorPrimary)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: Text('Cancel', style: GoogleFonts.poppins(color: textColorSecondary)),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logged out!')),
                              );
                              // Add your logout logic here
                            },
                            child: Text('Log Out', style: GoogleFonts.poppins(color: accentColor)),
                          ),
                        ],
                      ),
                    );
                  },
                  style: NeumorphicStyle(
                    color: cardColor,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                    depth: 2,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: accentColor),
                        const SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: GoogleFonts.poppins(
                            color: textColorPrimary,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColorPrimary = const Color(0xFFEDE3DB);
    final textColorSecondary = const Color(0xFFBFAF9F);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: textColorSecondary,
              fontSize: 15,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: textColorPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
