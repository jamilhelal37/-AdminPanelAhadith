import 'package:flutter/material.dart';

import '../../../../core/utils/external_url_opener.dart';
import '../providers/admin_pro_upgrade_requests_provider.dart';

class AdminProDocumentsDialog extends StatelessWidget {
  const AdminProDocumentsDialog({
    super.key,
    required this.request,
    required this.previews,
  });

  final AdminProRequestView request;
  final List<AdminProDocumentPreview> previews;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080, maxHeight: 760),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                textDirection: TextDirection.ltr,
                children: [
                  IconButton.filledTonal(
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'إغلاق',
                    icon: const Icon(Icons.close_rounded, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'وثائق ${request.displayName}',
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: cs.onSurface,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: previews.length,
                  itemBuilder: (context, index) =>
                      AdminProDocumentCard(preview: previews[index]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminProDocumentCard extends StatelessWidget {
  const AdminProDocumentCard({super.key, required this.preview});

  final AdminProDocumentPreview preview;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => openExternalUrl(preview.signedUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: double.infinity,
                      color: cs.surfaceContainerHighest.withValues(alpha: 0.45),
                      child: preview.isImage
                          ? Image.network(preview.signedUrl, fit: BoxFit.cover)
                          : Center(
                              child: Icon(
                                Icons.picture_as_pdf_outlined,
                                size: 42,
                                color: cs.primary,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              preview.fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              preview.createdAt,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => openExternalUrl(preview.signedUrl),
                  icon: const Icon(Icons.open_in_new_rounded, size: 16),
                  label: const Text('فتح'),
                ),
                OutlinedButton.icon(
                  onPressed: () => downloadExternalUrl(
                    preview.signedUrl,
                    fileName: preview.fileName,
                  ),
                  icon: const Icon(Icons.download_rounded, size: 16),
                  label: const Text('تنزيل'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AdminProDocumentPreview {
  const AdminProDocumentPreview({
    required this.fileName,
    required this.createdAt,
    required this.signedUrl,
    required this.isImage,
  });

  final String fileName;
  final String createdAt;
  final String signedUrl;
  final bool isImage;
}

class AdminProEmptyState extends StatelessWidget {
  const AdminProEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 34, color: cs.primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
