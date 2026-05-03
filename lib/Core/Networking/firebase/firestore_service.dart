import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Helper to inject the document ID into the map so Repos can use it
  static Map<String, dynamic> _injectId(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    data['doc_id'] = doc.id; 
    return data;
  }

  // ================= MAIN COLLECTION METHODS =================

/// Fetches all documents from a main collection
  static Future<List<Map<String, dynamic>>> getCollection({
    required String collectionName,
  }) async {
    final snapshot = await _db.collection(collectionName).get();
    return snapshot.docs.map((doc) => _injectId(doc)).toList();
  }

  /// Adds a document to a main collection with an auto-generated ID
  static Future<DocumentReference> addDocument({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    return await _db.collection(collectionName).add(data);
  }

  /// Deletes a document from a main collection
  static Future<void> deleteDocument({
    required String collectionName,
    required String docId,
  }) async {
    await _db.collection(collectionName).doc(docId).delete();
  }
  
   /// Checks if a document exists in a main collection
  static Future<Map<String, dynamic>?> getDocument({
    required String collectionName,
    required String docId,
  }) async {
    final doc = await _db.collection(collectionName).doc(docId).get();
    if (doc.exists && doc.data() != null) return _injectId(doc);
    return null;
  }

  static Future<void> setDocument({
    required String collectionName,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(collectionName).doc(docId).set(data);
  }

  static Future<void> updateDocument({
    required String collectionName,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(collectionName).doc(docId).update(data);
  }

  // ================= SUB-COLLECTION METHODS =================

  /// Fetches a single document from a sub-collection
  static Future<Map<String, dynamic>?> getSubCollectionDocument({
    required String parentCollection,
    required String parentDocId,
    required String subCollectionName,
    required String docId,
  }) async {
    final doc = await _db.collection(parentCollection).doc(parentDocId)
        .collection(subCollectionName).doc(docId).get();
    if (doc.exists && doc.data() != null) return _injectId(doc);
    return null;
  }

  /// Fetches all documents from a sub-collection
  static Future<List<Map<String, dynamic>>> getSubCollection({
    required String parentCollection,
    required String parentDocId,
    required String subCollectionName,
  }) async {
    final snapshot = await _db.collection(parentCollection).doc(parentDocId)
        .collection(subCollectionName).get();
    return snapshot.docs.map((doc) => _injectId(doc)).toList();
  }

  /// Fetches sub-collection documents ordered by a specific field
  static Future<List<Map<String, dynamic>>> getSubCollectionOrdered({
    required String parentCollection,
    required String parentDocId,
    required String subCollectionName,
    required String orderByField,
    bool descending = false,
  }) async {
    final snapshot = await _db.collection(parentCollection).doc(parentDocId)
        .collection(subCollectionName).orderBy(orderByField, descending: descending).get();
    return snapshot.docs.map((doc) => _injectId(doc)).toList();
  }

  /// Fetches sub-collection documents matching a specific condition
  static Future<List<Map<String, dynamic>>> getSubCollectionWithCondition({
    required String parentCollection,
    required String parentDocId,
    required String subCollectionName,
    required String field,
    required dynamic isEqualTo,
  }) async {
    final snapshot = await _db.collection(parentCollection).doc(parentDocId)
        .collection(subCollectionName).where(field, isEqualTo: isEqualTo).get();
    return snapshot.docs.map((doc) => _injectId(doc)).toList();
  }

  /// Adds a document to a sub-collection with an auto-generated ID
  static Future<void> addSubCollectionDocument({
    required String parentCollection,
    required String parentDocId,
    required String subCollectionName,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(parentCollection).doc(parentDocId).collection(subCollectionName).add(data);
  }

  /// Sets a document in a sub-collection with a specific custom ID
  static Future<void> setSubCollectionDocument({
    required String parentCollection,
    required String parentDocId,
    required String subCollectionName,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(parentCollection).doc(parentDocId)
        .collection(subCollectionName).doc(docId).set(data);
  }

  /// Updates specific fields in a sub-collection document
  static Future<void> updateSubCollectionDocument({
    required String parentCollection,
    required String parentDocId,
    required String subCollectionName,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await _db.collection(parentCollection).doc(parentDocId)
        .collection(subCollectionName).doc(docId).update(data);
  }

  /// Deletes a document from a sub-collection
  static Future<void> deleteSubCollectionDocument({
    required String parentCollection,
    required String parentDocId,
    required String subCollectionName,
    required String docId,
  }) async {
    await _db.collection(parentCollection).doc(parentDocId)
        .collection(subCollectionName).doc(docId).delete();
  }

  /// Checks if a document exists in a sub-collection
  static Future<bool> checkSubCollectionDocExists({
    required String parentCollection,
    required String parentDocId,
    required String subCollectionName,
    required String docId,
  }) async {
    final doc = await _db.collection(parentCollection).doc(parentDocId)
        .collection(subCollectionName).doc(docId).get();
    return doc.exists;
  }
}