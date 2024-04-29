// ignore_for_file: camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medical_corner/core/cubit/cubit.dart';

class lastresultbrain extends StatefulWidget {
  const lastresultbrain({super.key});

  @override
  _lastresult createState() => _lastresult();
}

class _lastresult extends State<lastresultbrain> {
  ScrollController? _scrollController;
  var top = 0.0;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController?.addListener(() {
      setState(() {});
    });
    // getData();
  }

  // void getData() async {
  //   User? user = _auth.currentUser;
  //   _uid = user?.uid;
  //   // to get Data from fire base
  //   final DocumentSnapshot userDoc =
  //       await FirebaseFirestore.instance.collection('users').doc(_uid).get();
  //   setState(() {
  //     // _userImageUrl = BlocProvider.of<AppCubit>(context).iimage.toString();
  //     _userImageUrl = userDoc.get('imageurl2');
  //   });
  //   // print("name $_name");
  // }

  @override
  Widget build(BuildContext context) {
    const double height = 812.9;
    final cubit = BlocProvider.of<AppCubit>(context);
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
        title: const Text(
          'My last Result',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            fontFamily: 'seguisb',
            color: Color(0xff03045E),
          ),
        ),
      ),
      body: cubit.iimage == null
          ? const Center(
              child: Text(
                "There is not result yet",
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 30),
                Image.file(
                  cubit.iimage!,
                  fit: BoxFit.contain,
                  height: height * 0.48,
                  width: 350,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    width: double.infinity,
                    height: height * 0.1,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.blue,
                          Colors.blueGrey,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          "Result: ${cubit.outputs![0]["label"]}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "Rate: ${cubit.outputs![0]["confidence"] * 100} %",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: height * 0.02,
                ),
              ],
            ),
    );

    //  Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //     automaticallyImplyLeading: false,
    //     backgroundColor: Colors.transparent,
    //     leading: IconButton(
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //       icon: const Icon(
    //         Icons.arrow_back_ios_rounded,
    //         size: 30,
    //         color: Colors.black,
    //       ),
    //     ),
    //     title: const Text(
    //       'My last Result',
    //       style: TextStyle(
    //         fontSize: 28,
    //         fontWeight: FontWeight.w700,
    //         fontFamily: 'seguisb',
    //         color: Color(0xff03045E),
    //       ),
    //     ),
    //   ),
    //   body: Container(
    //     alignment: Alignment.center,
    //     child: Image.network(_userImageUrl ??
    //         'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'),
    //   ),
    // );
  }
}
