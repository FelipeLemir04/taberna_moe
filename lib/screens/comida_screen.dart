import 'package:flutter/material.dart';
import '../models/item.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class ComidaScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Comida')),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: comidas.length,
        itemBuilder: (context, idx) {
          final c = comidas[idx];
          final qty = cart.items[c.id]?.quantity ?? 0;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Image.asset(c.image, height: 180, width: double.infinity, fit: BoxFit.cover),
                ListTile(
                  title: Text(c.name),
                  subtitle: Text(c.description),
                  trailing: Text('\$${c.price.toStringAsFixed(0)}'),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () => cart.removeItem(c.id), icon: const Icon(Icons.remove_circle_outline)),
                    Text(qty.toString(), style: const TextStyle(fontSize: 18)),
                    IconButton(onPressed: () => cart.addItem(c), icon: const Icon(Icons.add_circle_outline)),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          cart.addToDebt(c.price * (cart.items[c.id]?.quantity ?? 0));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agregado a deuda.')));
                        },
                        child: const Text('Agregar al Carrito'))
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
