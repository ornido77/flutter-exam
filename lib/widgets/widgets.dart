import 'package:flutter/material.dart';

Text reusableText(
    String text, {
    double? size,
    FontWeight? fw,
    Color? color,
  }) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size ?? 14,
        fontWeight: fw ?? FontWeight.normal,
        color: color ?? Colors.black,
      ),
    );
  }