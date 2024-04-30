import 'package:cloud_firestore/cloud_firestore.dart';

class UserF {
  String? uid;
  String? email;
  String? profileImageUrl;
  String? name;
  String? brainTumorImage;
  String? pneumoniaImage;

  UserF({
    this.uid,
    this.email,
    this.name,
    this.brainTumorImage,
    this.pneumoniaImage,
    this.profileImageUrl,
  });

  factory UserF.fromFirebase(UserF firebaseUser) {
    return UserF(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
    );
  }

  factory UserF.fromDocument(DocumentSnapshot doc) {
    return UserF(
      uid: doc['uid'],
      email: doc['email'],
      name: doc['name'],
      brainTumorImage: doc['image_url_brain_tumor'],
      pneumoniaImage: doc['image_url_pneumonia'],
      profileImageUrl: doc['profile_image_url'],
    );
  }
}
