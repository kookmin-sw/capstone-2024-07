import 'package:flutter/material.dart';

import '../../common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final String? suffixText;
  final bool obscureText;
  final bool isInputEnabled;
  final bool autoFocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    this.hintText,
    this.errorText,
    this.suffixText,
    this.obscureText = false,
    this.autoFocus = false,
    this.isInputEnabled = true,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: INPUT_BORDER_COLOR,
        width: 1.0,
      ),
    );

    return TextFormField(
      enabled: isInputEnabled,
      cursorColor: PRIMARY_COLOR,
      // obscureText = 입력할때 비밀번호처럼 가려지게 할지 여부!
      obscureText: obscureText,
      // autofocus = 화면에 처음 들어왔을때 포커스 시켜놓을지 여부.
      autofocus: autoFocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10.0),
        suffixIcon: suffixText == null
            ? null
            : Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Text(suffixText!),
        ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 10,
          minWidth: 10,
        ),
        suffixStyle: const TextStyle(
          fontSize: 14.0,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        fillColor: INPUT_BG_COLOR, //배경색
        filled: true, //배경색 있음.
        // border = 모든 input 상태의 기본 세팅
        border: baseBorder,
        //enabledBorder ->
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_COLOR,
          ),
        ),
        errorText: errorText,
      ),
    );
  }
}