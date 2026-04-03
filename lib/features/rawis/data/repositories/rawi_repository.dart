import '../../domain/models/rawi.dart';

abstract class RawiRepository {
  Future<List<Rawi>> getRawis(String? searchQuery);
  Future<void> createRawi(Rawi rawi);
  Future<void> updateRawi(Rawi rawi);
  Future<void> deleteRawi(String id);
  Stream<List<Rawi>> getRawisStream();
}
