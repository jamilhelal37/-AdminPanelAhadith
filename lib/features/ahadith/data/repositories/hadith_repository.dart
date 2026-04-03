import '../../domain/models/hadith.dart';
import '../../domain/models/hadith_page_result.dart';

abstract class HadithRepository {
  Future<List<Hadith>> getHadiths({
    String? searchQuery,
    List<String>? rawiIds,
    List<String>? muhaddithIds,
    List<String>? topicIds,
    List<String>? bookIds,
    List<String>? rulingIds,
    List<String>? types,
    int? limit,
    String searchMode = 'any',
  });

  Future<HadithPageResult> getHadithsPage({
    String? searchQuery,
    int page = 1,
    int pageSize = 100,
  });

  Future<Hadith> getHadithById(String id);
  Future<void> createHadith(Hadith hadith);
  Future<void> updateHadith(Hadith hadith);
  Future<void> deleteHadith(String id);
  Stream<List<Hadith>> getHadithsStream();
}
