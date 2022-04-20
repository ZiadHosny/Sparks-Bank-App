// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'add_card_details_screen.dart';

class ScreenOnBoarding extends StatelessWidget {
  final SharedPreferences prefs;
  final String boolKey;
  ScreenOnBoarding({required this.prefs, required this.boolKey});

  @override
  Widget build(BuildContext context) {
    prefs.setBool(boolKey, false); // You might want to save this on a callback.

    AssetImage assetImage = const AssetImage("assets/images/bank.png");
    Image image = Image(image: assetImage);

    return Scaffold(
      backgroundColor: mgBgColor,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: image,
              ),
              RichText(
                text: const TextSpan(
                    text: "Money ",
                    style: TextStyle(
                      color: mgOrangeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: "Transfer",
                          style: TextStyle(
                            color: mgMainColor,
                          )),
                    ]),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 20),
                child: Text(
                  "A brand new experiance of managing your business",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: mgMainColor,
                    minimumSize: const Size(170, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddCardDetails()));
                  },
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
