import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../providers/cart_provider.dart';

class BebidasScreen extends StatelessWidget {
  BebidasScreen({Key? key}) : super(key: key);

  final List<Item> beers = [
    Item(id: 'beer_duff', name: 'Duff Original', description: 'La clásica cerveza de Springfield.', image: 'assets/images/bebidas/duff_original.jpg', price: 120.0),
    Item(id: 'beer_light', name: 'Duff Light', description: 'Versión ligera para los que cuidan la figura.', image: 'assets/images/bebidas/duff_light.jpg', price: 110.0),
    Item(id: 'beer_dry', name: 'Duff Dry', description: 'Más amarga y con más cuerpo.', image: 'assets/images/bebidas/duff_dry.jpg', price: 130.0),
    Item(id: 'beer_christmas', name: 'Duff Christmas', description: 'Edición navideña especial.', image: 'assets/images/bebidas/duff_christmas.jpg', price: 150.0),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Bebidas')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: beers.length,
        itemBuilder: (context, idx) {
          final b = beers[idx];
          final qty = cart.items[b.id]?.quantity ?? 0;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Image.asset(b.image, height: 180, width: double.infinity, fit: BoxFit.cover),
                ListTile(
                  title: Text(b.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(b.description),
                  trailing: Text('\$${b.price.toStringAsFixed(0)}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => cart.removeItem(b.id),
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(qty.toString(), style: const TextStyle(fontSize: 18)),
                      IconButton(
                        onPressed: () {
                          cart.addItem(b, amount: 1);
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          // Añadir al "debt optionally" - aquí simplemente sumamos al carrito y acumulamos deuda si decide pagar después.
                          cart.addToDebt(b.price * (cart.items[b.id]?.quantity ?? 0)); // No ideal: ejemplo
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cantidad agregada al carrito.')));
                        },
                        child: const Text('Agregar al Carrito'),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
