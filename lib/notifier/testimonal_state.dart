import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidyamani/models/testimonial_model.dart';

final testimonialProvider = FutureProvider<Testimonial>((FutureProviderRef<Testimonial> ref) async {
  final querySnapshot = await FirebaseFirestore.instance.collection('testimonials').get();
  final testimonialData = Testimonial.fromMap(querySnapshot.docs.first.data());

  return testimonialData;
});
