import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

getCommanButtomTitleHeading(
  String title,
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.close,
              color: Color(0xfff223e6d),
            ),
          ),
        ),
      ],
    ),
  );
}
