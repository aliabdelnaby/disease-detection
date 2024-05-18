import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_corner/core/cubit/cubit.dart';
import 'package:medical_corner/core/cubit/states.dart';
import 'package:medical_corner/features/prediction/heart/models/predicts_req_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';

enum Gender { male, female }

class GetPredictScreen extends StatefulWidget {
  const GetPredictScreen({super.key});

  @override
  State<GetPredictScreen> createState() => _GetPredictScreenState();
}

class _GetPredictScreenState extends State<GetPredictScreen> {
  final _ageCtrl = TextEditingController();
  final _cpCtrl = TextEditingController();
  final _trestbpsCtrl = TextEditingController();
  final _cholCtrl = TextEditingController();
  final _fbsCtrl = TextEditingController();
  final _restecgCtrl = TextEditingController();
  final _thalachCtrl = TextEditingController();
  final _exangCtrl = TextEditingController();
  final _oldpeakCtrl = TextEditingController();
  final _slopeCtrl = TextEditingController();
  final _caCtrl = TextEditingController();
  final _thalCtrl = TextEditingController();

  Gender? _selectedGender;

  _clearFields() {
    FocusScope.of(context).unfocus();
    // _ageCtrl.clear();
    // _cpCtrl.clear();
    // _trestbpsCtrl.clear();
    // _cholCtrl.clear();
    // _fbsCtrl.clear();
    // _restecgCtrl.clear();
    // _thalachCtrl.clear();
    // _exangCtrl.clear();
    // _oldpeakCtrl.clear();
    // _slopeCtrl.clear();
    // _caCtrl.clear();
    // _thalCtrl.clear();
  }

  void _getPredicts() {
    _clearFields();

    if (context.read<AppCubit>().isLoading) return;

    int age,
        sex,
        cp,
        trestbps,
        chol,
        fbs,
        restecg,
        thalach,
        exang,
        oldpeak,
        slope,
        ca,
        thal;

    try {
      if (_selectedGender == null) {
        SnackBar snackBar = const SnackBar(
          content: Text("Please select gender"),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      } else if (_selectedGender == Gender.female) {
        sex = 0;
      } else {
        sex = 1;
      }

      age = int.parse(_ageCtrl.text);
      cp = int.parse(_cpCtrl.text);
      trestbps = int.parse(_trestbpsCtrl.text);
      chol = int.parse(_cholCtrl.text);
      fbs = int.parse(_fbsCtrl.text);
      restecg = int.parse(_restecgCtrl.text);
      thalach = int.parse(_thalachCtrl.text);
      exang = int.parse(_exangCtrl.text);
      oldpeak = int.parse(_oldpeakCtrl.text);
      slope = int.parse(_slopeCtrl.text);
      ca = int.parse(_caCtrl.text);
      thal = int.parse(_thalCtrl.text);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      SnackBar snackBar = const SnackBar(
        content: Text("Some error occured!"),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return;
    }

    PredictReqModel reqData = PredictReqModel(
      age: age,
      sex: sex,
      cp: cp,
      trestbps: trestbps,
      chol: chol,
      fbs: fbs,
      restecg: restecg,
      thalach: thalach,
      exang: exang,
      oldpeak: oldpeak,
      slope: slope,
      ca: ca,
      thal: thal,
    );

    context.read<AppCubit>().getPredicts(context, reqData);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is GetDataHeartSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Data predicted successfully"),
              backgroundColor: Colors.green,
            ),
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text(
                  'Probability of you having a heart attack is: ${state.percentage.toString()}%',
                  style: const TextStyle(fontSize: 24),
                ),
                actions: [
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (state is GetDataHeartFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Text(
                      'Input Correct Data',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.purple,
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Gender',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        Radio<Gender>(
                          value: Gender.female,
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        Text(
                          'female',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Radio<Gender>(
                          value: Gender.male,
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                        ),
                        Text(
                          'male',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _renderInputField(_ageCtrl, "Age"),
                  _renderInputField(_cpCtrl,
                      "Chest pain type: typical:0, atypical:1, non-anginal:2,  asymptomatic:3"),
                  _renderInputField(_trestbpsCtrl, "Resting Blood Pressure"),
                  _renderInputField(_cholCtrl, "serum cholestoral in mg/dl"),
                  _renderInputField(_fbsCtrl,
                      "fasting blood sugar > 120 mg/dl? false=0, true=1"),
                  _renderInputField(_restecgCtrl,
                      "resting electrocardiographic results (values 0,1,2)"),
                  _renderInputField(
                      _thalachCtrl, "maximum heart rate achieved"),
                  _renderInputField(_exangCtrl, "exercise induced angina"),
                  _renderInputField(_oldpeakCtrl,
                      "oldpeak = ST depression induced by exercise relative to rest"),
                  _renderInputField(
                      _slopeCtrl, "the slope of the peak exercise ST segment"),
                  _renderInputField(_caCtrl,
                      "number of major vessels (0-3) colored by flourosopy"),
                  _renderInputField(_thalCtrl,
                      "thal: 0 = normal; 1 = fixed defect; 2 = reversable defect"),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: _getPredicts,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.purple,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            context.watch<AppCubit>().isLoading
                                ? 'Loading'
                                : 'Get Predictions',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          context.watch<AppCubit>().isLoading
                              ? Container(
                                  height: 25,
                                  padding: const EdgeInsets.only(left: 10),
                                  child: const LoadingIndicator(
                                      indicatorType: Indicator.ballPulseSync,

                                      /// Required, The loading type of the widget
                                      colors: [Colors.white],

                                      /// Optional, The color collections
                                      strokeWidth: 2,

                                      /// Optional, The stroke of the line, only applicable to widget which contains line
                                      backgroundColor: Colors.transparent,

                                      /// Optional, Background of the widget
                                      pathBackgroundColor: Colors.black

                                      /// Optional, the stroke backgroundColor
                                      ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _renderInputField(TextEditingController ctrl, String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: ctrl,
            decoration: InputDecoration(
              labelText: '',
              hintText: '',
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
