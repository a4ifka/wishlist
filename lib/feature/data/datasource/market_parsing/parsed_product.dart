class ParsedProduct {
  final String name;
  final double price;
  final String? imageUrl;

  const ParsedProduct({
    required this.name,
    required this.price,
    this.imageUrl,
  });
}
