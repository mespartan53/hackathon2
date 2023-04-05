import 'package:flutter/material.dart';

class HoverText extends StatefulWidget {
  final String text;
  final Color mainColor;
  final Color hoverColor;
  final Function()? onTap;

  const HoverText({Key? key, required this.text, required this.mainColor, required this.hoverColor, this.onTap}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<HoverText> createState() => _HoverTextState(text: text, hoverColor: hoverColor, mainColor: mainColor, onTap: onTap);
}

class _HoverTextState extends State<HoverText> {
  final String text;
  final Color mainColor;
  final Color hoverColor;
  final Function()? onTap;
  bool isHovered = false;

  _HoverTextState({
    required this.text,
    required this.mainColor,
    required this.hoverColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onHover: (value) {
        setState(() {
          isHovered = value;
        });
      },
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: isHovered ? hoverColor : mainColor),
        ),
      ),
    );
  }
}
