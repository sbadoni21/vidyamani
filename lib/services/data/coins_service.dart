import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vidyamani/models/coins_model.dart';

class CoinsService {
  final CollectionReference coinsCollection =
      FirebaseFirestore.instance.collection('coins');

  Future<Coins> getCoinsData() async {
    try {
      DocumentSnapshot documentSnapshot =
          await coinsCollection.doc('coins').get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        Coins coins = Coins.fromMap(data);
        return coins;
      } else {
        return Coins(
            coinsToRupee: 0, coinsForGold: 0, rupeesForGold: 0, id: '');
      }
    } catch (e) {
     const SnackBar(content: Text("Error getting Coin Data"));
      rethrow;
    }
  }
}
