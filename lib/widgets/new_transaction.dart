import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/adaptive_flat_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx) {
    print('Costructor NewTransaction Widget');
  }

  @override
  State<NewTransaction> createState() {
    print('createState NewTransaction Widget');
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  var _selectedDate =
      DateTime.now(); //questa variabile non è di tipo final perchè cambierà

  _NewTransactionState() {
    print('Constructor NewTransactionState');
  }

  @override
  void initState() {
    //Esegue lo State per la prima volta (lo State viene gestito come un oggetto separato, non viene ricreato  automaticamente ma si attacca, è semplicemente  il riferimento dell'elemento, che gestisce lo State che viene aggiornato e punta al nuovo Widget nell'albero.)
    //initState viene spesso usato per recuperare dati iniziali necessari nell'app o in un widget dell'app.
    //serve per interagire con i WebServer.
    super.initState();
    print('initState()');
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    //aggiorna lo stato del widget
    //usato molto meno spesso, usarlo se so che è cambiato qualcosa nel widget principale e devo recuperare i dati nel mio stato, recuperare dati da un database e ho ricevuto un nuovo ID nel mio Widget che è collegato allo stato e per quell'ID voglio recuperare nuovi dati.
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    //elimina lo stato di un Widget
    //Casi d'uso: ho un ascoltatore di una connessione Internet in tempo reale che ti invia nuovi messaggi perchè sto creando un'applicazione di chat o qualcosa del genere, quindi voglio ripulire questa connessione al mio server qui quando il mio Widget viene rimosso, in modo che non ho piu quella connessione in corso in memoria anche se non ho piu Widget, questo porterà a strani bug e anche a perdite di memoria.
    //Quindi ripulire gli ascoltatori o le connessioni è qualcosa che farò spesso con dispose() lo smaltimento di un WIDGET.
    print('dispose()');
    super.dispose();
  }

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    }); //restituisce un "future"
  }

  @override
  Widget build(BuildContext context) {
    print('build() NewTransactionState');
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Prodotto'),
                // onChanged: (value) => titleInput = value,
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Prezzo'),
                // onChanged: (value) => amountInput = value,
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Nessuna data selezionata!'
                            : 'Data selezionata: ${DateFormat.yMEd().format(_selectedDate)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    AdaptiveFlatButton("Scegli Data", _presentDatePicker),
                  ],
                ),
              ),
              // ignore: deprecated_member_use
              ElevatedButton(
                // textColor: Colors.purple,
                onPressed: _submitData,
                child: Text(
                  'Aggiungi',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
