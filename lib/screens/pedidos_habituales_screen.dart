import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/item.dart';

class PedidosHabitualesScreen extends StatelessWidget {
  // Solo el combo favorito de Homero
  final List<Item> favoritos = [
    Item(
        id: 'combo_homer',
        name: 'COMBO HOMER',
        description: '12 Donuts + 6 Cervezas + Nachos Gigantes',
        image: 'assets/images/pedidos/pedido1.jpg',
        price: 25.0
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAVORITOS',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink[700],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Título simple
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'EL FAVORITO DE HOMERO',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          // Combo único de Homero
          ...favoritos.map((favorito) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Iconos del combo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ItemIcon(icon: Icons.cake, color: Colors.pink, label: '12 DONUTS'),
                        _ItemIcon(icon: Icons.local_bar, color: Colors.amber, label: '6 CERVEZAS'),
                        _ItemIcon(icon: Icons.restaurant, color: Colors.orange, label: 'NACHOS GIGANTES'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Nombre del combo
                    Text(
                      favorito.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Descripción
                    Text(
                      favorito.description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Precio grande
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: Text(
                        '\$${favorito.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Botón enorme para agregar
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          cart.addItem(favorito);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '¡COMBO HOMER AGREGADO! 🍩🍺',
                                style: TextStyle(fontSize: 16),
                              ),
                              backgroundColor: Colors.pink,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[700],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          '¡QUIERO ESTE COMBO!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Mensaje especial
                    const Text(
                      '¡El combo perfecto para Homero!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          // Información adicional
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Card(
              color: Colors.amber,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '🍩 ¡EL COMBO MÁS PEDIDO! 🍺',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '12 donuts glaseados + 6 cervezas Duff + Nachos extra grandes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para los iconos de los items
class _ItemIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _ItemIcon({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlpha(50),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}