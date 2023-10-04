import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextInputFieldLabel extends StatelessWidget {
  /// The label above the input field.
  final String label;

  /// Whether the field is required or not.
  final bool isRequired;

  const TextInputFieldLabel({
    super.key,
    required this.label,
    required this.isRequired,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            isRequired
                ? Text(
              '*',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
              ),
            )
                : Container(),
          ],
        ),
        const SizedBox(height: 6.0),
      ],
    );
  }
}
