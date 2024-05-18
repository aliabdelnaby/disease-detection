import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical_corner/features/prediction/heart/models/predicts_res_model.dart';

class PredictionsScreen extends StatelessWidget {
  final PredicResModel? predicts;
  const PredictionsScreen(this.predicts, {super.key});

  String _roundProbabilityToTwoDecimals() {
    String text = '';
    try {
      double number = double.parse(predicts!.data.toString());
      int num = number.toInt();
      text = num.toString();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return text;
  }

  Color _relevantColor(String percentage) {
    Color c = Colors.blue;
    try {
      int num = int.parse(percentage);
      if (num > 60) {
        c = Colors.red;
      } else {
        c = Colors.blueAccent;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Probability of you having a heart attack is:',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.purple,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            '${_roundProbabilityToTwoDecimals()}%',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: _relevantColor(_roundProbabilityToTwoDecimals()),
                fontSize: 70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Go Back',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
