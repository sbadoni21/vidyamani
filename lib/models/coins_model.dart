class Coins {
  final num coinsForGold;
  final num coinsToRupee;
  final num rupeesForGold;
  final String id;
  Coins(
      {required this.coinsToRupee,
      required this.coinsForGold,
      required this.rupeesForGold,
      required this.id});

  factory Coins.fromMap(Map<String, dynamic> map) {
    return Coins(
        coinsToRupee: map['coinsToRupee'] ?? 0,
        coinsForGold: map['coinsForGold'] ?? 0,
        id: map['id'] ?? '',
        rupeesForGold: map['rupeesForGold'] ?? 0);
  }
}
