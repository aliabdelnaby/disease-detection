// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_corner/core/Network/firebase%20service/userf.dart';
import 'package:medical_corner/core/Network/news%20api%20service/dio_helper.dart';
import 'package:medical_corner/core/cubit/states.dart';
import 'package:medical_corner/features/news/data_models/news.dart';
import 'package:medical_corner/features/prediction/heart/models/predicts_req_model.dart';
import 'package:medical_corner/features/prediction/heart/models/predicts_res_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(IntiAppState());

  UserF user = UserF();
  static AppCubit get(context) => BlocProvider.of(context);
  final ImagePicker _picker = ImagePicker();
  late List? outputs;
  File? iimage;
  late bool loading = true;
  News news = News();
  double postop = 0.8;

  //! Load Pneumonia Model
  Future loadPneumoniaModel() async {
    Tflite.close();
    emit(ModelLoadedSTate());
    await Tflite.loadModel(
      model: "assets/tflite_models/model.tflite",
      labels: "assets/tflite_models/labels.txt",
    ).then(
      (value) {
        loading = false;
        emit(ModelLoadedSTate());
        if (kDebugMode) {
          print('pneumonia model loaded');
        }
      },
    );
  }

  //! Load Brain Tumour Model
  Future loadBrainTumourModel() async {
    Tflite.close();
    emit(ModelLoadedSTate());
    await Tflite.loadModel(
      model: "assets/tflite_models/model_brain_tumour.tflite",
      labels: "assets/tflite_models/labels_brain_tumour.txt",
    ).then(
      (value) {
        loading = false;
        emit(ModelLoadedSTate());
        if (kDebugMode) {
          print('brain tumour model loaded');
        }
      },
    );
  }

  //! Load Kidney Model
  Future loadKidneyModel() async {
    Tflite.close();
    emit(ModelLoadedSTate());
    await Tflite.loadModel(
      model: "assets/tflite_models/model_kidney_unquant.tflite",
      labels: "assets/tflite_models/labels_kidney.txt",
    ).then(
      (value) {
        loading = false;
        emit(ModelLoadedSTate());
        if (kDebugMode) {
          print('Kidney model loaded');
        }
      },
    );
  }

  //! Pick Image From Phone
  Future pickImage({
    required double imageMean,
    required double imageStd,
    required int numResults,
    required double threshold,
  }) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    loading = true;
    iimage = File(image.path);
    emit(PickedImageState());
    classifyImage(
      image: File(image.path),
      imageMean: imageMean,
      imageStd: imageStd,
      numResults: numResults,
      threshold: threshold,
    );
    emit(ClassifyImageState());
  }

  //! Classify Input Image
  void classifyImage({
    required File image,
    required double imageMean,
    required double imageStd,
    required int numResults,
    required double threshold,
  }) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: numResults,
      threshold: threshold,
      imageMean: imageMean,
      imageStd: imageStd,
      asynch: true,
    );
    loading = false;
    outputs = output!;
    if (kDebugMode) {
      print(outputs);
    }
    if (kDebugMode) {
      print(imageStd);
    }
    emit(FinalResultState());
  }

  //! Make iimage and output = null function
  void clearImage() {
    iimage = null;
    outputs = null;
    emit(ClearState());
  }

  //! Save image to gallery function and permission function
  Future<void> saveImage(Uint8List bytes) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(bytes.buffer.asUint8List()));
      if (kDebugMode) {
        print(result);
      }
    } else {
      if (kDebugMode) {
        print('permission denied');
      }
    }
  }

  //! Get News Method
  void getNews() async {
    emit(NewsLoadState());
    await DioHelper.getData(
      url: 'top-headlines',
      query: {
        'country': 'gb',
        'category': 'health',
        'apiKey': 'c806ed6527df4f2aadc50d564e6923d4',
      },
    ).then((value) {
      news = News.fromJson(value.data);
      if (kDebugMode) {
        print(news.articles![0].title);
      }
      emit(NewsDoneState());
    }).catchError((error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(NewsErrorState(error.toString()));
    });
  }

  //! Sign Up Method
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      emit(SignUpLoadingState());
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': name,
          'uid': user.uid,
          'email': user.email,
          'image_url_pneumonia': null,
          'image_url_brain_tumor': null,
          'profile_image_url': null,
          'password': password,
        });
      }
      getUserData(user!.uid);
      await verifyEmail();
      emit(SignUpDoneState());
      return user;
    } on FirebaseAuthException catch (e) {
      _signUpHandleException(e);
    } catch (e) {
      emit(SignUpErrorState(error: e.toString()));
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return null;
  }

  //! Sign Up Handle Exception
  void _signUpHandleException(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      emit(SignUpErrorState(error: 'The password provided is too weak.'));
    } else if (e.code == 'email-already-in-use') {
      emit(SignUpErrorState(
          error: 'The account already exists for that email.'));
    } else if (e.code == 'invalid-email') {
      emit(SignUpErrorState(error: 'The email is invalid.'));
    } else {
      emit(SignUpErrorState(error: e.code));
    }
  }

  //! Get data
  void getUserData(String uid) async {
    try {
      emit(GetUserDataLoadingState());
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();

      if (snapshot.exists) {
        user = UserF.fromDocument(snapshot);
        emit(GetUserDataDoneState());
      } else {
        emit(GetUserDataErrorState(error: "User data not found"));
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(GetUserDataErrorState(error: error.toString()));
    }
  }

  //! Sign In Method
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      emit(SignInLoadingState());
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      getUserData(userCredential.user!.uid);
      emit(SignInDoneState());
    } on FirebaseAuthException catch (e) {
      _signInHandleException(e);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(SignInErrorState(error: e.toString()));
    }
  }

  //! Sign In Handle Exception
  void _signInHandleException(FirebaseAuthException e) {
    if (e.code == 'user-not-found') {
      emit(SignInErrorState(error: "No user found for that email."));
    } else if (e.code == 'wrong-password') {
      emit(SignInErrorState(error: "Wrong password provided for that user."));
    } else {
      emit(SignInErrorState(error: 'Check your Email and password!'));
    }
  }

  //! Verify Email Method
  Future<void> verifyEmail() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  //! Reset Password Link Method
  Future<void> resetPasswordLink({required String email}) async {
    try {
      emit(ResetPasswordLoadingState());
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      emit(ResetPasswordDoneState());
    } catch (e) {
      emit(
        ResetPasswordErrorState(
          error: e.toString(),
        ),
      );
    }
  }

  //! Sign Out Method
  void signOut() async {
    try {
      emit(SignOutLoadingState());
      await FirebaseAuth.instance.signOut();
      emit(SignOutDoneState());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      emit(SignOutErrorState(error.toString()));
    }
  }

  //! Slide Up and Down
  double? topup(String pos) {
    if (pos == 'up') {
      postop = 0;
    } else if (pos == 'down') {
      postop = 0.8;
    } else if (pos == 'upmore') {
      postop = 0;
    } else {
      return null;
    }
    return null;
  }

  //! http post heart attack predictions

  static const String baseUrl = 'http://10.0.2.2:5000';
  Future<http.Response?> postRequest(
    String path, {
    Map<String, dynamic>? bodyJson,
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl/$path');
    try {
      emit(GetDataHeartLoadingState());
      final body = json.encode(bodyJson);
      final response = await http.post(
        url,
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("======== Done :${response.body}");
        }
      }
      final responseData = json.decode(response.body);
      if (responseData['isError'] == false) {
        final data = responseData['data'];
        final percentage = _roundProbabilityToTwoDecimals(data);
        emit(GetDataHeartSuccessState(percentage: percentage));
      }
      return response;
    } catch (e) {
      emit(GetDataHeartFailureState(error: e.toString()));
      // throw HttpException('Failed to fetch data: $e');
    }
    return null;
  }

  String _roundProbabilityToTwoDecimals(dynamic data) {
    String text = '';
    try {
      double number = double.parse(data.toString());
      int num = number.toInt();
      text = num.toString();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return text;
  }

  //! get predictions
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  //* get predictions
  //INPUT: buildcontext and reqModel(which contains post request body data)
  //DO: do the api call get response, error handle if error occurs, if everythings good navigate to
  //preidctions screen(with response data)
  //RETURN: none|void
  void getPredicts(BuildContext cxt, PredictReqModel reqData) async {
    //make isLoading true to show the loading indicator in ui
    _isLoading = true;
    // notifyListeners();
    try {
      final res = await postRequest("/heart-attack/predictions",
          bodyJson: reqData.toJson());

      if (res == null) {
        _isLoading = false;
        // notifyListeners();
        return;
      }

      PredicResModel searchResultsRes =
          PredicResModel.fromJson(jsonDecode(res.body));

      if (searchResultsRes.isError) {
        if (cxt.mounted) {
          SnackBar snackBar = SnackBar(
            content: Text(searchResultsRes.msg),
            duration: const Duration(seconds: 2),
          );
          ScaffoldMessenger.of(cxt).showSnackBar(snackBar);
        }
        _isLoading = false;
        // notifyListeners();
        return;
      }

      _isLoading = false;
      // notifyListeners();

      // PredicResModel? data = searchResultsRes.data;
      // if (cxt.mounted) {
      //   Navigator.push(cxt,
      //       MaterialPageRoute(builder: (context) => PredictionsScreen(data)));
      // }
    } catch (e) {
      _isLoading = false;
      // notifyListeners();
      if (kDebugMode) {
        print("error: $e -------------------");
      }
      SnackBar snackBar = const SnackBar(
        content: Text("Some error occured fetching results"),
        duration: Duration(seconds: 2),
      );
      ScaffoldMessenger.of(cxt).showSnackBar(snackBar);
      return;
    }
  }
}
