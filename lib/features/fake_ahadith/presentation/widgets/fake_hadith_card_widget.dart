import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

import '../../../ahadith/presentation/models/sub_valid_screen_args.dart';
import '../../../ahadith/presentation/screens/sub_valid_hadith_screen.dart';
import '../../../settings/presentation/widgets/app_reading_preferences_scope.dart';
import '../../domain/models/fake_ahadith.dart';
import '../screens/fake_hadith_detail_screen.dart';

class FakeHadithCard extends StatelessWidget {
  final FakeAhadith fakeHadith;
  final int serialNumber;
  final bool showActionButtons;
  final bool showSubValidAction;
  final bool showDetailAction;
  final bool showFullText;

  const FakeHadithCard({
    super.key,
    required this.fakeHadith,
    required this.serialNumber,
    this.showActionButtons = true,
    this.showSubValidAction = true,
    this.showDetailAction = true,
    this.showFullText = false,
  });

  bool get _hasSubValid =>
      fakeHadith.subValidText != null &&
      fakeHadith.subValidText!.trim().isNotEmpty;

  String _buildCopyShareText() {
    final degree = fakeHadith.rulingName ?? 'غير محدد';
    final subValid = _hasSubValid
        ? fakeHadith.subValidText!.trim()
        : 'لا يوجد حديث صحيح بديل';

    return 'رقم التسلسل: $serialNumber\n\n'
        'نص الحديث:\n${fakeHadith.text}\n\n'
        'الدرجة: $degree\n\n'
        'الحديث الصحيح البديل:\n$subValid';
  }

  void _openDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => FakeHadithDetailScreen(
          fakeHadith: fakeHadith,
          serialNumber: serialNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final displayText = AppReadingPreferencesScope.resolveDisplayText(
      context,
      text: fakeHadith.text,
      normalText: fakeHadith.normalText,
    );

    return Card(
      color: cs.surface,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: cs.outlineVariant.withValues(alpha: 0.8)),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: InkWell(
        onTap: showDetailAction ? () => _openDetails(context) : null,
        borderRadius: BorderRadius.circular(14.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: cs.primary.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Text(
                        'حديث منتشر لا يصح',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (showFullText)
                      Text(
                        '$serialNumber- $displayText',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 16, height: 1.5),
                      )
                    else
                      ReadMoreText(
                        '$serialNumber- $displayText',
                        textDirection: TextDirection.rtl,
                        trimMode: TrimMode.Line,
                        trimLines: 4,
                        trimCollapsedText:
                            '\nعرض المزيد ...',
                        trimExpandedText:
                            '\nعرض مختصر',
                        moreStyle: TextStyle(fontSize: 14),
                        lessStyle: TextStyle(fontSize: 14),
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                    const SizedBox(height: 10),
                    _buildMetadataRow(
                      context,
                      label: 'الدرجة',
                      value:
                          fakeHadith.rulingName ??
                          'غير محدد',
                      valueColor: const Color(0xFF1E8E5A),
                    ),
                  ],
                ),
              ),
              if (showActionButtons) ...[
                Divider(
                  height: 1,
                  thickness: 1,
                  color: cs.outlineVariant.withValues(alpha: 0.45),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        _buildActionChip(
                          context,
                          label: 'نسخ',
                          icon: Icons.content_copy_rounded,
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: _buildCopyShareText()),
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  'تم نسخ الحديث بنجاح',
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        _buildActionChip(
                          context,
                          label: 'مشاركة',
                          icon: Icons.ios_share_rounded,
                          onPressed: () {
                            Share.share(
                              _buildCopyShareText(),
                              subject:
                                  'حديث منتشر لا يصح',
                            );
                          },
                        ),
                        if (showDetailAction)
                          _buildActionChip(
                            context,
                            label: 'تفاصيل',
                            icon: Icons.info_outline_rounded,
                            onPressed: () => _openDetails(context),
                          ),
                        if (_hasSubValid && showSubValidAction)
                          _buildActionChip(
                            context,
                            label:
                                'الصحيح البديل',
                            icon: Icons.verified_outlined,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => SubValidHadithScreen(
                                    args: SubValidScreenArgs(
                                      isHadith: false,
                                      fakeHadith: fakeHadith,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetadataRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return RichText(
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
              fontSize: 15,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
              fontSize: 15,
              color: valueColor ?? Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: ActionChip(
        onPressed: onPressed,
        avatar: Icon(icon, color: cs.primary, size: 16),
        label: Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: cs.surface,
        side: BorderSide(color: cs.primary.withValues(alpha: 0.35), width: 0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
    );
  }
}


