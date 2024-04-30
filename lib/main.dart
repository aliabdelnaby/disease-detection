import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_corner/core/cubit/cubit.dart';
import 'package:medical_corner/core/cubit/observer.dart';
import 'package:medical_corner/core/cubit/states.dart';
import 'package:medical_corner/core/function/check_state_changes.dart';
import 'package:medical_corner/core/router/app_router.dart';
import 'core/Network/news api service/dio_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  checkStateChanges();
  DioHelper.init();

  runApp(
    MyApp(
      app: AppCubit()..getNews(),
    ),
  );
  Bloc.observer = MyBlocObserver();
}

class MyApp extends StatelessWidget {
  final AppCubit app;

  const MyApp({super.key, required this.app});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (context) => app,
      child: BlocConsumer<AppCubit, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: AppRouter().onGenerateRoute,
          );
        },
      ),
    );
  }
}
