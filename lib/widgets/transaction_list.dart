import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    print('build() TransactionList');
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraint) {
            return Column(
              children: <Widget>[
                Text(
                  "Non ci sono transazioni in elenco!",
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: constraint.maxHeight * 0.7,
                  child: Image.asset(
                    'assets/images/sleeping-panda.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            );
          })
        : ListView(
            children: //non aggiungo parentesi quadre perchè non abbiamo altri children Widget altrimenti avrei dovuto usare l'operatore di diffusione per un elenco di elenchi (...) in transactions.
                // ListView.builder(
                // itemBuilder: (context, index) {   //itemBuilder è una chiave, il vantaggio di itemBuilder è che posiamo avere elenchi molto lunghi
                transactions
                    .map(
                      (tx) => TransactionItem(
                        key: ValueKey(tx.id), //IMPOSTO LA KEY (3)
                        transaction: tx,
                        deleteTx: deleteTx,
                      ),
                    )
                    .toList(),
            // return Card(
            //   child: Row(
            //     children: <Widget>[
            //       Container(
            //         margin: EdgeInsets.symmetric(
            //           vertical: 10,
            //           horizontal: 15,
            //         ),
            //         decoration: BoxDecoration(
            //           border: Border.all(
            //             color: Theme.of(context).primaryColor,
            //             width: 2,
            //           ),
            //         ),
            //         padding: EdgeInsets.all(10),
            //         child: Text(
            //           '\$${transactions[index].amount.toStringAsFixed(2)}',
            //           // ignore: prefer_const_constructors
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 20,
            //             color: Theme.of(context).primaryColor,
            //           ),
            //         ),
            //       ),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Text(
            //             transactions[index].title,
            //             style: Theme.of(context).appBarTheme.titleTextStyle,
            //             // style: TextStyle(
            //             //   fontSize: 16,
            //             //   fontWeight: FontWeight.bold,
            //             // ),
            //           ),
            //           Text(
            //             DateFormat('EEE, d/M/y')
            //                 .format(transactions[index].date),
            //             style: TextStyle(
            //               fontSize: 18,
            //               color: Colors.grey,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // );
            // },
            // itemCount: transactions.length,
          );
  }
}
