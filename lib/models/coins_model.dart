class Coins {
  final num coinsForGold;
  final num coinsToRupee;
    final num rupeesForGold;
  Coins({
    required this.coinsToRupee,
    required this.coinsForGold,
    required this.rupeesForGold
  });

  factory Coins.fromMap(Map<String, dynamic> map) {
    return Coins(coinsToRupee: map['coinsToRupee'] ?? 0,
    coinsForGold: map['coinsForGold'] ?? 0,
    rupeesForGold: map['rupeesForGold'] ?? 0);
  }
}
