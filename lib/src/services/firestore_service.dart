import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FS {
  static final _db = FirebaseFirestore.instance;
  static String get uid => FirebaseAuth.instance.currentUser!.uid;

  // paths
  static CollectionReference<Map<String,dynamic>> veiculosCol() =>
    _db.collection('usuarios').doc(uid).collection('veiculos');

  static CollectionReference<Map<String,dynamic>> abastecimentosCol() =>
    _db.collection('usuarios').doc(uid).collection('abastecimentos');
}
