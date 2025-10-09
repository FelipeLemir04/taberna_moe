import 'package:flutter/material.dart';
import 'package:taberna_moe/screens/pedidos_habituales_screen.dart';
import '../widgets/menu_card.dart';
import 'bebidas_screen.dart';
import 'comida_screen.dart';
import 'pedidos_habituales_screen.dart';
import 'ubicacion_screen.dart';
import 'contador_screen.dart';
import 'pagar_screen.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFFFD100); // amarillo estilo Simpsons

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Principal'),
        backgroundColor: bg,
        elevation: 0,
        foregroundColor: Colors.black54,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🟦 LOGO grande centrado arriba
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo/logo_taberna.png', // tu logo
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // 🟨 Menú principal
            Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  MenuCard(
                    imagePath: 'assets/images/bebidas/duff_original.jpg',
                    title: 'BEBIDAS',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BebidasScreen()),
                    ),
                  ),
                  MenuCard(
                    imagePath: 'assets/images/comida/papas1.jpg',
                    title: 'COMIDA',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ComidaScreen()),
                    ),
                  ),
                  MenuCard(
                    imagePath: 'assets/images/pedidos_habituales/pedido.jpg',
                    title: 'HABITUALES',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => PedidosHabitualesScreen()),
                    ),
                  ),
                  MenuCard(
                    imagePath: 'assets/images/ubicacion/ubicacion.jpg',
                    title: 'UBICACIÓN',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => UbicacionScreen()),
                    ),
                  ),
                  MenuCard(
                    imagePath: 'assets/images/contador/contador.jpg',
                    title: 'CONTADOR',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ContadorScreen()),
                    ),
                  ),
                  MenuCard(
                    imagePath: 'assets/images/pagar/pagar.jpg',
                    title: 'PAGAR',
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
