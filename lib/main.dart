import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/main_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TabernaApp());
}

class TabernaApp extends StatelessWidget {
  const TabernaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Taberna Moe',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: MainMenu(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

