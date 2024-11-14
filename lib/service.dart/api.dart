
import '/service.dart/CryptoApiConfig.dart';
import '/service.dart/ThrottleService.dart';
import '/service.dart/CacheService.dart';
import 'package:http/http.dart' as http;
import '/service.dart/json_and_others.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';




class ApiService {
  static final Random _random = Random();
  static DateTime _lastRequestTime = DateTime.now();
  static final Map<String, String> _symbolToId = {};
  static final Map<String, String> _idToSymbol = {};

  static Future<void> _respectRateLimit() async {
    final now = DateTime.now();
    final timeSinceLastRequest = now.difference(_lastRequestTime);
    if (timeSinceLastRequest < CryptoApiConfig.rateLimitDuration) {
      await Future.delayed(CryptoApiConfig.rateLimitDuration - timeSinceLastRequest);
    }
    _lastRequestTime = DateTime.now();
  }

  static Future<dynamic> _makeRequest(String url, {Map<String, String>? headers, int retryCount = 0}) async {
    await _respectRateLimit();
    await ThrottleService.throttle(url);
    
    final cachedData = await CacheService.getCache(url);
    if (cachedData != null) {
      return json.decode(cachedData);
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        await CacheService.setCache(url, response.body);
        return json.decode(response.body);
      } else if (response.statusCode == 429 && retryCount < CryptoApiConfig.maxRetries) {
        final retryDelay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
        await Future.delayed(retryDelay);
        return _makeRequest(url, headers: headers, retryCount: retryCount + 1);
      } else {
        throw Exception('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (retryCount < CryptoApiConfig.maxRetries) {
        await Future.delayed(Duration(seconds: retryCount + 1));
        return _makeRequest(url, headers: headers, retryCount: retryCount + 1);
      }
      throw e;
    }
  }

