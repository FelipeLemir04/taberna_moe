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
      appBar: AppBar(title: Text('Pedidos Habituales')),
      body: ListView.builder(
        itemCount: pedidosHabituales.length,
        itemBuilder: (ctx, i) {
          final pedido = pedidosHabituales[i];
          return ListTile(
            leading: Image.asset(pedido.image, width: 50, fit: BoxFit.cover),
            title: Text(pedido.name),
            subtitle: Text(pedido.description),
            trailing: Text('\$${pedido.price.toStringAsFixed(2)}'),
            onTap: () {
              cart.addItem(pedido);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${pedido.name} agregado al carrito')));
            },
          );
        },
      ),
    );
  }
}

