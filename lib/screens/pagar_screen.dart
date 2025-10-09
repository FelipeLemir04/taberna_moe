import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PagarScreen extends StatefulWidget {
  const PagarScreen({Key? key}) : super(key: key);

  @override
  State<PagarScreen> createState() => _PagarScreenState();
}

class _PagarScreenState extends State<PagarScreen> {
  final TextEditingController _debtAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pagar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // DEUDA ACUMULADA
            ListTile(
              title: const Text('DEUDA A PAGAR'),
              subtitle: Text('\$${cart.debt.toStringAsFixed(2)}'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _debtAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto a pagar de deuda',
                prefixText: '\$',
                hintText: 'Deja vacío para pagar toda la deuda',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: cart.debt <= 0
                  ? null
                  : () {
                final amt =
                    double.tryParse(_debtAmountController.text) ??
                        cart.debt;
                if (amt <= 0) return;
                cart.payDebt(amt);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Has pagado \$${amt.toStringAsFixed(2)} de tu deuda'),
                  ),
                );
                _debtAmountController.clear();
              },
              child: const Text('Pagar deuda'),
            ),
            const SizedBox(height: 20),

            // BOTONES PARA EL PEDIDO ACTUAL
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: cart.total <= 0
                        ? null
                        : () {
                      final totalCart = cart.total;
                      cart.clearCart(); // solo limpia el carrito
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '¡Tu pedido de \$${totalCart.toStringAsFixed(2)} se está preparando! 🍺🍔'),
                        ),
                      );
                    },
                    child: const Text('Pagar ahora (pedido actual)'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: cart.total <= 0
                        ? null
                        : () {
                      final totalCart = cart.total;
                      cart.addToDebt(totalCart); // acumula en deuda
                      cart.clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '¡Tu pedido se ha agregado a la deuda! \$${totalCart.toStringAsFixed(2)}'),
                        ),
                      );
                    },
                    child: const Text('Pagar después'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // VISTA PREVIA DEL CARRITO CON BOTONES PARA QUITAR PRODUCTOS
            const Text(
              'Carrito (preview):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: cart.items.isEmpty
                  ? const Center(child: Text('No hay productos en el carrito'))
                  : ListView(
                children: cart.items.values.map((i) {
                  return ListTile(
                    leading: Image.asset(
                      i.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text('${i.name} x${i.quantity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            '\$${(i.price * i.quantity).toStringAsFixed(2)}'),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            cart.removeItem(i.id);
                          },
                        ),
                      ],
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
