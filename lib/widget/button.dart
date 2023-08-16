import 'package:flutter/material.dart';
import 'package:notiboy/utils/color.dart';

class MyButton extends StatelessWidget {
  double? width;
  double? height;
  Color? buttonClr;
  Color? textColor;
  BorderRadiusGeometry? borderRadius;
  final String title;
  double? fontSize;
  Function() onClick;

  MyButton({
    Key? key,
    this.width,
    this.height,
    this.buttonClr,
    this.borderRadius,
    this.textColor,
    required this.title,
    this.fontSize,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 40,
      decoration: BoxDecoration(
        color: buttonClr ?? Clr.blue,
        borderRadius: borderRadius ?? BorderRadius.circular(30),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());
            onClick();
          },
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                letterSpacing: 0.5,
                color: textColor ??  Clr.white,
                fontSize: fontSize ?? 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DialogButton extends StatelessWidget {
  double? width;
  final double? height;
  final ButtonStyle? style;
  final void Function()? onPressed;
  final String? text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? textColor;
  bool? bordered = false;
  final Color? buttonColor;
  final Color? borderColor;
  final double? radius;
  final Gradient? gradient;
  final TextStyle? textStyle;

  DialogButton(
      {Key? key,
      this.width,
      this.height,
      this.style,
      required this.onPressed,
      required this.text,
      this.fontWeight,
      this.fontSize,
      this.textColor,
      this.buttonColor,
      this.bordered,
      this.borderColor,
      this.gradient,
      this.radius,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      hoverColor: Colors.transparent,
      child: Container(
        width: width,
        height: height ?? 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(radius ?? 100),
            gradient: bordered == true ? null : gradient,
            border: Border.all(color: bordered == true ? Color(0xFF4F5051) : Colors.transparent, width: 1)),
        child: Text(
          text.toString(),
          textAlign: TextAlign.center,
          style:
              textStyle ?? TextStyle(fontWeight: fontWeight ?? FontWeight.w600, fontSize: fontSize ?? 20, color: textColor ?? Colors.white),
        ),
      ),
    );
  }
}
