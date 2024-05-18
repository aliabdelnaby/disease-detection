import 'dart:convert';

PredictReqModel predicReqFromJson(String str) =>
    PredictReqModel.fromJson(json.decode(str));

String predicReqToJson(PredictReqModel data) => json.encode(data.toJson());

class PredictReqModel {
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

  PredictReqModel({
    required this.age,
    required this.sex,
    required this.cp,
    required this.trestbps,
    required this.chol,
    required this.fbs,
    required this.restecg,
    required this.thalach,
    required this.exang,
    required this.oldpeak,
    required this.slope,
    required this.ca,
    required this.thal,
  });

  factory PredictReqModel.fromJson(Map<String, dynamic> json) =>
      PredictReqModel(
          age: json['age'],
          sex: json['sex'],
          cp: json['cp'],
          trestbps: json['trestbps'],
          chol: json['chol'],
          fbs: json['fbs'],
          restecg: json['restecg'],
          thalach: json['thalach'],
          exang: json['exang'],
          oldpeak: json['oldpeak'],
          slope: json['slope'],
          ca: json['ca'],
          thal: json['thal']);

  Map<String, dynamic> toJson() => {
        "age": age,
        "sex": sex,
        "cp": cp,
        "trestbps": trestbps,
        "chol": chol,
        "fbs": fbs,
        "restecg": restecg,
        "thalach": thalach,
        "exang": exang,
        "oldpeak": oldpeak,
        "slope": slope,
        "ca": ca,
        "thal": thal,
      };
}
