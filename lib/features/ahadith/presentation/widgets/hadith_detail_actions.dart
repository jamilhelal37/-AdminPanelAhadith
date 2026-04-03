import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/models/hadith.dart';

class HadithDetailActions extends StatelessWidget {
  final Hadith hadith;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const HadithDetailActions({
    super.key,
    required this.hadith,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  void _copyToClipboard(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln('نص الحديث:');
    buffer.writeln(hadith.text);
    buffer.writeln('');
    buffer.writeln('بيانات الحديث:');
    buffer.writeln('الراوي: ${hadith.rawiName ?? '-'}');
    buffer.writeln('المصدر: ${hadith.sourceName ?? '-'}');
    buffer.writeln('الرقم: ${hadith.hadithNumber}');
    if (hadith.muhaddithRulingName != null) {
      buffer.writeln('حكم المحدث: ${hadith.muhaddithRulingName}');
    }
    if (hadith.finalRulingName != null) {
      buffer.writeln('الحكم النهائي: ${hadith.finalRulingName}');
    }
    if (hadith.relatedTopics != null && hadith.relatedTopics!.isNotEmpty) {
      buffer.writeln('الموضوعات: ${hadith.relatedTopics!.join(' - ')}');
    }
    if (hadith.explainingText != null && hadith.explainingText!.isNotEmpty) {
      buffer.writeln('\nشرح الحديث:');
      buffer.writeln(hadith.explainingText);
    }
    if (hadith.sanad != null && hadith.sanad!.isNotEmpty) {
      buffer.writeln('\nأصل الحديث:');
      buffer.writeln(hadith.sanad);
    }
    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم نسخ الحديث بنجاح')));
  }

  void _shareHadith(BuildContext context) {
    final buffer = StringBuffer();
    buffer.writeln('نص الحديث:');
    buffer.writeln(hadith.text);
    buffer.writeln('');
    buffer.writeln('بيانات الحديث:');
    buffer.writeln('الراوي: ${hadith.rawiName ?? '-'}');
    buffer.writeln('المصدر: ${hadith.sourceName ?? '-'}');
    buffer.writeln('الرقم: ${hadith.hadithNumber}');
    if (hadith.relatedTopics != null && hadith.relatedTopics!.isNotEmpty) {
      buffer.writeln('الموضوعات: ${hadith.relatedTopics!.join(' - ')}');
    }
    Share.share(buffer.toString(), subject: 'حديث من موسوعة الأحاديث');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => _copyToClipboard(context),
          icon: const Icon(Icons.copy),
          label: const Text('نسخ'),
        ),
        ElevatedButton.icon(
          onPressed: onToggleFavorite,
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          label: Text(isFavorite ? 'إزالة من المفضلة' : 'مفضلة'),
        ),
        ElevatedButton.icon(
          onPressed: () => _shareHadith(context),
          icon: const Icon(Icons.share),
          label: const Text('مشاركة'),
        ),
      ],
    );
  }
}
