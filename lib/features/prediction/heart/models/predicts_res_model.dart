import 'dart:convert';

class PredicResModel {
  String? data;
  String? error;
  bool isError;
  String msg;

  PredicResModel({
    required this.data,
    required this.error,
    required this.isError,
    required this.msg,
  });

  factory PredicResModel.fromRawJson(String str) =>
      PredicResModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PredicResModel.fromJson(Map<String, dynamic> json) => PredicResModel(
        data: json['data'] as String?,
        error: json["error"] as String?,
        isError: json["isError"] as bool,
        msg: json["msg"] as String,
      );

  Map<String, dynamic> toJson() => {
        "data": data,
        "error": error,
        "isError": isError,
        "msg": msg,
      };
}
