import 'package:flutter/material.dart';

import '../../../utils/constants/constant_colors.dart';

class ContinueBtn extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor; // Make nullable
  final Color textColor;
  final bool showArrow; // Parameter to control arrow visibility

  const ContinueBtn({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor, // No default here
    this.textColor = Colors.white,
    this.showArrow = true, // Default is true
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Max width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? ConstantColors.primary, // Use default if null
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Rounded corners
          ),
          padding: const EdgeInsets.symmetric(vertical: 16), // Adjust height
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Shrink the row size
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showArrow) // Conditionally show arrow
              const SizedBox(width: 8), // Space between text and arrow
            if (showArrow)
              const Icon(
                Icons.arrow_forward, // Arrow icon
                color: Colors.white, // Arrow color
              ),
          ],
        ),
      ),
    );
  }
}
