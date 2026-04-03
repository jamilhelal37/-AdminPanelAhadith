import '../../domain/models/explaining.dart';

abstract class ExplainingRepository {
  Future<List<Explaining>> getExplainings(String? searchQuery);
  Future<void> createExplaining(Explaining explaining);
  Future<void> updateExplaining(Explaining explaining);
  Future<void> deleteExplaining(String id);
  Stream<List<Explaining>> getExplainingsStream();
}
