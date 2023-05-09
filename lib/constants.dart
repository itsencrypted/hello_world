import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle kmyText = GoogleFonts.firaCode(
  textStyle: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      shadows: [
        Shadow(
          offset: const Offset(0.0, 0.6),
          blurRadius: 6.0,
          color: Colors.white30.withOpacity(0.5),
        )
      ]),
);
