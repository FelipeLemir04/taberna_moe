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
            // DEUDA ACTUAL
            Card(
              color: Colors.red[100],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('DEBO:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                    Text('\$${cart.debt.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // PAGAR DEUDA COMPLETA
            if (cart.debt > 0)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    cart.payDebt(cart.debt);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡DEUDA PAGADA!')));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: const Text('PAGAR TODA LA DEUDA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),

            const SizedBox(height: 30),

            // PEDIDO ACTUAL
            Card(
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('PEDIDO ACTUAL:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('\$${cart.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),

            const SizedBox(height: 20),

            // PAGAR AHORA
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: cart.total <= 0
                    ? null
                    : () {
                  final totalCart = cart.total;
                  // Primero confirmar ítems (aquí se registran las cervezas en el contador)
                  cart.confirmItemsAtPayment();
                  // Luego limpiar carrito
                  cart.clearCart();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('¡PEDIDO LISTO! \$${totalCart.toStringAsFixed(0)}'), backgroundColor: Colors.green),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: const Text('PAGAR AHORA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 10),

            // PAGAR DESPUÉS
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: cart.total <= 0
                    ? null
                    : () {
                  final totalCart = cart.total;
                  // confirmar items (se cuenta cerveza)
                  cart.confirmItemsAtPayment();
                  // agregar a deuda con el total actual
                  cart.addToDebt(totalCart);
                  // limpiar carrito
                  cart.clearCart();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('AGREGADO A DEUDA: \$${totalCart.toStringAsFixed(0)}'), backgroundColor: Colors.orange),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                child: const Text('PAGAR DESPUÉS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 30),

            const Text('MI PEDIDO:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // LISTA SIMPLE DEL CARRITO
            Expanded(
              child: cart.items.isEmpty
                  ? const Center(child: Text('CARRITO VACÍO', style: TextStyle(fontSize: 18, color: Colors.grey)))
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
                          image: DecorationImage(image: AssetImage(i.image), fit: BoxFit.cover),
                        ),
                      ),
                      title: Text(i.name, style: const TextStyle(fontSize: 16)),
                      subtitle: Text('x${i.quantity}', style: const TextStyle(fontSize: 14)),
                      trailing: Text('\$${(i.price * i.quantity).toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

