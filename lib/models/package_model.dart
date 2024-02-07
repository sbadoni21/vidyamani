class Packages {
  final num goldPackagePrice;
  final num premiumPackagePrice;

  Packages({
    required this.goldPackagePrice,
    required this.premiumPackagePrice,
  });

  factory Packages.fromMap(Map<String, dynamic> map) {
    return Packages(
      goldPackagePrice: map['goldPackagePrice'] ?? 0,
      premiumPackagePrice: map['premiumPackagePrice'] ?? 0,
    );
  }
}
