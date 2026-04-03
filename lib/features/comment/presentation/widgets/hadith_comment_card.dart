import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/models/comment.dart';

class HadithCommentCard extends StatelessWidget {
  const HadithCommentCard({
    super.key,
    required this.comment,
    required this.scholarName,
    this.scholarAvatarUrl,
    this.trailing,
    this.onEdit,
    this.onDelete,
  });

  final Comment comment;
  final String scholarName;
  final String? scholarAvatarUrl;
  final Widget? trailing;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Theme.of(context).colorScheme.surface, border: Border.all(color: Theme.of(context).colorScheme.outlineVariant)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _buildAvatar(context),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scholarName,
                        style: TextStyle(fontSize: 16, height: 1.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatDate(comment.createdAt),
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Theme.of(context).colorScheme.outline, width: 1), color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)),
              padding: const EdgeInsets.all(12),
              child: Text(
                comment.text.trim().isEmpty ? '-' : comment.text.trim(),
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  _buildActionChip(
                    context,
                    label: 'نسخ',
                    icon: Icons.content_copy_rounded,
                    onPressed: () => _copyComment(context),
                  ),
                  _buildActionChip(
                    context,
                    label: 'مشاركة',
                    icon: Icons.ios_share_rounded,
                    onPressed: _shareComment,
                  ),
                  if (onEdit != null)
                    _buildActionChip(
                      context,
                      label: 'تعديل',
                      icon: Icons.edit_note_outlined,
                      onPressed: onEdit!,
                    ),
                  if (onDelete != null)
                    _buildActionChip(
                      context,
                      label: 'حذف',
                      icon: Icons.delete_outline_rounded,
                      onPressed: onDelete!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final avatarUrl = scholarAvatarUrl?.trim();
    final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary.withValues(alpha: 0.12),
      ),
      child: ClipOval(
        child: hasAvatar
            ? Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person_rounded,
                    color: colorScheme.primary,
                    size: 24,
                  );
                },
              )
            : Icon(Icons.person_rounded, color: colorScheme.primary, size: 24),
      ),
    );
  }

  Widget _buildActionChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: ActionChip(
        onPressed: onPressed,
        avatar: Icon(icon, size: 16, color: colorScheme.primary),
        label: Text(
          label,
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: colorScheme.surface,
        side: BorderSide(
          color: colorScheme.primary.withValues(alpha: 0.35),
          width: 0.9,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
    );
  }

  Future<void> _copyComment(BuildContext context) async {
    final text = 'تعليق $scholarName:\n${comment.text}';
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم نسخ التعليق',
        ),
      ),
    );
  }

  void _shareComment() {
    final text = 'تعليق $scholarName:\n${comment.text}';
    Share.share(
      text,
      subject: 'تعليق على حديث',
    );
  }

  String _formatDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value;
    }
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');
    return '${parsed.year}/$month/$day - $hour:$minute';
  }
}



