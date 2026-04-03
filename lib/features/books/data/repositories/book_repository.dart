import '../../domain/models/book.dart';

abstract class BookRepository {
  Future<List<Book>> getBooks(String? searchQuery);
  Future<void> createBook(Book book);
  Future<void> updateBook(Book book);
  Future<void> deleteBook(String id);
  Stream<List<Book>> getBooksStream();
}
