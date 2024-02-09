import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vidyamani/models/crousal_model.dart';
import 'package:riverpod/riverpod.dart';


final carousalProvider = FutureProvider<List<Carousal>>((ref) {
  return  CarousalDataService().getCarousalData();
});

class CarousalDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Carousal>> getCarousalData() async {
    try {
      DocumentSnapshot documentSnapshot = await _firestore
          .collection("carouselImages")
          .doc("gn2wh3DadblTv4pZr90T")
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        if (data != null) {
          return [Carousal.fromMap(data)];
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

