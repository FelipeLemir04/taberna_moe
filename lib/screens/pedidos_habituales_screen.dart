import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/item.dart';

class PedidosHabitualesScreen extends StatelessWidget {
  final List<Item> pedidosHabituales = [
    Item(id: 'p1', name: 'Combo Homer', description: '6 Duff y 1 Hamburguesa', image: 'assets/images/pedidos/pedido1.jpg', price: 10.0),
    Item(id: 'p2', name: 'Combo Moe', description: '4 Duff Dry y 2 Porciones de Papas', image: 'assets/images/comida/papas2.jpg', price: 9.0),
    Item(id: 'p3', name: 'Combo Barney', description: '10 Duff + Nachos gratis', image: 'assets/images/bebidas/duff_dry.jpg', price: 12.0),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PEDIDOS USUALES',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Título simple
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'TUS COMBOS FAVORITOS',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Combos grandes y simples
          ...pedidosHabituales.map((pedido) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Imagen del combo
                    Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(pedido.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Nombre del combo
                    Text(
                      pedido.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Descripción simple
                    Text(
                      _simplificarDescripcion(pedido.description),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Precio grande
                    Text(
                      '\$${pedido.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botón enorme para agregar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          cart.addItem(pedido);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '¡${pedido.name} AGREGADO!',
                                style: const TextStyle(fontSize: 16),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[700],
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          '¡QUIERO ESTE COMBO!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // Función para simplificar las descripciones
  String _simplificarDescripcion(String descripcion) {
    if (descripcion.contains('6 Duff y 1 Hamburguesa')) {
      return '6 Cervezas + 1 Hamburguesa';
    } else if (descripcion.contains('4 Duff Dry y 2 Porciones de Papas')) {
      return '4 Cervezas + 2 Papas';
    } else if (descripcion.contains('10 Duff + Nachos gratis')) {
      return '10 Cervezas + Nachos Gratis';
    }
    return descripcion;
  }
}