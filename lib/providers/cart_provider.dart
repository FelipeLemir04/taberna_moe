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

  // 🔹 Callback para advertencia cada 5 cervezas
  VoidCallback? onBeerLimitReached;

  CartProvider() {
    _loadFromPrefs();
  }

  Map<String, Item> get items => {..._items};

  double get total {
    double s = 0.0;
    _items.forEach((k, item) => s += item.price * item.quantity);
    return s;
  }

  double get debt => _debt;
  int get dailyBeerCount => _dailyBeerCount;

  // -----------------------------------------------------
  // 🔥 Ya no suma cervezas al agregar al carrito
  // -----------------------------------------------------
  void addItem(Item item, {int amount = 1}) {
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

    final existing = _items[id]!;
    existing.quantity -= amount;

    if (existing.quantity <= 0) {
      _items.remove(id);
    }

    notifyListeners();
    saveToPrefs();
  }

  // 🔹 Aumentar cantidad de un item del carrito
  void increaseQuantity(String id) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
      notifyListeners();
      saveToPrefs();
    }
  }

// 🔹 Disminuir cantidad
  void decreaseQuantity(String id) {
    if (!_items.containsKey(id)) return;

    _items[id]!.quantity--;
    if (_items[id]!.quantity <= 0) {
      _items.remove(id);
    }

    notifyListeners();
    saveToPrefs();
  }

// 🔹 Confirmar ítems al momento de PAGAR
// Aquí SÍ se suman cervezas al contador
  void confirmItemsAtPayment() {
    for (final item in _items.values) {
      if (item.id.startsWith("beer")) {
        _dailyBeerCount += item.quantity;

        // Aviso cada 5 cervezas
        if (_dailyBeerCount % 5 == 0) {
          if (onBeerLimitReached != null) {
            onBeerLimitReached!();
          }
        }
      }
    }

    notifyListeners();
    saveToPrefs();
  }


  void clearCart() {
    _items.clear();
    notifyListeners();
    saveToPrefs();
  }

  // -----------------------------------------------------
  // 🔥 SUMAR cervezas SOLO al pagar
  // -----------------------------------------------------
  void addBeersFromCart() {
    int beersInCart = 0;

    _items.forEach((key, item) {
      if (item.id.startsWith("beer")) {
        beersInCart += item.quantity;
      }
    });

    _dailyBeerCount += beersInCart;

    // Mostrar advertencia si toca múltiplo de 5
    if (beersInCart > 0 && _dailyBeerCount % 5 == 0) {
      if (onBeerLimitReached != null) {
        onBeerLimitReached!();
      }
    }

    saveToPrefs();
    notifyListeners();
  }

  // -----------------------------------------------------
  // MANEJO DE DEUDA
  // -----------------------------------------------------
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

  // -----------------------------------------------------
  // Reinicio diario del contador
  // -----------------------------------------------------
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

  // -----------------------------------------------------
  // Persistencia
  // -----------------------------------------------------
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
    prefs.setString(
      'lastResetDate',
      _lastResetDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
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
    _lastResetDate = prefs.getString('lastResetDate') ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    await checkDailyReset();
    notifyListeners();
  }
}
