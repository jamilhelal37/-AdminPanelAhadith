import 'package:ahadith/features/muhaddiths/domain/models/muhaddith.dart';

abstract class MuhaddithRepository {
  Future<List<Muhaddith>> getMuhaddiths(String? searchQuery);
  Future<void> createMuhaddith(Muhaddith muhaddith);
  Future<void> updateMuhaddith(Muhaddith muhaddith);
  Future<void> deleteMuhaddith(String id);
  Stream<List<Muhaddith>> getMuhaddithsStream();
}
