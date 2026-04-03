import '../../domain/models/hadith.dart';

abstract class MobileHadithSearchRepository {
  Future<List<Hadith>> searchHadiths({
    required String searchQuery,
    List<String>? rawiIds,
    List<String>? muhaddithIds,
    List<String>? topicIds,
    List<String>? bookIds,
    List<String>? rulingIds,
    List<String>? types,
    String searchMode = 'any',
  });
}
