import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String? errorText;
  final bool isName;
  final bool isEmail;
  final bool isPassword;
  final bool isChangePassword;
  final TextInputType keyboardType;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final bool isValid;
  final bool isDisabled;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText = '',
    this.errorText,
    this.isName = false,
    this.isEmail = false,
    this.isPassword = false,
    this.isChangePassword = false,
    this.keyboardType = TextInputType.text,
    this.onSubmitted,
    this.onChanged,
    this.isValid = false,
    this.isDisabled = false,
  });

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      enableSuggestions: !widget.isPassword,
      autocorrect: false,
      enabled: !widget.isDisabled,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        errorMaxLines: 2,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: widget.isValid ? 2 : 1,
            color: widget.isValid ? Colors.green : Colors.grey,
          ),
        ),
        prefixIcon: widget.isName
            ? Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
              )
            : widget.isEmail
                ? Icon(
                    Icons.email,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : widget.isPassword
                    ? Icon(
                        Icons.lock,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      onSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
    );
  }
}
