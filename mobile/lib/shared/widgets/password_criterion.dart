import 'package:flutter/material.dart';

class PasswordCriterion extends StatelessWidget {
  final String text;
  final bool isMet;

  const PasswordCriterion({
    super.key,
    required this.text,
    required this.isMet,
  });

  static const _metIcon = Icon(Icons.check_circle, color: Colors.green, size: 16);
  static const _unmetIcon = Icon(Icons.cancel, color: Colors.red, size: 16);
  static const _metStyle = TextStyle(color: Colors.green, fontSize: 12);
  static const _unmetStyle = TextStyle(color: Colors.red, fontSize: 12);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          isMet ? _metIcon : _unmetIcon,
          const SizedBox(width: 8),
          Text(text, style: isMet ? _metStyle : _unmetStyle),
        ],
      ),
    );
  }
}
