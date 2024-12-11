import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookService {
  final CollectionReference booksCollection = FirebaseFirestore.instance.collection('books');

  Future<void> addBook(Book book) async {
    await booksCollection.doc(book.id).set(book.toJson());
  }

  Stream<List<Book>> getBooks() {
    return booksCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Book.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }
}