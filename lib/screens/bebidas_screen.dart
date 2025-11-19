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
  final Map<String, int> _selections = {};

  int _getSelection(String id) => _selections[id] ?? 0;

  void _increment(String id) => setState(() => _selections[id] = _getSelection(id) + 1);

  void _decrement(String id) {
    final current = _getSelection(id);
    if (current <= 0) return;
    setState(() {
      _selections[id] = current - 1;
      if (_selections[id] == 0) _selections.remove(id);
    });
  }

  void _showWaterAlert(BuildContext context, int beerCount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[50],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Column(
            children: [
              Icon(
                Icons.water_drop,
                color: Colors.blue[700],
                size: 60,
              ),
              const SizedBox(height: 10),
              const Text(
                '¡RECUERDA TOMAR AGUA! 💧',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          content: Text(
            'Llevas $beerCount cervezas.\n\n¡Es hora de tomar un poco de agua para mantenerte hidratado! 🍺💧',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '¡ENTENDIDO! TOMARÉ AGUA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cart = Provider.of<CartProvider>(context, listen: false);
      cart.onBeerWarning = () => _showWaterAlert(context, cart.dailyBeerCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    cart.onBeerWarning = () => _showWaterAlert(context, cart.dailyBeerCount);

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
          final beer = widget.beers[idx];
          final localQty = _getSelection(beer.id);
          final inCartQty = cart.items[beer.id]?.quantity ?? 0;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            elevation: 2,
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  child: Image.asset(beer.image, fit: BoxFit.cover),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          beer.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${beer.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _decrement(beer.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('QUITAR', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _increment(beer.id),
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
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final amountToAdd = localQty > 0 ? localQty : 1;
                        cart.addItem(beer, amount: amountToAdd);
                        setState(() {
                          _selections.remove(beer.id);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('¡${beer.name} agregada x$amountToAdd!'),
                              backgroundColor: Colors.green
                          ),
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