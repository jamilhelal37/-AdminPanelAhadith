import 'hadith.dart';

class HadithPageResult {
  const HadithPageResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  final List<Hadith> items;
  final int totalCount;
  final int page;
  final int pageSize;

  int get totalPages {
    if (totalCount <= 0) return 1;
    return (totalCount / pageSize).ceil();
  }
}
