import 'package:flutter/material.dart';
import 'package:medical_corner/features/prediction/heart/views/get_predict_screen.dart';

import '../../../custom_widgets/open_close_Text_box.dart';

class HeartDisease extends StatelessWidget {
  const HeartDisease({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Heart Attack Prediction',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            fontFamily: 'seguisb',
            color: Color(0xff03045E),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Overview',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'seguisb',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                const Text(
                  "A heart attack, or myocardial infarction (MI), occurs when blood flow to a part of the heart is blocked, leading to heart muscle damage. It's a critical medical emergency, with symptoms like chest pain, nausea, and shortness of breath. Risk factors include high cholesterol, hypertension, and smoking. Diagnosis involves tests like ECG and blood tests. Treatment aims to restore blood flow quickly through medication or procedures like angioplasty. Recovery often involves cardiac rehabilitation for lifestyle changes and emotional support. Prevention includes managing risk factors through diet, exercise, and regular check-ups.",
                  style: TextStyle(
                    fontSize: 19,
                    fontFamily: 'seguisb',
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 8,
                  ),
                  child: Column(
                    children: [
                      OpenCloseTextBox(
                        title: 'Symptoms',
                        text:
                            "The symptoms of a heart attack can vary but commonly include chest pain or discomfort, which may feel like pressure, tightness, squeezing, or heaviness. Other symptoms may include pain or discomfort in the arms, back, neck, jaw, or stomach, shortness of breath, nausea, lightheadedness, and cold sweats. However, it's important to note that some people, especially women, may experience atypical symptoms or even no symptoms at all.",
                        clr: Colors.blue,
                        txtclr: Colors.white,
                      ),
                      OpenCloseTextBox(
                          text:
                              "Heart attacks often result from a condition called coronary artery disease (CAD). CAD is caused by the buildup of fatty deposits, cholesterol, and other substances in the arteries that supply blood to the heart (coronary arteries). This buildup, known as plaque, can rupture and form a blood clot that blocks blood flow to the heart muscle.",
                          title: 'Causes',
                          clr: Colors.transparent,
                          txtclr: Colors.grey),
                      OpenCloseTextBox(
                        text:
                            "Several factors can increase the risk of heart attack, including smoking, high blood pressure, high cholesterol, diabetes, obesity, physical inactivity, unhealthy diet, family history of heart disease, and stress. Age and gender also play a role, with men over 45 and women over 55 being at higher risk.",
                        title: 'Risk Factors',
                        clr: Colors.red,
                        txtclr: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  endIndent: 15,
                  thickness: 2,
                  color: Color(0xff03045E),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Medical Corner provides Heart attack ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      'prediction with accuracy up to 91%.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const GetPredictScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 125,
                                width: 125,
                                color: Colors.blue,
                                child: const Icon(
                                  Icons.add_chart,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            ),
                            const Text(
                              'Heart Attack',
                              style: TextStyle(
                                  color: Color(0xff004EC4), fontSize: 20),
                            ),
                            const Text(
                              'prediction',
                              style: TextStyle(
                                  color: Color(0xff004EC4), fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        // Column(
                        //   children: [
                        //     Container(
                        //       height: 125,
                        //       width: 125,
                        //       color: Colors.blue,
                        //       child: IconButton(
                        //         onPressed: () {},
                        //         icon: const Icon(
                        //           Icons.list,
                        //           color: Colors.white,
                        //           size: 80,
                        //         ),
                        //       ),
                        //     ),
                        //     const Text(
                        //       'Last  Result',
                        //       style: TextStyle(
                        //           color: Color(0xff004EC4), fontSize: 20),
                        //     ),
                        //     const Text(
                        //       '      ',
                        //       style: TextStyle(
                        //           color: Color(0xff004EC4), fontSize: 20),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ],
                ),
                const Divider(
                  endIndent: 15,
                  thickness: 2,
                  color: Color(0xff03045E),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Preventation',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: 'seguisb',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 9,
                ),
                const Text(
                  "Preventing heart attacks involves managing and controlling risk factors through lifestyle modifications such as quitting smoking, adopting a healthy diet, maintaining a healthy weight, being physically active, managing stress, and controlling conditions like high blood pressure, high cholesterol, and diabetes. Regular medical check-ups and screenings are also important for early detection and management of risk factors.",
                  style: TextStyle(
                    fontSize: 19,
                    fontFamily: 'seguisb',
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
