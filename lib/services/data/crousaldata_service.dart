import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidyamani/models/crousal_model.dart';
import 'package:riverpod/riverpod.dart';

final carousalProvider = FutureProvider<List<Carousal>>((ref) {
  return CarousalDataService().getCarousalData();
});

class CarousalDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Carousal>> getCarousalData() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection("carouselImages").get();

      List<Carousal> carousals = querySnapshot.docs
          .map((doc) => Carousal.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return carousals;
    } catch (e) {
      print("Error getting carousel data: $e");
      return [];
    }
  }
}
