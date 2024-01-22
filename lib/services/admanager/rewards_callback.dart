import 'package:cloud_firestore/cloud_firestore.dart';



class UserCoinsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> updateCoins(String userId, int coinsToAdd) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      int currentCoins = userSnapshot['coins'] ?? 0;
      int newCoins = currentCoins + coinsToAdd;
      await _firestore
          .collection('users')
          .doc(userId)
          .update({'coins': newCoins});

      print('Coins updated successfully. New coins value: $newCoins');
    } catch (e) {
      print('Error updating coins: $e');
      throw e;
    }
  }
}
