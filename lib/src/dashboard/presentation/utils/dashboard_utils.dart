import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/src/auth/data/models/local_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardUtils {
  DashboardUtils._();

  static Stream<LocalUserModel> get userDataStream => sl<FirebaseFirestore>()
          .collection('users')
          .doc(sl<FirebaseAuth>().currentUser!.uid)
          .snapshots()
          .map((event) {
        return LocalUserModel.fromMap(event.data()!);
      });
}
