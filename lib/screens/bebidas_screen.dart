import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../providers/cart_provider.dart';

class BebidasScreen extends StatefulWidget {
  BebidasScreen({Key? key}) : super(key: key);

  final List<Item> beers = [
    Item(id: 'beer_duff', name: 'Duff Original', description: 'La clásica cerveza de Springfield.', image: 'assets/images/bebidas/duff_original.jpg', price: 120.0),
    Item(id: 'beer_light', name: 'Duff Light', description: 'Versión ligera para los que cuidan la figura.', image: 'assets/images/bebidas/duff_light.jpg', price: 110.0),
    Item(id: 'beer_dry', name: 'Duff Dry', description: 'Más amarga y con más cuerpo.', image: 'assets/images/bebidas/duff_dry.jpg', price: 130.0),
    Item(id: 'beer_christmas', name: 'Duff Christmas', description: 'Edición navideña especial.', image: 'assets/images/bebidas/duff_christmas.jpg', price: 150.0),
  ];

  @override
  State<BebidasScreen> createState() => _BebidasScreenState();
}

class _BebidasScreenState extends State<BebidasScreen> {
  // Selección local por ítem (no se añade al carrito hasta "¡QUIERO ESTA CERVEZA!" o PONER individual)
  final Map<String, int> _selections = {};

  int _sel(String id) => _selections[id] ?? 0;

  void _inc(String id) => setState(() => _selections[id] = _sel(id) + 1);

  void _dec(String id) {
    final cur = _sel(id);
    if (cur <= 0) return;
    setState(() {
      _selections[id] = cur - 1;
      if (_selections[id] == 0) _selections.remove(id);
    });
  }

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
        itemCount: widget.beers.length,
        itemBuilder: (context, idx) {
          final b = widget.beers[idx];
          final localQty = _sel(b.id);
          final inCartQty = cart.items[b.id]?.quantity ?? 0;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            elevation: 2,
            child: Column(
              children: [
                // Imagen
                Container(
                  height: 250,
                  width: double.infinity,
                  child: Image.asset(b.image, fit: BoxFit.cover),
                ),

                // Nombre y precio
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

                // Controles locales
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      // QUITAR (selección local)
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _dec(b.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('QUITAR', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Cantidad local
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(localQty.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),

                      const SizedBox(width: 12),

                      // PONER (selección local)
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _inc(b.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('PONER', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Botón principal: agrega la cantidad local (o 1 si no seleccionó)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final amountToAdd = localQty > 0 ? localQty : 1;
                        cart.addItem(b, amount: amountToAdd);

                        // limpiar selección local
                        setState(() {
                          _selections.remove(b.id);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('¡${b.name} agregada x$amountToAdd!'), backgroundColor: Colors.green),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[700],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        '¡QUIERO ESTA CERVEZA!',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                // Info de carrito si ya hay unidades
                if (inCartQty > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text('En carrito: x$inCartQty', style: const TextStyle(color: Colors.grey)),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
