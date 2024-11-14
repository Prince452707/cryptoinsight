


class Cryptocurrency {
  final String id;
  final String name;
  final String symbol;
  final double price;
  final double marketCap;
  final double volume24h;
  final double percentChange24h;
  final String image;
  final int rank;
  final double circulatingSupply;
  final double? totalSupply;
  final double? maxSupply;

  Cryptocurrency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.marketCap,
    required this.volume24h,
    required this.percentChange24h,
    required this.image,
    required this.rank,
    required this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'price': price,
      'market_cap': marketCap,
      'volume_24h': volume24h,
      'percent_change_24h': percentChange24h,
      'image': image,
      'rank': rank,
      'circulating_supply': circulatingSupply,
      'total_supply': totalSupply,
      'max_supply': maxSupply,
    };
  }

  factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
    return Cryptocurrency(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      price: (json['current_price'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      volume24h: (json['total_volume'] ?? 0).toDouble(),
      percentChange24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      image: json['image'] ?? '',
      rank: json['market_cap_rank'] ?? 0,
      circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
      totalSupply: json['total_supply']?.toDouble(),
      maxSupply: json['max_supply']?.toDouble(),
    );
  }
}
