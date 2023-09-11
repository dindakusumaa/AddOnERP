import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLinePasiveWidget extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String title;
  final String subtitle;

  const TimeLinePasiveWidget({
    super.key,
    this.isFirst = false,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      afterLineStyle: LineStyle(
        color: const Color(0xffFAFAFA).withOpacity(0.5),
        thickness: 6,
      ),
      alignment: TimelineAlign.start,

      indicatorStyle: IndicatorStyle(
        width: 24,
        color: const Color(0xffFAFAFA).withOpacity(0.5),
      ),
      beforeLineStyle: LineStyle(
        color: const Color(0xffFAFAFA).withOpacity(0.5),
        thickness: 6,
      ),

      isLast: isLast,
      isFirst: isFirst,
      endChild: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(left: 16, top: 30),
        decoration: BoxDecoration(
          color: const Color(0xffFAFAFA).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: const Color(0xff084D88),
                fontWeight: FontWeight.w700,
                height: 22 / 14,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: const Color(0xff084D88),
                height: 22 / 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
