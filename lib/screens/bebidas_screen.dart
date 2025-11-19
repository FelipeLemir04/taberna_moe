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
      appBar: AppBar(
        title: const Text(
          'CERVEZAS DUFF',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: beers.length,
        itemBuilder: (context, idx) {
          final b = beers[idx];
          final qty = cart.items[b.id]?.quantity ?? 0;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            elevation: 2,
            child: Column(
              children: [
                // Imagen más grande
                Container(
                  height: 250,
                  width: double.infinity,
                  child: Image.asset(b.image, fit: BoxFit.cover),
                ),

                // Nombre y precio más grandes
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          b.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${b.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                // Contador grande y simple
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      // Botón QUITAR grande
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => cart.removeItem(b.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'QUITAR',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Cantidad grande y visible
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          qty.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Botón PONER grande
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => cart.addItem(b, amount: 1),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              'PONER',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Botón principal grande
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        cart.addItem(b, amount: qty == 0 ? 1 : qty);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '¡Cerveza agregada!',
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        '¡QUIERO ESTA CERVEZA!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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