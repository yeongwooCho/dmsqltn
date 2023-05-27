import 'package:flutter/material.dart';
import 'package:read_fix_korean/const/colors.dart';

class CustomCard extends StatelessWidget {
  final bool isCorrect;
  final String title;

  const CustomCard({
    Key? key,
    required this.isCorrect,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCorrect ? TRUE_BOX_COLOR : FALSE_BOX_COLOR,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            isCorrect
                ? const Icon(Icons.check_circle)
                : const Icon(Icons.circle_outlined)
          ],
        ),
      ),
    );
  }
}
