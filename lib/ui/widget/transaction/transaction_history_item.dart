import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moneyger/common/color_value.dart';
import 'package:moneyger/common/navigate.dart';
import 'package:moneyger/common/shared_code.dart';
import 'package:moneyger/ui/transaction/edit_transaction.dart';

class TransactionHistoryItem extends StatefulWidget {
  final bool isHome;

  const TransactionHistoryItem({Key? key, this.isHome = false})
      : super(key: key);

  @override
  State<TransactionHistoryItem> createState() => _TransactionHistoryItemState();
}

class _TransactionHistoryItemState extends State<TransactionHistoryItem> {
  final _collection = FirebaseFirestore.instance
      .collection('users')
      .doc(SharedCode().uid)
      .collection('transaction');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return StreamBuilder<QuerySnapshot>(
      stream: _collection.orderBy('created_at', descending: true).snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('Data masih kosong'),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.isHome
                ? snapshot.data!.docs.length < 3
                    ? snapshot.data!.docs.length
                    : 3
                : snapshot.data!.docs.length,
            itemBuilder: (_, index) {
              final data = snapshot.data!.docs[index];
              final type = data['type'];

              return GestureDetector(
                onTap: () {
                  Navigate.navigatorPush(
                    context,
                    EditTransactionPage(
                      data: [
                        data['total'],
                        data['category'],
                        data['date'],
                        data['desc'],
                        data['day'],
                        data['week'],
                        data.id,
                      ],
                      isSelectedIncome: type == 'income' ? true : false,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: 35,
                        height: 35,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: type == 'income'
                              ? ColorValue.greenColor
                              : ColorValue.redColor,
                        ),
                        child: SvgPicture.asset(
                          type == 'income'
                              ? 'assets/svg/up.svg'
                              : 'assets/svg/down.svg',
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['category'],
                            style: textTheme.bodyText1!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            data['desc'],
                            style: textTheme.bodyText2,
                          )
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${type == 'income' ? '+' : '-'} ${SharedCode().convertToIdr(data['total'], 0)}',
                            style: textTheme.bodyText2!.copyWith(
                              color: type == 'income'
                                  ? ColorValue.greenColor
                                  : ColorValue.redColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            data['date'],
                            style: textTheme.bodyText2,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          // ganti dengan shimmer effect
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}