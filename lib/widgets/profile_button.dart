import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  final Color color;
  final Color titleColor;

  const ProfileButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
    this.color = const Color(0xFFEDF3F2),
    this.titleColor = const Color(0xFF80AFAD),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: titleColor),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.right, // لأنه عربي
        ),
        trailing: Icon(Icons.arrow_back_ios, color: titleColor, size: 18),
        onTap: onPressed,
      ),
    );
  }
}
