// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:bank_sparks_app/Helper/database_helper.dart';
import 'package:bank_sparks_app/Views/Screens/payment_screen.dart';
import 'package:bank_sparks_app/Views/Widgets/customer_list.dart';

import 'package:flutter/material.dart';

import '../../constants.dart';

class TransferMoney extends StatefulWidget {
  final double currentBalance;
  final int currentCustomerId;
  final String currentUserCardNumebr, senderName;

  TransferMoney({
    required this.currentBalance,
    required this.currentCustomerId,
    required this.senderName,
    required this.currentUserCardNumebr,
  });
  @override
  _TransferMoneyState createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
  final double _currentBalance = 0.0;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mgBgColor,
      appBar: AppBar(
        backgroundColor: mgMainColor,
        title: const Text("Transfer Money"),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: mgDefaultPadding),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      "Current Balance",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _currentBalance == widget.currentBalance
                          ? "\$ 0"
                          : "\$ ${widget.currentBalance}",
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _currentBalance == widget.currentBalance
                                ? Colors.red
                                : Colors.green,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
              initialData: const [],
              future: _dbHelper.getUserDetailsList(widget.currentCustomerId),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: mgDefaultPadding),
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Payment(
                            customerAvatar: snapshot.data[index].userName[0],
                            customerName: snapshot.data[index].userName,
                            senderName: widget.senderName,
                            customerAccountNumber:
                                snapshot.data[index].cardNumber,
                            currentUserCardNumber: widget.currentUserCardNumebr,
                            currentCustomerId: widget.currentCustomerId,
                            currentUserBalance: widget.currentBalance,
                            transferTouserId: snapshot.data[index].id,
                            tranferTouserCurrentBalance:
                                snapshot.data[index].totalAmount,
                          ),
                        ),
                      ),
                      child: CustomerList(
                        customerName: snapshot.data[index].userName,
                        currentBalance: snapshot.data[index].totalAmount,
                        avatar: snapshot.data[index].userName[0],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
