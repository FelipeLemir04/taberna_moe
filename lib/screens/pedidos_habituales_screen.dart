import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/item.dart';

class PedidosHabitualesScreen extends StatelessWidget {
  // Solo el combo favorito de Homero
  final Item comboHomer = Item(
      id: 'combo_homer',
      name: 'COMBO HOMER',
      description: '12 Donuts + 6 Cervezas + Nachos Gigantes',
      image: 'assets/images/pedidos_habituales/favhomero.jpg',
      price: 25.0
  );

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
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                // IMAGEN GRANDE EN LA PARTE SUPERIOR
                Container(
                  height: 200, // Más grande
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    color: Colors.amber[50],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: Image.asset(
                      comboHomer.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Si no hay imagen, mostrar placeholder atractivo
                        return Container(
                          color: Colors.amber[100],
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fastfood,
                                size: 60,
                                color: Colors.amber,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'COMBO HOMER',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.brown,
                                ),
                              ),
                              Text(
                                '🍩 12 Donuts + 🍺 6 Cervezas + 🧀 Nachos',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.brown,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // CONTENIDO DEBAJO DE LA IMAGEN
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Nombre del combo DEBAJO de la imagen
                      Text(
                        comboHomer.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Descripción
                      Text(
                        comboHomer.description,
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
                          '\$${comboHomer.price.toStringAsFixed(0)}',
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
                            cart.addItem(comboHomer);
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
              ],
            ),
          ),

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