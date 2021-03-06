// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:bank_sparks_app/Helper/database_helper.dart';
import 'package:bank_sparks_app/Views/Widgets/custom_dialog.dart';
import 'package:bank_sparks_app/models/transection_details.dart';

import 'package:flutter/material.dart';

import '../../constants.dart';
import 'home_screen.dart';

class Payment extends StatefulWidget {
  final String customerAvatar,
      senderName,
      customerName,
      customerAccountNumber,
      currentUserCardNumber;
  final int transferTouserId, currentCustomerId;
  final double currentUserBalance, tranferTouserCurrentBalance;
  Payment({
    required this.customerAvatar,
    required this.customerName,
    required this.senderName,
    required this.customerAccountNumber,
    required this.currentUserCardNumber,
    required this.currentCustomerId,
    required this.transferTouserId,
    required this.currentUserBalance,
    required this.tranferTouserCurrentBalance,
  });
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  double? transferAmount;

  final DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mgBgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Text(
                    widget.customerAvatar,
                    style: const TextStyle(fontSize: 25),
                  ),
                  radius: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.customerName,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Text(widget.customerAccountNumber,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[600])),
              ],
            ),
          ),
          const SizedBox(height: 100),
          Column(
            children: [
              Form(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: mgDefaultPadding),
                child: TextFormField(
                  onChanged: (value) {
                    transferAmount = double.parse(value);
                  },
                  validator: (check) => "please enter amount",
                  keyboardType: TextInputType.number,
                  cursorColor: const Color(0xFF3E8E7E),
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Amount",
                    prefixText: "\$ ",
                    hintStyle: TextStyle(
                      fontSize: 25,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3E8E7E)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3E8E7E)),
                    ),
                  ),
                ),
              )),
            ],
          ),
          const Spacer(),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: mgDefaultPadding * 1.5,
                      vertical: mgDefaultPadding * 5 / 2),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your Card No: ${widget.currentUserCardNumber}",
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    )),
                        const SizedBox(height: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Check Balance",
                            style:
                                Theme.of(context).textTheme.subtitle2!.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: mgGreenColor,
                                    ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (transferAmount == null) {
                                CustomDialog(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  title: "Amount not added",
                                  description:
                                      "Please make sure that you added amount in the field",
                                  buttonText: "Cancel",
                                  addIcon: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ).showdialog(context);
                              } else if (transferAmount! >
                                  widget.currentUserBalance) {
                                // print("Balance is insufficent");
                                CustomDialog(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  title: "Insufficient Balance",
                                  description:
                                      "Please make sure that your account have sufficient balance",
                                  buttonText: "Cancel",
                                  addIcon: const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ).showdialog(context);
                              } else {
                                double currentUserRemainingBalance =
                                    widget.currentUserBalance - transferAmount!;

                                await _dbHelper.updateTotalAmount(
                                    widget.currentCustomerId,
                                    currentUserRemainingBalance);

                                double transferToCurrentBalance =
                                    widget.tranferTouserCurrentBalance +
                                        transferAmount!;

                                await _dbHelper.updateTotalAmount(
                                    widget.transferTouserId,
                                    transferToCurrentBalance);

                                TransectionDetails _transectionDetails =
                                    TransectionDetails(
                                  transectionId: widget.currentCustomerId,
                                  userName: widget.customerName,
                                  senderName: widget.senderName,
                                  transectionAmount: transferAmount,
                                );

                                await _dbHelper.insertTransectionHistroy(
                                    _transectionDetails);

                                CustomDialog(
                                  onPressed: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeScreen()))
                                        .then((value) => {});
                                  },
                                  title: "Paid Successfully",
                                  isSuccess: true,
                                  description:
                                      "Thanking for using our service. Have a nice day.",
                                  buttonText: "Home",
                                  addIcon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ).showdialog(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xFF3E8E7E),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Transfer Now",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700),
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
        ],
      ),
    );
  }
}
