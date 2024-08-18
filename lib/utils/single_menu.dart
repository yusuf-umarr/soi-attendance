import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SingleMenu extends StatelessWidget {
  final IconData icon;
  final String menuName;
  final Color? color;
  final Function()? action;
  final String? decName;

  const SingleMenu({
    super.key,
    required this.icon,
    required this.menuName,
    this.color,
    this.action,
    this.decName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: Color(0x34090F13),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 25.0,
              height: 25.0,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 13.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              menuName,
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
