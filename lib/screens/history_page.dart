// lib/screens/history_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme colors for consistency with the rest of the app
    const baseColor = Color(0xFF2A1B17);
    const cardColor = Color(0xFF4A342E);
    const accentColor = Color(0xFFD86C2F);
    const textPrimary = Color(0xFFEDE3DB);
    const textSecondary = Color(0xFFBFAF9F);

    return Scaffold(
      backgroundColor: baseColor,
      appBar: NeumorphicAppBar(
        title: Text(
          'History',
          style: GoogleFonts.poppins(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 1.1,
          ),
        ),
        color: baseColor,
        iconTheme: const IconThemeData(color: accentColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Text(
              'Your Meal Logs',
              style: GoogleFonts.poppins(
                color: accentColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            // Example Card for a Day's Log
            Neumorphic(
              style: NeumorphicStyle(
                color: cardColor,
                depth: 4,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
                shadowLightColor: Colors.orange.withOpacity(0.15),
                shadowDarkColor: Colors.black87,
              ),
              margin: const EdgeInsets.only(bottom: 18),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: accentColor.withOpacity(0.15),
                  child: Icon(Icons.calendar_today, color: accentColor),
                ),
                title: Text(
                  'July 6, 2025',
                  style: GoogleFonts.poppins(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Calories: 1,850  •  Protein: 110g  •  Carbs: 230g  •  Fat: 60g',
                  style: GoogleFonts.poppins(
                    color: textSecondary,
                    fontSize: 13,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: accentColor),
                onTap: () {
                  // Placeholder for navigation to detailed day log
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Detailed logs coming soon!',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: accentColor,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
            // Placeholder for chart/records
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart_rounded, size: 48, color: accentColor.withOpacity(0.7)),
                    const SizedBox(height: 16),
                    Text(
                      'Charts and meal records will appear here.',
                      style: GoogleFonts.poppins(
                        color: textSecondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Track your nutrition over time!',
                      style: GoogleFonts.poppins(
                        color: accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
