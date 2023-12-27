import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notiboy/utils/color.dart';

class MyTextField extends StatelessWidget {
  EdgeInsetsGeometry? contentPadding;
  EdgeInsetsGeometry? padding;
  TextEditingController controller;
  bool? readOnly;
  String hintText;
  String validate;
  bool? obscureText;
  TextInputAction? textInputAction;
  TextInputType keyboardType;
  Widget? prefixIcon;
  Widget? suffixIcon;
  bool? fill;
  bool isCounter;
  Color? fillColor;
  String textFieldType;
  TextStyle? hintTextStyle;
  TextStyle? inputTextStyle;
  int? extraSetup;
  Function()? fun;
  Function(String)? onChanged;
  Function(String)? onFieldSubmitted;
  void Function()? onTap;
  int? maxLines;
  String? error;
  int? maxLength;
  bool? isDense;
  bool? isCollapsed;
  InputBorder? border;
  InputBorder? focusBorder;
  InputBorder? errorBorder;
  BoxConstraints? prefixIconConstraints;
  BoxConstraints? suffixIconConstraints;
  String? Function(String?)? validator;

  MyTextField(
      {Key? key,
      this.readOnly,
      required this.controller,
      required this.hintText,
      required this.validate,
      this.obscureText,
      required this.keyboardType,
      this.textInputAction,
      this.prefixIcon,
      this.suffixIcon,
      this.extraSetup,
      this.fill,
      this.fillColor,
      required this.textFieldType,
      this.hintTextStyle,
      this.inputTextStyle,
      this.fun,
      this.onChanged,
      this.onFieldSubmitted,
      this.maxLines,
      this.error,
      this.onTap,
      this.contentPadding,
      this.padding,
      this.maxLength,
      this.isDense,
      this.border,
      this.isCollapsed,
      this.focusBorder,
      this.prefixIconConstraints,
      this.suffixIconConstraints,
      this.isCounter = false,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.only(top: 10, left: 5, right: 5),
      child: TextFormField(
        controller: controller,
        onTap: onTap,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        maxLines: maxLines ?? 1,
        onChanged: onChanged,
        cursorColor: Clr.hint,
        cursorHeight: 20,
        textInputAction: textInputAction ?? TextInputAction.next,
        inputFormatters: inputFormattersFun(),
        textAlign: TextAlign.left,
        readOnly: readOnly ?? false,
        style: inputTextStyle ?? TextStyle(color: Clr.white, fontSize: 15),
        maxLength: maxLength,
        validator: validator,
        decoration: InputDecoration(
          counter: isCounter
              ? Text(
                  '${controller.text.length}' + '/' + '${'${maxLength ?? 5}'}',
                  style: inputTextStyle ??
                      TextStyle(color: Clr.white, fontSize: 15),
                )
              : null,
          // style counter text
          counterStyle: isCounter
              ? inputTextStyle ?? TextStyle(color: Clr.white, fontSize: 15)
              : null,
          isCollapsed: isCollapsed ?? false,
          errorText: error,
          fillColor: fillColor,
          filled: true,
          isDense: isDense ?? true,
          counterText: '',
          contentPadding: contentPadding,
          hintText: hintText,
          hintStyle: TextStyle(color: Clr.hint, fontSize: 15),
          border: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: BorderSide.none,
              ),
          enabledBorder: border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: BorderSide.none,
              ),
          focusedBorder: focusBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: BorderSide.none,
              ),
          errorBorder: errorBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: BorderSide(color: Colors.red, width: 1),
              ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          prefixIconConstraints: prefixIconConstraints,
          suffixIconConstraints: suffixIconConstraints,
        ),
      ),
    );
  }

  inputFormattersFun() {
    switch (textFieldType) {
      case "name":
        return [
          LengthLimitingTextInputFormatter(maxLength??150),
          NoLeadingSpaceFormatter(),
        ];
      default:
        return [
          NoLeadingSpaceFormatter(),
        ];
    }
  }
}

class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.startsWith(' ')) {
      final String trimedText = newValue.text.trimLeft();

      return TextEditingValue(
        text: trimedText,
        selection: TextSelection(
          baseOffset: trimedText.length,
          extentOffset: trimedText.length,
        ),
      );
    }

    return newValue;
  }
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
