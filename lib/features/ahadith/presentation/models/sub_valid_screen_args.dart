import '../../../fake_ahadith/domain/models/fake_ahadith.dart';
import '../../domain/models/hadith.dart';

class SubValidScreenArgs {
  const SubValidScreenArgs({
    required this.isHadith,
    this.hadith,
    this.fakeHadith,
  });

  final bool isHadith;
  final Hadith? hadith;
  final FakeAhadith? fakeHadith;

  String? get subValidId => isHadith ? hadith?.subValid : fakeHadith?.subValid;

  String? get subValidText =>
      isHadith ? hadith?.subValidText : fakeHadith?.subValidText;
}
