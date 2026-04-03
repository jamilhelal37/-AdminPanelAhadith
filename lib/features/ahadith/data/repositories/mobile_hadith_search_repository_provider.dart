import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../datasources/mobile_hadith_search_supabase_datasource.dart';
import 'mobile_hadith_search_repository.dart';

final mobileHadithSearchRepositoryProvider =
    Provider<MobileHadithSearchRepository>((ref) {
      return MobileHadithSearchSupabaseDatasource();
    });
