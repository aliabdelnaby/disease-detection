// ignore_for_file: avoid_print
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_corner/core/Network/firebase%20service/auth.dart';
import 'package:medical_corner/core/Network/news%20api%20service/dio_helper.dart';
import 'package:medical_corner/core/cubit/states.dart';
import 'package:medical_corner/features/news/data_models/news.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite/tflite.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(IntiAppState());

  AuthBase authBase = AuthBase();
  UserF user = UserF();
  static AppCubit get(context) => BlocProvider.of(context);
  final ImagePicker _picker = ImagePicker();
  late List? outputs;
  File? iimage;
  late bool loading = true;
  News news = News();
  double postop = 0.8;

  //! Load Model
  Future loadModel() async {
    Tflite.close();
    emit(ModelLoadedSTate());
    await Tflite.loadModel(
      model: "assets/tflite_models/model.tflite",
      labels: "assets/tflite_models/labels.txt",
    ).then((value) {
      loading = false;
      emit(ModelLoadedSTate());
      print('pneumonia model loaded');
    });
  }

  //! Load Brain Tumour Model
  Future loadBrainTumourModel() async {
    Tflite.close();
    emit(ModelLoadedSTate());
    await Tflite.loadModel(
      model: "assets/tflite_models/model_brain_tumour.tflite",
      labels: "assets/tflite_models/labels_brain_tumour.txt",
    ).then((value) {
      loading = false;
      emit(ModelLoadedSTate());
      print('brain tumour model loaded');
    });
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
    print(outputs);
    print(imageStd);
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
      print(result);
    } else {
      print('permission denied');
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
      print(news.articles![0].title);
      emit(NewsDoneState());
    }).catchError((error) {
      print(error.toString());
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
      emit(SignUpDoneState());
      return user;
    } on FirebaseAuthException catch (e) {
      _signUpHandleException(e);
    } catch (e) {
      emit(SignUpErrorState(error: e.toString()));
      print(e.toString());
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
      print(error.toString());
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
      if (e.code == 'user-not-found') {
        emit(SignInErrorState(error: "No user found for that email."));
      } else if (e.code == 'wrong-password') {
        emit(SignInErrorState(error: "Wrong password provided for that user."));
      } else {
        emit(SignInErrorState(error: 'Check your Email and password!'));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      emit(SignInErrorState(error: e.toString()));
    }
  }

  //! Sign Out Method
  void signOut() async {
    emit(SignOutLoadingState());
    await authBase.logout().then((value) {
      emit(SignOutDoneState());
    }).catchError((error) {
      print(error.toString());
      emit(SignOutErrorState(error.toString()));
    });
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
}
