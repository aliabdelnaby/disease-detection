import 'package:flutter/material.dart';

class Aboutus extends StatelessWidget {
  const Aboutus({super.key});

  @override
  Widget build(BuildContext context) {
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
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              'We are final-year students studying ',
              style: TextStyle(
                fontSize: 19,
                fontFamily: 'seguisb',
                color: Colors.grey,
              ),
            ),
          ),
          Center(
            child: Text(
              'Computer Science at Thebes Academy.',
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'seguisb',
                color: Colors.grey,
              ),
            ),
          ),
          Center(
            child: Text(
              'We developed this app with the aim of helping',
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'seguisb',
                color: Colors.grey,
              ),
            ),
          ),
          Center(
            child: Text(
              'to provide early disease detection.',
              style: TextStyle(
                fontSize: 19,
                fontFamily: 'seguisb',
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
