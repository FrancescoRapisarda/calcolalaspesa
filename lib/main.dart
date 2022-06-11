//Import CONVENZIONE:
//in cima: import DART,
//blocco successivo: import FLUTTER,
//blocco successivo: LE MIE IMPORTAZIONI!

// import 'dart:ui';
// import 'dart:io';

// import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:flutter/cupertino.dart';
//import 'package:flutter/services.dart';
// import 'package:page_transition/page_transition.dart';

import 'dart:io';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ],
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //MyApp crea un'istanza del widget MyHomePage() riga 63 home: MyHomePage() viene creata la classe nella riga 68
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('it', ''),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Spese Personali',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.red,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //WidgetBindingObserver è una classe che aggiungiamo per prendere alcune proprietà della classe che ci servono quindi creiamo un "mixin"
  // final titleController = TextEditingController();
  // final amountController = TextEditingController();

  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 'ts1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 'ts2',
    //   title: 'Weekly Grociers',
    //   amount: 29.99,
    //   date: DateTime.now(),
    // ),
  ];

  bool _showChart = false;

  //per attivare il metodo che cancella i miei ascoltatori del ciclo di vita dell'app devo creare il metodo initState() e aggiungere un ascoltatore
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(
        this); //aggiungi ascoltatore, hey Flutter ogni volta che il mio stato del ciclo di vita dell'app cambia voglio che tu vada a un certo osservatore e chiami il metodo didChangeAppLifecycleState()
  }

  //WidgetsBindingObserver
  //questo metodo verrà chiamato ogni volta che lo stato del ciclo di vita della mia app cambia, ogni volta che l'app raggiuge un nuovo stato nel ciclo di vita.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state); //vedo qual'è il nuovo stato
  }

  //cancellare il listener ai cambiamenti del ciclo di vita quando quel widget o quell'oggetto state non è piu richiesto.
  @override
  dispose() {
    WidgetsBinding.instance!.removeObserver(
        this); //dispose() di fatto cancella tutti i listener che ho al ciclo di vita dell'app.
    super
        .dispose(); //cancella gli ascoltatori alle modifiche del ciclo di vita altrimenti manterò quel listener attivo e funzionante (didChangeAppLifecycleState).
  }

  List<Transaction> get _recentTransactions {
    //prendo le transazioni avvenute negli ultimi 7 giorni!

    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chooseDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chooseDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  List<Widget> _buildLandascapeContent(
    //METODI DI COSTRUZIONE WIDGET
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Mostra Grafico'),
          Switch.adaptive(
            activeColor: Colors.green,
            value: _showChart,
            onChanged: (bool value) {
              setState(() {
                _showChart = value;
              });
            },
          ),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.6,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
    //METODI DI COSTRUZIONE WIDGET
    MediaQueryData mediaQuery,
    AppBar appBar,
    Widget txListWidget,
  ) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      // backgroundColor: Colors.red,
      title: Text(
        'Spese Personali',
        // style: TextStyle(fontFamily: 'OpenSans'),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(
            Icons.add,
            color: Colors.white,
            // size: 30,
          ),
        ),
      ],
    );

    final txListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandascapeContent(
                //metodo che migliora la leggibilità del codice
                mediaQuery,
                appBar,
                txListWidget,
              ),
            if (!isLandscape)
              ..._buildPortraitContent(
                //metodo che migliora la leggibilità del codice
                mediaQuery,
                appBar,
                txListWidget,
              ),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    pageBody,
                    Icon(
                      CupertinoIcons.add,
                    ),
                  ],
                ),
              ),
            ),
            navigationBar: CupertinoNavigationBar(
              middle: Text(
                'Spese Personali',
              ),
              trailing: Row(mainAxisSize: MainAxisSize.min),
            ),
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
          );
  }
}
