import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class textWidget extends StatelessWidget {
  String title;
  Color? color;
  double? fontSize;
  FontWeight? fontWeight;
  TextAlign? textAlign;

  textWidget(
      {super.key,
      required this.title,
      this.color,
      this.fontSize,
      this.fontWeight,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      textAlign: textAlign,
      title,
      style: GoogleFonts.poppins(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
