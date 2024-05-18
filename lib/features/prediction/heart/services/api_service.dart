// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;

// class ApiService {
//   //! basepath of the endoint url
//   static const String baseUrl = 'http://10.0.2.2:5000';

//   //* get request
//   //INPUT: path, accesstoken
//   //DO: do a GET api call
//   //RETURN: http.Response object
//   static Future<http.Response?> getRequest(String path, {String? token}) async {
//     final url = Uri.parse('$baseUrl/$path');
//     try {
//       //create header map
//       // Map<String, String> headers = {};
//       // headers = {
//       //   'Content-Type': 'application/json',
//       //   // 'Accept': 'application/json',
//       // };

//       //
//       final response = await http.get(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       );
//       return response;
//     } catch (e) {
//       throw HttpException('Failed to fetch data: $e');
//     }
//   }

//   //* post request
//   //INPUT: path,body as a map object, accesstoken
//   //DO: do a POST api call
//   //RETURN: http.Response object

//   //! static Future<http.Response?> postRequest(String path,
//   //     {Map<String, dynamic>? bodyJson, String? token}) async {
//   //   final url = Uri.parse('$baseUrl/$path');

//   //   try {
//   //     Map<String, String> headers = {};

//   //     headers = {
//   //       'Content-Type': 'application/json',
//   //       'Accept': 'application/json',
//   //     };

//   //     final body = json.encode(bodyJson);

//   //     final response = await http.post(url, body: body, headers: headers);
//   //     return response;
//   //   } catch (e) {
//   //     throw HttpException('Failed to fetch data: $e');
//   //   }
//   // }

//   // static Future<http.Response?> postRequest(String path,
//   //     {Map<String, dynamic>? bodyJson, String? token}) async {
//   //   final url = Uri.parse('$baseUrl/$path');

//   //   try {
//   //     // Map<String, String> headers = {};

//   //     // headers = {
//   //     //   'Content-Type': 'application/json',
//   //     //   'Accept': 'application/json',
//   //     // };

//   //     final body = json.encode(bodyJson);

//   //     final response = await http.post(
//   //       url,
//   //       body: body,
//   //       headers: {
//   //         'Content-Type': 'application/json',
//   //         'Accept': 'application/json',
//   //       },
//   //     );
//   //     if (response.statusCode == 200) {
//   //       if (kDebugMode) {
//   //         print("======== Done :${response.body}");
//   //       }
//   //     }
//   //     return response;
//   //   } catch (e) {
//   //     throw HttpException('Failed to fetch data: $e');
//   //   }
//   // }
// }
