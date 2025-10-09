class Item {
  final String id;
  final String name;
  final String description;
  final String image; // path in assets
  final double price;
  int quantity;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    this.quantity = 0,
  });
}

