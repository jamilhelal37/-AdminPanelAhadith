import 'pro_upgrade_decision.dart';
import 'pro_upgrade_request.dart';

class ProUpgradeViewState {
  const ProUpgradeViewState({
    required this.activeRequest,
    required this.currentDecision,
    required this.resolvedRequestId,
    required this.canCreateNewRequest,
  });

  final ProUpgradeRequest? activeRequest;
  final ProUpgradeDecision? currentDecision;
  final String? resolvedRequestId;
  final bool canCreateNewRequest;

  bool get canRetryRejectedRequest {
    return activeRequest?.status == 'reviewed' &&
        currentDecision?.approved == false;
  }

  bool get isCreatingFromScratch => activeRequest == null;

  int get currentStep {
    if (activeRequest == null) return 1;
    if (activeRequest!.status == 'pending_documents') return 2;
    return 3;
  }

  String statusTitle({required bool isCreatingRequest}) {
    if (isCreatingRequest && activeRequest == null) {
      return 'جارٍ تجهيز الطلب';
    }
    if (activeRequest == null) {
      return 'سيتم إنشاء الطلب تلقائيًا';
    }
    if (activeRequest!.status == 'pending_documents') {
      return 'المرحلة الحالية: رفع الوثائق';
    }
    if (activeRequest!.status == 'under_review') {
      return 'المرحلة الحالية: بانتظار مراجعة المشرف';
    }
    if (currentDecision?.approved == true) {
      return 'تمت الموافقة على الطلب';
    }
    return 'تمت مراجعة الطلب';
  }

  String statusDescription({required bool isCreatingRequest}) {
    if (isCreatingRequest && activeRequest == null) {
      return 'يتم الآن تجهيز طلب الترقية حتى تنتقل مباشرة إلى خطوة رفع الوثائق.';
    }
    if (activeRequest == null) {
      return 'عند الدخول إلى هذه الصفحة لأول مرة، يتم إنشاء طلب الترقية لك تلقائيًا ثم تبدأ برفع الوثائق المطلوبة.';
    }
    if (activeRequest!.status == 'pending_documents') {
      return 'ارفع وثيقة واحدة أو أكثر، وبعد اكتمال الرفع أرسل الطلب للمراجعة. لن ينتقل طلبك إلى المرحلة التالية قبل الإرسال.';
    }
    if (activeRequest!.status == 'under_review') {
      return 'وصل طلبك إلى المشرف بنجاح، وما عليك الآن إلا انتظار نتيجة المراجعة.';
    }
    if (currentDecision?.approved == true) {
      return 'تم اعتماد طلبك بنجاح. يمكنك متابعة أي تحديثات إضافية من هذه الصفحة.';
    }
    return 'تمت مراجعة الطلب الحالي. إذا رغبت بالمحاولة مجددًا يمكنك إنشاء طلب جديد مع وثائق محدثة.';
  }

  static ProUpgradeViewState resolve({
    required List<ProUpgradeRequest> requests,
    required List<ProUpgradeDecision> decisions,
    required String? activeRequestId,
  }) {
    final active = requests.cast<ProUpgradeRequest?>().firstWhere(
      (item) => item?.status != 'reviewed',
      orElse: () => null,
    );
    final fallback = requests.isEmpty ? null : requests.first;
    final chosen = active ?? fallback;

    ProUpgradeRequest? resolvedRequest = chosen;
    if (activeRequestId != null) {
      for (final request in requests) {
        if (request.id == activeRequestId) {
          resolvedRequest = request;
          break;
        }
      }
    }

    ProUpgradeDecision? decision;
    final requestId = resolvedRequest?.id;
    if (requestId != null) {
      for (final item in decisions) {
        if (item.requestId == requestId) {
          decision = item;
          break;
        }
      }
    }

    final isRejected = decision != null && !decision.approved;
    final canCreateNewRequest =
        resolvedRequest == null ||
        (resolvedRequest.status == 'reviewed' && isRejected);

    return ProUpgradeViewState(
      activeRequest: resolvedRequest,
      currentDecision: decision,
      resolvedRequestId: resolvedRequest?.id,
      canCreateNewRequest: canCreateNewRequest,
    );
  }

  static String statusText(String status) {
    switch (status) {
      case 'pending_documents':
        return 'بانتظار رفع الوثائق';
      case 'under_review':
        return 'بانتظار مراجعة المشرف';
      case 'reviewed':
        return 'تمت المراجعة';
      default:
        return 'غير معروف';
    }
  }

  static String formatDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    final month = parsed.month.toString().padLeft(2, '0');
    final day = parsed.day.toString().padLeft(2, '0');
    return '${parsed.year}/$month/$day';
  }

  static String extractFileName(String path) {
    final normalized = path.replaceAll('\\', '/');
    final parts = normalized.split('/');
    return parts.isEmpty ? path : parts.last;
  }

  static String shortId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '-';
    }
    if (value.length <= 8) {
      return value;
    }
    return '${value.substring(0, 8)}...';
  }
}
