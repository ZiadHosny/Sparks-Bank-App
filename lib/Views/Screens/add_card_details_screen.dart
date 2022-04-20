// ignore_for_file: use_key_in_widget_constructors, avoid_print

import 'package:bank_sparks_app/Helper/database_helper.dart';
import 'package:bank_sparks_app/Views/Screens/home_screen.dart';
import 'package:bank_sparks_app/Views/Widgets/custom_dialog.dart';
import 'package:bank_sparks_app/Views/Widgets/custom_text_field.dart';
import 'package:bank_sparks_app/models/user_data.dart';

import 'package:flutter/material.dart';

import '../../constants.dart';

class AddCardDetails extends StatefulWidget {
  @override
  _AddCardDetailsState createState() => _AddCardDetailsState();
}

class _AddCardDetailsState extends State<AddCardDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? cardHolderName;
  String? cardNumber;
  String? cardExpiry;
  double? currentBalance;

  final DatabaseHelper _dbhelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mgBgColor,
      appBar: AppBar(
        backgroundColor: mgMainColor,
        title: const Text("Add Account"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Card(
                  color: mgOrangeColor,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomTextField(
                            hintName: "Enter card holder name",
                            keyboardTypeNumber: false,
                            onSaved: (value) {
                              cardHolderName = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter Name";
                              } else {
                                if (value.length < 3) {
                                  return "Must be more than 2 character";
                                } else {
                                  return null;
                                }
                              }
                            },
                          ),
                          CustomTextField(
                            hintName: "Enter card number",
                            keyboardTypeNumber: false,
                            onSaved: (value) {
                              cardNumber = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter Card Number";
                              } else {
                                if (value.length < 6) {
                                  return "Must be more than 6 number";
                                } else {
                                  return null;
                                }
                              }
                            },
                          ),
                          CustomTextField(
                            hintName: "Enter card expiry date",
                            keyboardTypeNumber: false,
                            onSaved: (value) {
                              cardExpiry = value;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter Card Expiry Date";
                              } else {
                                if (value.length < 3) {
                                  return "Must be more than 2 character";
                                } else {
                                  return null;
                                }
                              }
                            },
                          ),
                          CustomTextField(
                            hintName: "Enter current amount",
                            keyboardTypeNumber: true,
                            onSaved: (value) {
                              currentBalance = double.parse(value);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter Current Amount";
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                _formKey.currentState!.save();
                                if (_formKey.currentState!.validate()) {
                                  UserData _userData = UserData(
                                    userName: cardHolderName,
                                    cardNumber: cardNumber,
                                    cardExpiry: cardExpiry,
                                    totalAmount: currentBalance,
                                  );

                                  await _dbhelper.insertUserDetails(_userData);

                                  CustomDialog(
                                    onPressed: () {
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreen()))
                                          .then((value) => {});
                                    },
                                    title: "Success",
                                    isSuccess: true,
                                    description:
                                        "Thanking for adding your details",
                                    buttonText: "Ok",
                                    addIcon: const Icon(
                                      Icons.check,
                                      color: mgMainColor,
                                      size: 50,
                                    ),
                                  ).showdialog(context);
                                } else {
                                  print("Fail to insert");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                primary: mgMainColor,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
