
class Medicine {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final DateTime expiryDate;

  const Medicine({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.expiryDate,
  });

  bool get isLowStock => quantity <= 10;

  bool get isExpired =>
      expiryDate.isBefore(DateTime.now());

  bool get isAvailable =>
      quantity > 0 && !isExpired;
}
