// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';


class TransactionHistroy extends StatefulWidget {
  final String customerName, avatar;
  final String senderName;
  final bool isTransfer;
  final double transferAmount;
   TransactionHistroy({
    required this.customerName,
    required this.avatar,
    required this.senderName,
    required this.isTransfer,
    required this.transferAmount,
  });
  @override
  _TransactionHistroyState createState() => _TransactionHistroyState();
}

class _TransactionHistroyState extends State<TransactionHistroy> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12, right: 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(8, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(widget.avatar,
                    style: const TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.customerName,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    widget.senderName,
                    style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text(
                widget.isTransfer
                    ? '+ \$ ${widget.transferAmount}'
                    : '- \$ ${widget.transferAmount}',
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                    color: widget.isTransfer ? Colors.green : Colors.red,
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
