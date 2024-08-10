import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/web.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  Logger logger = Logger();

  // SignUp User
  Future<String> signUpUser(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        await _saveUserToStorage(userCredential.user!);
        return 'success';
      } else {
        return 'Failed to register user';
      }
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred';
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Logging in user with email and password
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      // Handling specific Firebase Auth errors
      switch (e.code) {
        case 'user-not-found':
          res = "No user found for that email.";
          break;
        case 'wrong-password':
          res = "Wrong password provided for that user.";
          break;
        case 'invalid-email':
          res = "The email address is badly formatted.";
          break;
        default:
          res = "An error occurred: ${e.message}";
      }
      logger.e(
          "FirebaseAuthException: ${e.message}"); // Log specific Firebase error
    } catch (e) {
      logger.e("Error during login: ${e.toString()}"); // Log general errors
      res = e.toString();
    }
    return res;
  }

  // for signOut
  Future<void> signOut() async {
    await _auth.signOut();
    await _secureStorage.delete(key: 'user');
  }

  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      Map<String, dynamic> userJson = {
        'uid': user?.uid,
        'displayName': user?.displayName,
        'email': user?.email,
        'photoURL': user?.photoURL,
        'phoneNumber': user?.phoneNumber,
        'isAnonymous': user?.isAnonymous,
        'emailVerified': user?.emailVerified,
        'metadata': {
          'creationTime': user?.metadata.creationTime?.toIso8601String(),
          'lastSignInTime': user?.metadata.lastSignInTime?.toIso8601String(),
        },
        'providerData': user?.providerData.map((userInfo) {
          return {
            'providerId': userInfo.providerId,
            'uid': userInfo.uid,
            'displayName': userInfo.displayName,
            'email': userInfo.email,
            'photoURL': userInfo.photoURL,
            'phoneNumber': userInfo.phoneNumber,
          };
        }).toList(),
      };

      logger.f(userJson);

      await _secureStorage.write(key: 'user', value: jsonEncode(userJson));
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveUserToStorage(User user) async {
    final Map<String, dynamic> userData = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
    };
    await _secureStorage.write(key: 'user', value: jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final String? userJson = await _secureStorage.read(key: 'user');
      if (userJson != null) {
        return jsonDecode(userJson);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
