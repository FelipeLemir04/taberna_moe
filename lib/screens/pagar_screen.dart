import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PagarScreen extends StatefulWidget {
  const PagarScreen({Key? key}) : super(key: key);

  @override
  State<PagarScreen> createState() => _PagarScreenState();
}

class _PagarScreenState extends State<PagarScreen> {
  // Función para mostrar alerta de agua
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
    // Configurar el callback después de que el widget se inicialice
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cart = Provider.of<CartProvider>(context, listen: false);
      cart.onBeerWarning = () => _showWaterAlert(context, cart.dailyBeerCount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    // Configurar el callback cada vez que se construye
    cart.onBeerWarning = () => _showWaterAlert(context, cart.dailyBeerCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PAGAR',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🟢 DEUDA ACTUAL
            Card(
              color: Colors.red[100],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'DEBO:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '\$${cart.debt.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🟡 PAGAR DEUDA COMPLETA
            if (cart.debt > 0)
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    cart.payDebt(cart.debt);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          '¡DEUDA PAGADA!',
                          style: TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'PAGAR TODA LA DEUDA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // 🟠 PEDIDO ACTUAL
            Card(
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PEDIDO ACTUAL:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '\$${cart.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Información de cervezas pendientes
            if (cart.pendingBeerCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Cervezas en pedido: ${cart.pendingBeerCount}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.amber[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // 🟢 PAGAR AHORA
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: cart.total <= 0
                    ? null
                    : () {
                  final totalCart = cart.total;
                  cart.processPayment(); // PAGAR AHORA
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '¡PEDIDO LISTO! \$${totalCart.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'PAGAR AHORA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔴 PAGAR DESPUÉS
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: cart.total <= 0
                    ? null
                    : () {
                  final totalCart = cart.total;
                  cart.processPayment(addToDebt: true); // PAGAR DESPUÉS
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'AGREGADO A DEUDA: \$${totalCart.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'PAGAR DESPUÉS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🟤 CARRITO ACTUAL CON BOTÓN PARA ELIMINAR
            const Text(
              'MI PEDIDO:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // LISTA DEL CARRITO CON BOTÓN PARA ELIMINAR - CORREGIDO
            Expanded(
              child: cart.items.isEmpty
                  ? const Center(
                child: Text(
                  'CARRITO VACÍO',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView(
                children: cart.items.values.map((item) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: AssetImage(item.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(
                        'x${item.quantity}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Botón para eliminar producto - CORREGIDO
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              cart.removeItemCompletely(item.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${item.name} eliminado'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}