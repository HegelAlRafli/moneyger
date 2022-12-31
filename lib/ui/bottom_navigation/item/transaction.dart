import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyger/common/color_value.dart';
import 'package:moneyger/common/navigate.dart';
import 'package:moneyger/ui/transaction/add_transaction.dart';
import 'package:moneyger/ui/widget/detail_transaction_item.dart';
import 'package:moneyger/ui/widget/transaction/transaction_list.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigate.navigatorPush(context, const AddTransactionPage());
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // container biru
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  height: 264,
                  width: MediaQuery.of(context).size.width,
                  color: ColorValue.secondaryColor,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16, bottom: 48),
                          child: Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 16),
                                height: 35,
                                width: 35,
                                child: const CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/google.png'),
                                ),
                              ),
                              const Text(
                                "Selamat Pagi User",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        const Text(
                          "IDR 3.000.000,00",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        const Text(
                          "Total Saldo",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFC7C7C7)),
                        ),
                      ],
                    ),
                  ),
                ),
                // 264(tinggi container biru) - 65 (tinggi pengeluaran) / 2(maksudnya setengah dari tinggi pengeluaran)
                Positioned(
                  top: 264 - 65 / 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        DetailTransactionItem(),
                        DetailTransactionItem(
                          isIncome: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // judul transaksi seterusnya
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 32.5, 30, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/article.svg',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Transaksi',
                            style: textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Transaksi kamu selama ini',
                            style: textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  //
                  const SizedBox(
                    height: 16,
                  ),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return const WidgetTransactionList();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
