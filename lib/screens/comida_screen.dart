import 'package:flutter/material.dart';
import '../models/item.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ComidaScreen extends StatefulWidget {
  ComidaScreen({Key? key}) : super(key: key);

  final List<Item> comidas = [
    // Papas (3)
    Item(id: 'papas_clasicas', name: 'Papas Clásicas', description: 'Papas fritas clásicas.', image: 'assets/images/comida/papas1.jpg', price: 350),
    Item(id: 'papas_cheddar', name: 'Papas Cheddar', description: 'Papas con cheddar y bacon.', image: 'assets/images/comida/papas2.jpg', price: 420),
    Item(id: 'papas_bbq', name: 'Papas BBQ', description: 'Papas con salsa BBQ y especies.', image: 'assets/images/comida/papas3.jpg', price: 390),
    // Nachos (2)
    Item(id: 'nachos_clasicos', name: 'Nachos Clásicos', description: 'Nachos con queso.', image: 'assets/images/comida/nachos1.jpg', price: 450),
    Item(id: 'nachos_pollo', name: 'Nachos con pollo', description: 'Nachos con pollo desmenuzado.', image: 'assets/images/comida/nachos2.jpg', price: 520),
    // Hamburguesas (4)
    Item(id: 'hamburguesa_clasica', name: 'Hamburguesa Clásica', description: 'Carne, lechuga, tomate.', image: 'assets/images/comida/hamb1.jpg', price: 980),
    Item(id: 'hamburguesa_queso', name: 'Hamburguesa con Queso', description: 'Con doble queso.', image: 'assets/images/comida/hamb2.jpg', price: 1050),
    Item(id: 'hamburguesa_bacon', name: 'Bacon Burger', description: 'Con bacon crocante.', image: 'assets/images/comida/hamb3.jpg', price: 1150),
    Item(id: 'hamburguesa_veg', name: 'Veggie Burger', description: 'Versión vegetariana.', image: 'assets/images/comida/hamb4.jpg', price: 950),
    // Donas (4)
    Item(id: 'dona_chocolate', name: 'Dona Chocolate', description: 'Dona glaseada chocolate.', image: 'assets/images/comida/dona1.jpg', price: 220),
    Item(id: 'dona_vainilla', name: 'Dona Vainilla', description: 'Dona con glaseado de vainilla.', image: 'assets/images/comida/dona2.jpg', price: 220),
    Item(id: 'dona_fresa', name: 'Dona Fresa', description: 'Dona con cobertura de fresa.', image: 'assets/images/comida/dona3.jpg', price: 220),
    Item(id: 'dona_especial', name: 'Dona Especial', description: 'Dona rellena.', image: 'assets/images/comida/dona4.jpg', price: 260),
    // Panchos (3)
    Item(id: 'pancho_clasico', name: 'Pancho Clásico', description: 'Pancho con salsa.', image: 'assets/images/comida/pancho1.jpg', price: 300),
    Item(id: 'pancho_queso', name: 'Pancho con Queso', description: 'Pancho con queso fundido.', image: 'assets/images/comida/pancho2.jpg', price: 350),
    Item(id: 'pancho_chili', name: 'Pancho Chili', description: 'Pancho con chili', image: 'assets/images/comida/pancho3.jpg', price: 380),
  ];

  @override
  State<ComidaScreen> createState() => _ComidaScreenState();
}

class _ComidaScreenState extends State<ComidaScreen> {
  // Selecciones locales (no stored in cart until "¡QUIERO ESTO!" se presiona)
  final Map<String, int> _selections = {};

  int _getSelection(String id) => _selections[id] ?? 0;

  void _incSelection(String id) {
    setState(() {
      _selections[id] = _getSelection(id) + 1;
    });
  }

  void _decSelection(String id) {
    final cur = _getSelection(id);
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
          'COMIDA',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.comidas.length,
        itemBuilder: (context, idx) {
          final c = widget.comidas[idx];
          final localQty = _getSelection(c.id);
          final inCartQty = cart.items[c.id]?.quantity ?? 0;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            elevation: 2,
            child: Column(
              children: [
                // Imagen de la comida
                Container(
                  height: 140,
                  width: double.infinity,
                  child: Image.asset(c.image, fit: BoxFit.cover),
                ),

                // Nombre y precio
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${c.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                // Controles: QUITAR (local), cantidad (local), PONER (local)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      // QUITAR (desde selección local)
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _decSelection(c.id),
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

                      // Cantidad local visible (si no hay selección se muestra 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          localQty.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // PONER (a selección local)
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _incSelection(c.id),
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

                // Botón principal: agrega la cantidad seleccionada (o 1 si no seleccionó)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        final amountToAdd = localQty > 0 ? localQty : 1;
                        cart.addItem(c, amount: amountToAdd);

                        // limpiar selección local para ese item
                        setState(() {
                          _selections.remove(c.id);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('¡${c.name} agregada x$amountToAdd!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        '¡QUIERO ESTO!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // Mostrar si ya hay unidades en el carrito (informativo)
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
