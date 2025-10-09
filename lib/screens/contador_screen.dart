import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Contador diario de cervezas')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: cart.checkDailyReset(),
          builder: (context, snapshot) {
            return Column(
              children: [
                const Text('Cervezas pedidas hoy:', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 20),
                Text('${cart.dailyBeerCount}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    // Forzar reset (debug)
                    await cart.saveToPrefs();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guardado.')));
                  },
                  child: const Text('Forzar guardado (debug)'),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

