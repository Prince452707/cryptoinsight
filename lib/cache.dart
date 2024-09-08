
class CachedInsight {
  final String content;
  final DateTime expirationTime;

  CachedInsight(this.content, this.expirationTime);

  bool get isExpired => DateTime.now().isAfter(expirationTime);
}