import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

class AuthBase {

  // Future<UserF?> googleSignUp() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser!.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     await FirebaseAuth.instance
  //         .signInWithCredential(credential)
  //         .then((value) {
  //       FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(value.user!.uid)
  //           .set({
  //         'email': value.user!.email,
  //         'name': value.user!.displayName,
  //         'profile_image_url': value.user!.photoURL,
  //         'uid': value.user!.uid,
  //         'image_url_pneumonia': null,
  //         'image_url_brain_tumor': null,
  //       });
  //     });
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //     return null;
  //   }
  //   return null;
  // }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
