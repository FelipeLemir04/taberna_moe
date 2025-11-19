import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item.dart';
import 'package:intl/intl.dart';

class CartProvider with ChangeNotifier {
  final Map<String, Item> _items = {};
  double _debt = 0.0;

  int _dailyBeerCount = 0; // Total de cervezas
  String? _lastResetDate;

  // 🔔 Callback de alerta
  VoidCallback? onBeerWarning;

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

  // ---------------------------------------------------
  // 🚨 ALERTA DE TOMAR AGUA (CADA 5 CERVEZAS)
  // ---------------------------------------------------
  void addItem(Item item, {int amount = 1}) {
    final isBeer = item.id.toLowerCase().contains("beer");

    // Agregar producto
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

    // Si es cerveza → sumar al contador
    if (isBeer) {
      _dailyBeerCount += amount;

      // Cada 5 cervezas exactas → alerta
      if (_dailyBeerCount % 5 == 0) {
        if (onBeerWarning != null) onBeerWarning!();
      }
    }

    notifyListeners();
    saveToPrefs();
  }

  // ---------------------------------------------------
  // REMOVER ITEMS
  // ---------------------------------------------------
  void removeItem(String id, {int amount = 1}) {
    if (!_items.containsKey(id)) return;

    final isBeer = id.toLowerCase().contains("beer");

    _items[id]!.quantity -= amount;

    if (isBeer) {
      _dailyBeerCount -= amount;
      if (_dailyBeerCount < 0) _dailyBeerCount = 0;
    }

    if (_items[id]!.quantity <= 0) {
      _items.remove(id);
    }

    notifyListeners();
    saveToPrefs();
  }

  // ---------------------------------------------------
  // AUMENTAR / DISMINUIR
  // ---------------------------------------------------
  void increaseQuantity(String id) {
    if (_items.containsKey(id)) {
      final isBeer = id.toLowerCase().contains("beer");

      _items[id]!.quantity++;

      if (isBeer) {
        _dailyBeerCount++;

        if (_dailyBeerCount % 5 == 0) {
          if (onBeerWarning != null) onBeerWarning!();
        }
      }

      notifyListeners();
      saveToPrefs();
    }
  }

  void decreaseQuantity(String id) {
    if (!_items.containsKey(id)) return;

    final isBeer = id.toLowerCase().contains("beer");

    _items[id]!.quantity--;

    if (isBeer) {
      _dailyBeerCount--;
      if (_dailyBeerCount < 0) _dailyBeerCount = 0;
    }

    if (_items[id]!.quantity <= 0) {
      _items.remove(id);
    }

    notifyListeners();
    saveToPrefs();
  }

  // ---------------------------------------------------
  // CONFIRMAR EN PAGO
  // ---------------------------------------------------
  void confirmItemsAtPayment() {
    notifyListeners();
    saveToPrefs();
  }

  // ---------------------------------------------------
  // 🔵 NUEVO: VACIAR TODO EL CARRITO
  // ---------------------------------------------------
  void clearAllItems() {
    _items.clear();

    // No eliminar conteo de cerveza (es diario)
    notifyListeners();
    saveToPrefs();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    saveToPrefs();
  }

  // ---------------------------------------------------
  // DEUDA
  // ---------------------------------------------------
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

  // ---------------------------------------------------
  // RESETEO DIARIO
  // ---------------------------------------------------
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

  // ---------------------------------------------------
  // GUARDAR EN PREFS
  // ---------------------------------------------------
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final itemsJson = _items.map(
          (k, v) => MapEntry(k, {
        'id': v.id,
        'name': v.name,
        'description': v.description,
        'image': v.image,
        'price': v.price,
        'quantity': v.quantity,
      }),
    );

    prefs.setString('cart_items', jsonEncode(itemsJson));
    prefs.setDouble('debt', _debt);
    prefs.setInt('dailyBeerCount', _dailyBeerCount);

    prefs.setString(
      'lastResetDate',
      _lastResetDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
  }

  // ---------------------------------------------------
  // CARGAR PREFS
  // ---------------------------------------------------
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

    // ⚠️ RECONSTRUIR TOTAL DE CERVEZAS REAL
    _dailyBeerCount = 0;
    for (var item in _items.values) {
      if (item.id.toLowerCase().contains("beer")) {
        _dailyBeerCount += item.quantity;
      }
    }

    _lastResetDate = prefs.getString('lastResetDate') ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    await checkDailyReset();
    notifyListeners();
  }
}



