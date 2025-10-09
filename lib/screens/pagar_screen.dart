import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PagarScreen extends StatefulWidget {
  PagarScreen({Key? key}) : super(key: key);

  @override
  State<PagarScreen> createState() => _PagarScreenState();
}

class _PagarScreenState extends State<PagarScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Pagar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Deuda acumulada'),
              subtitle: Text('\$${cart.debt.toStringAsFixed(2)}'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Monto a pagar ahora', prefixText: '\$'),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      final amt = double.tryParse(_amountController.text) ?? 0.0;
                      if (amt <= 0) return;
                      cart.payDebt(amt);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pago realizado')));
                      _amountController.clear();
                    },
                    child: const Text('Pagar ahora')),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: () {
                      // Pagar después: añade total del carrito a deuda
                      final totalCart = cart.total;
                      if (totalCart <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Carrito vacío')));
                        return;
                      }
                      cart.addToDebt(totalCart);
                      cart.clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pedido agregado a deuda')));
                    },
                    child: const Text('Pagar después (acumular)')),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Carrito (preview):', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: cart.items.values.map((i) {
                  return ListTile(
                    leading: Image.asset(i.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text('${i.name} x${i.quantity}'),
                    trailing: Text('\$${(i.price * i.quantity).toStringAsFixed(0)}'),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}


