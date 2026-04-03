import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/models/similar_ahadith.dart';
import '../repositories/similar_ahadith_repository.dart';

class SimilarAhadithSupabaseDatasource implements SimilarAhadithRepository {
  final _client = Supabase.instance.client;
  static const String _table = 'similar_ahadith';

  // تحميل بيانات الحديث الرئيسي والحديث المشابه مع العلاقات المرتبطة.
  static const String _selectWithRelations = '''
    *,
    main_ahadith:main_hadith(text, hadith_number, books!source(name)),
    sim_ahadith:sim_hadith(text, hadith_number, books!source(name))
  ''';

  @override
  Future<List<SimilarAhadith>> getSimilarAhadiths(String? searchQuery) async {
    try {
      var query = _client.from(_table).select(_selectWithRelations);

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query = query.or(
          'main_hadith.ilike.%${searchQuery.trim()}%,sim_hadith.ilike.%${searchQuery.trim()}%',
        );
      }

      final res = await query.order('created_at', ascending: false);

      return (res as List).map((e) {
        final map = e as Map<String, dynamic>;

        // استخراج بيانات الحديث الرئيسي.
        String? mainHadithText;
        int? mainHadithNumber;
        String? mainBookName;

        if (map['main_ahadith'] != null) {
          final mainData = map['main_ahadith'] as Map<String, dynamic>;
          mainHadithText = mainData['text'] as String?;
          mainHadithNumber = mainData['hadith_number'] as int?;

          if (mainData['books'] != null) {
            mainBookName = mainData['books']['name'] as String?;
          }
        }

        // استخراج بيانات الحديث المشابه.
        String? simHadithText;
        int? simHadithNumber;
        String? simBookName;

        if (map['sim_ahadith'] != null) {
          final simData = map['sim_ahadith'] as Map<String, dynamic>;
          simHadithText = simData['text'] as String?;
          simHadithNumber = simData['hadith_number'] as int?;

          if (simData['books'] != null) {
            simBookName = simData['books']['name'] as String?;
          }
        }

        // إنشاء النموذج بعد دمج بيانات العلاقات.
        return SimilarAhadith.fromJson(map).copyWith(
          mainHadithText: mainHadithText,
          mainHadithNumber: mainHadithNumber,
          mainBookName: mainBookName,
          simHadithText: simHadithText,
          simHadithNumber: simHadithNumber,
          simBookName: simBookName,
        );
      }).toList();
    } catch (error) {
      throw AppFailure.network('تعذر تحميل الأحاديث المشابهة.', cause: error);
    }
  }

  @override
  Future<SimilarAhadith> createSimilarAhadith(
    SimilarAhadith similarAhadith,
  ) async {
    try {
      final json = similarAhadith.toJson();
      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      // إزالة حقول العلاقات لأنها للقراءة فقط.
      json.remove('main_hadith_text');
      json.remove('main_hadith_number');
      json.remove('main_book_name');
      json.remove('sim_hadith_text');
      json.remove('sim_hadith_number');
      json.remove('sim_book_name');

      final res = await _client.from(_table).insert(json).select().single();

      return SimilarAhadith.fromJson(res);
    } catch (error) {
      throw AppFailure.storage('تعذر إنشاء الحديث المشابه.', cause: error);
    }
  }

  @override
  Future<SimilarAhadith> updateSimilarAhadith(
    SimilarAhadith similarAhadith,
  ) async {
    try {
      if (similarAhadith.id == null) {
        throw AppFailure.validation('معرّف الحديث المشابه مطلوب.');
      }

      final json = similarAhadith.toJson();
      json.remove('id');
      json.remove('created_at');

      // إزالة حقول العلاقات لأنها للقراءة فقط.
      json.remove('main_hadith_text');
      json.remove('main_hadith_number');
      json.remove('main_book_name');
      json.remove('sim_hadith_text');
      json.remove('sim_hadith_number');
      json.remove('sim_book_name');

      final res = await _client
          .from(_table)
          .update(json)
          .eq('id', similarAhadith.id!)
          .select()
          .single();

      return SimilarAhadith.fromJson(res);
    } catch (error) {
      if (error is AppFailure) rethrow;
      throw AppFailure.storage('تعذر تحديث الحديث المشابه.', cause: error);
    }
  }

  @override
  Future<void> deleteSimilarAhadith(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
    } catch (error) {
      throw AppFailure.storage('تعذر حذف الحديث المشابه.', cause: error);
    }
  }

  @override
  Stream<List<SimilarAhadith>> getSimilarAhadithsStream() {
    return _client
        .from(_table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map(
          (event) => event.map((row) => SimilarAhadith.fromJson(row)).toList(),
        );
  }
}
