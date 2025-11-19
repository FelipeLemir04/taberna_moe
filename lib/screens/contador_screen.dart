import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CONTADOR DE CERVEZAS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber[700],
      ),
      body: FutureBuilder(
        future: cart.checkDailyReset(),
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título simple
                const Text(
                  'CERVEZAS DE HOY:',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 40),

                // Contador gigante
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.amber[100],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.amber[700]!,
                      width: 8,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${cart.dailyBeerCount}',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Emojis según la cantidad
                if (cart.dailyBeerCount == 0)
                  const Text(
                    '😴 ¡Todavía nada!',
                    style: TextStyle(fontSize: 24),
                  )
                else
                  if (cart.dailyBeerCount < 5)
                    const Text(
                      '😊 ¡Recién empezando!',
                      style: TextStyle(fontSize: 24),
                    )
                  else
                    if (cart.dailyBeerCount < 10)
                      const Text(
                        '🎉 ¡Vamos bien!',
                        style: TextStyle(fontSize: 24),
                      )
                    else
                      const Text(
                        '🤪 ¡Eso es espíritu!',
                        style: TextStyle(fontSize: 24),
                      ),

                const SizedBox(height: 30),

                // Botón simple para recargar
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            '¡Contador actualizado!',
                            style: TextStyle(fontSize: 16),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'ACTUALIZAR',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}