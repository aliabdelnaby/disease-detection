// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static AppCubit get(context) => BlocProvider.of(context);

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

  final ImagePicker _picker = ImagePicker();

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

  late List? outputs;
  File? iimage;
  late bool loading = true;

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

  //make iimage and output = null function
  void clearImage() {
    iimage = null;
    outputs = null;
    emit(ClearState());
  }

  //save image to gallery function and permission function
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

  News news = News();

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

  //
  AuthBase authBase = AuthBase();
  UserF user = UserF();

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
      emit(SignUpDoneState());
      return user!;
    } on FirebaseAuthException catch (e) {
      _signupUpHandleException(e);
    } catch (e) {
      emit(SignUpErrorState(error: e.toString()));
      print(e.toString());
    }
    return null;
  }

  void _signupUpHandleException(FirebaseAuthException e) {
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

  //get data from firebase
  void getUserData(String uid) async {
    emit(GetUserDataLoadingState());
    await authBase
        .getUserData(
      uid,
    )
        .then((value) {
      user = UserF.fromDocument(value!);
      emit(GetUserDataDoneState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUserDataErrorState(error.toString()));
    });
  }

  void signIn({
    required String email,
    required String password,
  }) async {
    emit(SignInLoadingState());
    await authBase
        .login(
      email,
      password,
    )
        .then((value) {
      if (value != null) {
        getUserData(value.uid);
      }
      emit(SignInDoneState());
    }).catchError((error) {
      print(error.toString());
      emit(SignInErrorState(error.toString()));
    });
  }

  void signOut() async {
    emit(SignOutLoadingState());
    await authBase.logout().then((value) {
      emit(SignOutDoneState());
    }).catchError((error) {
      print(error.toString());
      emit(SignOutErrorState(error.toString()));
    });
  }

  double postop = 0.8;

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
