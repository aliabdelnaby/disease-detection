import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cubit/cubit.dart';
import '../../../core/cubit/states.dart';
import '../../custom_widgets/my_form_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController(),
      nameController = TextEditingController(),
      passwordController = TextEditingController(),
      repasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is SignUpDoneState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Done, Check your email to verify your account'),
            ),
          );
          Navigator.of(context).pushReplacementNamed('/intro');
        }
        if (state is SignUpErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.error),
            ),
          );
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: const Color(0xff00B4D8),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Sign Up with Email.',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: deviceSize.height * 0.07),
                      MyFormField(
                        label: 'Name',
                        hint: 'Enter your name',
                        prefixIcon: Icons.person,
                        controller: nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your name';
                          }
                        },
                      ),
                      SizedBox(height: deviceSize.height * 0.02),
                      MyFormField(
                        label: 'Email',
                        hint: 'Enter your email',
                        prefixIcon: Icons.email,
                        controller: emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email';
                          }
                        },
                      ),
                      SizedBox(height: deviceSize.height * 0.02),
                      MyFormField(
                        label: 'Password',
                        hint: 'Enter your password',
                        prefixIcon: Icons.lock,
                        isPassword: isPassword,
                        controller: passwordController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 6) {
                            return "Must be more than 6 characters";
                          }
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: isPassword ? Colors.grey : Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              isPassword = !isPassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: deviceSize.height * 0.02),
                      SizedBox(height: deviceSize.height * 0.02),
                      const SizedBox(height: 10),
                      state is SignUpLoadingState
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  cubit.signUp(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                  );
                                }
                                FocusScope.of(context).unfocus();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                elevation: 5,
                                shadowColor: Colors.black,
                                backgroundColor: const Color(0xff71bbff),
                                textStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minimumSize: Size(
                                  deviceSize.width * 1,
                                  deviceSize.height * 0.075,
                                ),
                              ),
                              child: const Text('Sign Up'),
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
