import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/cubit/cubit.dart';
import '../../core/cubit/states.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 30,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            title: const Text(
              'My profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontFamily: 'seguisb',
                color: Color(0xff03045E),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 35),
                  Center(
                    child: Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/03/04/22/35/head-659652_960_720.png',
                          ),
                          radius: 90,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Name: ${cubit.user.name}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'seguisb',
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Email: ${cubit.user.email}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'seguisb',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
