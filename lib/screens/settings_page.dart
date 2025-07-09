import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Warm brown color scheme (adjust shades as you want)
    final accentColor = const Color(0xFFD2691E); // chocolate brown
    final backgroundColor = const Color(0xFF3E2723); // dark brown
    final subtitleColor = Colors.brown[200];
    final dividerColor = Colors.brown[700];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: accentColor,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 4,
        iconTheme: IconThemeData(color: accentColor),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: 5,
        separatorBuilder: (context, index) => Divider(
          color: dividerColor,
          height: 1,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return ListTile(
                leading: Icon(Icons.notifications, color: accentColor),
                title: Text(
                  'Notifications',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Manage notification preferences',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: subtitleColor,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: accentColor),
                onTap: () {
                  // TODO: Implement notification settings
                },
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              );
            case 1:
              return ListTile(
                leading: Icon(Icons.privacy_tip, color: accentColor),
                title: Text(
                  'Privacy Policy',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'View our privacy policy',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: subtitleColor,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: accentColor),
                onTap: () {
                  // TODO: Show privacy policy page or dialog
                },
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              );
            case 2:
              return ListTile(
                leading: Icon(Icons.feedback_outlined, color: accentColor),
                title: Text(
                  'Send Feedback',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Help us improve the app',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: subtitleColor,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: accentColor),
                onTap: () {
                  // TODO: Implement feedback form or link
                },
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              );
            case 3:
              return ListTile(
                leading: Icon(Icons.delete_forever, color: accentColor),
                title: Text(
                  'Reset Data',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Clear all saved meals and history',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: subtitleColor,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: accentColor),
                onTap: () {
                  // TODO: Implement data reset confirmation dialog
                },
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              );
            case 4:
              return ListTile(
                leading: Icon(Icons.info_outline, color: accentColor),
                title: Text(
                  'About',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'App version, credits, legal info',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: subtitleColor,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: accentColor),
                onTap: () {
                  // TODO: Show about dialog or page
                },
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