  static Future<List<Cryptocurrency>> getCryptocurrencies({int page = 1, int perPage = 100}) async {
    final cacheKey = 'cryptocurrencies_$page$perPage';
    final cachedData = await CacheService.getCache(cacheKey);
    if (cachedData != null) {
      return (json.decode(cachedData) as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
    }

    try {
      final url = '${CryptoApiConfig.coinCompareBaseUrl}/top/mktcapfull?limit=$perPage&tsym=USD&page=${page - 1}';
      final data = await _makeRequest(url, headers: CryptoApiConfig.coinCompareHeaders);
      
      final List<Cryptocurrency> cryptos = [];
      for (var item in data['Data']) {
        final raw = item['RAW']['USD'];
       // final display = item['DISPLAY']['USD'];
        
        final crypto = Cryptocurrency(
          id: item['CoinInfo']['Name'].toLowerCase(),
          name: item['CoinInfo']['FullName'],
          symbol: item['CoinInfo']['Name'],
          price: raw['PRICE'].toDouble(),
          marketCap: raw['MKTCAP'].toDouble(),
          volume24h: raw['VOLUME24HOUR'].toDouble(),
          percentChange24h: raw['CHANGEPCT24HOUR'].toDouble(),
          image: 'https://www.cryptocompare.com${item['CoinInfo']['ImageUrl']}',
          rank: item['CoinInfo']['SortOrder'],
          circulatingSupply: raw['SUPPLY'].toDouble(),
          totalSupply: raw['TOTALSUPPLY']?.toDouble(),
          maxSupply: raw['MAXSUPPLY']?.toDouble(),
        );
        
        cryptos.add(crypto);
        _symbolToId[crypto.symbol.toLowerCase()] = crypto.id;
        _idToSymbol[crypto.id] = crypto.symbol;
      }

      await CacheService.setCache(cacheKey, json.encode(cryptos.map((c) => c.toJson()).toList()));
      return cryptos;
    } catch (e) {
      final baseUrlIndex = _random.nextInt(CryptoApiConfig.coinGeckoBaseUrls.length);
      final url = '${CryptoApiConfig.coinGeckoBaseUrls[baseUrlIndex]}/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false';
      final data = await _makeRequest(url);
      
      final cryptos = (data as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
      await CacheService.setCache(cacheKey, json.encode(data));
      return cryptos;
    }
  }

  static Future<Map<String, dynamic>> getCryptocurrencyDetails(String id) async {
    try {
      final symbol = _idToSymbol[id] ?? id.toUpperCase();
      final url = '${CryptoApiConfig.coinCompareBaseUrl}/coin/data/all?fsym=$symbol';
      final data = await _makeRequest(url, headers: CryptoApiConfig.coinCompareHeaders);
      
      final priceData = await getCoinComparePriceData(symbol);
      
      return {
        'id': id,
        'symbol': symbol,
        'name': data['Data']['NAME'],
        'description': data['Data']['DESCRIPTION'],
        'market_data': {
          'current_price': {'usd': priceData['PRICE']},
          'market_cap': {'usd': priceData['MKTCAP']},
          'total_volume': {'usd': priceData['VOLUME24HOUR']},
          'price_change_percentage_24h': priceData['CHANGEPCT24HOUR'],
          'circulating_supply': priceData['SUPPLY'],
          'total_supply': priceData['TOTALSUPPLY'],
          'max_supply': priceData['MAXSUPPLY'],
        },
        'market_cap_rank': data['Data']['MARKET_CAP_RANK'],
        'links': data['Data']['LINKS'],
      };
    } catch (e) {
      return await getFallbackData(id);
    }
  }

  static Future<Cryptocurrency?> getSearchedCryptocurrency(String query) async {
    try {
      final url = '${CryptoApiConfig.coinCompareBaseUrl}/search?q=$query';
      final data = await _makeRequest(url, headers: CryptoApiConfig.coinCompareHeaders);
      
      if (data['Data'].isEmpty) {
        throw Exception('No results found');
      }

      final firstCoin = data['Data'][0];
      final symbol = firstCoin['Symbol'];
      
      final priceData = await getCoinComparePriceData(symbol);
      
      return Cryptocurrency(
        id: symbol.toLowerCase(),
        name: firstCoin['FullName'],
        symbol: symbol,
        price: priceData['PRICE'].toDouble(),
        marketCap: priceData['MKTCAP'].toDouble(),
        volume24h: priceData['VOLUME24HOUR'].toDouble(),
        percentChange24h: priceData['CHANGEPCT24HOUR'].toDouble(),
        image: 'https://www.cryptocompare.com${firstCoin['ImageUrl']}',
        rank: priceData['MARKET_CAP_RANK'] ?? 0,
        circulatingSupply: priceData['SUPPLY'].toDouble(),
        totalSupply: priceData['TOTALSUPPLY']?.toDouble(),
        maxSupply: priceData['MAXSUPPLY']?.toDouble(),
      );
    } catch (e) {
      try {
        final baseUrlIndex = _random.nextInt(CryptoApiConfig.coinGeckoBaseUrls.length);
        final url = '${CryptoApiConfig.coinGeckoBaseUrls[baseUrlIndex]}/search?query=$query';
        final data = await _makeRequest(url);
        
        if ((data['coins'] as List).isEmpty) {
          return null;
        }

        final firstCoin = data['coins'].first;
        final detailData = await getFallbackData(firstCoin['id']);
        
        return Cryptocurrency(
          id: firstCoin['id'],
          name: firstCoin['name'],
          symbol: firstCoin['symbol'],
          price: detailData['market_data']['current_price']['usd']?.toDouble() ?? 0,
          marketCap: detailData['market_data']['market_cap']['usd']?.toDouble() ?? 0,
          volume24h: detailData['market_data']['total_volume']['usd']?.toDouble() ?? 0,
          percentChange24h: detailData['market_data']['price_change_percentage_24h']?.toDouble() ?? 0,
          image: firstCoin['large'] ?? '',
          rank: detailData['market_cap_rank'] ?? 0,
          circulatingSupply: detailData['market_data']['circulating_supply']?.toDouble() ?? 0,
          totalSupply: detailData['market_data']['total_supply']?.toDouble(),
          maxSupply: detailData['market_data']['max_supply']?.toDouble(),
        );
      } catch (e) {
        return null;
      }
    }
  }

  static Future<List<List<dynamic>>> getMarketChart(String id, int days) async {
    try {
      final symbol = _idToSymbol[id] ?? id.toUpperCase();
      final url = '${CryptoApiConfig.coinCompareBaseUrl}/v2/histoday?fsym=$symbol&tsym=USD&limit=$days';
      final data = await _makeRequest(url, headers: CryptoApiConfig.coinCompareHeaders);
      
      return data['Data']['Data'].map<List<dynamic>>((item) => [
        item['time'] * 1000,
        item['close'].toDouble()
      ]).toList();
    } catch (e) {
      final baseUrlIndex = _random.nextInt(CryptoApiConfig.coinGeckoBaseUrls.length);
      final url = '${CryptoApiConfig.coinGeckoBaseUrls[baseUrlIndex]}/coins/$id/market_chart?vs_currency=usd&days=$days';
      final data = await _makeRequest(url);
      return List<List<dynamic>>.from(data['prices']);
    }
  }

  static Future<Map<String, dynamic>> getCoinComparePriceData(String symbol) async {
    final url = '${CryptoApiConfig.coinCompareBaseUrl}/pricemultifull?fsyms=$symbol&tsyms=USD';
    final response = await _makeRequest(url, headers: CryptoApiConfig.coinCompareHeaders);
    return response['RAW'][symbol]['USD'];
  }

  static Future<Map<String, dynamic>> getFallbackData(String id) async {
    final baseUrlIndex = _random.nextInt(CryptoApiConfig.coinGeckoBaseUrls.length);
    final url = '${CryptoApiConfig.coinGeckoBaseUrls[baseUrlIndex]}/coins/$id?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false';
    return await _makeRequest(url);
  }

  static Future<Map<String, dynamic>> getCombinedCryptoData(String symbol, String id) async {
    try {
      final priceData = await getCoinComparePriceData(symbol);
      final newsData = await _getNewsData(symbol);
      
      return {
        'price': {
          'PRICE': priceData['PRICE'],
          'CHANGEPCT24HOUR': priceData['CHANGEPCT24HOUR'],
          'current_price': {'usd': priceData['PRICE']},
          'price_change_percentage_24h': priceData['CHANGEPCT24HOUR'],
        },
        'news': newsData,
        'source': 'crypto insight'
      };
    } catch (e) {
      try {
        final baseUrlIndex = _random.nextInt(CryptoApiConfig.coinGeckoBaseUrls.length);
        final url = '${CryptoApiConfig.coinGeckoBaseUrls[baseUrlIndex]}/coins/$id';
        final data = await _makeRequest(url);
        
        return {
          'price': {
            'current_price': data['market_data']['current_price'],
            'price_change_percentage_24h': data['market_data']['price_change_percentage_24h'],
          },
          'news': [],
          'source': 'CoinGecko'
        };
      } catch (e) {
        throw Exception('Failed to fetch data from both CoinCompare and CoinGecko');
      }
    }
  }

  static Future<List<Map<String, dynamic>>> _getNewsData(String symbol) async {
    try {
      final url = '${CryptoApiConfig.coinCompareBaseUrl}/v2/news/?categories=$symbol';
      final data = await _makeRequest(url, headers: CryptoApiConfig.coinCompareHeaders);
      
      return (data['Data'] as List)
          .take(5)
          .map((news) => {
                'title': news['title'],
                'url': news['url'],
                'source': news['source'],
              })
          .toList();
    } catch (e) {
      return [];
    }
  }
}