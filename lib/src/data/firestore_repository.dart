import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker_app_flutter_firebase/src/data/job.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirestoreRepository {
  final FirebaseFirestore _firestore;

  FirestoreRepository(this._firestore);

  Future<void> addJob(String uid, String title, String company) async {
    final docRef = await _firestore.collection('jobs').add({
      'uid': uid,
      'title': title,
      'company': company,
      'createdAt': FieldValue.serverTimestamp(),
    });
    debugPrint('Added document: ${docRef.id}');
  }

  Future<void> updateJob(
          String jobId, String uid, String title, String company) =>
      _firestore.collection('jobs').doc(jobId).update({
        'uid': uid,
        'title': title,
        'company': company,
      });

  Query<Job> jobsQuery(
    String uid,
  ) {
    return _firestore
        .collection('jobs')
        .withConverter(
            fromFirestore: (snapshot, _) => Job.fromMap(snapshot.data()!),
            toFirestore: (job, _) => job.toMap())
        // .where('uid', isEqualTo: uid)
        .orderBy('createdAt', descending: true);
  }

  void deleteJob(String uid, String jobId) {
    _firestore.collection('jobs').doc(jobId).delete();
  }
}

final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref) {
  return FirestoreRepository(FirebaseFirestore.instance);
});
