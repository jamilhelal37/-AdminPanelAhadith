import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/auth_notifier_provider.dart';

class PostSignupAvatarScreen extends ConsumerStatefulWidget {
  const PostSignupAvatarScreen({super.key, this.onCompleted});

  final VoidCallback? onCompleted;

  @override
  ConsumerState<PostSignupAvatarScreen> createState() =>
      _PostSignupAvatarScreenState();
}

class _PostSignupAvatarScreenState
    extends ConsumerState<PostSignupAvatarScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickAndUploadAvatar() async {
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );

    if (file == null) return;

    setState(() => _isUploading = true);
    try {
      final bytes = await file.readAsBytes();
      final extension = file.name.contains('.')
          ? file.name.split('.').last
          : 'jpg';

      await ref
          .read(authNotifierProvider.notifier)
          .uploadAvatar(
            bytes: bytes,
            fileExtension: extension,
            onSuccess: (publicUrl) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('صورة الملف الشخصي تم تحميلها بنجاح')),
              );
              widget.onCompleted?.call();
            },
            onError: (message) {
              if (!mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
          );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: const Text('صورة الملف الشخصي'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  'أضف صورة ملفك الشخصي',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Text(
                  'يمكنك استخدام صورة شخصية أو صورة تمثلك',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                const SizedBox(height: 48),
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: cs.primary.withValues(alpha: 0.15),
                    child: Icon(Icons.person, size: 72, color: cs.primary),
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _pickAndUploadAvatar,
                  icon: _isUploading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(cs.onPrimary),
                          ),
                        )
                      : const Icon(Icons.add_photo_alternate_rounded),
                  label: Text(_isUploading ? 'جاري التحميل...' : 'اختر الصورة'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: _isUploading ? null : widget.onCompleted,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('تخطي'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
