import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestoreHelper {
  CloudFirestoreHelper._();
  static final CloudFirestoreHelper cloudFirestoreHelper =
      CloudFirestoreHelper._();

  static final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  late CollectionReference votekepperRef;
  void connectWithCollection() {
    votekepperRef = firebaseFirestore.collection("vote");
  }

  Future<void> insertrecord({required Map<String, dynamic> data}) async {
    connectWithCollection();

    await votekepperRef.doc().set(data);
  }

  Stream<QuerySnapshot> selectrecord() {
    connectWithCollection();

    return votekepperRef.snapshots();
  }

  Future<void> updateRecords(
      {required String id, required Map<String, dynamic> data}) async {
    connectWithCollection();

    await votekepperRef.doc(id).update(data);
  }
}
