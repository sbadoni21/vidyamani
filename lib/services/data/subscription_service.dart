import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:vidyamani/models/user_model.dart';

class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> changeUserType(String userID, String packageType) async {
    try {
      DocumentReference userReference =
          _firestore.collection('users').doc(userID);
      DocumentSnapshot userSnapshot = await userReference.get();
      if (userSnapshot.exists) {
        DateTime subscriptionStartDate = DateTime.now();
        DateTime subscriptionEndDate =
            subscriptionStartDate.add(Duration(days: 30));
        String formattedStartDate =
            DateFormat('dd-MM-yyyyTHH:mm').format(subscriptionStartDate);
        String formattedEndDate =
            DateFormat('dd-MM-yyyyTHH:mm').format(subscriptionEndDate);

        await userReference.update({
          'type': packageType,
          'subscriptionStart': formattedStartDate,
          'subscriptionEnd': formattedEndDate,
        });
        print('User type and subscription updated successfully.');
      } else {
        print('User not found.');
      }
    } catch (e) {
      print('Error updating user type and subscription: $e');
    }
  }

  Future<void> changeUserTypeViaCoinToGold(String userID) async {
    try {
      DocumentReference userReference =
          _firestore.collection('users').doc(userID);
      DocumentSnapshot userSnapshot = await userReference.get();
      if (userSnapshot.exists) {
        DateTime subscriptionStartDate = DateTime.now();
        DateTime subscriptionEndDate =
            subscriptionStartDate.add(Duration(days: 30));
        await userReference.update({
          'type': 'gold',
          'subscriptionStart': subscriptionStartDate,
          'subscriptionEnd': subscriptionEndDate,
        });
        print('User type and subscription updated successfully.');
      } else {
        print('User not found.');
      }
    } catch (e) {
      print('Error updating user type and subscription: $e');
    }
  }

  Future<void> fetchSubscriptionStatus(String userID) async {
    try {
      DocumentReference userReference =
          _firestore.collection('users').doc(userID);
      DocumentSnapshot userSnapshot = await userReference.get();

      if (userSnapshot.exists) {
        User user = User.fromMap(userSnapshot.data() as Map<String, dynamic>);
        DateTime? subscriptionEndDate;
        if (user.subscriptionEnd != null) {
          subscriptionEndDate =
              DateFormat("dd-MM-yyyyTHH:mm").parse(user.subscriptionEnd);
        }

        DateTime now = DateTime.now();

        if (subscriptionEndDate != null &&
            subscriptionEndDate.isBefore(now) &&
            user.type != 'free') {
          await userReference.update({
            'type': 'free',
            'subscriptionStart': "01-01-1901T01:00",
            'subscriptionEnd': "01-01-2099T01:00",
          });
        } else {
          print('Subscription is still active.');
        }
      } else {
        print('User not found.');
      }
    } catch (e) {
      print('Error updating user type and subscription: $e');
    }
  }
}
