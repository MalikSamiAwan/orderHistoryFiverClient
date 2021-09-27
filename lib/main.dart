import 'package:fiver/controller.dart';
import 'package:fiver/modals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'newOrderScreen.dart';
import 'order_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: MyConstants.primaryColor,

        ),
        home: NewOrderScreen(),
      ),
    );
  }
}
