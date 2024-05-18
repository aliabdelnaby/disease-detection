import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_corner/core/cubit/cubit.dart';
import 'package:medical_corner/core/cubit/states.dart';

import '../../custom_widgets/my_form_field.dart';

class Forgotten extends StatefulWidget {
  const Forgotten({super.key});

  @override
  State<Forgotten> createState() => _ForgottenState();
}

class _ForgottenState extends State<Forgotten> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is ResetPasswordDoneState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text("A password reset link has been sent"),
            ),
          );
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/intro', (route) => false);
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
        return Scaffold(
          backgroundColor: const Color(0xff17c1ff),
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
                      SizedBox(height: deviceSize.height * 0.07),
                      MyFormField(
                        controller: emailController,
                        hint: 'Email',
                        prefixIcon: Icons.email,
                        isPassword: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email';
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      state is ResetPasswordLoadingState
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                backgroundColor: Colors.white,
                                minimumSize: Size(deviceSize.width * 1, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.resetPasswordLink(
                                    email: emailController.text,
                                  );
                                }
                                FocusScope.of(context).unfocus();
                              },
                              child: const Text('Send Reset Password Link'),
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
