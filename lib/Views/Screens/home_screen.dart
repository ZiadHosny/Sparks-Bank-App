import 'package:bank_sparks_app/Helper/database_helper.dart';
import 'package:bank_sparks_app/Views/Screens/transfer_money_screen.dart';
import 'package:bank_sparks_app/Views/Widgets/atm_card.dart';
import 'package:bank_sparks_app/Views/Widgets/transaction_histroy.dart';

import 'package:flutter/material.dart';

import '../../card_data.dart';
import '../../constants.dart';
import 'add_card_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbhelper = DatabaseHelper();
  late List<CardData> _list;

  @override
  void initState() {
    _list = CardData.cardDataList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mgBgColor,
      appBar: AppBar(
        backgroundColor: mgMainColor,
        elevation: 0,
        title: Text("Sparks Bank"),
        leading: const Padding(
          padding: EdgeInsets.only(left: mgDefaultPadding),
          child: Icon(
            Icons.attach_money_outlined,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 199,
              child: FutureBuilder(
                initialData: const [],
                future: _dbhelper.getUserDetails(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.only(left: mgDefaultPadding, right: 6),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => TransferMoney(
                                currentBalance:
                                    snapshot.data[index].totalAmount,
                                currentCustomerId: snapshot.data[index].id,
                                currentUserCardNumebr:
                                    snapshot.data[index].cardNumber,
                                senderName: snapshot.data[index].userName,
                              ),
                            ),
                          );
                        },
                        child: UserATMCard(
                          cardNumber: snapshot.data[index].cardNumber,
                          cardExpiryDate: snapshot.data[index].cardExpiry,
                          totalAmount: snapshot.data[index].totalAmount,
                          gradientColor: _list[index].mgPrimaryGradient,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: mgDefaultPadding,
                  bottom: 13,
                  top: 29,
                  right: mgDefaultPadding),
              child: Text(
                "Transaction Histories",
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontSize: 25, fontWeight: FontWeight.w700),
              ),
            ),
            FutureBuilder(
              initialData: const [],
              future: _dbhelper.getTransectionDetatils(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: mgDefaultPadding),
                  itemBuilder: (context, index) {
                    return TransactionHistroy(
                      isTransfer: true,
                      customerName: snapshot.data[index].userName,
                      transferAmount: snapshot.data[index].transectionAmount,
                      senderName: snapshot.data[index].senderName,
                      avatar: snapshot.data[index].userName[0],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mgMainColor,
        onPressed: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 100),
                  transitionsBuilder:
                      (context, animation, animationTime, child) {
                    animation = CurvedAnimation(
                        parent: animation, curve: Curves.easeInOutCubic);
                    return ScaleTransition(
                      scale: animation,
                      alignment: Alignment.bottomCenter,
                      child: child,
                    );
                  },
                  pageBuilder: (context, animation, animationTime) {
                    return AddCardDetails();
                  }));
        },
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }
}
