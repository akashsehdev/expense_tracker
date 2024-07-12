import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:flutter/material.dart';

class Btn extends StatelessWidget {
  final String label;
  final VoidCallback press;
  final double? fontSize;
  final Color txtColor;
  final Color? backgroundColor;
  final FontWeight fontWeight;
  final double? width;
  const Btn({
    super.key,
    required this.label,
    required this.press,
    required this.txtColor,
    this.fontSize,
    required this.fontWeight,
    required this.backgroundColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    //Query width and height of device for being fit or responsive
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: width ?? size.width * .9,
      height: 55,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: TextButton(
        onPressed: press,
        child: textWidget(
            title: label,
            color: txtColor,
            fontSize: fontSize,
            fontWeight: fontWeight),
      ),
    );
  }
}
