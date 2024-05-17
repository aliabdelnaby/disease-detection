import 'package:flutter/material.dart';
import 'package:medical_corner/features/classification/kidney/last_rsult_kidney.dart';
import '../../../core/cubit/cubit.dart';
import '../../custom_widgets/open_close_Text_box.dart';
import '../detection_lab.dart';

class KidneyScreen extends StatelessWidget {
  const KidneyScreen({super.key});

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
          'Kidney detection',
          style: TextStyle(
            fontSize: 28,
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
              mainAxisAlignment: MainAxisAlignment.start,
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
                  "Kidney disease, also known as renal disease, encompasses a range of conditions affecting the kidneys' ability to function properly. The kidneys are crucial organs responsible for filtering waste products and excess fluids from the blood, which are then excreted as urine. They also play a vital role in regulating blood pressure, electrolyte balance, and red blood cell production. Kidney disease can be acute or chronic, with chronic kidney disease (CKD) being more prevalent and a significant global health concern.",
                  style: TextStyle(
                    fontSize: 19,
                    fontFamily: 'seguisb',
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    OpenCloseTextBox(
                      text:
                          "Fatigue and weakness, swelling (edema) in legs, ankles, feet, face, and hands, changes in urination (increased frequency, nocturia, foamy or bubbly urine, blood in urine, reduced or decreased output), shortness of breath due to fluid in lungs, nausea and vomiting, high blood pressure, muscle cramps and twitching from electrolyte imbalances, severe itching (pruritus), metallic taste in mouth, and ammonia-like breath odor.",
                      title: 'Symptoms',
                      clr: Colors.blue,
                      txtclr: Colors.white,
                    ),
                    OpenCloseTextBox(
                      text:
                          '1. Diabetes: High blood sugar levels can damage kidney filters.\n'
                          '2. Hypertension: High blood pressure can damage blood vessels in the kidneys.\n'
                          '3. Glomerulonephritis: Inflammation of kidney\'s filtering units.\n'
                          '4. Polycystic Kidney Disease (PKD): Genetic disorder causing cysts in kidneys.\n'
                          '5. Infections: Recurrent urinary tract infections can lead to kidney damage.\n'
                          '6. Obstructions: Kidney stones or enlarged prostate blocking urine flow.\n'
                          '7. Autoimmune Diseases: Conditions like lupus affecting kidneys.\n'
                          '8. Toxins: Long-term exposure to heavy metals or certain medications.\n'
                          '9. Recurrent Kidney Infections (Pyelonephritis): Repeated infections damaging the kidneys.',
                      title: 'Causes',
                      clr: Colors.transparent,
                      txtclr: Colors.grey,
                    ),
                    OpenCloseTextBox(
                      text: 'Risk Factors for Kidney Disease\n\n'
                          '- Diabetes: High blood sugar levels can damage the kidneys over time.\n'
                          '- Hypertension (High Blood Pressure): Prolonged high blood pressure can strain the kidneys.\n'
                          '- Family History: Genetics can predispose individuals to certain kidney conditions.\n'
                          '- Age: Risk increases with age, particularly after 65 years old.\n'
                          '- Obesity: Excess weight can increase the risk of developing diabetes and hypertension.\n'
                          '- Smoking: Smoking can worsen kidney function and increase the risk of kidney disease.\n'
                          '- Heart Disease: Conditions like heart failure and coronary artery disease can impair kidney function.\n'
                          '- Race and Ethnicity: African Americans, Hispanics, and Native Americans are at higher risk.\n'
                          '- Kidney Stones: A history of kidney stones increases the risk of chronic kidney disease.\n'
                          '- Autoimmune Diseases: Conditions such as lupus and rheumatoid arthritis can affect kidney function.\n'
                          '- Urinary Tract Infections (UTIs): Frequent or severe UTIs can lead to kidney damage.\n'
                          '- Chronic Urinary Tract Obstruction: Conditions such as enlarged prostate or kidney stones can increase risk.\n'
                          '- Exposure to Certain Toxins: Long-term exposure to heavy metals, certain medications, and chemicals can harm the kidneys.\n'
                          '- Certain Medications: Some medications, when used long-term or in high doses, can damage the kidneys.\n'
                          '- Low Birth Weight: Babies born with low birth weight may have underdeveloped kidneys and are at higher risk later in life.',
                      title: 'Risk factors',
                      clr: Colors.red,
                      txtclr: Colors.white,
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Divider(
                    endIndent: 15,
                    thickness: 2,
                    color: Color(0xff03045E),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Medical Corner provides Kidney',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const Text(
                      'detection with accuracy up to 91%.',
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
                                    builder: (context) => Result(
                                      lottieAnimationName: 'pneumonia',
                                      numResults: 4,
                                      threshold: 0.2,
                                      imageMean: 244.0,
                                      imageStd: 244.0,
                                    ),
                                  ),
                                );
                                AppCubit.get(context).loadKidneyModel();
                                AppCubit.get(context).clearImage();
                              },
                              child: Container(
                                height: 125,
                                width: 125,
                                color: Colors.blue,
                                child: const Icon(
                                  Icons.image_search_outlined,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            ),
                            const Text(
                              'Kidney',
                              style: TextStyle(
                                  color: Color(0xff004EC4), fontSize: 20),
                            ),
                            const Text(
                              'Detection',
                              style: TextStyle(
                                  color: Color(0xff004EC4), fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            Container(
                              height: 125,
                              width: 125,
                              color: Colors.blue,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const lastresultKidney(),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.list,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            ),
                            const Text(
                              'Last results',
                              style: TextStyle(
                                  color: Color(0xff004EC4), fontSize: 20),
                            ),
                            const Text(
                              '      ',
                              style: TextStyle(
                                  color: Color(0xff004EC4), fontSize: 20),
                            ),
                          ],
                        ),
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
                  "Control blood sugar, monitor blood pressure, maintain a healthy diet, stay hydrated, exercise regularly, quit smoking, limit alcohol, avoid overuse of painkillers, manage chronic conditions, schedule regular check-ups, maintain a healthy weight, protect against infections, avoid exposure to toxins, consider genetic testing, seek prompt treatment.",
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
