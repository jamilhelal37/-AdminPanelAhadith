enum AdminCountTarget {
  rulings('ruling'),
  rawis('rawis'),
  muhaddiths('muhaddiths'),
  books('books'),
  ahadith('ahadith'),
  topics('topics'),
  questions('questions'),
  users('app_user'),
  fakeAhadith('fake_ahadith'),
  topicClass('topic_class'),
  similarAhadith('similar_ahadith'),
  proUpgradeRequests('pro_upgrade_requests'),
  proUpgradeDecisions('pro_upgrade_decisions');

  const AdminCountTarget(this.table);

  final String table;
}

abstract class AdminMetricsRepository {
  Future<int> count(AdminCountTarget target);
}
