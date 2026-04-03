import '../../domain/models/fake_ahadith.dart';

abstract class FakeAhadithRepository {
  Future<List<FakeAhadith>> getFakeAhadiths(String? searchQuery);
  Future<FakeAhadith?> getFakeAhadithById(String id);
  Future<void> createFakeAhadith(FakeAhadith fakeAhadith);
  Future<void> updateFakeAhadith(FakeAhadith fakeAhadith);
  Future<void> deleteFakeAhadith(String id);
  Stream<List<FakeAhadith>> getFakeAhadithsStream();
}
