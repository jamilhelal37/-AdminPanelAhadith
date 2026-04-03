import '../../domain/models/ruling.dart';

abstract class RulingRepository {
  Future<List<Ruling>> getRulings(String? searchQuery);
  Future<void> createRuling(Ruling ruling);
  Future<void> updateRuling(Ruling ruling);
  Future<void> deleteRuling(String id);
  Stream<List<Ruling>> getRulingsStream();
}
