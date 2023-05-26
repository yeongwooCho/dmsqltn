import 'package:flutter/material.dart';
import 'package:read_fix_korean/component/custom_card.dart';
import 'package:read_fix_korean/const/colors.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '추천 정답',
                      style: textStyle,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '비교 정답',
                      style: textStyle,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                      const SizedBox(height: 8.0),
                      CustomCard(
                        isCorrect: false,
                        title: '1. 사람들에게 사진 바람이나',
                        errorText: 'Error(123)',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: PRIMARY_COLOR,
            minimumSize: const Size(100, 60),
            textStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_camera),
              const SizedBox(width: 8.0),
              Text('Open Camera'),
            ],
          ),
        )
      ],
    );
  }
}
