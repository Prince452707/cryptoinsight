

class CryptoApiConfig {
  // CoinCompare API configuration
  static const String coinCompareApiKey = '682a577a63781a9dc6fc13cad64b4adcfe37e8b60d624de1e6a5fcd2423e94d6';
  static const String coinCompareBaseUrl = 'https://min-api.cryptocompare.com/data';
  
  // CoinGecko API configuration (as fallback)
  static const List<String> coinGeckoBaseUrls = [
    'https://api.coingecko.com/api/v3',
    'https://api.coingecko.com/api/v3',
  ];
  
  // API request configurations
  static const Duration rateLimitDuration = Duration(milliseconds: 500);
  static const int maxRetries = 3;
  static const Map<String, String> coinCompareHeaders = {
    'Authorization': '682a577a63781a9dc6fc13cad64b4adcfe37e8b60d624de1e6a5fcd2423e94d6',
  };
}