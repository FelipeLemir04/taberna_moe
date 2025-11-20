import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import 'package:intl/intl.dart';

class CartProvider with ChangeNotifier {
  final Map<String, Item> _items = {};
  double _debt = 0.0;
  int _dailyBeerCount = 0;
  String? _lastResetDate;

  // Callbacks de alerta
  VoidCallback? onBeerWarning;

  CartProvider() {
    _loadFromPrefs();
  }

  // GETTERS
  Map<String, Item> get items => {..._items};

  double get total {
    double s = 0.0;
    _items.forEach((k, item) => s += item.price * item.quantity);
    return s;
  }

  double get debt => _debt;
  int get dailyBeerCount => _dailyBeerCount;

  // Cervezas en el carrito (sin contar aún)
  int get pendingBeerCount {
    int count = 0;
    _items.forEach((key, item) {
      if (item.id.toLowerCase().contains("beer")) {
        count += item.quantity;
      }
    });
    return count;
  }

  void addItem(Item item, {int amount = 1}) {
    // Agregar producto SIN sumar al contador de cervezas
    if (_items.containsKey(item.id)) {
      _items[item.id]!.quantity += amount;
    } else {
      _items[item.id] = Item(
        id: item.id,
        name: item.name,
        description: item.description,
        image: item.image,
        price: item.price,
        quantity: amount,
      );
    }

    notifyListeners();
    saveToPrefs();
  }

  void removeItem(String id, {int amount = 1}) {
    if (!_items.containsKey(id)) return;

    _items[id]!.quantity -= amount;

    if (_items[id]!.quantity <= 0) {
      _items.remove(id);
    }

    notifyListeners();
    saveToPrefs();
  }

  // Eliminar producto completamente del carrito
  void removeItemCompletely(String id) {
    if (_items.containsKey(id)) {
      _items.remove(id);
      notifyListeners();
      saveToPrefs();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    saveToPrefs();
  }

  void addToDebt(double amount) {
    _debt += amount;
    notifyListeners();
    saveToPrefs();
  }

  void payDebt(double amount) {
    _debt = (_debt - amount).clamp(0.0, double.infinity);
    notifyListeners();
    saveToPrefs();
  }

  // MÉTODO CORREGIDO: Procesar pago y contar cervezas
  void processPayment({bool addToDebt = false}) {
    final double totalAmount = total;

    // 1. Contar cervezas antes de limpiar el carrito
    int beersToCount = 0;
    _items.forEach((key, item) {
      if (item.id.toLowerCase().contains("beer")) {
        beersToCount += item.quantity;
      }
    });

    // 2. Manejar deuda si es necesario
    if (addToDebt) {
      _debt += totalAmount;
    }

    // 3. Contar las cervezas en el contador diario
    if (beersToCount > 0) {
      final oldBeerCount = _dailyBeerCount;
      _dailyBeerCount += beersToCount;

      // 4. Verificar si debemos mostrar alerta de agua
      if (_dailyBeerCount >= 5) {
        final currentMultiple = _dailyBeerCount ~/ 5;
        final previousMultiple = oldBeerCount ~/ 5;

        if (currentMultiple > previousMultiple) {
          if (onBeerWarning != null) {
            onBeerWarning!();
          }
        }
      }
    }

    // 5. Limpiar carrito después del pago
    _items.clear();

    notifyListeners();
    saveToPrefs();
  }

  Future<void> checkDailyReset() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _lastResetDate = prefs.getString('lastResetDate') ?? today;

    if (_lastResetDate != today) {
      _dailyBeerCount = 0;
      _lastResetDate = today;
      await prefs.setString('lastResetDate', today);
      await prefs.setInt('dailyBeerCount', 0);
      notifyListeners();
    }
  }

  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = _items.map((k, v) => MapEntry(k, {
      'id': v.id,
      'name': v.name,
      'description': v.description,
      'image': v.image,
      'price': v.price,
      'quantity': v.quantity,
    }));

    prefs.setString('cart_items', jsonEncode(itemsJson));
    prefs.setDouble('debt', _debt);
    prefs.setInt('dailyBeerCount', _dailyBeerCount);
    prefs.setString('lastResetDate', _lastResetDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('cart_items');

    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      map.forEach((k, v) {
        _items[k] = Item(
          id: v['id'],
          name: v['name'],
          description: v['description'],
          image: v['image'],
          price: (v['price'] as num).toDouble(),
          quantity: v['quantity'],
        );
      });
    }

    _debt = prefs.getDouble('debt') ?? 0.0;
    _dailyBeerCount = prefs.getInt('dailyBeerCount') ?? 0;

    _lastResetDate = prefs.getString('lastResetDate') ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    await checkDailyReset();
    notifyListeners();
  }
}