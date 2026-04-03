import '../../domain/models/similar_ahadith.dart';

abstract class SimilarAhadithRepository {
  Future<List<SimilarAhadith>> getSimilarAhadiths(String? searchQuery);
  Future<SimilarAhadith> createSimilarAhadith(SimilarAhadith similarAhadith);
  Future<SimilarAhadith> updateSimilarAhadith(SimilarAhadith similarAhadith);
  Future<void> deleteSimilarAhadith(String id);
  Stream<List<SimilarAhadith>> getSimilarAhadithsStream();
}
