import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PagarScreen extends StatefulWidget {
  const PagarScreen({Key? key}) : super(key: key);

  @override
  State<PagarScreen> createState() => _PagarScreenState();
}

class _PagarScreenState extends State<PagarScreen> {
  @override
  void initState() {
    super.initState();

    final cart = Provider.of<CartProvider>(context, listen: false);

    // 🔔 ALERTA PEQUEÑA AL LLEGAR A 5 CERVEZAS
    cart.onBeerWarning = () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Has consumido 5 cervezas!"),
          duration: Duration(seconds: 2),
        ),
      );
    };

    // 🔵 ALERTA MUY GRANDE EN EL CENTRO – RECORDATORIO DE AGUA
    cart.onBeerWarning = () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          // Cierra la alerta después de 3 segundos
          Future.delayed(const Duration(seconds: 3), () {
            if (Navigator.canPop(context)) Navigator.pop(context);
          });

          return Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              margin: const EdgeInsets.symmetric(horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 25,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ],
              ),
              child: const Material(
                color: Colors.transparent,
                child: Text(
                  "🚰 ¡RECUERDA BEBER AGUA!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 42,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PAGAR',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔴 DEUDA ACTUAL
            Card(
              color: Colors.red[100],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'DEBO:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '\$${cart.debt.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔵 PAGAR DEUDA COMPLETA
            if (cart.debt > 0)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    cart.payDebt(cart.debt);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('¡DEUDA PAGADA!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'PAGAR TODA LA DEUDA',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // 🟡 PEDIDO ACTUAL
            Card(
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PEDIDO ACTUAL:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${cart.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🟢 PAGAR AHORA
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: cart.total <= 0
                    ? null
                    : () {
                  final totalCart = cart.total;

                  cart.confirmItemsAtPayment();
                  cart.clearCart();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '¡PEDIDO LISTO! \$${totalCart.toStringAsFixed(0)}'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'PAGAR AHORA',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🟠 PAGAR DESPUÉS
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: cart.total <= 0
                    ? null
                    : () {
                  final totalCart = cart.total;

                  cart.confirmItemsAtPayment();
                  cart.addToDebt(totalCart);
                  cart.clearCart();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'AGREGADO A DEUDA: \$${totalCart.toStringAsFixed(0)}'),
                      backgroundColor: Colors.orange,
                    ),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white),
                child: const Text(
                  'PAGAR DESPUÉS',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'MI PEDIDO:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // 🧾 LISTA DEL CARRITO
            Expanded(
              child: cart.items.isEmpty
                  ? const Center(
                child: Text(
                  'CARRITO VACÍO',
                  style:
                  TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView(
                children: cart.items.values.map((i) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(i.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        i.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        'x${i.quantity}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${(i.price * i.quantity).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 10),

                          // ❌ ELIMINAR PRODUCTO
                          IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () {
                              final cartProv =
                              Provider.of<CartProvider>(context,
                                  listen: false);

                              cartProv.removeItem(i.id, amount: 1);

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${i.name} eliminado'),
                                  duration:
                                  const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




