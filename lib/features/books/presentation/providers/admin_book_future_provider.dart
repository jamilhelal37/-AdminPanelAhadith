import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/book_repository_provider.dart';
import '../../domain/models/book.dart';
import 'search_provider.dart';

var adminBooksFutureProvider = FutureProvider<List<Book>>((ref) async {
  var repo = ref.read(bookRepositoryProvider);
  var search = ref.watch(searchProvider);
  return repo.getBooks(search);
});

final allBooksFutureProvider = FutureProvider<List<Book>>((ref) async {
  final repo = ref.read(bookRepositoryProvider);
  return repo.getBooks(null);
});
