import 'package:flutter/material.dart';

class CustomElevetedButton extends StatelessWidget {
  const CustomElevetedButton({
    super.key,
    required this.text,
    required this.color,
    this.width = 227,
    this.textColor = Colors.white,
    this.height = 50,
    this.onPressed,
  });

  final String text;
  final Color color;
  final double width;
  final double height;
  final Color textColor;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: color,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
