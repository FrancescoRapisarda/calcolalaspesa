import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key?
        key, //ACCETTO LA KEY (2).. nel costruttore (ogni widget ha una key come card "vedi giu...")
    required this.transaction,
    required this.deleteTx,
  }) : super(
            key:
                key); //INOLTRO LA KEY (1).. questa parte entra in gioco nel nostro TransactionItem widget! Super si riferisce alla classe genitore, passando super come una funzione sto istanziando la classe genitore. Questo strano costrutto dopo i : si chiama ELENCO DI INIZIALIZZATORI DEL COSTRUTTORE

  final Transaction transaction;
  final Function deleteTx;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  late Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.red,
      Colors.yellow,
      Colors.green,
      Colors.blue,
    ];

    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // key: ,   si dovrebbe impostare una chiave a livello di root al widget piu in alto (sul figlio diretto di ListView) che in questo caso è TransactionItem il widget personalizzato nel file transaction_list.dart, un widget Stateful!
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          //argomento "leading" parte iniziale del ListTile
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              child: Text('\$${widget.transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ), //argomento "title" è l'elemento che sta nel mezzo del ListTile
        subtitle: Text(
          DateFormat('EEE, d/M/y').format(widget.transaction.date),
          style: const TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
        ),
        trailing: MediaQuery.of(context).size.width > 393
            ? FlatButton.icon(
                onPressed: () => widget.deleteTx(widget.transaction.id),
                icon: const Icon(
                  Icons.delete_sweep,
                ),
                label: const Text(
                  'Elimina',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                textColor: Colors.red,
              )
            : IconButton(
                onPressed: () => widget.deleteTx(widget.transaction.id),
                icon: const Icon(
                  Icons.delete_sweep,
                  color: Colors.red,
                ),
              ),
      ),
    );
  }
}
