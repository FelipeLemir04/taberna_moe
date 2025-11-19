import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/menu_card.dart';
import '../providers/cart_provider.dart';

import 'bebidas_screen.dart';
import 'comida_screen.dart';
import 'ubicacion_screen.dart';
import 'pedidos_habituales_screen.dart';
import 'pagar_screen.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFFD100);

    // 🔹 Obtener CartProvider
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // 🔹 Acción al llegar a múltiplos de 5 cervezas
    cartProvider.onBeerLimitReached = () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Toma agua! 🍺💧'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    };

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // 🟦 LOGO + CONTADOR ARRIBA A LA DERECHA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // LOGO
                  Image.asset(
                    'assets/images/logo/logo_taberna.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),

                  // CONTADOR (CERVEZAS HOY)
                  Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              '🍺',
                              style: TextStyle(fontSize: 22),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${cart.dailyBeerCount}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // 🟨 TÍTULO
            const Text(
              '¡HOLA!',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),

            // 🟩 BOTONES GRANDES
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(15),
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  // CERVEZA
                  _BigButton(
                    image: 'assets/images/bebidas/duff.jpg',
                    text: '🍺 CERVEZA',
                    color: Colors.amber[700]!,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BebidasScreen()),
                    ),
                  ),

                  // COMIDA
                  _BigButton(
                    image: 'assets/images/comida/papas1.jpg',
                    text: '🍔 COMIDA',
                    color: Colors.orange[700]!,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ComidaScreen()),
                    ),
                  ),

                  // USUAL
                  _BigButton(
                    image: 'assets/images/pedidos_habituales/pedido.jpg',
                    text: '⭐ USUAL',
                    color: Colors.yellow[700]!,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PedidosHabitualesScreen()),
                    ),
                  ),

                  // DÓNDE ESTOY
                  _BigButton(
                    image: 'assets/images/ubicacion/ubicacion.jpg',
                    text: '🗺️ DÓNDE ESTOY',
                    color: Colors.blue[400]!,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => UbicacionScreen()),
                    ),
                  ),

                  // PAGAR
                  _BigButton(
                    image: 'assets/images/pagar/pagar.jpg',
                    text: '💵 PAGAR',
                    color: Colors.green[600]!,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PagarScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🟪 BOTÓN GRANDE SIMPLE
class _BigButton extends StatelessWidget {
  final String image;
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _BigButton({
    required this.image,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IMAGEN
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),

            const SizedBox(height: 8),

            // TEXTO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


