// ignore_for_file: must_be_immutable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_corner/core/cubit/cubit.dart';
import 'package:medical_corner/core/cubit/states.dart';
import 'package:medical_corner/features/custom_widgets/my_form_field.dart';
import 'package:medical_corner/features/auth/auth_sheet/forgotten.dart';
import 'package:medical_corner/features/introduction/paints/auth_sheet_paint/auth_sheet_paint.dart';

class AuthSheet extends StatefulWidget {
  final Function() expandCallback;
  bool isExpanded;
  AuthSheet({super.key, required this.expandCallback, this.isExpanded = true});

  @override
  State<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends State<AuthSheet> {
  final TextEditingController emailController = TextEditingController(),
      nameController = TextEditingController(),
      passwordController = TextEditingController();
  late bool expandAuthSheet;

  @override
  void initState() {
    super.initState();
    expandAuthSheet = false;
  }

  final _formKey = GlobalKey<FormState>();
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is SignInErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(state.error),
            ),
          );
        } else if (state is SignInDoneState) {
          if (FirebaseAuth.instance.currentUser!.emailVerified) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/Home', (route) => false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Welcome Back!'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Please verify your account'),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return SizedBox(
          width: deviceSize.width,
          height: deviceSize.height,
          child: CustomPaint(
            painter: AuthSheetPaint(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                margin: EdgeInsets.only(top: deviceSize.height * 0.075),
                width: deviceSize.width * 0.8,
                height: deviceSize.height * 0.65,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          widget.expandCallback.call();
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 10),
                          child: Text('Sign in',
                              style: TextStyle(
                                color: Color(0xff03045E),
                                fontWeight: FontWeight.w500,
                                fontSize: 24,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            MyFormField(
                              onTap: () {
                                cubit.topup('upmore');
                              },
                              controller: emailController,
                              hint: 'Email',
                              prefixIcon: Icons.email,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your email';
                                }
                              },
                              label: 'Email',
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MyFormField(
                              controller: passwordController,
                              isPassword: isPassword,
                              label: 'Password',
                              prefixIcon: Icons.lock,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              onSubmit: (value) {
                                if (_formKey.currentState!.validate()) {
                                  cubit.signIn(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                                FocusScope.of(context).unfocus();
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
                              hint: 'Password',
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const SizedBox(height: 12),
                            state is SignInLoadingState
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        cubit.signIn(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                      }
                                      FocusScope.of(context).unfocus();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: const Color(0xff03045E),
                                      elevation: 5,
                                      shadowColor: Colors.black,
                                      backgroundColor: Colors.white,
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
                                    child: const Text('Sign in'),
                                  ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 24,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      hoverColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      onTap: () {
                                        FocusScope.of(context).unfocus();

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Forgotten(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Forgotten Password?',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 16,
                              ),
                              alignment: Alignment.center,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.grey),
                                  children: [
                                    const TextSpan(
                                        text: 'Don\'t have an account? ',
                                        style: TextStyle(color: Colors.white)),
                                    TextSpan(
                                      text: ' Register Now',
                                      style: const TextStyle(
                                          color: Color(0xff03045E),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          FocusScope.of(context).unfocus();
                                          Navigator.pushNamed(
                                            context,
                                            '/signup',
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
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
