// import 'dart:math';
// import 'package:shimmer/shimmer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: CryptoExchangeApp(),
//     ),
//   );
// }

// class CryptoExchangeApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           title: 'Crypto Insights',
//           theme: themeProvider.currentTheme,
//           home: SearchScreen(),
//           routes: {
//             '/settings': (context) => SettingsScreen(),
//           },
//           debugShowCheckedModeBanner: false,
//         );
//       },
//     );
//   }
// }

// class ThemeProvider extends ChangeNotifier {
//   static const Color _primaryDark = Color(0xFF6200EA);
//   static const Color _primaryLight = Color(0xFF3F51B5);
//   static const Color _accentDark = Color(0xFFFF4081);
//   static const Color _accentLight = Color(0xFFFF9800);
//   static const Color _backgroundDark = Color(0xFF121212);
//   static const Color _backgroundLight = Color(0xFFF5F5F5);
//   static const Color _cardDark = Color(0xFF1E1E1E);
//   static const Color _cardLight = Color(0xFFFFFFFF);

//   static final ThemeData _darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: _primaryDark,
//     scaffoldBackgroundColor: _backgroundDark,
//     cardColor: _cardDark,
//     colorScheme: const ColorScheme.dark(
//       primary: _primaryDark,
//       secondary: _accentDark,
//       surface: _cardDark,
//       background: _backgroundDark,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentDark,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentDark),
//   );

//   static final ThemeData _lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: _primaryLight,
//     scaffoldBackgroundColor: _backgroundLight,
//     cardColor: _cardLight,
//     colorScheme: const ColorScheme.light(
//       primary: _primaryLight,
//       secondary: _accentLight,
//       surface: _cardLight,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.black54, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentLight,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentLight),
//   );

//   late ThemeData _currentTheme;

//   ThemeProvider() {
//     _currentTheme = _darkTheme;
//   }

//   ThemeData get currentTheme => _currentTheme;
//   bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

//   void toggleTheme() {
//     _currentTheme = isDarkMode ? _lightTheme : _darkTheme;
//     notifyListeners();
//   }

//   void setDarkMode() {
//     _currentTheme = _darkTheme;
//     notifyListeners();
//   }

//   void setLightMode() {
//     _currentTheme = _lightTheme;
//     notifyListeners();
//   }
// }

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
//   final TextEditingController _searchController = TextEditingController();
//   Cryptocurrency? _searchResult;
//   bool _isLoading = false;
//   Timer? _debounce;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//     _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     _debounce?.cancel();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (_searchController.text.isNotEmpty) {
//         _performSearch(_searchController.text);
//       } else {
//         setState(() => _searchResult = null);
//       }
//     });
//   }

//   Future<void> _performSearch(String query) async {
//     setState(() => _isLoading = true);
//     try {
//       final result = await ApiService.getSearchedCryptocurrency(query);
//       setState(() {
//         _searchResult = result;
//         _isLoading = false;
//       });
//       _animationController.forward(from: 0.0);
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crypto Insights', style: TextStyle(fontWeight: FontWeight.bold)),
//         elevation: 0,
//       ),
//       drawer: AppDrawer(),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
//             ),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search cryptocurrency',
//                 prefixIcon: const Icon(Icons.search, color: Colors.white),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.2),
//               ),
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//           Expanded(
//             child: _buildSearchResults(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchResults() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (_searchResult != null) {
//       return FadeTransition(
//         opacity: _fadeAnimation,
//         child: CryptocurrencyListItem(cryptocurrency: _searchResult!),
//       );
//     } else {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.search, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'Search for a cryptocurrency',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

// class CryptocurrencyListItem extends StatelessWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyListItem({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () => _navigateToDetailScreen(context),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader(),
//                 const SizedBox(height: 12),
//                 _buildPriceInfo(),
//                 const SizedBox(height: 12),
//                 _buildAdditionalInfo(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Hero(
//           tag: 'crypto-${cryptocurrency.id}',
//           child: CircleAvatar(
//             backgroundImage: CachedNetworkImageProvider(cryptocurrency.image),
//             radius: 24,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 cryptocurrency.name,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               Text(
//                 cryptocurrency.symbol.toUpperCase(),
//                 style: const TextStyle(fontSize: 14, color: Colors.white70),
//               ),
//             ],
//           ),
//         ),
//         if (cryptocurrency.rank != 0)
//           Chip(
//             label: Text(
//               '#${cryptocurrency.rank}',
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             backgroundColor: Colors.black26,
//           ),
//       ],
//     );
//   }

//   Widget _buildPriceInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Price',
//               style: TextStyle(fontSize: 14, color: Colors.white70),
//             ),
//             Text(
//               '\$${cryptocurrency.price.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ],
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             const Text(
//               '24h Change',
//               style: TextStyle(fontSize: 14, color: Colors.white70),
//             ),
//             Text(
//               '${_getChangeIcon(cryptocurrency.percentChange24h)} ${cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _getChangeColor(cryptocurrency.percentChange24h),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAdditionalInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildInfoItem('Market Cap', '\$${_formatLargeNumber(cryptocurrency.marketCap)}'),
//         _buildInfoItem('24h Volume', '\$${_formatLargeNumber(cryptocurrency.volume24h)}'),
//       ],
//     );
//   }

//   Widget _buildInfoItem(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
//         Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
//       ],
//     );
//   }

//   String _getChangeIcon(double change) {
//     return change >= 0 ? '▲' : '▼';
//   }

//   Color _getChangeColor(double change) {
//     return change >= 0 ? Colors.greenAccent : Colors.redAccent;
//   }

//   String _formatLargeNumber(double number) {
//     if (number >= 1e9) {
//       return '${(number / 1e9).toStringAsFixed(2)}B';
//     } else if (number >= 1e6) {
//       return '${(number / 1e6).toStringAsFixed(2)}M';
//     } else if (number >= 1e3) {
//       return '${(number / 1e3).toStringAsFixed(2)}K';
//     } else {
//       return number.toStringAsFixed(2);
//     }
//   }

//   void _navigateToDetailScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CryptocurrencyDetailScreen(
//           cryptocurrency: cryptocurrency,
//         ),
//       ),
//     );
//   }
// }

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: const Text('Theme'),
//             trailing: Consumer<ThemeProvider>(
//               builder: (context, themeProvider, child) {
//                 return Switch(
//                   value: themeProvider.currentTheme.brightness == Brightness.dark,
//                   onChanged: (value) {
//                     themeProvider.toggleTheme();
//                   },
//                   activeColor: Theme.of(context).colorScheme.secondary,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//             ),
//             child: const Text(
//               'Crypto Insights',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.home),
//           title: const Text('Home'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushReplacementNamed(context, '/');
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('Settings'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/settings');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Cryptocurrency {
//   final String id;
//   final String name;
//   final String symbol;
//   final double price;
//   final double marketCap;
//   final double volume24h;
//   final double percentChange24h;
//   final String image;
//   final int rank;
//   final double circulatingSupply;
//   final double? totalSupply;
//   final double? maxSupply;

//   Cryptocurrency({
//     required this.id,
//     required this.name,
//     required this.symbol,
//     required this.price,
//     required this.marketCap,
//     required this.volume24h,
//     required this.percentChange24h,
//     required this.image,
//     required this.rank,
//     required this.circulatingSupply,
//     this.totalSupply,
//     this.maxSupply,
//   });

//   factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
//     return Cryptocurrency(
//       id: json['id'],
//       name: json['name'],
//       symbol: json['symbol'],
//       price: (json['current_price'] ?? 0).toDouble(),
//       marketCap: (json['market_cap'] ?? 0).toDouble(),
//       volume24h: (json['total_volume'] ?? 0).toDouble(),
//       percentChange24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
//       image: json['image'] ?? '',
//       rank: json['market_cap_rank'] ?? 0,
//       circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
//       totalSupply: json['total_supply']?.toDouble(),
//       maxSupply: json['max_supply']?.toDouble(),
//     );
//   }
// }

// class CacheService {
//   static const String prefix = 'api_cache_';
//   static const Duration defaultCacheDuration = Duration(minutes: 15);

//   static Future<void> setCache(String key, String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('$prefix$key', value);
//     await prefs.setInt('${prefix}${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
//   }

//   static Future<String?> getCache(String key, {Duration? maxAge}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final value = prefs.getString('$prefix$key');
//     final timestamp = prefs.getInt('${prefix}${key}_timestamp');
    
//     if (value != null && timestamp != null) {
//       final age = DateTime.now().millisecondsSinceEpoch - timestamp;
//       if (age < (maxAge ?? defaultCacheDuration).inMilliseconds) {
//         return value;
//       }
//     }
//     return null;
//   }
// }

// class ThrottleService {
//   static final Map<String, DateTime> _lastRequestTimes = {};
//   static const Duration throttleDuration = Duration(seconds: 1);

//   static Future<void> throttle(String key) async {
//     final now = DateTime.now();
//     final lastRequestTime = _lastRequestTimes[key];
//     if (lastRequestTime != null) {
//       final timeSinceLastRequest = now.difference(lastRequestTime);
//       if (timeSinceLastRequest < throttleDuration) {
//         await Future.delayed(throttleDuration - timeSinceLastRequest);
//       }
//     }
//     _lastRequestTimes[key] = DateTime.now();
//   }
// }

// class AIService {
//   static const String apiKey = 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y';
//   static final model = GenerativeModel(
//     model: 'gemini-pro',
//     apiKey: apiKey,
//   );

//   static Future<String> generateAIResponse(String prompt) async {
//     try {
//       final content = [Content.text(prompt)];
//       final response = await model.generateContent(content);
//       if (response.text != null && response.text!.isNotEmpty) {
//         return response.text!;
//       } else {
//         return 'No response generated';
//       }
//     } catch (e) {
//       return 'Error generating response: $e';
//     }
//   }
// static Future<Map<String, String>> generateComprehensiveAnalysis(Cryptocurrency crypto) async {
//   Map<String, String> analysis = {};
//   String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

//   analysis['general'] = await generateAIResponse(
//     "Provide a comprehensive general analysis of ${crypto.name} (${crypto.symbol}) in the cryptocurrency market as of $currentDate. Include:\n"
//     "1. Current price: \$${crypto.price.toStringAsFixed(2)} - compare this to 7-day and 30-day averages\n"
//     "2. Market cap: \$${crypto.marketCap.toStringAsFixed(2)} - discuss its rank and recent changes\n"
//     "3. 24-hour trading volume and how it compares to the 7-day average\n"
//     "4. Recent performance: 24h, 7d, and 30d price changes (in percentages)\n"
//     "5. Current market dominance and comparison to major cryptocurrencies\n"
//     "6. Brief overview of on-chain metrics (e.g., active addresses, transaction count) if applicable\n"
//     "7. General market sentiment towards ${crypto.name} based on recent events\n"
//     "Provide specific numbers and percentages where possible, and focus on data from the last 30 days."
//   );

//   analysis['news'] = await generateAIResponse(
//     "Summarize the most recent news and developments for ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
//     "1. Major announcements or events from the past 7 days, with exact dates\n"
//     "2. Any significant partnerships or collaborations revealed in the last 30 days\n"
//     "3. Recent protocol upgrades or technological advancements, specifying implementation dates\n"
//     "4. Regulatory news or legal developments affecting ${crypto.name} in the past month\n"
//     "5. Notable mentions of ${crypto.name} by industry leaders or influential figures (quote if possible)\n"
//     "6. Upcoming events in the next 14 days that could impact ${crypto.name}'s value\n"
//     "7. Any changes in ${crypto.name}'s ecosystem (e.g., DeFi, NFTs) in the last 30 days\n"
//     "8. Comparison of recent news to its main competitors\n"
//     "Prioritize the most impactful and recent news items. For each point, provide the date of occurrence or announcement."
//   );

 
// //  analysis['technical'] = await generateAIResponse(
// //   "Provide a real-time technical analysis for ${crypto.name} (${crypto.symbol}) as of $currentDate. Use the most current data available and specify the exact timestamp for each data point. Include:\n"
// //   "1. Current price: \$${crypto.price.toStringAsFixed(2)} (as of [INSERT EXACT TIMESTAMP])\n"
// //   "2. Precise 24-hour price change: [INSERT EXACT PERCENTAGE] (from [START TIME] to [END TIME])\n"
// //   "3. Current 24-hour trading volume: [INSERT VOLUME] and percentage comparison to 7-day average\n"
// //   "4. Real-time order book analysis:\n"
// //   "   - Immediate support levels: [LEVEL 1], [LEVEL 2], [LEVEL 3]\n"
// //   "   - Immediate resistance levels: [LEVEL 1], [LEVEL 2], [LEVEL 3]\n"
// //   "   - Current bid-ask spread\n"
// //   "5. Live technical indicator values (specify time for each):\n"
// //   "   - RSI (14-period): [VALUE]\n"
// //   "   - MACD (12, 26, 9): [VALUE]\n"
// //   "   - Bollinger Bands (20, 2): Upper [VALUE], Middle [VALUE], Lower [VALUE]\n"
// //   "   - 50-day MA: [VALUE]\n"
// //   "   - 200-day MA: [VALUE]\n"
// //   "6. Most recent completed candlestick pattern and its implications\n"
// //   "7. Current trading volume in the last hour compared to the same hour yesterday\n"
// //   "8. Live market depth chart analysis\n"
// //   "9. Highest and lowest prices in the last 60 minutes\n"
// //   "10. Current funding rates for perpetual futures (if applicable)\n"
// //   "Ensure all data points are as current as possible, ideally not older than 5 minutes. "
// //   "If real-time data is unavailable for any metric, clearly state the most recent available timestamp for that data point."
// // );

//   analysis['fundamental'] = await generateAIResponse(
//     "Analyze the current fundamental aspects of ${crypto.name} (${crypto.symbol}) as of $currentDate. Cover:\n"
//     "1. Latest technological updates or changes to the protocol\n"
//     "2. Most recent partnerships or adoption metrics\n"
//     "3. Upcoming events or releases in the next 30 days\n"
//     "4. Current market sentiment and social media buzz\n"
//     "5. Any recent regulatory news affecting ${crypto.name}\n"
//     "Prioritize information from the last 30 days and specify dates for any mentioned events or updates."
//   );

// //   analysis['outlook'] = await generateAIResponse(
// //   "Provide a forward-looking analysis for ${crypto.name} (${crypto.symbol}) based on real-time data as of $currentDate. Ensure all referenced data is current within the last hour. Include:\n"
// //   "1. Projected price range for the next 24 hours based on current order book and recent price action\n"
// //   "2. Immediate catalysts or risks within the next 24-48 hours:\n"
// //   "   - Ongoing or imminent network upgrades (specify exact time if scheduled)\n"
// //   "   - Breaking news or rumors affecting ${crypto.name} in the last 3 hours\n"
// //   "   - Sudden changes in whale wallet activity in the last 6 hours\n"
// //   "3. Live market sentiment indicators:\n"
// //   "   - Current Fear and Greed Index value (timestamp the reading)\n"
// //   "   - Real-time social media sentiment analysis (e.g., Twitter mentions in the last hour)\n"
// //   "   - Latest Google Trends data for ${crypto.name} and ${crypto.symbol}\n"
// //   "4. Immediate technical levels to watch in the next 24 hours:\n"
// //   "   - Key support levels: [LEVEL 1], [LEVEL 2]\n"
// //   "   - Key resistance levels: [LEVEL 1], [LEVEL 2]\n"
// //   "5. Current correlation with Bitcoin price movements in the last 4 hours\n"
// //   "6. Live data on open interest and funding rates in derivative markets\n"
// //   "7. Immediate impact of any breaking macroeconomic news in the last 2 hours\n"
// //   "8. Projected volatility for the next 24 hours based on current options market data\n"
// //   "9. Any significant changes in on-chain metrics in the last 6 hours\n"
// //   "10. Current liquidation levels for long and short positions in major exchanges\n"
// //   "Clearly state the timestamp for each data point used in the analysis. "
// //   "Emphasize that this outlook is based on real-time conditions and may change rapidly. "
// //   "Include a prominent disclaimer about the high volatility and unpredictability of cryptocurrency markets."
// // );
//   analysis['team'] = await generateAIResponse(
//     "Deliver a comprehensive report on the current team behind ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
//     "1. Detailed profiles of key team members (at least 5), including their roles, professional backgrounds, and notable achievements\n"
//     "2. Recent changes in leadership or significant hires in the last 6 months\n"
//     "3. Team's latest public appearances, interviews, or statements (provide dates)\n"
//     "4. Ongoing projects or initiatives led by specific team members\n"
//     "5. Any controversies or praised actions involving team members in the last year\n"
//     "6. Assessment of the team's transparency and communication with the community\n"
//     "7. Comparison of the team's expertise with that of competitor projects\n"
//     "Provide specific dates for any mentioned events or changes and focus on the most recent information available."
//   );

//   return analysis;
// }
// }

// class ApiService {
//   static const List<String> baseUrls = [
//     'https://api.coingecko.com/api/v3',
//     'https://api.coingecko.com/api/v3',
//     'https://api.coingecko.com/api/v3',
//   ];
//   static const Duration rateLimitDuration = Duration(milliseconds: 500);
//   static const int maxRetries = 5;
//   static final Random _random = Random();
//   static DateTime _lastRequestTime = DateTime.now();

//   static Future<void> _respectRateLimit() async {
//     final now = DateTime.now();
//     final timeSinceLastRequest = now.difference(_lastRequestTime);
//     if (timeSinceLastRequest < rateLimitDuration) {
//       await Future.delayed(rateLimitDuration - timeSinceLastRequest);
//     }
//     _lastRequestTime = DateTime.now();
//   }

//   static Future<dynamic> _getRequest(String endpoint, {int retryCount = 0}) async {
//     await _respectRateLimit();
//     await ThrottleService.throttle(endpoint);
    
//     final cachedData = await CacheService.getCache(endpoint);
//     if (cachedData != null) {
//       return json.decode(cachedData);
//     }

//     final baseUrlIndex = _random.nextInt(baseUrls.length);
//     try {
//       final response = await http.get(Uri.parse('${baseUrls[baseUrlIndex]}$endpoint'));
//       if (response.statusCode == 200) {
//         await CacheService.setCache(endpoint, response.body);
//         return json.decode(response.body);
//       } else if (response.statusCode == 429 && retryCount < maxRetries) {
//         final retryDelay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
//         await Future.delayed(retryDelay);
//         return _getRequest(endpoint, retryCount: retryCount + 1);
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       if (retryCount < maxRetries) {
//         final delay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
//         await Future.delayed(delay);
//         return _getRequest(endpoint, retryCount: retryCount + 1);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   static Future<List<Cryptocurrency>> getCryptocurrencies({int page = 1, int perPage = 100}) async {
//     final cacheKey = 'cryptocurrencies_$page$perPage';
//     final cachedData = await CacheService.getCache(cacheKey);
//     if (cachedData != null) {
//       return (json.decode(cachedData) as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
//     }

//     final data = await _getRequest('/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false');
//     await CacheService.setCache(cacheKey, json.encode(data));
//     return (data as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
//   }

//   static Future<Map<String, dynamic>> getCryptocurrencyDetails(String id) async {
//     return await _getRequest('/coins/$id?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false');
//   }

//   static Future<Cryptocurrency?> getSearchedCryptocurrency(String query) async {
//     final data = await _getRequest('/search?query=$query');
//     final coins = data['coins'] as List;
    
//     if (coins.isEmpty) {
//       return null;
//     }

//     final firstCoin = coins.first;
//     try {
//       final detailData = await getCryptocurrencyDetails(firstCoin['id']);
//       return Cryptocurrency(
//         id: firstCoin['id'],
//         name: firstCoin['name'],
//         symbol: firstCoin['symbol'],
//         price: detailData['market_data']['current_price']['usd']?.toDouble() ?? 0,
//         marketCap: detailData['market_data']['market_cap']['usd']?.toDouble() ?? 0,
//         volume24h: detailData['market_data']['total_volume']['usd']?.toDouble() ?? 0,
//         percentChange24h: detailData['market_data']['price_change_percentage_24h']?.toDouble() ?? 0,
//         image: firstCoin['large'] ?? '',
//         rank: detailData['market_cap_rank'] ?? 0,
//         circulatingSupply: detailData['market_data']['circulating_supply']?.toDouble() ?? 0,
//         totalSupply: detailData['market_data']['total_supply']?.toDouble(),
//         maxSupply: detailData['market_data']['max_supply']?.toDouble(),
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future<List<List<dynamic>>> getMarketChart(String id, int days) async {
//     final data = await _getRequest('/coins/$id/market_chart?vs_currency=usd&days=$days');
//     return List<List<dynamic>>.from(data['prices']);
//   }
// }

// class CryptocurrencyDetailScreen extends StatefulWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyDetailScreen({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   _CryptocurrencyDetailScreenState createState() => _CryptocurrencyDetailScreenState();
// }

// class _CryptocurrencyDetailScreenState extends State<CryptocurrencyDetailScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late ScrollController _scrollController;
  
//   Map<String, dynamic> details = {};
//   bool isLoading = true;
//   bool isChartLoading = true;
//   List<FlSpot> priceData = [];
//   int selectedChartDays = 7;
//   Map<String, String> aiAnalysis = {
//     'general': 'Loading...',
//     'news': 'Loading...',
//    // 'technical': 'Loading...',
//     'fundamental': 'Loading...',
//    // 'outlook': 'Loading...',
//     'team': 'Loading...',
//   };

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     _scrollController = ScrollController();
//     fetchDetails();
//     fetchComprehensiveAnalysis();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchDetails() async {
//     setState(() => isLoading = true);
//     try {
//       final fetchedDetails = await ApiService.getCryptocurrencyDetails(widget.cryptocurrency.id);
//       setState(() {
//         details = fetchedDetails;
//         isLoading = false;
//       });
//       fetchMarketChart();
//     } catch (e) {
//       setState(() => isLoading = false);
//       _showErrorSnackbar('Failed to fetch cryptocurrency details');
//     }
//   }

//   Future<void> fetchMarketChart() async {
//     setState(() => isChartLoading = true);
//     try {
//       final chartData = await ApiService.getMarketChart(widget.cryptocurrency.id, selectedChartDays);
//       setState(() {
//         priceData = chartData.map((point) => FlSpot(point[0].toDouble(), point[1].toDouble())).toList();
//         isChartLoading = false;
//       });
//     } catch (e) {
//       setState(() => isChartLoading = false);
//       _showErrorSnackbar('Failed to fetch market chart data');
//     }
//   }

//   Future<void> fetchComprehensiveAnalysis() async {
//     try {
//       final analysis = await AIService.generateComprehensiveAnalysis(widget.cryptocurrency);
//       setState(() {
//         aiAnalysis = analysis;
//       });
//     } catch (e) {
//       _showErrorSnackbar('Failed to fetch AI analysis');
//     }
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 200.0,
//               floating: false,
//               pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(widget.cryptocurrency.name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     shadows: [Shadow(blurRadius: 2.0, color: Colors.black45, offset: Offset(1.0, 1.0))],
//                   ),
//                 ),
//                 background: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Hero(
//                       tag: 'crypto-${widget.cryptocurrency.id}',
//                       child: CachedNetworkImage(
//                         imageUrl: widget.cryptocurrency.image,
//                         fit: BoxFit.cover,
//                         color: Colors.black.withOpacity(0.5),
//                         colorBlendMode: BlendMode.darken,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 60,
//                       left: 16,
//                       child: CircleAvatar(
//                         backgroundImage: CachedNetworkImageProvider(widget.cryptocurrency.image),
//                         radius: 30,
//                         backgroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.refresh),
//                   onPressed: fetchDetails,
//                 ),
//               ],
//             ),
//           ];
//         },
//         body: isLoading
//             ? _buildLoadingScreen()
//             : Column(
//                 children: [
//                   _buildPriceHeader(),
//                   TabBar(
//                     controller: _tabController,
//                     labelColor: Theme.of(context).primaryColor,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Theme.of(context).primaryColor,
//                     tabs: const [
//                       Tab(text: 'Overview'),
//                       Tab(text: 'Chart'),
//                       Tab(text: 'AI Insights'),
//                       Tab(text: 'Details'),
//                     ],
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         _buildOverviewTab(),
//                         _buildChartTab(),
//                         _buildAIInsightsTab(),
//                         _buildDetailsTab(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildAIInsightsTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildAIInsights(),
//       ],
//     );
//   }

//   Widget _buildAIInsights() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('AI Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 16),
//         _buildAIInsightCard('General Analysis', aiAnalysis['general']!),
//         _buildAIInsightCard('Latest News', aiAnalysis['news']!),
//        // _buildAIInsightCard('Technical Analysis', aiAnalysis['technical']!),
//         _buildAIInsightCard('Fundamental Analysis', aiAnalysis['fundamental']!),
//       //  _buildAIInsightCard('Future Outlook', aiAnalysis['outlook']!),
//         _buildAIInsightCard('Team Details', aiAnalysis['team']!),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: fetchComprehensiveAnalysis,
//           child: const Text('Refresh AI Insights'),
//         ),
//       ],
//     );
//   }

//   Widget _buildAIInsightCard(String title, String content) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       margin: const EdgeInsets.only(bottom: 16),
//       child: ExpansionTile(
//         title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text(content),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingScreen() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) => Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 80,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPriceHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: Theme.of(context).cardColor,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 widget.cryptocurrency.symbol.toUpperCase(),
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: widget.cryptocurrency.percentChange24h >= 0 ? Colors.green : Colors.red,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               '${widget.cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOverviewTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildKeyStatistics(),
//         const SizedBox(height: 16),
//         _buildDescription(),
//         const SizedBox(height: 16),
//         _buildLinks(),
//       ],
//     );
//   }

//   Widget _buildChartTab() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildChartButton('7D', 7),
//               _buildChartButton('30D', 30),
//               _buildChartButton('90D', 90),
//               _buildChartButton('1Y', 365),
//             ],
//           ),
//         ),
//         Expanded(
//           child: isChartLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: LineChart(
//                     LineChartData(
//                       gridData: FlGridData(show: false),
//                       titlesData: FlTitlesData(show: false),
//                       borderData: FlBorderData(show: false),
//                       minX: priceData.isNotEmpty ? priceData.first.x : 0,
//                       maxX: priceData.isNotEmpty ? priceData.last.x : 0,
//                       minY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(min) : 0,
//                       maxY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(max) : 0,
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: priceData,
//                           isCurved: true,
//                           color: Theme.of(context).primaryColor,
//                           barWidth: 3,
//                           isStrokeCapRound: true,
//                           dotData: FlDotData(show: false),
//                           belowBarData: BarAreaData(
//                             show: true,
//                             color: Theme.of(context).primaryColor.withOpacity(0.1),
//                           ),
//                         ),
//                       ],
//                       lineTouchData: LineTouchData(
//                         touchTooltipData: LineTouchTooltipData(
//                           tooltipRoundedRadius: 8,
//                           getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
//                             return touchedBarSpots.map((barSpot) {
//                               final flSpot = barSpot;
//                               if (flSpot.x == 0 || flSpot.x.isNaN || flSpot.y == 0 || flSpot.y.isNaN) {
//                                 return null;
//                               }
//                               final DateTime date = DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
//                               return LineTooltipItem(
//                                 '${DateFormat('MMM d, yyyy').format(date)}\n\$${flSpot.y.toStringAsFixed(2)}',
//                                 const TextStyle(color: Colors.white),
//                               );
//                             }).toList();
//                           },
//                         ),
//                         handleBuiltInTouches: true,
//                         getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
//                           return spotIndexes.map((spotIndex) {
//                             return TouchedSpotIndicatorData(
//                               FlLine(color: Colors.blue, strokeWidth: 2),
//                               FlDotData(
//                                 getDotPainter: (spot, percent, barData, index) {
//                                   return FlDotCirclePainter(
//                                     radius: 6,
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                     strokeColor: Colors.blue,
//                                   );
//                                 },
//                               ),
//                             );
//                           }).toList();
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             'Price: \$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChartButton(String label, int days) {
//     return ElevatedButton(
//       onPressed: () {
//         setState(() => selectedChartDays = days);
//         fetchMarketChart();
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: selectedChartDays == days ? Theme.of(context).primaryColor : Colors.grey.shade200,
//         foregroundColor: selectedChartDays == days ? Colors.white : Colors.black,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       ),
//       child: Text(label),
//     );
//   }

//   Widget _buildDetailsTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildAllTimeHighLow(),
//         const SizedBox(height: 16),
//         _buildAdditionalInfo(),
//       ],
//     );
//   }

//   Widget _buildKeyStatistics() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Key Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('Market Cap', '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.marketCap)}'),
//             _buildStatItem('24h Volume', '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.volume24h)}'),
//             _buildStatItem('Circulating Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.circulatingSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//             if (widget.cryptocurrency.totalSupply != null)
//               _buildStatItem('Total Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.totalSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//             if (widget.cryptocurrency.maxSupply != null)
//               _buildStatItem('Max Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.maxSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 16)),
//           Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   Widget _buildDescription() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             Text(details['description']?['en'] ?? 'No description available.'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLinks() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Links', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             if (details['links']?['homepage'] != null)
//               _buildLinkItem('Website', details['links']['homepage'][0]),
//             if (details['links']?['blockchain_site'] != null)
//               _buildLinkItem('Blockchain Explorer', details['links']['blockchain_site'][0]),
//             if (details['links']?['repos_url']?['github']?.isNotEmpty ?? false)
//               _buildLinkItem('GitHub', details['links']['repos_url']['github'][0]),
//             if (details['links']?['twitter_screen_name'] != null)
//               _buildLinkItem('Twitter', 'https://twitter.com/${details['links']['twitter_screen_name']}'),
//             if (details['links']?['facebook_username'] != null)
//               _buildLinkItem('Facebook', 'https://facebook.com/${details['links']['facebook_username']}'),
//             if (details['links']?['subreddit_url'] != null)
//               _buildLinkItem('Reddit', details['links']['subreddit_url']),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLinkItem(String label, String url) {
//     return ListTile(
//       title: Text(label),
//       trailing: const Icon(Icons.open_in_new),
//       onTap: () => _launchURL(url),
//     );
//   }

//   void _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       _showErrorSnackbar('Could not launch $url');
//     }
//   }

//   Widget _buildAllTimeHighLow() {
//     final athDate = details['market_data']?['ath_date']?['usd'] != null
//         ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['ath_date']['usd']))
//         : 'N/A';
//     final atlDate = details['market_data']?['atl_date']?['usd'] != null
//         ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['atl_date']['usd']))
//         : 'N/A';

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('All-Time High/Low', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('All-Time High', '\$${NumberFormat("#,##0.00").format(details['market_data']?['ath']?['usd'] ?? 0)}'),
//             Text('Date: $athDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
//             const SizedBox(height: 8),
//             _buildStatItem('All-Time Low', '\$${NumberFormat("#,##0.00").format(details['market_data']?['atl']?['usd'] ?? 0)}'),
//             Text('Date: $atlDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAdditionalInfo() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Additional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('Hashing Algorithm', details['hashing_algorithm'] ?? 'N/A'),
//             _buildStatItem('Genesis Date', details['genesis_date'] ?? 'N/A'),
//             _buildStatItem('Sentiment Up Votes', '${details['sentiment_votes_up_percentage']}%'),
//             _buildStatItem('Sentiment Down Votes', '${details['sentiment_votes_down_percentage']}%'),
//             _buildStatItem('Market Cap Rank', '#${details['market_cap_rank']}'),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'dart:math';
// import 'package:shimmer/shimmer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: CryptoExchangeApp(),
//     ),
//   );
// }

// class CryptoExchangeApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           title: 'Crypto Insights',
//           theme: themeProvider.currentTheme,
//           home: SearchScreen(),
//           routes: {
//             '/settings': (context) => SettingsScreen(),
//           },
//           debugShowCheckedModeBanner: false,
//         );
//       },
//     );
//   }
// }

// class ThemeProvider extends ChangeNotifier {
//   static const Color _primaryDark = Color(0xFF6200EA);
//   static const Color _primaryLight = Color(0xFF3F51B5);
//   static const Color _accentDark = Color(0xFFFF4081);
//   static const Color _accentLight = Color(0xFFFF9800);
//   static const Color _backgroundDark = Color(0xFF121212);
//   static const Color _backgroundLight = Color(0xFFF5F5F5);
//   static const Color _cardDark = Color(0xFF1E1E1E);
//   static const Color _cardLight = Color(0xFFFFFFFF);

//   static final ThemeData _darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: _primaryDark,
//     scaffoldBackgroundColor: _backgroundDark,
//     cardColor: _cardDark,
//     colorScheme: const ColorScheme.dark(
//       primary: _primaryDark,
//       secondary: _accentDark,
//       surface: _cardDark,
//       background: _backgroundDark,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentDark,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentDark),
//   );

//   static final ThemeData _lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: _primaryLight,
//     scaffoldBackgroundColor: _backgroundLight,
//     cardColor: _cardLight,
//     colorScheme: const ColorScheme.light(
//       primary: _primaryLight,
//       secondary: _accentLight,
//       surface: _cardLight,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.black54, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentLight,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentLight),
//   );

//   late ThemeData _currentTheme;

//   ThemeProvider() {
//     _currentTheme = _darkTheme;
//   }

//   ThemeData get currentTheme => _currentTheme;
//   bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

//   void toggleTheme() {
//     _currentTheme = isDarkMode ? _lightTheme : _darkTheme;
//     notifyListeners();
//   }

//   void setDarkMode() {
//     _currentTheme = _darkTheme;
//     notifyListeners();
//   }

//   void setLightMode() {
//     _currentTheme = _lightTheme;
//     notifyListeners();
//   }
// }

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
//   final TextEditingController _searchController = TextEditingController();
//   Cryptocurrency? _searchResult;
//   bool _isLoading = false;
//   Timer? _debounce;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//     _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     _debounce?.cancel();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (_searchController.text.isNotEmpty) {
//         _performSearch(_searchController.text);
//       } else {
//         setState(() => _searchResult = null);
//       }
//     });
//   }

//   Future<void> _performSearch(String query) async {
//     setState(() => _isLoading = true);
//     try {
//       final result = await ApiService.getSearchedCryptocurrency(query);
//       setState(() {
//         _searchResult = result;
//         _isLoading = false;
//       });
//       _animationController.forward(from: 0.0);
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crypto Insights', style: TextStyle(fontWeight: FontWeight.bold)),
//         elevation: 0,
//       ),
//       drawer: AppDrawer(),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
//             ),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search cryptocurrency',
//                 prefixIcon: const Icon(Icons.search, color: Colors.white),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.2),
//               ),
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//           Expanded(
//             child: _buildSearchResults(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchResults() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (_searchResult != null) {
//       return FadeTransition(
//         opacity: _fadeAnimation,
//         child: CryptocurrencyListItem(cryptocurrency: _searchResult!),
//       );
//     } else {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.search, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'Search for a cryptocurrency',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

// class CryptocurrencyListItem extends StatelessWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyListItem({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () => _navigateToDetailScreen(context),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader(),
//                 const SizedBox(height: 12),
//                 _buildPriceInfo(),
//                 const SizedBox(height: 12),
//                 _buildAdditionalInfo(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Hero(
//           tag: 'crypto-${cryptocurrency.id}',
//           child: CircleAvatar(
//             backgroundImage: CachedNetworkImageProvider(cryptocurrency.image),
//             radius: 24,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 cryptocurrency.name,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               Text(
//                 cryptocurrency.symbol.toUpperCase(),
//                 style: const TextStyle(fontSize: 14, color: Colors.white70),
//               ),
//             ],
//           ),
//         ),
//         if (cryptocurrency.rank != 0)
//           Chip(
//             label: Text(
//               '#${cryptocurrency.rank}',
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             backgroundColor: Colors.black26,
//           ),
//       ],
//     );
//   }

//   Widget _buildPriceInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Price',
//               style: TextStyle(fontSize: 14, color: Colors.white70),
//             ),
//             Text(
//               '\$${cryptocurrency.price.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ],
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             const Text(
//               '24h Change',
//               style: TextStyle(fontSize: 14, color: Colors.white70),
//             ),
//             Text(
//               '${_getChangeIcon(cryptocurrency.percentChange24h)} ${cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _getChangeColor(cryptocurrency.percentChange24h),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAdditionalInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildInfoItem('Market Cap', '\$${_formatLargeNumber(cryptocurrency.marketCap)}'),
//         _buildInfoItem('24h Volume', '\$${_formatLargeNumber(cryptocurrency.volume24h)}'),
//       ],
//     );
//   }

//   Widget _buildInfoItem(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
//         Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
//       ],
//     );
//   }

//   String _getChangeIcon(double change) {
//     return change >= 0 ? '▲' : '▼';
//   }

//   Color _getChangeColor(double change) {
//     return change >= 0 ? Colors.greenAccent : Colors.redAccent;
//   }

//   String _formatLargeNumber(double number) {
//     if (number >= 1e9) {
//       return '${(number / 1e9).toStringAsFixed(2)}B';
//     } else if (number >= 1e6) {
//       return '${(number / 1e6).toStringAsFixed(2)}M';
//     } else if (number >= 1e3) {
//       return '${(number / 1e3).toStringAsFixed(2)}K';
//     } else {
//       return number.toStringAsFixed(2);
//     }
//   }

//   void _navigateToDetailScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CryptocurrencyDetailScreen(
//           cryptocurrency: cryptocurrency,
//         ),
//       ),
//     );
//   }
// }

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: const Text('Theme'),
//             trailing: Consumer<ThemeProvider>(
//               builder: (context, themeProvider, child) {
//                 return Switch(
//                   value: themeProvider.currentTheme.brightness == Brightness.dark,
//                   onChanged: (value) {
//                     themeProvider.toggleTheme();
//                   },
//                   activeColor: Theme.of(context).colorScheme.secondary,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//             ),
//             child: const Text(
//               'Crypto Insights',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//        ListTile(
//             leading: const Icon(Icons.home),
//             title: const Text('Home'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushReplacementNamed(context, '/');
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('Settings'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/settings');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Cryptocurrency {
//   final String id;
//   final String name;
//   final String symbol;
//   final double price;
//   final double marketCap;
//   final double volume24h;
//   final double percentChange24h;
//   final String image;
//   final int rank;
//   final double circulatingSupply;
//   final double? totalSupply;
//   final double? maxSupply;

//   Cryptocurrency({
//     required this.id,
//     required this.name,
//     required this.symbol,
//     required this.price,
//     required this.marketCap,
//     required this.volume24h,
//     required this.percentChange24h,
//     required this.image,
//     required this.rank,
//     required this.circulatingSupply,
//     this.totalSupply,
//     this.maxSupply,
//   });

//   factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
//     return Cryptocurrency(
//       id: json['id'],
//       name: json['name'],
//       symbol: json['symbol'],
//       price: (json['current_price'] ?? 0).toDouble(),
//       marketCap: (json['market_cap'] ?? 0).toDouble(),
//       volume24h: (json['total_volume'] ?? 0).toDouble(),
//       percentChange24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
//       image: json['image'] ?? '',
//       rank: json['market_cap_rank'] ?? 0,
//       circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
//       totalSupply: json['total_supply']?.toDouble(),
//       maxSupply: json['max_supply']?.toDouble(),
//     );
//   }
// }

// class CacheService {
//   static const String prefix = 'api_cache_';
//   static const Duration defaultCacheDuration = Duration(minutes: 15);

//   static Future<void> setCache(String key, String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('$prefix$key', value);
//     await prefs.setInt('${prefix}${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
//   }

//   static Future<String?> getCache(String key, {Duration? maxAge}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final value = prefs.getString('$prefix$key');
//     final timestamp = prefs.getInt('${prefix}${key}_timestamp');
    
//     if (value != null && timestamp != null) {
//       final age = DateTime.now().millisecondsSinceEpoch - timestamp;
//       if (age < (maxAge ?? defaultCacheDuration).inMilliseconds) {
//         return value;
//       }
//     }
//     return null;
//   }
// }

// class ThrottleService {
//   static final Map<String, DateTime> _lastRequestTimes = {};
//   static const Duration throttleDuration = Duration(seconds: 1);

//   static Future<void> throttle(String key) async {
//     final now = DateTime.now();
//     final lastRequestTime = _lastRequestTimes[key];
//     if (lastRequestTime != null) {
//       final timeSinceLastRequest = now.difference(lastRequestTime);
//       if (timeSinceLastRequest < throttleDuration) {
//         await Future.delayed(throttleDuration - timeSinceLastRequest);
//       }
//     }
//     _lastRequestTimes[key] = DateTime.now();
//   }
// }

// class AIService {
//   static const String apiKey = 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y';
//   static final model = GenerativeModel(
//     model: 'gemini-pro',
//     apiKey: apiKey,
//   );

//   static Future<String> generateAIResponse(String prompt) async {
//     try {
//       final content = [Content.text(prompt)];
//       final response = await model.generateContent(content);
//       if (response.text != null && response.text!.isNotEmpty) {
//         return response.text!;
//       } else {
//         return 'No response generated';
//       }
//     } catch (e) {
//       return 'Error generating response: $e';
//     }
//   }

//   static Future<Map<String, String>> generateComprehensiveAnalysis(Cryptocurrency crypto) async {
//     Map<String, String> analysis = {};
//     String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

//     analysis['general'] = await generateAIResponse(
//       "Provide a comprehensive general analysis of ${crypto.name} (${crypto.symbol}) in the cryptocurrency market as of $currentDate. Include:\n"
//       "1. Current price: \$${crypto.price.toStringAsFixed(2)} - compare this to 7-day and 30-day averages\n"
//       "2. Market cap: \$${crypto.marketCap.toStringAsFixed(2)} - discuss its rank and recent changes\n"
//       "3. 24-hour trading volume and how it compares to the 7-day average\n"
//       "4. Recent performance: 24h, 7d, and 30d price changes (in percentages)\n"
//       "5. Current market dominance and comparison to major cryptocurrencies\n"
//       "6. Brief overview of on-chain metrics (e.g., active addresses, transaction count) if applicable\n"
//       "7. General market sentiment towards ${crypto.name} based on recent events\n"
//       "Provide specific numbers and percentages where possible, and focus on data from the last 30 days."
//     );

//     analysis['news'] = await generateAIResponse(
//       "Summarize the most recent news and developments for ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
//       "1. Major announcements or events from the past 7 days, with exact dates\n"
//       "2. Any significant partnerships or collaborations revealed in the last 30 days\n"
//       "3. Recent protocol upgrades or technological advancements, specifying implementation dates\n"
//       "4. Regulatory news or legal developments affecting ${crypto.name} in the past month\n"
//       "5. Notable mentions of ${crypto.name} by industry leaders or influential figures (quote if possible)\n"
//       "6. Upcoming events in the next 14 days that could impact ${crypto.name}'s value\n"
//       "7. Any changes in ${crypto.name}'s ecosystem (e.g., DeFi, NFTs) in the last 30 days\n"
//       "8. Comparison of recent news to its main competitors\n"
//       "Prioritize the most impactful and recent news items. For each point, provide the date of occurrence or announcement."
//     );

//     analysis['fundamental'] = await generateAIResponse(
//       "Analyze the current fundamental aspects of ${crypto.name} (${crypto.symbol}) as of $currentDate. Cover:\n"
//       "1. Latest technological updates or changes to the protocol\n"
//       "2. Most recent partnerships or adoption metrics\n"
//       "3. Upcoming events or releases in the next 30 days\n"
//       "4. Current market sentiment and social media buzz\n"
//       "5. Any recent regulatory news affecting ${crypto.name}\n"
//       "Prioritize information from the last 30 days and specify dates for any mentioned events or updates."
//     );

//     analysis['team'] = await generateAIResponse(
//       "Deliver a comprehensive report on the current team behind ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
//       "1. Detailed profiles of key team members (at least 5), including their roles, professional backgrounds, and notable achievements\n"
//       "2. Recent changes in leadership or significant hires in the last 6 months\n"
//       "3. Team's latest public appearances, interviews, or statements (provide dates)\n"
//       "4. Ongoing projects or initiatives led by specific team members\n"
//       "5. Any controversies or praised actions involving team members in the last year\n"
//       "6. Assessment of the team's transparency and communication with the community\n"
//       "7. Comparison of the team's expertise with that of competitor projects\n"
//       "Provide specific dates for any mentioned events or changes and focus on the most recent information available."
//     );

//     return analysis;
//   }
// }

// class ApiService {
//   static const List<String> baseUrls = [
//     'https://api.coingecko.com/api/v3',
//     'https://api.coingecko.com/api/v3',
//     'https://api.coingecko.com/api/v3',
//   ];
//   static const Duration rateLimitDuration = Duration(milliseconds: 500);
//   static const int maxRetries = 5;
//   static final Random _random = Random();
//   static DateTime _lastRequestTime = DateTime.now();

//   static Future<void> _respectRateLimit() async {
//     final now = DateTime.now();
//     final timeSinceLastRequest = now.difference(_lastRequestTime);
//     if (timeSinceLastRequest < rateLimitDuration) {
//       await Future.delayed(rateLimitDuration - timeSinceLastRequest);
//     }
//     _lastRequestTime = DateTime.now();
//   }

//   static Future<dynamic> _getRequest(String endpoint, {int retryCount = 0}) async {
//     await _respectRateLimit();
//     await ThrottleService.throttle(endpoint);
    
//     final cachedData = await CacheService.getCache(endpoint);
//     if (cachedData != null) {
//       return json.decode(cachedData);
//     }

//     final baseUrlIndex = _random.nextInt(baseUrls.length);
//     try {
//       final response = await http.get(Uri.parse('${baseUrls[baseUrlIndex]}$endpoint'));
//       if (response.statusCode == 200) {
//         await CacheService.setCache(endpoint, response.body);
//         return json.decode(response.body);
//       } else if (response.statusCode == 429 && retryCount < maxRetries) {
//         final retryDelay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
//         await Future.delayed(retryDelay);
//         return _getRequest(endpoint, retryCount: retryCount + 1);
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       if (retryCount < maxRetries) {
//         final delay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
//         await Future.delayed(delay);
//         return _getRequest(endpoint, retryCount: retryCount + 1);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   static Future<List<Cryptocurrency>> getCryptocurrencies({int page = 1, int perPage = 100}) async {
//     final cacheKey = 'cryptocurrencies_$page$perPage';
//     final cachedData = await CacheService.getCache(cacheKey);
//     if (cachedData != null) {
//       return (json.decode(cachedData) as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
//     }

//     final data = await _getRequest('/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false');
//     await CacheService.setCache(cacheKey, json.encode(data));
//     return (data as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
//   }

//   static Future<Map<String, dynamic>> getCryptocurrencyDetails(String id) async {
//     return await _getRequest('/coins/$id?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false');
//   }

//   static Future<Cryptocurrency?> getSearchedCryptocurrency(String query) async {
//     final data = await _getRequest('/search?query=$query');
//     final coins = data['coins'] as List;
    
//     if (coins.isEmpty) {
//       return null;
//     }

//     final firstCoin = coins.first;
//     try {
//       final detailData = await getCryptocurrencyDetails(firstCoin['id']);
//       return Cryptocurrency(
//         id: firstCoin['id'],
//         name: firstCoin['name'],
//         symbol: firstCoin['symbol'],
//         price: detailData['market_data']['current_price']['usd']?.toDouble() ?? 0,
//         marketCap: detailData['market_data']['market_cap']['usd']?.toDouble() ?? 0,
//         volume24h: detailData['market_data']['total_volume']['usd']?.toDouble() ?? 0,
//         percentChange24h: detailData['market_data']['price_change_percentage_24h']?.toDouble() ?? 0,
//         image: firstCoin['large'] ?? '',
//         rank: detailData['market_cap_rank'] ?? 0,
//         circulatingSupply: detailData['market_data']['circulating_supply']?.toDouble() ?? 0,
//         totalSupply: detailData['market_data']['total_supply']?.toDouble(),
//         maxSupply: detailData['market_data']['max_supply']?.toDouble(),
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future<List<List<dynamic>>> getMarketChart(String id, int days) async {
//     final data = await _getRequest('/coins/$id/market_chart?vs_currency=usd&days=$days');
//     return List<List<dynamic>>.from(data['prices']);
//   }
// }

// class CryptocurrencyDetailScreen extends StatefulWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyDetailScreen({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   _CryptocurrencyDetailScreenState createState() => _CryptocurrencyDetailScreenState();
// }

// class _CryptocurrencyDetailScreenState extends State<CryptocurrencyDetailScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late ScrollController _scrollController;
  
//   Map<String, dynamic> details = {};
//   bool isLoading = true;
//   bool isChartLoading = true;
//   List<FlSpot> priceData = [];
//   int selectedChartDays = 7;
//   Map<String, String> aiAnalysis = {
//     'general': 'Loading...',
//     'news': 'Loading...',
//     'fundamental': 'Loading...',
//     'team': 'Loading...',
//   };
//   String aiQuestion = '';
//   String aiAnswer = '';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//     _scrollController = ScrollController();
//     fetchDetails();
//     fetchComprehensiveAnalysis();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchDetails() async {
//     setState(() => isLoading = true);
//     try {
//       final fetchedDetails = await ApiService.getCryptocurrencyDetails(widget.cryptocurrency.id);
//       setState(() {
//         details = fetchedDetails;
//         isLoading = false;
//       });
//       fetchMarketChart();
//     } catch (e) {
//       setState(() => isLoading = false);
//       _showErrorSnackbar('Failed to fetch cryptocurrency details');
//     }
//   }

//   Future<void> fetchMarketChart() async {
//     setState(() => isChartLoading = true);
//     try {
//       final chartData = await ApiService.getMarketChart(widget.cryptocurrency.id, selectedChartDays);
//       setState(() {
//         priceData = chartData.map((point) => FlSpot(point[0].toDouble(), point[1].toDouble())).toList();
//         isChartLoading = false;
//       });
//     } catch (e) {
//       setState(() => isChartLoading = false);
//       _showErrorSnackbar('Failed to fetch market chart data');
//     }
//   }

//   Future<void> fetchComprehensiveAnalysis() async {
//     try {
//       final analysis = await AIService.generateComprehensiveAnalysis(widget.cryptocurrency);
//       setState(() {
//         aiAnalysis = analysis;
//       });
//     } catch (e) {
//       _showErrorSnackbar('Failed to fetch AI analysis');
//     }
//   }
//   Future<void> askAIQuestion() async {
//   if (aiQuestion.isEmpty) return;

//   setState(() => aiAnswer = 'Loading...');

//   try {
//     // Use the latest details from the WebSocket connection
//     final response = await AIService.generateAIResponse(
//       "Answer this question about ${details['name']} (${details['symbol']}) as of ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}: $aiQuestion"
//     );
//     setState(() => aiAnswer = response);
//   } catch (e) {
//     setState(() => aiAnswer = 'Failed to get AI response');
//   }
// }

//   // Future<void> askAIQuestion() async {
//   //   if (aiQuestion.isEmpty) return;
//   //   setState(() => aiAnswer = 'Loading...');
//   //   try {
//   //     final answer = await AIService.generateAIResponse(
//   //       "Answer this question about ${widget.cryptocurrency.name}: $aiQuestion"
//   //     );
//   //     setState(() => aiAnswer = answer);
//   //   } catch (e) {
//   //     setState(() => aiAnswer = 'Failed to get AI response');
//   //   }
//   // }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 200.0,
//               floating: false,
//               pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(widget.cryptocurrency.name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     shadows: [Shadow(blurRadius: 2.0, color: Colors.black45, offset: Offset(1.0, 1.0))],
//                   ),
//                 ),
//                 background: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Hero(
//                       tag: 'crypto-${widget.cryptocurrency.id}',
//                       child: CachedNetworkImage(
//                         imageUrl: widget.cryptocurrency.image,
//                         fit: BoxFit.cover,
//                         color: Colors.black.withOpacity(0.5),
//                         colorBlendMode: BlendMode.darken,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 60,
//                       left: 16,
//                       child: CircleAvatar(
//                         backgroundImage: CachedNetworkImageProvider(widget.cryptocurrency.image),
//                         radius: 30,
//                         backgroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.refresh),
//                   onPressed: fetchDetails,
//                 ),
//               ],
//             ),
//           ];
//         },
//         body: isLoading
//             ? _buildLoadingScreen()
//             : Column(
//                 children: [
//                   _buildPriceHeader(),
//                   TabBar(
//                     controller: _tabController,
//                     labelColor: Theme.of(context).primaryColor,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Theme.of(context).primaryColor,
//                     isScrollable: true,
//                     tabs: const [
//                       Tab(text: 'Overview'),
//                       Tab(text: 'Chart'),
//                       Tab(text: 'AI Insights'),
//                       Tab(text: 'AI Q&A'),
//                       Tab(text: 'Details'),
//                     ],
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         _buildOverviewTab(),
//                         _buildChartTab(),
//                         _buildAIInsightsTab(),
//                         _buildAIQATab(),
//                         _buildDetailsTab(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildLoadingScreen() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) => Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 80,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPriceHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: Theme.of(context).cardColor,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 widget.cryptocurrency.symbol.toUpperCase(),
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: widget.cryptocurrency.percentChange24h >= 0 ? Colors.green : Colors.red,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               '${widget.cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOverviewTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildKeyStatistics(),
//         const SizedBox(height: 16),
//         _buildDescription(),
//         const SizedBox(height: 16),
//         _buildLinks(),
//       ],
//     );
//   }

//   Widget _buildChartTab() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildChartButton('7D', 7),
//               _buildChartButton('30D', 30),
//               _buildChartButton('90D', 90),
//               _buildChartButton('1Y', 365),
//             ],
//           ),
//         ),
//         Expanded(
//           child: isChartLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: LineChart(
//                     LineChartData(
//                       gridData: FlGridData(show: false),
//                       titlesData: FlTitlesData(show: false),
//                       borderData: FlBorderData(show: false),
//                       minX: priceData.isNotEmpty ? priceData.first.x : 0,
//                       maxX: priceData.isNotEmpty ? priceData.last.x : 0,
//                       minY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(min) : 0,
//                       maxY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(max) : 0,
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: priceData,
//                           isCurved: true,
//                           color: Theme.of(context).primaryColor,
//                           barWidth: 3,
//                           isStrokeCapRound: true,
//                           dotData: FlDotData(show: false),
//                           belowBarData: BarAreaData(
//                             show: true,
//                             color: Theme.of(context).primaryColor.withOpacity(0.1),
//                           ),
//                         ),
//                       ],
//                       lineTouchData: LineTouchData(
//                         touchTooltipData: LineTouchTooltipData(
//                           tooltipRoundedRadius: 8,
//                           getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
//                             return touchedBarSpots.map((barSpot) {
//                               final flSpot = barSpot;
//                               if (flSpot.x == 0 || flSpot.x.isNaN || flSpot.y == 0 || flSpot.y.isNaN) {
//                                 return null;
//                               }
//                               final DateTime date = DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
//                               return LineTooltipItem(
//                                 '${DateFormat('MMM d, yyyy').format(date)}\n\$${flSpot.y.toStringAsFixed(2)}',
//                                 const TextStyle(color: Colors.white),
//                               );
//                             }).toList();
//                           },
//                         ),
//                         handleBuiltInTouches: true,
//                         getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
//                           return spotIndexes.map((spotIndex) {
//                             return TouchedSpotIndicatorData(
//                               FlLine(color: Colors.blue, strokeWidth: 2),
//                               FlDotData(
//                                 getDotPainter: (spot, percent, barData, index) {
//                                   return FlDotCirclePainter(
//                                     radius: 6,
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                     strokeColor: Colors.blue,
//                                   );
//                                 },
//                               ),
//                             );
//                           }).toList();
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             'Price: \$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChartButton(String label, int days) {
//     return ElevatedButton(
//       onPressed: () {
//         setState(() => selectedChartDays = days);
//         fetchMarketChart();
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: selectedChartDays == days ? Theme.of(context).primaryColor : Colors.grey.shade200,
//         foregroundColor: selectedChartDays == days ? Colors.white : Colors.black,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       ),
//       child: Text(label),
//     );
//   }

//   Widget _buildAIInsightsTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildAIInsights(),
//       ],
//     );
//   }

//   Widget _buildAIInsights() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('AI Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 16),
//         _buildAIInsightCard('General Analysis', aiAnalysis['general']!),
//         _buildAIInsightCard('Latest News', aiAnalysis['news']!),
//         _buildAIInsightCard('Fundamental Analysis', aiAnalysis['fundamental']!),
//         _buildAIInsightCard('Team Details', aiAnalysis['team']!),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: fetchComprehensiveAnalysis,
//           child: const Text('Refresh AI Insights'),
//         ),
//       ],
//     );
//   }

//   Widget _buildAIInsightCard(String title, String content) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       margin: const EdgeInsets.only(bottom: 16),
//       child: ExpansionTile(
//         title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text(content),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAIQATab() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Ask AI about this Cryptocurrency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//           TextField(
//             onChanged: (value) => setState(() => aiQuestion = value),
//             decoration: InputDecoration(
//               hintText: 'Enter your question here',
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.send),
//                 onPressed: askAIQuestion,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text('AI Answer:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Text(aiAnswer),
//               ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailsTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildAllTimeHighLow(),
//         const SizedBox(height: 16),
//         _buildAdditionalInfo(),
//       ],
//     );
//   }

//   Widget _buildKeyStatistics() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Key Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('Market Cap', '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.marketCap)}'),
//             _buildStatItem('24h Volume', '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.volume24h)}'),
//             _buildStatItem('Circulating Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.circulatingSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//             if (widget.cryptocurrency.totalSupply != null)
//               _buildStatItem('Total Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.totalSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//             if (widget.cryptocurrency.maxSupply != null)
//               _buildStatItem('Max Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.maxSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 15)),
//           Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   Widget _buildDescription() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             Text(details['description']?['en'] ?? 'No description available.'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLinks() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Links', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             if (details['links']?['homepage'] != null)
//               _buildLinkItem('Website', details['links']['homepage'][0]),
//             if (details['links']?['blockchain_site'] != null)
//               _buildLinkItem('Blockchain Explorer', details['links']['blockchain_site'][0]),
//             if (details['links']?['repos_url']?['github']?.isNotEmpty ?? false)
//               _buildLinkItem('GitHub', details['links']['repos_url']['github'][0]),
//             if (details['links']?['twitter_screen_name'] != null)
//               _buildLinkItem('Twitter', 'https://twitter.com/${details['links']['twitter_screen_name']}'),
//             if (details['links']?['facebook_username'] != null)
//               _buildLinkItem('Facebook', 'https://facebook.com/${details['links']['facebook_username']}'),
//             if (details['links']?['subreddit_url'] != null)
//               _buildLinkItem('Reddit', details['links']['subreddit_url']),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLinkItem(String label, String url) {
//     return ListTile(
//       title: Text(label),
//       trailing: const Icon(Icons.open_in_new),
//       onTap: () => _launchURL(url),
//     );
//   }

//   void _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       _showErrorSnackbar('Could not launch $url');
//     }
//   }

//   Widget _buildAllTimeHighLow() {
//     final athDate = details['market_data']?['ath_date']?['usd'] != null
//         ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['ath_date']['usd']))
//         : 'N/A';
//     final atlDate = details['market_data']?['atl_date']?['usd'] != null
//         ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['atl_date']['usd']))
//         : 'N/A';

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('All-Time High/Low', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('All-Time High', '\$${NumberFormat("#,##0.00").format(details['market_data']?['ath']?['usd'] ?? 0)}'),
//             Text('Date: $athDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
//             const SizedBox(height: 8),
//             _buildStatItem('All-Time Low', '\$${NumberFormat("#,##0.00").format(details['market_data']?['atl']?['usd'] ?? 0)}'),
//             Text('Date: $atlDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAdditionalInfo() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Additional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('Hashing Algorithm', details['hashing_algorithm'] ?? 'N/A'),
//             _buildStatItem('Genesis Date', details['genesis_date'] ?? 'N/A'),
//             _buildStatItem('Sentiment Up Votes', '${details['sentiment_votes_up_percentage']}%'),
//             _buildStatItem('Sentiment Down Votes', '${details['sentiment_votes_down_percentage']}%'),
//             _buildStatItem('Market Cap Rank', '#${details['market_cap_rank']}'),
//           ],
//         ),
//       ),
//     );
//   }
// }



















// import 'similar_coins.dart';
// import 'dart:math';
// import 'package:shimmer/shimmer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: CryptoExchangeApp(),
//     ),
//   );
// }

// class CryptoExchangeApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           title: 'Crypto Insights',
//           theme: themeProvider.currentTheme,
//           home: SearchScreen(),
//           routes: {
//             '/settings': (context) => SettingsScreen(),
//           },
//           debugShowCheckedModeBanner: false,
//         );
//       },
//     );
//   }
// }

// class ThemeProvider extends ChangeNotifier {
//   static const Color _primaryDark = Color(0xFF6200EA);
//   static const Color _primaryLight = Color(0xFF3F51B5);
//   static const Color _accentDark = Color(0xFFFF4081);
//   static const Color _accentLight = Color(0xFFFF9800);
//   static const Color _backgroundDark = Color(0xFF121212);
//   static const Color _backgroundLight = Color(0xFFF5F5F5);
//   static const Color _cardDark = Color(0xFF1E1E1E);
//   static const Color _cardLight = Color(0xFFFFFFFF);

//   static final ThemeData _darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: _primaryDark,
//     scaffoldBackgroundColor: _backgroundDark,
//     cardColor: _cardDark,
//     colorScheme: const ColorScheme.dark(
//       primary: _primaryDark,
//       secondary: _accentDark,
//       surface: _cardDark,
//       background: _backgroundDark,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentDark,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentDark),
//   );

//   static final ThemeData _lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: _primaryLight,
//     scaffoldBackgroundColor: _backgroundLight,
//     cardColor: _cardLight,
//     colorScheme: const ColorScheme.light(
//       primary: _primaryLight,
//       secondary: _accentLight,
//       surface: _cardLight,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.black54, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentLight,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentLight),
//   );

//   late ThemeData _currentTheme;

//   ThemeProvider() {
//     _currentTheme = _darkTheme;
//   }

//   ThemeData get currentTheme => _currentTheme;
//   bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

//   void toggleTheme() {
//     _currentTheme = isDarkMode ? _lightTheme : _darkTheme;
//     notifyListeners();
//   }

//   void setDarkMode() {
//     _currentTheme = _darkTheme;
//     notifyListeners();
//   }

//   void setLightMode() {
//     _currentTheme = _lightTheme;
//     notifyListeners();
//   }
// }

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
//   final TextEditingController _searchController = TextEditingController();
//   Cryptocurrency? _searchResult;
//   bool _isLoading = false;
//   Timer? _debounce;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//     _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     _debounce?.cancel();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (_searchController.text.isNotEmpty) {
//         _performSearch(_searchController.text);
//       } else {
//         setState(() => _searchResult = null);
//       }
//     });
//   }

//   Future<void> _performSearch(String query) async {
//     setState(() => _isLoading = true);
//     try {
//       final result = await ApiService.getSearchedCryptocurrency(query);
//       setState(() {
//         _searchResult = result;
//         _isLoading = false;
//       });
//       _animationController.forward(from: 0.0);
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crypto Insights', style: TextStyle(fontWeight: FontWeight.bold)),
//         elevation: 0,
//       ),
//       drawer: AppDrawer(),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
//             ),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search cryptocurrency',
//                 prefixIcon: const Icon(Icons.search, color: Colors.white),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.2),
//               ),
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//           Expanded(
//             child: _buildSearchResults(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchResults() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (_searchResult != null) {
//       return FadeTransition(
//         opacity: _fadeAnimation,
//         child: CryptocurrencyListItem(cryptocurrency: _searchResult!),
//       );
//     } else {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.search, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'Search for a cryptocurrency',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

// class CryptocurrencyListItem extends StatelessWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyListItem({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () => _navigateToDetailScreen(context),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader(),
//                 const SizedBox(height: 12),
//                 _buildPriceInfo(),
//                 const SizedBox(height: 12),
//                 _buildAdditionalInfo(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Hero(
//           tag: 'crypto-${cryptocurrency.id}',
//           child: CircleAvatar(
//             backgroundImage: CachedNetworkImageProvider(cryptocurrency.image),
//             radius: 24,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 cryptocurrency.name,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               Text(
//                 cryptocurrency.symbol.toUpperCase(),
//                 style: const TextStyle(fontSize: 14, color: Colors.white70),
//               ),
//             ],
//           ),
//         ),
//         if (cryptocurrency.rank != 0)
//           Chip(
//             label: Text(
//               '#${cryptocurrency.rank}',
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             backgroundColor: Colors.black26,
//           ),
//       ],
//     );
//   }

//   Widget _buildPriceInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Price',
//               style: TextStyle(fontSize: 14, color: Colors.white70),
//             ),
//             Text(
//               '\$${cryptocurrency.price.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ],
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             const Text(
//               '24h Change',
//               style: TextStyle(fontSize: 14, color: Colors.white70),
//             ),
//             Text(
//               '${_getChangeIcon(cryptocurrency.percentChange24h)} ${cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _getChangeColor(cryptocurrency.percentChange24h),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAdditionalInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildInfoItem('Market Cap', '\$${_formatLargeNumber(cryptocurrency.marketCap)}'),
//         _buildInfoItem('24h Volume', '\$${_formatLargeNumber(cryptocurrency.volume24h)}'),
//       ],
//     );
//   }

//   Widget _buildInfoItem(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
//         Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
//       ],
//     );
//   }

//   String _getChangeIcon(double change) {
//     return change >= 0 ? '▲' : '▼';
//   }

//   Color _getChangeColor(double change) {
//     return change >= 0 ? Colors.greenAccent : Colors.redAccent;
//   }

//   String _formatLargeNumber(double number) {
//     if (number >= 1e9) {
//       return '${(number / 1e9).toStringAsFixed(2)}B';
//     } else if (number >= 1e6) {
//       return '${(number / 1e6).toStringAsFixed(2)}M';
//     } else if (number >= 1e3) {
//       return '${(number / 1e3).toStringAsFixed(2)}K';
//     } else {
//       return number.toStringAsFixed(2);
//     }
//   }

//   void _navigateToDetailScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CryptocurrencyDetailScreen(
//           cryptocurrency: cryptocurrency,
//         ),
//       ),
//     );
//   }
// }

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: const Text('Theme'),
//             trailing: Consumer<ThemeProvider>(
//               builder: (context, themeProvider, child) {
//                 return Switch(
//                   value: themeProvider.currentTheme.brightness == Brightness.dark,
//                   onChanged: (value) {
//                     themeProvider.toggleTheme();
//                   },
//                   activeColor: Theme.of(context).colorScheme.secondary,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//             ),
//             child: const Text(
//               'Crypto Insights',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//        ListTile(
//             leading: const Icon(Icons.home),
//             title: const Text('Home'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushReplacementNamed(context, '/');
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('Settings'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/settings');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Cryptocurrency {
//   final String id;
//   final String name;
//   final String symbol;
//   final double price;
//   final double marketCap;
//   final double volume24h;
//   final double percentChange24h;
//   final String image;
//   final int rank;
//   final double circulatingSupply;
//   final double? totalSupply;
//   final double? maxSupply;

//   Cryptocurrency({
//     required this.id,
//     required this.name,
//     required this.symbol,
//     required this.price,
//     required this.marketCap,
//     required this.volume24h,
//     required this.percentChange24h,
//     required this.image,
//     required this.rank,
//     required this.circulatingSupply,
//     this.totalSupply,
//     this.maxSupply,
//   });

//   factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
//     return Cryptocurrency(
//       id: json['id'],
//       name: json['name'],
//       symbol: json['symbol'],
//       price: (json['current_price'] ?? 0).toDouble(),
//       marketCap: (json['market_cap'] ?? 0).toDouble(),
//       volume24h: (json['total_volume'] ?? 0).toDouble(),
//       percentChange24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
//       image: json['image'] ?? '',
//       rank: json['market_cap_rank'] ?? 0,
//       circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
//       totalSupply: json['total_supply']?.toDouble(),
//       maxSupply: json['max_supply']?.toDouble(),
//     );
//   }
// }

// class CacheService {
//   static const String prefix = 'api_cache_';
//   static const Duration defaultCacheDuration = Duration(minutes: 15);

//   static Future<void> setCache(String key, String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('$prefix$key', value);
//     await prefs.setInt('${prefix}${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
//   }

//   static Future<String?> getCache(String key, {Duration? maxAge}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final value = prefs.getString('$prefix$key');
//     final timestamp = prefs.getInt('${prefix}${key}_timestamp');
    
//     if (value != null && timestamp != null) {
//       final age = DateTime.now().millisecondsSinceEpoch - timestamp;
//       if (age < (maxAge ?? defaultCacheDuration).inMilliseconds) {
//         return value;
//       }
//     }
//     return null;
//   }
// }

// class ThrottleService {
//   static final Map<String, DateTime> _lastRequestTimes = {};
//   static const Duration throttleDuration = Duration(seconds: 1);

//   static Future<void> throttle(String key) async {
//     final now = DateTime.now();
//     final lastRequestTime = _lastRequestTimes[key];
//     if (lastRequestTime != null) {
//       final timeSinceLastRequest = now.difference(lastRequestTime);
//       if (timeSinceLastRequest < throttleDuration) {
//         await Future.delayed(throttleDuration - timeSinceLastRequest);
//       }
//     }
//     _lastRequestTimes[key] = DateTime.now();
//   }
// }

// class AIService {
//   static const String apiKey = 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y';
//   static final model = GenerativeModel(
//     model: 'gemini-pro',
//     apiKey: apiKey,
//   );

//   static Future<String> generateAIResponse(String prompt) async {
//     try {
//       final content = [Content.text(prompt)];
//       final response = await model.generateContent(content);
//       if (response.text != null && response.text!.isNotEmpty) {
//         return response.text!;
//       } else {
//         return 'No response generated';
//       }
//     } catch (e) {
//       return 'Error generating response: $e';
//     }
//   }

//   static Future<Map<String, String>> generateComprehensiveAnalysis(Cryptocurrency crypto) async {
//     Map<String, String> analysis = {};
//     String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

//     analysis['general'] = await generateAIResponse(
//       "Provide a comprehensive general analysis of ${crypto.name} (${crypto.symbol}) in the cryptocurrency market as of $currentDate. Include:\n"
//       "1. Current price: \$${crypto.price.toStringAsFixed(2)} - compare this to 7-day and 30-day averages\n"
//       "2. Market cap: \$${crypto.marketCap.toStringAsFixed(2)} - discuss its rank and recent changes\n"
//       "3. 24-hour trading volume and how it compares to the 7-day average\n"
//       "4. Recent performance: 24h, 7d, and 30d price changes (in percentages)\n"
//       "5. Current market dominance and comparison to major cryptocurrencies\n"
//       "6. Brief overview of on-chain metrics (e.g., active addresses, transaction count) if applicable\n"
//       "7. General market sentiment towards ${crypto.name} based on recent events\n"
//       "Provide specific numbers and percentages where possible, and focus on data from the last 30 days."
//     );

//     analysis['news'] = await generateAIResponse(
//       "Summarize the most recent news and developments for ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
//       "1. Major announcements or events from the past 7 days, with exact dates\n"
//       "2. Any significant partnerships or collaborations revealed in the last 30 days\n"
//       "3. Recent protocol upgrades or technological advancements, specifying implementation dates\n"
//       "4. Regulatory news or legal developments affecting ${crypto.name} in the past month\n"
//       "5. Notable mentions of ${crypto.name} by industry leaders or influential figures (quote if possible)\n"
//       "6. Upcoming events in the next 14 days that could impact ${crypto.name}'s value\n"
//       "7. Any changes in ${crypto.name}'s ecosystem (e.g., DeFi, NFTs) in the last 30 days\n"
//       "8. Comparison of recent news to its main competitors\n"
//       "Prioritize the most impactful and recent news items. For each point, provide the date of occurrence or announcement."
//     );

//     analysis['fundamental'] = await generateAIResponse(
//       "Analyze the current fundamental aspects of ${crypto.name} (${crypto.symbol}) as of $currentDate. Cover:\n"
//       "1. Latest technological updates or changes to the protocol\n"
//       "2. Most recent partnerships or adoption metrics\n"
//       "3. Upcoming events or releases in the next 30 days\n"
//       "4. Current market sentiment and social media buzz\n"
//       "5. Any recent regulatory news affecting ${crypto.name}\n"
//       "Prioritize information from the last 30 days and specify dates for any mentioned events or updates."
//     );

//     analysis['team'] = await generateAIResponse(
//       "Deliver a comprehensive report on the current team behind ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
//       "1. Detailed profiles of key team members (at least 5), including their roles, professional backgrounds, and notable achievements\n"
//       "2. Recent changes in leadership or significant hires in the last 6 months\n"
//       "3. Team's latest public appearances, interviews, or statements (provide dates)\n"
//       "4. Ongoing projects or initiatives led by specific team members\n"
//       "5. Any controversies or praised actions involving team members in the last year\n"
//       "6. Assessment of the team's transparency and communication with the community\n"
//       "7. Comparison of the team's expertise with that of competitor projects\n"
//       "Provide specific dates for any mentioned events or changes and focus on the most recent information available."
//     );

//     return analysis;
//   }
// }

// class ApiService {
//   static const List<String> baseUrls = [
//     'https://api.coingecko.com/api/v3',
//     'https://api.coingecko.com/api/v3',
//     'https://api.coingecko.com/api/v3',
//   ];
//   static const Duration rateLimitDuration = Duration(milliseconds: 500);
//   static const int maxRetries = 5;
//   static final Random _random = Random();
//   static DateTime _lastRequestTime = DateTime.now();

//   static Future<void> _respectRateLimit() async {
//     final now = DateTime.now();
//     final timeSinceLastRequest = now.difference(_lastRequestTime);
//     if (timeSinceLastRequest < rateLimitDuration) {
//       await Future.delayed(rateLimitDuration - timeSinceLastRequest);
//     }
//     _lastRequestTime = DateTime.now();
//   }

//   static Future<dynamic> _getRequest(String endpoint, {int retryCount = 0}) async {
//     await _respectRateLimit();
//     await ThrottleService.throttle(endpoint);
    
//     final cachedData = await CacheService.getCache(endpoint);
//     if (cachedData != null) {
//       return json.decode(cachedData);
//     }

//     final baseUrlIndex = _random.nextInt(baseUrls.length);
//     try {
//       final response = await http.get(Uri.parse('${baseUrls[baseUrlIndex]}$endpoint'));
//       if (response.statusCode == 200) {
//         await CacheService.setCache(endpoint, response.body);
//         return json.decode(response.body);
//       } else if (response.statusCode == 429 && retryCount < maxRetries) {
//         final retryDelay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
//         await Future.delayed(retryDelay);
//         return _getRequest(endpoint, retryCount: retryCount + 1);
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       if (retryCount < maxRetries) {
//         final delay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
//         await Future.delayed(delay);
//         return _getRequest(endpoint, retryCount: retryCount + 1);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   static Future<List<Cryptocurrency>> getCryptocurrencies({int page = 1, int perPage = 100}) async {
//     final cacheKey = 'cryptocurrencies_$page$perPage';
//     final cachedData = await CacheService.getCache(cacheKey);
//     if (cachedData != null) {
//       return (json.decode(cachedData) as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
//     }

//     final data = await _getRequest('/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false');
//     await CacheService.setCache(cacheKey, json.encode(data));
//     return (data as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
//   }

//   static Future<Map<String, dynamic>> getCryptocurrencyDetails(String id) async {
//     return await _getRequest('/coins/$id?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false');
//   }

//   static Future<Cryptocurrency?> getSearchedCryptocurrency(String query) async {
//     final data = await _getRequest('/search?query=$query');
//     final coins = data['coins'] as List;
    
//     if (coins.isEmpty) {
//       return null;
//     }

//     final firstCoin = coins.first;
//     try {
//       final detailData = await getCryptocurrencyDetails(firstCoin['id']);
//       return Cryptocurrency(
//         id: firstCoin['id'],
//         name: firstCoin['name'],
//         symbol: firstCoin['symbol'],
//         price: detailData['market_data']['current_price']['usd']?.toDouble() ?? 0,
//         marketCap: detailData['market_data']['market_cap']['usd']?.toDouble() ?? 0,
//         volume24h: detailData['market_data']['total_volume']['usd']?.toDouble() ?? 0,
//         percentChange24h: detailData['market_data']['price_change_percentage_24h']?.toDouble() ?? 0,
//         image: firstCoin['large'] ?? '',
//         rank: detailData['market_cap_rank'] ?? 0,
//         circulatingSupply: detailData['market_data']['circulating_supply']?.toDouble() ?? 0,
//         totalSupply: detailData['market_data']['total_supply']?.toDouble(),
//         maxSupply: detailData['market_data']['max_supply']?.toDouble(),
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future<List<List<dynamic>>> getMarketChart(String id, int days) async {
//     final data = await _getRequest('/coins/$id/market_chart?vs_currency=usd&days=$days');
//     return List<List<dynamic>>.from(data['prices']);
//   }
// }
// class CryptocurrencyDetailScreen extends StatefulWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyDetailScreen({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   _CryptocurrencyDetailScreenState createState() => _CryptocurrencyDetailScreenState();
// }

// class _CryptocurrencyDetailScreenState extends State<CryptocurrencyDetailScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late ScrollController _scrollController;
  
//   Map<String, dynamic> details = {};
//   bool isLoading = true;
//   bool isChartLoading = true;
//   List<FlSpot> priceData = [];
//   int selectedChartDays = 7;
//   Map<String, String> aiAnalysis = {
//     'general': 'Loading...',
//     'news': 'Loading...',
//     'fundamental': 'Loading...',
//     'team': 'Loading...',
//   };
//   String aiQuestion = '';
//   String aiAnswer = '';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//     _scrollController = ScrollController();
//     fetchDetails();
//     fetchComprehensiveAnalysis();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchDetails() async {
//     setState(() => isLoading = true);
//     try {
//       final fetchedDetails = await ApiService.getCryptocurrencyDetails(widget.cryptocurrency.id);
//       setState(() {
//         details = fetchedDetails;
//         isLoading = false;
//       });
//       fetchMarketChart();
//     } catch (e) {
//       setState(() => isLoading = false);
//       _showErrorSnackbar('Failed to fetch cryptocurrency details');
//     }
//   }

//   Future<void> fetchMarketChart() async {
//     setState(() => isChartLoading = true);
//     try {
//       final chartData = await ApiService.getMarketChart(widget.cryptocurrency.id, selectedChartDays);
//       setState(() {
//         priceData = chartData.map((point) => FlSpot(point[0].toDouble(), point[1].toDouble())).toList();
//         isChartLoading = false;
//       });
//     } catch (e) {
//       setState(() => isChartLoading = false);
//       _showErrorSnackbar('Failed to fetch market chart data');
//     }
//   }

//   Future<void> fetchComprehensiveAnalysis() async {
//     try {
//       final analysis = await AIService.generateComprehensiveAnalysis(widget.cryptocurrency);
//       setState(() {
//         aiAnalysis = analysis;
//       });
//     } catch (e) {
//       _showErrorSnackbar('Failed to fetch AI analysis');
//     }
//   }

//   Future<void> askAIQuestion() async {
//     if (aiQuestion.isEmpty) return;
//     setState(() => aiAnswer = 'Loading...');
//     try {
//       final answer = await AIService.generateAIResponse(
//         "Answer this question about ${widget.cryptocurrency.name} (${widget.cryptocurrency.symbol}) as of ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}: $aiQuestion"
//       );
//       setState(() => aiAnswer = answer);
//     } catch (e) {
//       setState(() => aiAnswer = 'Failed to get AI response');
//     }
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void showSimilarCryptocurrencies(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SimilarCryptocurrenciesScreen(cryptocurrency: widget.cryptocurrency),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 200.0,
//               floating: false,
//               pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(widget.cryptocurrency.name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     shadows: [Shadow(blurRadius: 2.0, color: Colors.black45, offset: Offset(1.0, 1.0))],
//                   ),
//                 ),
//                 background: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Hero(
//                       tag: 'crypto-${widget.cryptocurrency.id}',
//                       child: CachedNetworkImage(
//                         imageUrl: widget.cryptocurrency.image,
//                         fit: BoxFit.cover,
//                         color: Colors.black.withOpacity(0.5),
//                         colorBlendMode: BlendMode.darken,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 60,
//                       left: 16,
//                       child: CircleAvatar(
//                         backgroundImage: CachedNetworkImageProvider(widget.cryptocurrency.image),
//                         radius: 30,
//                         backgroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.refresh),
//                   onPressed: fetchDetails,
//                 ),
//               ],
//             ),
//           ];
//         },
//         body: isLoading
//             ? _buildLoadingScreen()
//             : Column(
//                 children: [
//                   _buildPriceHeader(),
//                   TabBar(
//                     controller: _tabController,
//                     labelColor: Theme.of(context).primaryColor,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Theme.of(context).primaryColor,
//                     isScrollable: true,
//                     tabs: const [
//                       Tab(text: 'Overview'),
//                       Tab(text: 'Chart'),
//                       Tab(text: 'AI Insights'),
//                       Tab(text: 'AI Q&A'),
//                       Tab(text: 'Details'),
//                     ],
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         _buildOverviewTab(),
//                         _buildChartTab(),
//                         _buildAIInsightsTab(),
//                         _buildAIQATab(),
//                         _buildDetailsTab(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => showSimilarCryptocurrencies(context),
//         label: const Text('Similar Cryptocurrencies'),
//         icon: const Icon(Icons.compare_arrows),
//       ),
//     );
//   }

//   Widget _buildLoadingScreen() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) => Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 80,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildPriceHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: Theme.of(context).cardColor,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 widget.cryptocurrency.symbol.toUpperCase(),
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: widget.cryptocurrency.percentChange24h >= 0 ? Colors.green : Colors.red,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               '${widget.cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOverviewTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildKeyStatistics(),
//         const SizedBox(height: 16),
//         _buildDescription(),
//         const SizedBox(height: 16),
//         _buildLinks(),
//       ],
//     );
//   }

//   Widget _buildChartTab() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildChartButton('7D', 7),
//               _buildChartButton('30D', 30),
//               _buildChartButton('90D', 90),
//               _buildChartButton('1Y', 365),
//             ],
//           ),
//         ),
//         Expanded(
//           child: isChartLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: LineChart(
//                     LineChartData(
//                       gridData: FlGridData(show: false),
//                       titlesData: FlTitlesData(show: false),
//                       borderData: FlBorderData(show: false),
//                       minX: priceData.isNotEmpty ? priceData.first.x : 0,
//                       maxX: priceData.isNotEmpty ? priceData.last.x : 0,
//                       minY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(min) : 0,
//                       maxY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(max) : 0,
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: priceData,
//                           isCurved: true,
//                           color: Theme.of(context).primaryColor,
//                           barWidth: 3,
//                           isStrokeCapRound: true,
//                           dotData: FlDotData(show: false),
//                           belowBarData: BarAreaData(
//                             show: true,
//                             color: Theme.of(context).primaryColor.withOpacity(0.1),
//                           ),
//                         ),
//                       ],
//                       lineTouchData: LineTouchData(
//                         touchTooltipData: LineTouchTooltipData(
//                           tooltipRoundedRadius: 8,
//                           getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
//                             return touchedBarSpots.map((barSpot) {
//                               final flSpot = barSpot;
//                               if (flSpot.x == 0 || flSpot.x.isNaN || flSpot.y == 0 || flSpot.y.isNaN) {
//                                 return null;
//                               }
//                               final DateTime date = DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
//                               return LineTooltipItem(
//                                 '${DateFormat('MMM d, yyyy').format(date)}\n\$${flSpot.y.toStringAsFixed(2)}',
//                                 const TextStyle(color: Colors.white),
//                               );
//                             }).toList();
//                           },
//                         ),
//                         handleBuiltInTouches: true,
//                         getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
//                           return spotIndexes.map((spotIndex) {
//                             return TouchedSpotIndicatorData(
//                               FlLine(color: Colors.blue, strokeWidth: 2),
//                               FlDotData(
//                                 getDotPainter: (spot, percent, barData, index) {
//                                   return FlDotCirclePainter(
//                                     radius: 6,
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                     strokeColor: Colors.blue,
//                                   );
//                                 },
//                               ),
//                             );
//                           }).toList();
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             'Price: \$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChartButton(String label, int days) {
//     return ElevatedButton(
//       onPressed: () {
//         setState(() => selectedChartDays = days);
//         fetchMarketChart();
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: selectedChartDays == days ? Theme.of(context).primaryColor : Colors.grey.shade200,
//         foregroundColor: selectedChartDays == days ? Colors.white : Colors.black,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       ),
//       child: Text(label),
//     );
//   }

//   Widget _buildAIInsightsTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildAIInsights(),
//       ],
//     );
//   }

//   Widget _buildAIInsights() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('AI Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 16),
//         _buildAIInsightCard('General Analysis', aiAnalysis['general']!),
//         _buildAIInsightCard('Latest News', aiAnalysis['news']!),
//         _buildAIInsightCard('Fundamental Analysis', aiAnalysis['fundamental']!),
//         _buildAIInsightCard('Team Details', aiAnalysis['team']!),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: fetchComprehensiveAnalysis,
//           child: const Text('Refresh AI Insights'),
//         ),
//       ],
//     );
//   }

//   Widget _buildAIInsightCard(String title, String content) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       margin: const EdgeInsets.only(bottom: 16),
//       child: ExpansionTile(
//         title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text(content),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAIQATab() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Ask AI about this Cryptocurrency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//           TextField(
//             onChanged: (value) => setState(() => aiQuestion = value),
//             decoration: InputDecoration(
//               hintText: 'Enter your question here',
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.send),
//                 onPressed: askAIQuestion,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text('AI Answer:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Text(aiAnswer),
//               ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailsTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildAllTimeHighLow(),
//         const SizedBox(height: 16),
//         _buildAdditionalInfo(),
//       ],
//     );
//   }



//   Widget _buildKeyStatistics() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Key Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('Market Cap', '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.marketCap)}'),
//             _buildStatItem('24h Volume', '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.volume24h)}'),
//             _buildStatItem('Circulating Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.circulatingSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//             if (widget.cryptocurrency.totalSupply != null)
//               _buildStatItem('Total Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.totalSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//             if (widget.cryptocurrency.maxSupply != null)
//               _buildStatItem('Max Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.maxSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 15)),
//           Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   Widget _buildDescription() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             Text(details['description']?['en'] ?? 'No description available.'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLinks() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Links', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             if (details['links']?['homepage'] != null)
//               _buildLinkItem('Website', details['links']['homepage'][0]),
//             if (details['links']?['blockchain_site'] != null)
//               _buildLinkItem('Blockchain Explorer', details['links']['blockchain_site'][0]),
//             if (details['links']?['repos_url']?['github']?.isNotEmpty ?? false)
//               _buildLinkItem('GitHub', details['links']['repos_url']['github'][0]),
//             if (details['links']?['twitter_screen_name'] != null)
//               _buildLinkItem('Twitter', 'https://twitter.com/${details['links']['twitter_screen_name']}'),
//             if (details['links']?['facebook_username'] != null)
//               _buildLinkItem('Facebook', 'https://facebook.com/${details['links']['facebook_username']}'),
//             if (details['links']?['subreddit_url'] != null)
//               _buildLinkItem('Reddit', details['links']['subreddit_url']),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLinkItem(String label, String url) {
//     return ListTile(
//       title: Text(label),
//       trailing: const Icon(Icons.open_in_new),
//       onTap: () => _launchURL(url),
//     );
//   }

//   void _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       _showErrorSnackbar('Could not launch $url');
//     }
//   }

//   Widget _buildAllTimeHighLow() {
//     final athDate = details['market_data']?['ath_date']?['usd'] != null
//         ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['ath_date']['usd']))
//         : 'N/A';
//     final atlDate = details['market_data']?['atl_date']?['usd'] != null
//         ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['atl_date']['usd']))
//         : 'N/A';

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('All-Time High/Low', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('All-Time High', '\$${NumberFormat("#,##0.00").format(details['market_data']?['ath']?['usd'] ?? 0)}'),
//             Text('Date: $athDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
//             const SizedBox(height: 8),
//             _buildStatItem('All-Time Low', '\$${NumberFormat("#,##0.00").format(details['market_data']?['atl']?['usd'] ?? 0)}'),
//             Text('Date: $atlDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAdditionalInfo() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Additional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('Hashing Algorithm', details['hashing_algorithm'] ?? 'N/A'),
//             _buildStatItem('Genesis Date', details['genesis_date'] ?? 'N/A'),
//             _buildStatItem('Sentiment Up Votes', '${details['sentiment_votes_up_percentage']}%'),
//             _buildStatItem('Sentiment Down Votes', '${details['sentiment_votes_down_percentage']}%'),
//             _buildStatItem('Market Cap Rank', '#${details['market_cap_rank']}'),
//           ],
//         ),
//       ),
//     );
//   }
// }













































// import 'similar_coins.dart';
// import 'dart:math';
// import 'package:shimmer/shimmer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'CryptoLearningScreen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: CryptoExchangeApp(),
//     ),
//   );
// }

// class CryptoExchangeApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           title: 'Crypto Insights',
//           theme: themeProvider.currentTheme,
//           home: SearchScreen(),
//           routes: {
//             '/settings': (context) => SettingsScreen(),
//             '/learning': (context) => CryptoLearningScreen(),
//           },
//           debugShowCheckedModeBanner: false,
//         );
//       },
//     );
//   }
// }

// class ThemeProvider extends ChangeNotifier {
//   static const Color _primaryDark = Color(0xFF6200EA);
//   static const Color _primaryLight = Color(0xFF3F51B5);
//   static const Color _accentDark = Color(0xFFFF4081);
//   static const Color _accentLight = Color(0xFFFF9800);
//   static const Color _backgroundDark = Color(0xFF121212);
//   static const Color _backgroundLight = Color(0xFFF5F5F5);
//   static const Color _cardDark = Color(0xFF1E1E1E);
//   static const Color _cardLight = Color(0xFFFFFFFF);

//   static final ThemeData _darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: _primaryDark,
//     scaffoldBackgroundColor: _backgroundDark,
//     cardColor: _cardDark,
//     colorScheme: const ColorScheme.dark(
//       primary: _primaryDark,
//       secondary: _accentDark,
//       surface: _cardDark,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentDark,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentDark),
//   );

//   static final ThemeData _lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: _primaryLight,
//     scaffoldBackgroundColor: _backgroundLight,
//     cardColor: _cardLight,
//     colorScheme: const ColorScheme.light(
//       primary: _primaryLight,
//       secondary: _accentLight,
//       surface: _cardLight,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.black54, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentLight,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentLight),
//   );

//   late ThemeData _currentTheme;

//   ThemeProvider() {
//     _currentTheme = _darkTheme;
//   }

//   ThemeData get currentTheme => _currentTheme;
//   bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

//   void toggleTheme() {
//     _currentTheme = isDarkMode ? _lightTheme : _darkTheme;
//     notifyListeners();
//   }

//   void setDarkMode() {
//     _currentTheme = _darkTheme;
//     notifyListeners();
//   }

//   void setLightMode() {
//     _currentTheme = _lightTheme;
//     notifyListeners();
//   }
// }

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
//   final TextEditingController _searchController = TextEditingController();
//   Cryptocurrency? _searchResult;
//   bool _isLoading = false;
//   Timer? _debounce;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//     _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     _debounce?.cancel();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (_searchController.text.isNotEmpty) {
//         _performSearch(_searchController.text);
//       } else {
//         setState(() => _searchResult = null);
//       }
//     });
//   }

//   Future<void> _performSearch(String query) async {
//     setState(() => _isLoading = true);
//     try {
//       final result = await ApiService.getSearchedCryptocurrency(query);
//       setState(() {
//         _searchResult = result;
//         _isLoading = false;
//       });
//       _animationController.forward(from: 0.0);
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crypto Insights', style: TextStyle(fontWeight: FontWeight.bold)),
//         elevation: 0,
//       ),
//       drawer: AppDrawer(),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
//             ),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search cryptocurrency',
//                 prefixIcon: const Icon(Icons.search, color: Colors.white),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.2),
//               ),
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//           Expanded(
//             child: _buildSearchResults(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchResults() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (_searchResult != null) {
//       return FadeTransition(
//         opacity: _fadeAnimation,
//         child: CryptocurrencyListItem(cryptocurrency: _searchResult!),
//       );
//     } else {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.search, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'Search for a cryptocurrency',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

// class CryptocurrencyListItem extends StatelessWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyListItem({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () => _navigateToDetailScreen(context),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader(),
//                 const SizedBox(height: 12),
//                 _buildPriceInfo(),
//                 const SizedBox(height: 12),
//                 _buildAdditionalInfo(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Hero(
//           tag: 'crypto-${cryptocurrency.id}',
//           child: CircleAvatar(
//             backgroundImage: CachedNetworkImageProvider(cryptocurrency.image),
//             radius: 24,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 cryptocurrency.name,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               Text(
//                 cryptocurrency.symbol.toUpperCase(),
//                 style: const TextStyle(fontSize: 14, color: Colors.white70),
//               ),
//             ],
//           ),
//         ),
//         if (cryptocurrency.rank != 0)
//           Chip(
//             label: Text(
//               '#${cryptocurrency.rank}',
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             backgroundColor: Colors.black26,
//           ),
//       ],
//     );
//   }

//   Widget _buildPriceInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Price',
//               style: TextStyle(fontSize: 14, color: Colors.white70),
//             ),
//             Text(
//               '\$${cryptocurrency.price.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ],
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             const Text(
//               '24h Change',
//               style: TextStyle(fontSize: 14, color: Colors.white70),
//             ),
//             Text(
//               '${_getChangeIcon(cryptocurrency.percentChange24h)} ${cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _getChangeColor(cryptocurrency.percentChange24h),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAdditionalInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildInfoItem('Market Cap', '\$${_formatLargeNumber(cryptocurrency.marketCap)}'),
//         _buildInfoItem('24h Volume', '\$${_formatLargeNumber(cryptocurrency.volume24h)}'),
//       ],
//     );
//   }

//   Widget _buildInfoItem(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
//         Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
//       ],
//     );
//   }

//   String _getChangeIcon(double change) {
//     return change >= 0 ? '▲' : '▼';
//   }

//   Color _getChangeColor(double change) {
//     return change >= 0 ? Colors.greenAccent : Colors.redAccent;
//   }

//   String _formatLargeNumber(double number) {
//     if (number >= 1e9) {
//       return '${(number / 1e9).toStringAsFixed(2)}B';
//     } else if (number >= 1e6) {
//       return '${(number / 1e6).toStringAsFixed(2)}M';
//     } else if (number >= 1e3) {
//       return '${(number / 1e3).toStringAsFixed(2)}K';
//     } else {
//       return number.toStringAsFixed(2);
//     }
//   }

//   void _navigateToDetailScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CryptocurrencyDetailScreen(
//           cryptocurrency: cryptocurrency,
//         ),
//       ),
//     );
//   }
// }

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: const Text('Theme'),
//             trailing: Consumer<ThemeProvider>(
//               builder: (context, themeProvider, child) {
//                 return Switch(
//                   value: themeProvider.currentTheme.brightness == Brightness.dark,
//                   onChanged: (value) {
//                     themeProvider.toggleTheme();
//                   },
//                   activeColor: Theme.of(context).colorScheme.secondary,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//             ),
//             child: const Text(
//               'Crypto Insights',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.home),
//             title: const Text('Home'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushReplacementNamed(context, '/');
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.school),
//             title: const Text('AI Learning'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/learning');
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('Settings'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/settings');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Cryptocurrency {
//   final String id;
//   final String name;
//   final String symbol;
//   final double price;
//   final double marketCap;
//   final double volume24h;
//   final double percentChange24h;
//   final String image;
//   final int rank;
//   final double circulatingSupply;
//   final double? totalSupply;
//   final double? maxSupply;

//   Cryptocurrency({
//     required this.id,
//     required this.name,
//     required this.symbol,
//     required this.price,
//     required this.marketCap,
//     required this.volume24h,
//     required this.percentChange24h,
//     required this.image,
//     required this.rank,
//     required this.circulatingSupply,
//     this.totalSupply,
//     this.maxSupply,
//   });

//   factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
//     return Cryptocurrency(
//       id: json['id'],
//       name: json['name'],
//       symbol: json['symbol'],
//       price: (json['current_price'] ?? 0).toDouble(),
//       marketCap: (json['market_cap'] ?? 0).toDouble(),
//       volume24h: (json['total_volume'] ?? 0).toDouble(),
//       percentChange24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
//       image: json['image'] ?? '',
//       rank: json['market_cap_rank'] ?? 0,
//       circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
//       totalSupply: json['total_supply']?.toDouble(),
//       maxSupply: json['max_supply']?.toDouble(),
//     );
//   }
// }

// class CacheService {
//   static const String prefix = 'api_cache_';
//   static const Duration defaultCacheDuration = Duration(minutes: 15);

//   static Future<void> setCache(String key, String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('$prefix$key', value);
//     await prefs.setInt('${prefix}${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
//   }

//   static Future<String?> getCache(String key, {Duration? maxAge}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final value = prefs.getString('$prefix$key');
//     final timestamp = prefs.getInt('${prefix}${key}_timestamp');
    
//     if (value != null && timestamp != null) {
//       final age = DateTime.now().millisecondsSinceEpoch - timestamp;
//       if (age < (maxAge ?? defaultCacheDuration).inMilliseconds) {
//         return value;
//       }
//     }
//     return null;
//   }
// }

// class ThrottleService {
//   static final Map<String, DateTime> _lastRequestTimes = {};
//   static const Duration throttleDuration = Duration(seconds: 1);

//   static Future<void> throttle(String key) async {
//     final now = DateTime.now();
//     final lastRequestTime = _lastRequestTimes[key];
//     if (lastRequestTime != null) {
//       final timeSinceLastRequest = now.difference(lastRequestTime);
//       if (timeSinceLastRequest < throttleDuration) {
//         await Future.delayed(throttleDuration - timeSinceLastRequest);
//       }
//     }
//     _lastRequestTimes[key] = DateTime.now();
//   }
// }

// class AIService {
//   static const String apiKey = 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y';
//   static final model = GenerativeModel(
//     model: 'gemini-pro',
//     apiKey: apiKey,
//   );

//   static Future<String> generateAIResponse(String prompt) async {
//     try {
//       final content = [Content.text(prompt)];
//       final response = await model.generateContent(content);
//       if (response.text != null && response.text!.isNotEmpty) {
//         return response.text!;
//       } else {
//         return 'No response generated';
//       }
//     } catch (e) {
//       return 'Error generating response: $e';
//     }
//   }

//   static Future<Map<String, String>> generateComprehensiveAnalysis(Cryptocurrency crypto) async {
//     Map<String, String> analysis = {};
//     String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

//     analysis['general'] = await generateAIResponse(
//       "Provide a comprehensive general analysis of ${crypto.name} (${crypto.symbol}) in the cryptocurrency market as of $currentDate. Include:\n"
//       "1. Current price: \$${crypto.price.toStringAsFixed(2)} - compare this to 7-day and 30-day averages\n"
//       "2. Market cap: \$${crypto.marketCap.toStringAsFixed(2)} - discuss its rank and recent changes\n"
//       "3. 24-hour trading volume and how it compares to the 7-day average\n"
//       "4. Recent performance: 24h, 7d, and 30d price changes (in percentages)\n"
//       "5. Current market dominance and comparison to major cryptocurrencies\n"
//       "6. Brief overview of on-chain metrics (e.g., active addresses, transaction count) if applicable\n"
//       "7. General market sentiment towards ${crypto.name} based on recent events\n"
//       "Provide specific numbers and percentages where possible, and focus on data from the last 30 days."
//     );

//     analysis['news'] = await generateAIResponse(
//       "Summarize the most recent news and developments for ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
//       "1. Major announcements or events from the past 7 days, with exact dates\n"
//       "2. Any significant partnerships or collaborations revealed in the last 30 days\n"
//       "3. Recent protocol upgrades or technological advancements, specifying implementation dates\n"
//       "4. Regulatory news or legal developments affecting ${crypto.name} in the past month\n"
//       "5. Notable mentions of ${crypto.name} by industry leaders or influential figures (quote if possible)\n"
//       "6. Upcoming events in the next 14 days that could impact ${crypto.name}'s value\n"
//       "7. Any changes in ${crypto.name}'s ecosystem (e.g., DeFi, NFTs) in the last 30 days\n"
//       "8. Comparison of recent news to its main competitors\n"
//       "Prioritize the most impactful and recent news items. For each point, provide the date of occurrence or announcement."
//     );

//     analysis['fundamental'] = await generateAIResponse(
//       "Analyze the current fundamental aspects of ${crypto.name} (${crypto.symbol}) as of $currentDate. Cover:\n"
//       "1. Latest technological updates or changes to the protocol\n"
//       "2. Most recent partnerships or adoption metrics\n"
//       "3. Upcoming events or releases in the next 30 days\n"
//       "4. Current market sentiment and social media buzz\n"
//       "5. Any recent regulatory news affecting ${crypto.name}\n"
//       "Prioritize information from the last 30 days and specify dates for any mentioned events or updates."
//     );

//     analysis['team'] = await generateAIResponse(
//       "Deliver a comprehensive report on the current team behind ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
//       "1. Detailed profiles of key team members (at least 5), including their roles, professional backgrounds, and notable achievements\n"
//       "2. Recent changes in leadership or significant hires in the last 6 months\n"
//       "3. Team's latest public appearances, interviews, or statements (provide dates)\n"
//       "4. Ongoing projects or initiatives led by specific team members\n"
//       "5. Any controversies or praised actions involving team members in the last year\n"
//       "6. Assessment of the team's transparency and communication with the community\n"
//       "7. Comparison of the team's expertise with that of competitor projects\n"
//       "Provide specific dates for any mentioned events or changes and focus on the most recent information available."
//     );

//     return analysis;
//   }
// }

// class ApiService {
//   static const List<String> baseUrls = [
//     'https://api.coingecko.com/api/v3',
//     'https://api.coingecko.com/api/v3',
//     'https://api.coingecko.com/api/v3',
//   ];
//   static const Duration rateLimitDuration = Duration(milliseconds: 500);
//   static const int maxRetries = 5;
//   static final Random _random = Random();
//   static DateTime _lastRequestTime = DateTime.now();

//   static Future<void> _respectRateLimit() async {
//     final now = DateTime.now();
//     final timeSinceLastRequest = now.difference(_lastRequestTime);
//     if (timeSinceLastRequest < rateLimitDuration) {
//       await Future.delayed(rateLimitDuration - timeSinceLastRequest);
//     }
//     _lastRequestTime = DateTime.now();
//   }

//   static Future<dynamic> _getRequest(String endpoint, {int retryCount = 0}) async {
//     await _respectRateLimit();
//     await ThrottleService.throttle(endpoint);
    
//     final cachedData = await CacheService.getCache(endpoint);
//     if (cachedData != null) {
//       return json.decode(cachedData);
//     }

//     final baseUrlIndex = _random.nextInt(baseUrls.length);
//     try {
//       final response = await http.get(Uri.parse('${baseUrls[baseUrlIndex]}$endpoint'));
//       if (response.statusCode == 200) {
//         await CacheService.setCache(endpoint, response.body);
//         return json.decode(response.body);
//       } else if (response.statusCode == 429 && retryCount < maxRetries) {
//         final retryDelay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
//         await Future.delayed(retryDelay);
//         return _getRequest(endpoint, retryCount: retryCount + 1);
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       if (retryCount < maxRetries) {
//         final delay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
//         await Future.delayed(delay);
//         return _getRequest(endpoint, retryCount: retryCount + 1);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   static Future<List<Cryptocurrency>> getCryptocurrencies({int page = 1, int perPage = 100}) async {
//     final cacheKey = 'cryptocurrencies_$page$perPage';
//     final cachedData = await CacheService.getCache(cacheKey);
//     if (cachedData != null) {
//       return (json.decode(cachedData) as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
//     }

//     final data = await _getRequest('/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false');
//     await CacheService.setCache(cacheKey, json.encode(data));
//     return (data as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
//   }

//   static Future<Map<String, dynamic>> getCryptocurrencyDetails(String id) async {
//     return await _getRequest('/coins/$id?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false');
//   }

//   static Future<Cryptocurrency?> getSearchedCryptocurrency(String query) async {
//     final data = await _getRequest('/search?query=$query');
//     final coins = data['coins'] as List;
    
//     if (coins.isEmpty) {
//       return null;
//     }

//     final firstCoin = coins.first;
//     try {
//       final detailData = await getCryptocurrencyDetails(firstCoin['id']);
//       return Cryptocurrency(
//         id: firstCoin['id'],
//         name: firstCoin['name'],
//         symbol: firstCoin['symbol'],
//         price: detailData['market_data']['current_price']['usd']?.toDouble() ?? 0,
//         marketCap: detailData['market_data']['market_cap']['usd']?.toDouble() ?? 0,
//         volume24h: detailData['market_data']['total_volume']['usd']?.toDouble() ?? 0,
//         percentChange24h: detailData['market_data']['price_change_percentage_24h']?.toDouble() ?? 0,
//         image: firstCoin['large'] ?? '',
//         rank: detailData['market_cap_rank'] ?? 0,
//         circulatingSupply: detailData['market_data']['circulating_supply']?.toDouble() ?? 0,
//         totalSupply: detailData['market_data']['total_supply']?.toDouble(),
//         maxSupply: detailData['market_data']['max_supply']?.toDouble(),
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future<List<List<dynamic>>> getMarketChart(String id, int days) async {
//     final data = await _getRequest('/coins/$id/market_chart?vs_currency=usd&days=$days');
//     return List<List<dynamic>>.from(data['prices']);
//   }
// }

// class CryptocurrencyDetailScreen extends StatefulWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyDetailScreen({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   _CryptocurrencyDetailScreenState createState() => _CryptocurrencyDetailScreenState();
// }

// class _CryptocurrencyDetailScreenState extends State<CryptocurrencyDetailScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late ScrollController _scrollController;
  
//   Map<String, dynamic> details = {};
//   bool isLoading = true;
//   bool isChartLoading = true;
//   List<FlSpot> priceData = [];
//   int selectedChartDays = 7;
//   Map<String, String> aiAnalysis = {
//     'general': 'Loading...',
//     'news': 'Loading...',
//     'fundamental': 'Loading...',
//     'team': 'Loading...',
//   };
//   String aiQuestion = '';
//   String aiAnswer = '';

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//     _scrollController = ScrollController();
//     fetchDetails();
//     fetchComprehensiveAnalysis();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchDetails() async {
//     setState(() => isLoading = true);
//     try {
//       final fetchedDetails = await ApiService.getCryptocurrencyDetails(widget.cryptocurrency.id);
//       setState(() {
//         details = fetchedDetails;
//         isLoading = false;
//       });
//       fetchMarketChart();
//     } catch (e) {
//       setState(() => isLoading = false);
//       _showErrorSnackbar('Failed to fetch cryptocurrency details');
//     }
//   }

//   Future<void> fetchMarketChart() async {
//     setState(() => isChartLoading = true);
//     try {
//       final chartData = await ApiService.getMarketChart(widget.cryptocurrency.id, selectedChartDays);
//       setState(() {
//         priceData = chartData.map((point) => FlSpot(point[0].toDouble(), point[1].toDouble())).toList();
//         isChartLoading = false;
//       });
//     } catch (e) {
//       setState(() => isChartLoading = false);
//       _showErrorSnackbar('Failed to fetch market chart data');
//     }
//   }

//   Future<void> fetchComprehensiveAnalysis() async {
//     try {
//       final analysis = await AIService.generateComprehensiveAnalysis(widget.cryptocurrency);
//       setState(() {
//         aiAnalysis = analysis;
//       });
//     } catch (e) {
//       _showErrorSnackbar('Failed to fetch AI analysis');
//     }
//   }

//   Future<void> askAIQuestion() async {
//     if (aiQuestion.isEmpty) return;
//     setState(() => aiAnswer = 'Loading...');
//     try {
//       final answer = await AIService.generateAIResponse(
//         "Answer this question about ${widget.cryptocurrency.name} (${widget.cryptocurrency.symbol}) as of ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}: $aiQuestion"
//       );
//       setState(() => aiAnswer = answer);
//     } catch (e) {
//       setState(() => aiAnswer = 'Failed to get AI response');
//     }
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void showSimilarCryptocurrencies(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SimilarCryptocurrenciesScreen(cryptocurrency: widget.cryptocurrency),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 200.0,
//               floating: false,
//               pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(widget.cryptocurrency.name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     shadows: [Shadow(blurRadius: 2.0, color: Colors.black45, offset: Offset(1.0, 1.0))],
//                   ),
//                 ),
//                 background: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Hero(
//                       tag: 'crypto-${widget.cryptocurrency.id}',
//                       child: CachedNetworkImage(
//                         imageUrl: widget.cryptocurrency.image,
//                         fit: BoxFit.cover,
//                         color: Colors.black.withOpacity(0.5),
//                         colorBlendMode: BlendMode.darken,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 60,
//                       left: 16,
//                       child: CircleAvatar(
//                         backgroundImage: CachedNetworkImageProvider(widget.cryptocurrency.image),
//                         radius: 30,
//                         backgroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.refresh),
//                   onPressed: fetchDetails,
//                 ),
//               ],
//             ),
//           ];
//         },
//         body: isLoading
//             ? _buildLoadingScreen()
//             : Column(
//                 children: [
//                   _buildPriceHeader(),
//                   TabBar(
//                     controller: _tabController,
//                     labelColor: Theme.of(context).primaryColor,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Theme.of(context).primaryColor,
//                     isScrollable: true,
//                     tabs: const [
//                       Tab(text: 'Overview'),
//                       Tab(text: 'Chart'),
//                       Tab(text: 'AI Insights'),
//                       Tab(text: 'AI Q&A'),
//                       Tab(text: 'Details'),
//                     ],
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         _buildOverviewTab(),
//                         _buildChartTab(),
//                         _buildAIInsightsTab(),
//                         _buildAIQATab(),
//                         _buildDetailsTab(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => showSimilarCryptocurrencies(context),
//         label: const Text('Similar Cryptocurrencies'),
//         icon: const Icon(Icons.compare_arrows),
//       ),
//     );
//   }

//   Widget _buildLoadingScreen() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) => Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 80,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildPriceHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: Theme.of(context).cardColor,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 widget.cryptocurrency.symbol.toUpperCase(),
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: widget.cryptocurrency.percentChange24h >= 0 ? Colors.green : Colors.red,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               '${widget.cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOverviewTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildKeyStatistics(),
//         const SizedBox(height: 16),
//         _buildDescription(),
//         const SizedBox(height: 16),
//         _buildLinks(),
//       ],
//     );
//   }

//   Widget _buildChartTab() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildChartButton('7D', 7),
//               _buildChartButton('30D', 30),
//               _buildChartButton('90D', 90),
//               _buildChartButton('1Y', 365),
//             ],
//           ),
//         ),
//         Expanded(
//           child: isChartLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: LineChart(
//                     LineChartData(
//                       gridData: FlGridData(show: false),
//                       titlesData: FlTitlesData(show: false),
//                       borderData: FlBorderData(show: false),
//                       minX: priceData.isNotEmpty ? priceData.first.x : 0,
//                       maxX: priceData.isNotEmpty ? priceData.last.x : 0,
//                       minY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(min) : 0,
//                       maxY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(max) : 0,
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: priceData,
//                           isCurved: true,
//                           color: Theme.of(context).primaryColor,
//                           barWidth: 3,
//                           isStrokeCapRound: true,
//                           dotData: FlDotData(show: false),
//                           belowBarData: BarAreaData(
//                             show: true,
//                             color: Theme.of(context).primaryColor.withOpacity(0.1),
//                           ),
//                         ),
//                       ],
//                       lineTouchData: LineTouchData(
//                         touchTooltipData: LineTouchTooltipData(
//                           tooltipRoundedRadius: 8,
//                           getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
//                             return touchedBarSpots.map((barSpot) {
//                               final flSpot = barSpot;
//                               if (flSpot.x == 0 || flSpot.x.isNaN || flSpot.y == 0 || flSpot.y.isNaN) {
//                                 return null;
//                               }
//                               final DateTime date = DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
//                               return LineTooltipItem(
//                                 '${DateFormat('MMM d, yyyy').format(date)}\n\$${flSpot.y.toStringAsFixed(2)}',
//                                 const TextStyle(color: Colors.white),
//                               );
//                             }).toList();
//                           },
//                         ),
//                         handleBuiltInTouches: true,
//                         getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
//                           return spotIndexes.map((spotIndex) {
//                             return TouchedSpotIndicatorData(
//                               FlLine(color: Colors.blue, strokeWidth: 2),
//                               FlDotData(
//                                 getDotPainter: (spot, percent, barData, index) {
//                                   return FlDotCirclePainter(
//                                     radius: 6,
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                     strokeColor: Colors.blue,
//                                   );
//                                 },
//                               ),
//                             );
//                           }).toList();
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             'Price: \$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChartButton(String label, int days) {
//     return ElevatedButton(
//       onPressed: () {
//         setState(() => selectedChartDays = days);
//         fetchMarketChart();
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: selectedChartDays == days ? Theme.of(context).primaryColor : Colors.grey.shade200,
//         foregroundColor: selectedChartDays == days ? Colors.white : Colors.black,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       ),
//       child: Text(label),
//     );
//   }

//   Widget _buildAIInsightsTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildAIInsights(),
//       ],
//     );
//   }

//   Widget _buildAIInsights() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('AI Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 16),
//         _buildAIInsightCard('General Analysis', aiAnalysis['general']!),
//         _buildAIInsightCard('Latest News', aiAnalysis['news']!),
//         _buildAIInsightCard('Fundamental Analysis', aiAnalysis['fundamental']!),
//         _buildAIInsightCard('Team Details', aiAnalysis['team']!),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: fetchComprehensiveAnalysis,
//           child: const Text('Refresh AI Insights'),
//         ),
//       ],
//     );
//   }

//   Widget _buildAIInsightCard(String title, String content) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       margin: const EdgeInsets.only(bottom: 16),
//       child: ExpansionTile(
//         title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text(content),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAIQATab() {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Ask AI about this Cryptocurrency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//           TextField(
//             onChanged: (value) => setState(() => aiQuestion = value),
//             decoration: InputDecoration(
//               hintText: 'Enter your question here',
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.send),
//                 onPressed: askAIQuestion,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text('AI Answer:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Text(aiAnswer),
//               ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailsTab() {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildAllTimeHighLow(),
//         const SizedBox(height: 16),
//         _buildAdditionalInfo(),
//       ],
//     );
//   }



//   Widget _buildKeyStatistics() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Key Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('Market Cap', '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.marketCap)}'),
//             _buildStatItem('24h Volume', '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.volume24h)}'),
//             _buildStatItem('Circulating Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.circulatingSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//             if (widget.cryptocurrency.totalSupply != null)
//               _buildStatItem('Total Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.totalSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//             if (widget.cryptocurrency.maxSupply != null)
//               _buildStatItem('Max Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.maxSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 15)),
//           Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   Widget _buildDescription() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             Text(details['description']?['en'] ?? 'No description available.'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLinks() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Links', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             if (details['links']?['homepage'] != null)
//               _buildLinkItem('Website', details['links']['homepage'][0]),
//             if (details['links']?['blockchain_site'] != null)
//               _buildLinkItem('Blockchain Explorer', details['links']['blockchain_site'][0]),
//             if (details['links']?['repos_url']?['github']?.isNotEmpty ?? false)
//               _buildLinkItem('GitHub', details['links']['repos_url']['github'][0]),
//             if (details['links']?['twitter_screen_name'] != null)
//               _buildLinkItem('Twitter', 'https://twitter.com/${details['links']['twitter_screen_name']}'),
//             if (details['links']?['facebook_username'] != null)
//               _buildLinkItem('Facebook', 'https://facebook.com/${details['links']['facebook_username']}'),
//             if (details['links']?['subreddit_url'] != null)
//               _buildLinkItem('Reddit',details['links']['subreddit_url']),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLinkItem(String label, String url) {
//     return ListTile(
//       title: Text(label),
//       trailing: const Icon(Icons.open_in_new),
//       onTap: () => _launchURL(url),
//     );
//   }

//   void _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       _showErrorSnackbar('Could not launch $url');
//     }
//   }

//   Widget _buildAllTimeHighLow() {
//     final athDate = details['market_data']?['ath_date']?['usd'] != null
//         ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['ath_date']['usd']))
//         : 'N/A';
//     final atlDate = details['market_data']?['atl_date']?['usd'] != null
//         ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['atl_date']['usd']))
//         : 'N/A';

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('All-Time High/Low', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('All-Time High', '\$${NumberFormat("#,##0.00").format(details['market_data']?['ath']?['usd'] ?? 0)}'),
//             Text('Date: $athDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
//             const SizedBox(height: 8),
//             _buildStatItem('All-Time Low', '\$${NumberFormat("#,##0.00").format(details['market_data']?['atl']?['usd'] ?? 0)}'),
//             Text('Date: $atlDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAdditionalInfo() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Additional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('Hashing Algorithm', details['hashing_algorithm'] ?? 'N/A'),
//             _buildStatItem('Genesis Date', details['genesis_date'] ?? 'N/A'),
//             _buildStatItem('Sentiment Up Votes', '${details['sentiment_votes_up_percentage']}%'),
//             _buildStatItem('Sentiment Down Votes', '${details['sentiment_votes_down_percentage']}%'),
//             _buildStatItem('Market Cap Rank', '#${details['market_cap_rank']}'),
//           ],
//         ),
//       ),
//     );
//   }
// }






























// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'similar_coins.dart';
// import 'dart:math';
// import 'package:shimmer/shimmer.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:async';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'CryptoLearningScreen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ThemeProvider(),
//       child: CryptoExchangeApp(),
//     ),
//   );
// }

// class CryptoExchangeApp extends StatelessWidget {   
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, child) {
//         return MaterialApp(
//           title: 'Crypto Insights',
//           theme: themeProvider.currentTheme,
//           home: SearchScreen(),
//           routes: {
//             '/settings': (context) => SettingsScreen(),
//             '/learning': (context) => CryptoLearningScreen(),
//           },
//           debugShowCheckedModeBanner: false,
//         );
//       },
//     );
//   }
// }

// class ThemeProvider extends ChangeNotifier {
//   static const Color _primaryDark = Color(0xFF6200EA);
//   static const Color _primaryLight = Color(0xFF3F51B5);
//   static const Color _accentDark = Color(0xFFFF4081);
//   static const Color _accentLight = Color(0xFFFF9800);
//   static const Color _backgroundDark = Color(0xFF121212);
//   static const Color _backgroundLight = Color(0xFFF5F5F5);
//   static const Color _cardDark = Color(0xFF1E1E1E);
//   static const Color _cardLight = Color(0xFFFFFFFF);
//   static final ThemeData _darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: _primaryDark,
//     scaffoldBackgroundColor: _backgroundDark,
//     cardColor: _cardDark,
//     colorScheme: const ColorScheme.dark(
//       primary: _primaryDark,
//       secondary: _accentDark,
//       surface: _cardDark,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentDark,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentDark),
//   );

//   static final ThemeData _lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: _primaryLight,
//     scaffoldBackgroundColor: _backgroundLight,
//     cardColor: _cardLight,
//     colorScheme: const ColorScheme.light(
//       primary: _primaryLight,
//       secondary: _accentLight,
//       surface: _cardLight,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.black54, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentLight,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentLight),
//   );

//   late ThemeData _currentTheme;

//   ThemeProvider() {
//     _currentTheme = _darkTheme;
//   }

//   ThemeData get currentTheme => _currentTheme;
//   bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

//   void toggleTheme() {
//     _currentTheme = isDarkMode ? _lightTheme : _darkTheme;
//     notifyListeners();
//   }

//   void setDarkMode() {
//     _currentTheme = _darkTheme;
//     notifyListeners();
//   }

//   void setLightMode() {
//     _currentTheme = _lightTheme;
//     notifyListeners();
//   }
// }

// class SearchScreen extends StatefulWidget {
//   @override
//   _SearchScreenState createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
//   final TextEditingController _searchController = TextEditingController();
//   Cryptocurrency? _searchResult;
//   bool _isLoading = false;
//   Timer? _debounce;
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//     _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     _debounce?.cancel();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (_searchController.text.isNotEmpty) {
//         _performSearch(_searchController.text);
//       } else {
//         setState(() => _searchResult = null);
//       }
//     });
//   }

//   Future<void> _performSearch(String query) async {
//     setState(() => _isLoading = true);
//     try {
//       final result = await ApiService.getSearchedCryptocurrency(query);
//       setState(() {
//         _searchResult = result;
//         _isLoading = false;
//       });
//       _animationController.forward(from: 0.0);
//     } catch (e) {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Crypto Insights', style: TextStyle(fontWeight: FontWeight.bold)),
//         elevation: 0,
//       ),
//       drawer: AppDrawer(),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(16.0),
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//               borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
//             ),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search cryptocurrency',
//                 prefixIcon: const Icon(Icons.search, color: Colors.white),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.white.withOpacity(0.2),
//               ),
//               style: const TextStyle(color: Colors.white),
//             ),
//           ),
//           Expanded(
//             child: _buildSearchResults(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchResults() {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     } else if (_searchResult != null) {
//       return FadeTransition(
//         opacity: _fadeAnimation,
//         child: CryptocurrencyListItem(cryptocurrency: _searchResult!),
//       );
//     } else {
//       return const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.search, size: 64, color: Colors.grey),
//             SizedBox(height: 16),
//             Text(
//               'Search for a cryptocurrency',
//               style: TextStyle(fontSize: 18, color: Colors.grey),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

// class CryptocurrencyListItem extends StatelessWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyListItem({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4.0,
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: () => _navigateToDetailScreen(context),
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader(),
//                 const SizedBox(height: 12),
//                 _buildPriceInfo(),
//                 const SizedBox(height: 12),
//                 _buildAdditionalInfo(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Hero(
//           tag: 'crypto-${cryptocurrency.id}',
//           child: CircleAvatar(
//             backgroundImage: CachedNetworkImageProvider(cryptocurrency.image),
//             radius: 24,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 cryptocurrency.name,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//               ),
//               Text(
//                 cryptocurrency.symbol.toUpperCase(),
//                 style: const TextStyle(fontSize: 14, color: Colors.white70),
//               ),
//             ],
//           ),
//         ),
//         if (cryptocurrency.rank != 0)
//           Chip(
//             label: Text(
//               '#${cryptocurrency.rank}',
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             backgroundColor: Colors.black26,
//           ),
//       ],
//     );
//   }

//   Widget _buildPriceInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Price',
//               style: TextStyle(fontSize: 14, color: Colors.white70),
//             ),
//             Text(
//               '\$${cryptocurrency.price.toStringAsFixed(2)}',
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ],
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             const Text(
//               '24h Change',
//               style: TextStyle(fontSize: 14, color: Colors.white70),
//             ),
//             Text(
//               '${_getChangeIcon(cryptocurrency.percentChange24h)} ${cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: _getChangeColor(cryptocurrency.percentChange24h),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAdditionalInfo() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         _buildInfoItem('Market Cap', '\$${_formatLargeNumber(cryptocurrency.marketCap)}'),
//         _buildInfoItem('24h Volume', '\$${_formatLargeNumber(cryptocurrency.volume24h)}'),
//       ],
//     );
//   }

//   Widget _buildInfoItem(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
//         Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
//       ],
//     );
//   }

//   String _getChangeIcon(double change) {
//     return change >= 0 ? '▲' : '▼';
//   }

//   Color _getChangeColor(double change) {
//     return change >= 0 ? Colors.greenAccent : Colors.redAccent;
//   }

//   String _formatLargeNumber(double number) {
//     if (number >= 1e9) {
//       return '${(number / 1e9).toStringAsFixed(2)}B';
//     } else if (number >= 1e6) {
//       return '${(number / 1e6).toStringAsFixed(2)}M';
//     } else if (number >= 1e3) {
//       return '${(number / 1e3).toStringAsFixed(2)}K';
//     } else {
//       return number.toStringAsFixed(2);
//     }
//   }

//   void _navigateToDetailScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CryptocurrencyDetailScreen(
//           cryptocurrency: cryptocurrency,
//         ),
//       ),
//     );
//   }
// }

// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Settings'),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             title: const Text('Theme'),
//             trailing: Consumer<ThemeProvider>(
//               builder: (context, themeProvider, child) {
//                 return Switch(
//                   value: themeProvider.currentTheme.brightness == Brightness.dark,
//                   onChanged: (value) {
//                     themeProvider.toggleTheme();
//                   },
//                   activeColor: Theme.of(context).colorScheme.secondary,
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class AppDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Theme.of(context).primaryColor,
//             ),
//             child: const Text(
//               'Crypto Insights',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           ListTile(
//             leading: const Icon(Icons.home),
//             title: const Text('Home'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushReplacementNamed(context, '/');
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.school),
//             title: const Text('AI Learning'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/learning');
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings),
//             title: const Text('Settings'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.pushNamed(context, '/settings');
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Cryptocurrency {
//   final String id;
//   final String name;
//   final String symbol;
//   final double price;
//   final double marketCap;
//   final double volume24h;
//   final double percentChange24h;
//   final String image;
//   final int rank;
//   final double circulatingSupply;
//   final double? totalSupply;
//   final double? maxSupply;

//   Cryptocurrency({
//     required this.id,
//     required this.name,
//     required this.symbol,
//     required this.price,
//     required this.marketCap,
//     required this.volume24h,
//     required this.percentChange24h,
//     required this.image,
//     required this.rank,
//     required this.circulatingSupply,
//     this.totalSupply,
//     this.maxSupply,
//   });

//   factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
//     return Cryptocurrency(
//       id: json['id'],
//       name: json['name'],
//       symbol: json['symbol'],
//       price: (json['current_price'] ?? 0).toDouble(),
//       marketCap: (json['market_cap'] ?? 0).toDouble(),
//       volume24h: (json['total_volume'] ?? 0).toDouble(),
//       percentChange24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
//       image: json['image'] ?? '',
//       rank: json['market_cap_rank'] ?? 0,
//       circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
//       totalSupply: json['total_supply']?.toDouble(),
//       maxSupply: json['max_supply']?.toDouble(),
//     );
//   }
// }

// class CacheService {
//   static const String prefix = 'api_cache_';
//   static const Duration defaultCacheDuration = Duration(minutes: 15);

//   static Future<void> setCache(String key, String value) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('$prefix$key', value);
//     await prefs.setInt('${prefix}${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
//   }

//   static Future<String?> getCache(String key, {Duration? maxAge}) async {
//     final prefs = await SharedPreferences.getInstance();
//     final value = prefs.getString('$prefix$key');
//     final timestamp = prefs.getInt('${prefix}${key}_timestamp');
    
//     if (value != null && timestamp != null) {
//       final age = DateTime.now().millisecondsSinceEpoch - timestamp;
//       if (age < (maxAge ?? defaultCacheDuration).inMilliseconds) {
//         return value;
//       }
//     }
//     return null;
//   }
// }

// class ThrottleService {
//   static final Map<String, DateTime> _lastRequestTimes = {};
//   static const Duration throttleDuration = Duration(seconds: 1);

//   static Future<void> throttle(String key) async {
//     final now = DateTime.now();
//     final lastRequestTime = _lastRequestTimes[key];
//     if (lastRequestTime != null) {
//       final timeSinceLastRequest = now.difference(lastRequestTime);
//       if (timeSinceLastRequest < throttleDuration) {
//         await Future.delayed(throttleDuration - timeSinceLastRequest);
//       }
//     }
//     _lastRequestTimes[key] = DateTime.now();
//   }
// }


// class AIService {
//   static const String apiKey = 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y';
//   static final model = GenerativeModel(
//     model: 'gemini-pro',
//     apiKey: apiKey,
//   );

//   static Future<String> generateAIResponse(String prompt) async {
//     try {
//       final content = [Content.text(prompt)];
//       final response = await model.generateContent(content);
//       if (response.text != null && response.text!.isNotEmpty) {
//         return response.text!;
//       } else {
//         return 'No response generated';
//       }
//     } catch (e) {
//       return 'Error generating response: $e';
//     }
//   }

//   static Future<Map<String, String>> generateComprehensiveAnalysis(Cryptocurrency crypto) async {
//     Map<String, String> analysis = {};
//     String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

//     analysis['general'] = await generateAIResponse(
//       "Provide a comprehensive general analysis of ${crypto.name} (${crypto.symbol}) in the cryptocurrency market as of $currentDate. Include:\n"
//       "1. Current price: \$${crypto.price.toStringAsFixed(2)} - compare this to 7-day and 30-day averages\n"
//       "2. Market cap: \$${crypto.marketCap.toStringAsFixed(2)} - discuss its rank and recent changes\n"
//       "3. 24-hour trading volume and how it compares to the 7-day average\n"
//       "4. Recent performance: 24h, 7d, and 30d price changes (in percentages)\n"
//       "5. Current market dominance and comparison to major cryptocurrencies\n"
//       "6. Brief overview of on-chain metrics (e.g., active addresses, transaction count) if applicable\n"
//       "7. General market sentiment towards ${crypto.name} based on recent events\n"
//       "Provide specific numbers and percentages where possible, and focus on data from the last 30 days."
//     );

//     analysis['news'] = await generateAIResponse(
//       "Summarize the most recent news and developments for ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
//       "1. Major announcements or events from the past 7 days, with exact dates\n"
//       "2. Any significant partnerships or collaborations revealed in the last 30 days\n"
//       "3. Recent protocol upgrades or technological advancements, specifying implementation dates\n"
//       "4. Regulatory news or legal developments affecting ${crypto.name} in the past month\n"
//       "5. Notable mentions of ${crypto.name} by industry leaders or influential figures (quote if possible)\n"
//       "6. Upcoming events in the next 14 days that could impact ${crypto.name}'s value\n"
//       "7. Any changes in ${crypto.name}'s ecosystem (e.g., DeFi, NFTs) in the last 30 days\n"
//       "8. Comparison of recent news to its main competitors\n"
//       "Prioritize the most impactful and recent news items. For each point, provide the date of occurrence or announcement."
//     );

//     analysis['fundamental'] = await generateAIResponse(
//       "Analyze the current fundamental aspects of ${crypto.name} (${crypto.symbol}) as of $currentDate. Cover:\n"
//       "1. Latest technological updates or changes to the protocol\n"
//       "2. Most recent partnerships or adoption metrics\n"
//       "3. Upcoming events or releases in the next 30 days\n"
//       "4. Current market sentiment and social media buzz\n"
//       "5. Any recent regulatory news affecting ${crypto.name}\n"
//       "Provide a comprehensive A to Z fundamental analysis of ${crypto.name} (${crypto.symbol}) as of $currentDate. Cover:\n"
// "1. Architecture: Explain the blockchain architecture and consensus mechanism\n"
// "2. Business model: Describe the project's business model and value proposition\n"
// "3. Competitive landscape: Compare with similar projects in the market\n"
// "4. Developer activity: Recent GitHub commits, contributors, and development progress\n"
// "5. Economic model: Token economics, distribution, and inflation/deflation mechanisms\n"
// "6. Funding: Initial and ongoing funding, including venture capital investments\n"
// "7. Governance: Decision-making processes and community involvement\n"
// "8. Hash rate (for PoW) or Staking statistics (for PoS): Network security metrics\n"
// "9. Innovations: Unique features or technological advancements\n"
// "10. Joint ventures and partnerships: Recent and significant collaborations\n"
// "11. Key team members: Backgrounds of founders and core team\n"
// "12. Liquidity: Trading volume across exchanges and DeFi protocols\n"
// "13. Market adoption: Real-world use cases and user growth metrics\n"
// "14. Network effects: How the project benefits from increased adoption\n"
// "15. On-chain metrics: Active addresses, transaction count, and network usage\n"
// "16. Planned upgrades: Roadmap and upcoming protocol changes\n"
// "17. Quality of documentation: Whitepaper, technical docs, and community resources\n"
// "18. Regulatory compliance: Legal status and compliance efforts\n"
// "19. Scalability: Current and planned solutions for network scaling\n"
// "20. Tokenomics: Detailed analysis of token utility and economic design\n"
// "21. Use cases: Current and potential applications of the technology\n"
// "22. Vulnerabilities: Known security issues or potential attack vectors\n"
// "23. Wallet ecosystem: Available storage solutions and integrations\n"
// "24. X-factor: Unique selling points or competitive advantages\n"
// "25. Yield opportunities: Staking, farming, or other reward mechanisms\n"
// "26. Zero-knowledge proofs (if applicable): Privacy features and implementations\n"
// "Prioritize the most relevant and recent information. Provide specific data points, dates, and metrics where possible."
//       "Prioritize information from the last 30 days and specify dates for any mentioned events or updates."
//     );

//     analysis['team'] = await generateAIResponse(
//       "Deliver a comprehensive report on the current team behind ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
//       "1. Detailed profiles of key team members (at least 5), including their roles, professional backgrounds, and notable achievements\n"
//       "2. Recent changes in leadership or significant hires in the last 6 months\n"
//       "3. Team's latest public appearances, interviews, or statements (provide dates)\n"
//       "4. Ongoing projects or initiatives led by specific team members\n"
//       "5. Any controversies or praised actions involving team members in the last year\n"
//       "6. Assessment of the team's transparency and communication with the community\n"
//       "7. Comparison of the team's expertise with that of competitor projects\n"
//       "Provide specific dates for any mentioned events or changes and focus on the most recent information available."
//     );

//     return analysis;
//   }
// }


// class ApiService {
//   static const List<String> baseUrls = [
//     'https://api.coingecko.com/api/v3',
//     'https://api.coingecko.com/api/v3',
//     'https://api.coingecko.com/api/v3',
//   ];
//   static const Duration rateLimitDuration = Duration(milliseconds: 500);
//   static const int maxRetries = 5;
//   static final Random _random = Random();
//   static DateTime _lastRequestTime = DateTime.now();

//   static Future<void> _respectRateLimit() async {
//     final now = DateTime.now();
//     final timeSinceLastRequest = now.difference(_lastRequestTime);
//     if (timeSinceLastRequest < rateLimitDuration) {
//       await Future.delayed(rateLimitDuration - timeSinceLastRequest);
//     }
//     _lastRequestTime = DateTime.now();
//   }

//   static Future<dynamic> _getRequest(String endpoint, {int retryCount = 0}) async {
//     await _respectRateLimit();
//     await ThrottleService.throttle(endpoint);
    
//     final cachedData = await CacheService.getCache(endpoint);
//     if (cachedData != null) {
//       return json.decode(cachedData);
//     }

//     final baseUrlIndex = _random.nextInt(baseUrls.length);
//     try {
//       final response = await http.get(Uri.parse('${baseUrls[baseUrlIndex]}$endpoint'));
//       if (response.statusCode == 200) {
//         await CacheService.setCache(endpoint, response.body);
//         return json.decode(response.body);
//       } else if (response.statusCode == 429 && retryCount < maxRetries) {
//         final retryDelay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
//         await Future.delayed(retryDelay);
//         return _getRequest(endpoint, retryCount: retryCount + 1);
//       } else {
//         throw Exception('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       if (retryCount < maxRetries) {
//         final delay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
//         await Future.delayed(delay);
//         return _getRequest(endpoint, retryCount: retryCount + 1);
//       } else {
//         rethrow;
//       }
//     }
//   }

//   static Future<List<Cryptocurrency>> getCryptocurrencies({int page = 1, int perPage = 100}) async {
//     final cacheKey = 'cryptocurrencies_$page$perPage';
//     final cachedData = await CacheService.getCache(cacheKey);
//     if (cachedData != null) {
//       return (json.decode(cachedData) as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
//     }

//     final data = await _getRequest('/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false');
//     await CacheService.setCache(cacheKey, json.encode(data));
//     return (data as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
//   }

//   static Future<Map<String, dynamic>> getCryptocurrencyDetails(String id) async {
//     return await _getRequest('/coins/$id?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false');
//   }

//   static Future<Cryptocurrency?> getSearchedCryptocurrency(String query) async {
//     final data = await _getRequest('/search?query=$query');
//     final coins = data['coins'] as List;
    
//     if (coins.isEmpty) {
//       return null;
//     }

//     final firstCoin = coins.first;
//     try {
//       final detailData = await getCryptocurrencyDetails(firstCoin['id']);
//       return Cryptocurrency(
//         id: firstCoin['id'],
//         name: firstCoin['name'],
//         symbol: firstCoin['symbol'],
//         price: detailData['market_data']['current_price']['usd']?.toDouble() ?? 0,
//         marketCap: detailData['market_data']['market_cap']['usd']?.toDouble() ?? 0,
//         volume24h: detailData['market_data']['total_volume']['usd']?.toDouble() ?? 0,
//         percentChange24h: detailData['market_data']['price_change_percentage_24h']?.toDouble() ?? 0,
//         image: firstCoin['large'] ?? '',
//         rank: detailData['market_cap_rank'] ?? 0,
//         circulatingSupply: detailData['market_data']['circulating_supply']?.toDouble() ?? 0,
//         totalSupply: detailData['market_data']['total_supply']?.toDouble(),
//         maxSupply: detailData['market_data']['max_supply']?.toDouble(),
//       );
//     } catch (e) {
//       return null;
//     }
//   }

//   static Future<List<List<dynamic>>> getMarketChart(String id, int days) async {
//     final data = await _getRequest('/coins/$id/market_chart?vs_currency=usd&days=$days');
//     return List<List<dynamic>>.from(data['prices']);
//   }
// }
    
// class CryptocurrencyDetailScreen extends StatefulWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyDetailScreen({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   _CryptocurrencyDetailScreenState createState() => _CryptocurrencyDetailScreenState();
// }

// class _CryptocurrencyDetailScreenState extends State<CryptocurrencyDetailScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   late ScrollController _scrollController;
  
//   Map<String, dynamic> details = {};
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//     _scrollController = ScrollController();
//     fetchDetails();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchDetails() async {
//     setState(() => isLoading = true);
//     try {
//       final fetchedDetails = await ApiService.getCryptocurrencyDetails(widget.cryptocurrency.id);
//       setState(() {
//         details = fetchedDetails;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       _showErrorSnackbar('Failed to fetch cryptocurrency details');
//     }
//   }

//   void _showErrorSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void showSimilarCryptocurrencies(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SimilarCryptocurrenciesScreen(cryptocurrency: widget.cryptocurrency),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 200.0,
//               floating: false,
//               pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(widget.cryptocurrency.name,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     shadows: [Shadow(blurRadius: 2.0, color: Colors.black45, offset: Offset(1.0, 1.0))],
//                   ),
//                 ),
//                 background: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Hero(
//                       tag: 'crypto-${widget.cryptocurrency.id}',
//                       child: CachedNetworkImage(
//                         imageUrl: widget.cryptocurrency.image,
//                         fit: BoxFit.cover,
//                         color: Colors.black.withOpacity(0.5),
//                         colorBlendMode: BlendMode.darken,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 60,
//                       left: 16,
//                       child: CircleAvatar(
//                         backgroundImage: CachedNetworkImageProvider(widget.cryptocurrency.image),
//                         radius: 30,
//                         backgroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.refresh),
//                   onPressed: fetchDetails,
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.compare_arrows),
//                   onPressed: () => showSimilarCryptocurrencies(context),
//                   tooltip: 'Similar Cryptocurrencies',
//                 ),
//               ],
//             ),
//           ];
//         },
//         body: isLoading
//             ? _buildLoadingScreen()
//             : Column(
//                 children: [
//                   _buildPriceHeader(),
//                   TabBar(
//                     controller: _tabController,
//                     labelColor: Theme.of(context).primaryColor,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Theme.of(context).primaryColor,
//                     isScrollable: true,
//                     tabs: const [
//                       Tab(text: 'Overview'),
//                       Tab(text: 'Chart'),
//                       Tab(text: 'AI Insights'),
//                       Tab(text: 'AI Q&A'),
//                       Tab(text: 'Details'),
//                     ],
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         CryptocurrencyOverviewTab(cryptocurrency: widget.cryptocurrency, details: details),
//                         CryptocurrencyChartTab(cryptocurrency: widget.cryptocurrency),
//                         CryptocurrencyAIInsightsTab(cryptocurrency: widget.cryptocurrency),
//                         CryptocurrencyAIQATab(cryptocurrency: widget.cryptocurrency),
//                         CryptocurrencyDetailsTab(cryptocurrency: widget.cryptocurrency, details: details),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }

//   Widget _buildLoadingScreen() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: ListView.builder(
//         itemCount: 10,
//         itemBuilder: (context, index) => Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             height: 80,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPriceHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: Theme.of(context).cardColor,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 widget.cryptocurrency.symbol.toUpperCase(),
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: widget.cryptocurrency.percentChange24h >= 0 ? Colors.green : Colors.red,
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: Text(
//               '${widget.cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
//               style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class CryptocurrencyOverviewTab extends StatelessWidget {
//   final Cryptocurrency cryptocurrency;
//   final Map<String, dynamic> details;

//   const CryptocurrencyOverviewTab({Key? key, required this.cryptocurrency, required this.details}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildKeyStatistics(),
//         const SizedBox(height: 16),
//         _buildDescription(),
//         const SizedBox(height: 16),
//         _buildLinks(),
//       ],
//     );
//   }

//   Widget _buildKeyStatistics() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Key Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('Market Cap', '\$${NumberFormat("#,##0.00").format(cryptocurrency.marketCap)}'),
//             _buildStatItem('24h Volume', '\$${NumberFormat("#,##0.00").format(cryptocurrency.volume24h)}'),
//             _buildStatItem('Circulating Supply', '${NumberFormat("#,##0.00").format(cryptocurrency.circulatingSupply)} ${cryptocurrency.symbol.toUpperCase()}'),
//             if (cryptocurrency.totalSupply != null)
//               _buildStatItem('Total Supply', '${NumberFormat("#,##0.00").format(cryptocurrency.totalSupply)} ${cryptocurrency.symbol.toUpperCase()}'),
//             if (cryptocurrency.maxSupply != null)
//               _buildStatItem('Max Supply', '${NumberFormat("#,##0.00").format(cryptocurrency.maxSupply)} ${cryptocurrency.symbol.toUpperCase()}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 15)),
//           Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }

//   Widget _buildDescription() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             Text(details['description']?['en'] ?? 'No description available.'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLinks() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Links', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             if (details['links']?['homepage'] != null)
//               _buildLinkItem('Website', details['links']['homepage'][0]),
//             if (details['links']?['blockchain_site'] != null)
//               _buildLinkItem('Blockchain Explorer', details['links']['blockchain_site'][0]),
//             if (details['links']?['repos_url']?['github']?.isNotEmpty ?? false)
//               _buildLinkItem('GitHub', details['links']['repos_url']['github'][0]),
//             if (details['links']?['twitter_screen_name'] != null)
//               _buildLinkItem('Twitter', 'https://twitter.com/${details['links']['twitter_screen_name']}'),
//             if (details['links']?['facebook_username'] != null)
//               _buildLinkItem('Facebook', 'https://facebook.com/${details['links']['facebook_username']}'),
//             if (details['links']?['subreddit_url'] != null)
//               _buildLinkItem('Reddit', details['links']['subreddit_url']),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLinkItem(String label, String url) {
//     return ListTile(
//       title: Text(label),
//       trailing: const Icon(Icons.open_in_new),
//       onTap: () => _launchURL(url),
//     );
//   }

//   void _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       print('Could not launch $url');
//     }
//   }
// }

// class CryptocurrencyChartTab extends StatefulWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyChartTab({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   _CryptocurrencyChartTabState createState() => _CryptocurrencyChartTabState();
// }

// class _CryptocurrencyChartTabState extends State<CryptocurrencyChartTab> {
//   bool isChartLoading = true;
//   List<FlSpot> priceData = [];
//   int selectedChartDays = 7;

//   @override
//   void initState() {
//     super.initState();
//     fetchMarketChart();
//   }

//   Future<void> fetchMarketChart() async {
//     setState(() => isChartLoading = true);
//     try {
//       final chartData = await ApiService.getMarketChart(widget.cryptocurrency.id, selectedChartDays);
//       setState(() {
//         priceData = chartData.map((point) => FlSpot(point[0].toDouble(), point[1].toDouble())).toList();
//         isChartLoading = false;
//       });
//     } catch (e) {
//       setState(() => isChartLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch market chart data')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildChartButton('7D', 7),
//               _buildChartButton('30D', 30),
//               _buildChartButton('90D', 90),
//               _buildChartButton('1Y', 365),
//             ],
//           ),
//         ),
//         Expanded(
//           child: isChartLoading
//               ? const Center(child: CircularProgressIndicator())
//               : Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: LineChart(
//                     LineChartData(
//                       gridData: FlGridData(show: false),
//                       titlesData: FlTitlesData(show: false),
//                       borderData: FlBorderData(show: false),
//                       minX: priceData.isNotEmpty ? priceData.first.x : 0,
//                       maxX: priceData.isNotEmpty ? priceData.last.x : 0,
//                       minY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(min) : 0,
//                       maxY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(max) : 0,
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: priceData,
//                           isCurved: true,
//                           color: Theme.of(context).primaryColor,
//                           barWidth: 3,
//                           isStrokeCapRound: true,
//                           dotData: FlDotData(show: false),
//                           belowBarData: BarAreaData(
//                             show: true,
//                             color: Theme.of(context).primaryColor.withOpacity(0.1),
//                           ),
//                         ),
//                       ],
//                       lineTouchData: LineTouchData(
//                         touchTooltipData: LineTouchTooltipData(
//                           tooltipRoundedRadius: 8,
//                           getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
//                             return touchedBarSpots.map((barSpot) {
//                               final flSpot = barSpot;
//                               if (flSpot.x == 0 || flSpot.x.isNaN || flSpot.y == 0 || flSpot.y.isNaN) {
//                                 return null;
//                               }
//                               final DateTime date = DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
//                               return LineTooltipItem(
//                                 '${DateFormat('MMM d, yyyy').format(date)}\n\$${flSpot.y.toStringAsFixed(2)}',
//                                 const TextStyle(color: Colors.white),
//                               );
//                             }).toList();
//                           },
//                         ),
//                         handleBuiltInTouches: true,
//                         getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
//                           return spotIndexes.map((spotIndex) {
//                             return TouchedSpotIndicatorData(
//                               FlLine(color: Colors.blue, strokeWidth: 2),
//                               FlDotData(
//                                 getDotPainter: (spot, percent, barData, index) {
//                                   return FlDotCirclePainter(
//                                     radius: 6,
//                                     color: Colors.white,
//                                     strokeWidth: 3,
//                                     strokeColor: Colors.blue,
//                                   );
//                                 },
//                               ),
//                             );
//                           }).toList();
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Text(
//             'Price: \$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChartButton(String label, int days) {
//     return ElevatedButton(
//       onPressed: () {
//         setState(() => selectedChartDays = days);
//         fetchMarketChart();
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: selectedChartDays == days ? Theme.of(context).primaryColor : Colors.grey.shade200,
//         foregroundColor: selectedChartDays == days ? Colors.white : Colors.black,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       ),
//       child: Text(label),
//     );
//   }
// }
// class CryptocurrencyAIInsightsTab extends StatefulWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyAIInsightsTab({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   _CryptocurrencyAIInsightsTabState createState() => _CryptocurrencyAIInsightsTabState();
// }

// class _CryptocurrencyAIInsightsTabState extends State<CryptocurrencyAIInsightsTab> {
//   Map<String, String> aiAnalysis = {
//     'general': 'Loading...',
//     'news': 'Loading...',
//     'fundamental': 'Loading...',
//     'team': 'Loading...',
//   };

//   @override
//   void initState() {
//     super.initState();
//     fetchComprehensiveAnalysis();
//   }

//   Future<void> fetchComprehensiveAnalysis() async {
//     try {
//       final analysis = await AIService.generateComprehensiveAnalysis(widget.cryptocurrency);
//       setState(() {
//         aiAnalysis = analysis;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch AI analysis')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildAIInsights(),
//       ],
//     );
//   }

//   Widget _buildAIInsights() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('AI Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 16),
//         _buildAIInsightCard('General Analysis', aiAnalysis['general']!),
//         _buildAIInsightCard('Latest News', aiAnalysis['news']!),
//         _buildAIInsightCard('Fundamental Analysis', aiAnalysis['fundamental']!),
//         _buildAIInsightCard('Team Details', aiAnalysis['team']!),
//         const SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: fetchComprehensiveAnalysis,
//           child: const Text('Refresh AI Insights'),
//         ),
//       ],
//     );
//   }

//   Widget _buildAIInsightCard(String title, String content) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       margin: const EdgeInsets.only(bottom: 16),
//       child: ExpansionTile(
//         title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: MarkdownBody(data: content),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CryptocurrencyAIQATab extends StatefulWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyAIQATab({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   _CryptocurrencyAIQATabState createState() => _CryptocurrencyAIQATabState();
// }

// class _CryptocurrencyAIQATabState extends State<CryptocurrencyAIQATab> {
//   String aiQuestion = '';
//   String aiAnswer = '';

//   Future<void> askAIQuestion() async {
//     if (aiQuestion.isEmpty) return;
//     setState(() => aiAnswer = 'Loading...');
//     try {
//       final answer = await AIService.generateAIResponse(
//         "Answer this question about ${widget.cryptocurrency.name} (${widget.cryptocurrency.symbol}) as of ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}: $aiQuestion"
//       );
//       setState(() => aiAnswer = answer);
//     } catch (e) {
//       setState(() => aiAnswer = 'Failed to get AI response');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text('Ask AI about this Cryptocurrency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 16),
//           TextField(
//             onChanged: (value) => setState(() => aiQuestion = value),
//             decoration: InputDecoration(
//               hintText: 'Enter your question here',
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.send),
//                 onPressed: askAIQuestion,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Text('AI Answer:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           Expanded(
//             child: SingleChildScrollView(
//               child: MarkdownBody(data: aiAnswer),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CryptocurrencyDetailsTab extends StatelessWidget {
//   final Cryptocurrency cryptocurrency;
//   final Map<String, dynamic> details;

//   const CryptocurrencyDetailsTab({Key? key, required this.cryptocurrency, required this.details}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         _buildAllTimeHighLow(),
//         const SizedBox(height: 16),
//         _buildAdditionalInfo(),
//       ],
//     );
//   }

//   Widget _buildAllTimeHighLow() {
//     final athDate = details['market_data']?['ath_date']?['usd'] != null
//         ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['ath_date']['usd']))
//         : 'N/A';
//     final atlDate = details['market_data']?['atl_date']?['usd'] != null
//         ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['atl_date']['usd']))
//         : 'N/A';

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('All-Time High/Low', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('All-Time High', '\$${NumberFormat("#,##0.00").format(details['market_data']?['ath']?['usd'] ?? 0)}'),
//             Text('Date: $athDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
//             const SizedBox(height: 8),
//             _buildStatItem('All-Time Low', '\$${NumberFormat("#,##0.00").format(details['market_data']?['atl']?['usd'] ?? 0)}'),
//             Text('Date: $atlDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAdditionalInfo() {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text('Additional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 16),
//             _buildStatItem('Hashing Algorithm', details['hashing_algorithm'] ?? 'N/A'),
//             _buildStatItem('Genesis Date', details['genesis_date'] ?? 'N/A'),
//             _buildStatItem('Sentiment Up Votes', '${details['sentiment_votes_up_percentage']}%'),
//             _buildStatItem('Sentiment Down Votes', '${details['sentiment_votes_down_percentage']}%'),
//             _buildStatItem('Market Cap Rank', '#${details['market_cap_rank']}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(fontSize: 15)),
//           Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }                       






























import 'package:flutter_markdown/flutter_markdown.dart';
import 'similar_coins.dart';
import 'dart:math';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'CryptoLearningScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: CryptoExchangeApp(),
    ),
  );
}

class CryptoExchangeApp extends StatelessWidget {   
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Crypto Insights',
          theme: themeProvider.currentTheme,
          home: SearchScreen(),
          routes: {
            '/settings': (context) => SettingsScreen(),
            '/learning': (context) => CryptoLearningScreen(),
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}


class ThemeProvider extends ChangeNotifier {
  // Colors for Cybertronian Theme
  static const Color primaryDark = Color(0xFF0D47A1); // Deep futuristic blue
  static const Color primaryLight = Color(0xFF42A5F5); // Bright neon blue
  static const Color accentDark = Color(0xFF76FF03); // Neon green
  static const Color accentLight = Color(0xFFFFEA00); // Bright yellow
  static const Color backgroundDark = Color(0xFF212121); // Dark gray background
  static const Color backgroundLight = Color(0xFFE3F2FD); // Very light blue
  static const Color cardDark = Color(0xFF2C2C2C); // Slightly lighter dark card color
  static const Color cardLight = Color(0xFFFFFFFF); // Pure white card

  // Cybertronian Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryDark,
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryDark,
      secondary: accentDark,
      surface: cardDark,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
      bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
      displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: accentDark,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(color: accentDark),
  );

  // Cybertronian Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    colorScheme: const ColorScheme.light(
      primary: primaryLight,
      secondary: accentLight,
      surface: cardLight,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),
      bodyMedium: TextStyle(color: Colors.black54, fontFamily: 'Roboto'),
      displayLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      labelLarge: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: accentLight,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(color: accentLight),
  );

  // Current Theme
  late ThemeData currentTheme;

  ThemeProvider() {
    currentTheme = darkTheme;
  }

  //ThemeData get currentTheme => currentTheme;

  bool get isDarkMode => currentTheme.brightness == Brightness.dark;

  void toggleTheme() {
    currentTheme = isDarkMode ? lightTheme : darkTheme;
    notifyListeners();
  }

  void setDarkMode() {
    currentTheme = darkTheme;
    notifyListeners();
  }

  void setLightMode() {
    currentTheme = lightTheme;
    notifyListeners();
  }
}


// class ThemeProvider extends ChangeNotifier {
//   static const Color _primaryDark = Color(0xFF6200EA);
//   static const Color _primaryLight = Color(0xFF3F51B5);
//   static const Color _accentDark = Color(0xFFFF4081);
//   static const Color _accentLight = Color(0xFFFF9800);
//   static const Color _backgroundDark = Color(0xFF121212);
//   static const Color _backgroundLight = Color(0xFFF5F5F5);
//   static const Color _cardDark = Color(0xFF1E1E1E);
//   static const Color _cardLight = Color(0xFFFFFFFF);
//   static final ThemeData _darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: _primaryDark,
//     scaffoldBackgroundColor: _backgroundDark,
//     cardColor: _cardDark,
//     colorScheme: const ColorScheme.dark(
//       primary: _primaryDark,
//       secondary: _accentDark,
//       surface: _cardDark,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentDark,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentDark),
//   );

//   static final ThemeData _lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: _primaryLight,
//     scaffoldBackgroundColor: _backgroundLight,
//     cardColor: _cardLight,
//     colorScheme: const ColorScheme.light(
//       primary: _primaryLight,
//       secondary: _accentLight,
//       surface: _cardLight,
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),
//       bodyMedium: TextStyle(color: Colors.black54, fontFamily: 'Roboto'),
//       displayLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
//       labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
//     ),
//     buttonTheme: const ButtonThemeData(
//       buttonColor: _accentLight,
//       textTheme: ButtonTextTheme.primary,
//     ),
//     iconTheme: const IconThemeData(color: _accentLight),
//   );

//   late ThemeData _currentTheme;

//   ThemeProvider() {
//     _currentTheme = _darkTheme;
//   }

//   ThemeData get currentTheme => _currentTheme;
//   bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

//   void toggleTheme() {
//     _currentTheme = isDarkMode ? _lightTheme : _darkTheme;
//     notifyListeners();
//   }

//   void setDarkMode() {
//     _currentTheme = _darkTheme;
//     notifyListeners();
//   }

//   void setLightMode() {
//     _currentTheme = _lightTheme;
//     notifyListeners();
//   }
// }

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  Cryptocurrency? _searchResult;
  bool _isLoading = false;
  Timer? _debounce;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _performSearch(_searchController.text);
      } else {
        setState(() => _searchResult = null);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() => _isLoading = true);
    try {
      final result = await ApiService.getSearchedCryptocurrency(query);
      setState(() {
        _searchResult = result;
        _isLoading = false;
      });
      _animationController.forward(from: 0.0);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Insights', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search cryptocurrency',
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.2),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_searchResult != null) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: CryptocurrencyListItem(cryptocurrency: _searchResult!),
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Search for a cryptocurrency',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }
  }
}

class CryptocurrencyListItem extends StatelessWidget {
  final Cryptocurrency cryptocurrency;

  const CryptocurrencyListItem({Key? key, required this.cryptocurrency}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToDetailScreen(context),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildPriceInfo(),
                const SizedBox(height: 12),
                _buildAdditionalInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Hero(
          tag: 'crypto-${cryptocurrency.id}',
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(cryptocurrency.image),
            radius: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cryptocurrency.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                cryptocurrency.symbol.toUpperCase(),
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
        if (cryptocurrency.rank != 0)
          Chip(
            label: Text(
              '#${cryptocurrency.rank}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.black26,
          ),
      ],
    );
  }

  Widget _buildPriceInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Price',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              '\$${cryptocurrency.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              '24h Change',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              '${_getChangeIcon(cryptocurrency.percentChange24h)} ${cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getChangeColor(cryptocurrency.percentChange24h),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoItem('Market Cap', '\$${_formatLargeNumber(cryptocurrency.marketCap)}'),
        _buildInfoItem('24h Volume', '\$${_formatLargeNumber(cryptocurrency.volume24h)}'),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  String _getChangeIcon(double change) {
    return change >= 0 ? '▲' : '▼';
  }

  Color _getChangeColor(double change) {
    return change >= 0 ? Colors.greenAccent : Colors.redAccent;
  }

  String _formatLargeNumber(double number) {
    if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }

  void _navigateToDetailScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CryptocurrencyDetailScreen(
          cryptocurrency: cryptocurrency,
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Theme'),
            trailing: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Switch(
                  value: themeProvider.currentTheme.brightness == Brightness.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                  activeColor: Theme.of(context).colorScheme.secondary,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'Crypto Insights',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('AI Learning'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/learning');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}

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

class CacheService {
  static const String prefix = 'api_cache_';
  static const Duration defaultCacheDuration = Duration(minutes: 15);

  static Future<void> setCache(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$prefix$key', value);
    await prefs.setInt('${prefix}${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  static Future<String?> getCache(String key, {Duration? maxAge}) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('$prefix$key');
    final timestamp = prefs.getInt('${prefix}${key}_timestamp');
    
    if (value != null && timestamp != null) {
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (age < (maxAge ?? defaultCacheDuration).inMilliseconds) {
        return value;
      }
    }
    return null;
  }
}

class ThrottleService {
  static final Map<String, DateTime> _lastRequestTimes = {};
  static const Duration throttleDuration = Duration(seconds: 1);

  static Future<void> throttle(String key) async {
    final now = DateTime.now();
    final lastRequestTime = _lastRequestTimes[key];
    if (lastRequestTime != null) {
      final timeSinceLastRequest = now.difference(lastRequestTime);
      if (timeSinceLastRequest < throttleDuration) {
        await Future.delayed(throttleDuration - timeSinceLastRequest);
      }
    }
    _lastRequestTimes[key] = DateTime.now();
  }
}


class AIService {
  static const String apiKey = 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y';
  static final model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: apiKey,
  );

  static Future<String> generateAIResponse(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return 'No response generated';
      }
    } catch (e) {
      return 'Error generating response: $e';
    }
  }

  static Future<Map<String, String>> generateComprehensiveAnalysis(Cryptocurrency crypto) async {
    Map<String, String> analysis = {};
    String currentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    analysis['general'] = await generateAIResponse(
      "Provide a comprehensive general analysis of ${crypto.name} (${crypto.symbol}) in the cryptocurrency market as of $currentDate. Include:\n"
      "1. Current price: \$${crypto.price.toStringAsFixed(2)} - compare this to 7-day and 30-day averages\n"
      "2. Market cap: \$${crypto.marketCap.toStringAsFixed(2)} - discuss its rank and recent changes\n"
      "3. 24-hour trading volume and how it compares to the 7-day average\n"
      "4. Recent performance: 24h, 7d, and 30d price changes (in percentages)\n"
      "5. Current market dominance and comparison to major cryptocurrencies\n"
      "6. Brief overview of on-chain metrics (e.g., active addresses, transaction count) if applicable\n"
      "7. General market sentiment towards ${crypto.name} based on recent events\n"
      "Provide specific numbers and percentages where possible, and focus on data from the last 30 days."
    );

    analysis['news'] = await generateAIResponse(
      "Summarize the most recent news and developments for ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
      "1. Major announcements or events from the past 7 days, with exact dates\n"
      "2. Any significant partnerships or collaborations revealed in the last 30 days\n"
      "3. Recent protocol upgrades or technological advancements, specifying implementation dates\n"
      "4. Regulatory news or legal developments affecting ${crypto.name} in the past month\n"
      "5. Notable mentions of ${crypto.name} by industry leaders or influential figures (quote if possible)\n"
      "6. Upcoming events in the next 14 days that could impact ${crypto.name}'s value\n"
      "7. Any changes in ${crypto.name}'s ecosystem (e.g., DeFi, NFTs) in the last 30 days\n"
      "8. Comparison of recent news to its main competitors\n"
      "Prioritize the most impactful and recent news items. For each point, provide the date of occurrence or announcement."
    );

    analysis['fundamental'] = await generateAIResponse(
      "Analyze the current fundamental aspects of ${crypto.name} (${crypto.symbol}) as of $currentDate. Cover:\n"
      "1. Latest technological updates or changes to the protocol\n"
      "2. Most recent partnerships or adoption metrics\n"
      "3. Upcoming events or releases in the next 30 days\n"
      "4. Current market sentiment and social media buzz\n"
      "5. Any recent regulatory news affecting ${crypto.name}\n"
      "Provide a comprehensive A to Z fundamental analysis of ${crypto.name} (${crypto.symbol}) as of $currentDate. Cover:\n"
"1. Architecture: Explain the blockchain architecture and consensus mechanism\n"
"2. Business model: Describe the project's business model and value proposition\n"
"3. Competitive landscape: Compare with similar projects in the market\n"
"4. Developer activity: Recent GitHub commits, contributors, and development progress\n"
"5. Economic model: Token economics, distribution, and inflation/deflation mechanisms\n"
"6. Funding: Initial and ongoing funding, including venture capital investments\n"
"7. Governance: Decision-making processes and community involvement\n"
"8. Hash rate (for PoW) or Staking statistics (for PoS): Network security metrics\n"
"9. Innovations: Unique features or technological advancements\n"
"10. Joint ventures and partnerships: Recent and significant collaborations\n"
"11. Key team members: Backgrounds of founders and core team\n"
"12. Liquidity: Trading volume across exchanges and DeFi protocols\n"
"13. Market adoption: Real-world use cases and user growth metrics\n"
"14. Network effects: How the project benefits from increased adoption\n"
"15. On-chain metrics: Active addresses, transaction count, and network usage\n"
"16. Planned upgrades: Roadmap and upcoming protocol changes\n"
"17. Quality of documentation: Whitepaper, technical docs, and community resources\n"
"18. Regulatory compliance: Legal status and compliance efforts\n"
"19. Scalability: Current and planned solutions for network scaling\n"
"20. Tokenomics: Detailed analysis of token utility and economic design\n"
"21. Use cases: Current and potential applications of the technology\n"
"22. Vulnerabilities: Known security issues or potential attack vectors\n"
"23. Wallet ecosystem: Available storage solutions and integrations\n"
"24. X-factor: Unique selling points or competitive advantages\n"
"25. Yield opportunities: Staking, farming, or other reward mechanisms\n"
"26. Zero-knowledge proofs (if applicable): Privacy features and implementations\n"
"Prioritize the most relevant and recent information. Provide specific data points, dates, and metrics where possible."
      "Prioritize information from the last 30 days and specify dates for any mentioned events or updates."
    );

    analysis['team'] = await generateAIResponse(
      "Deliver a comprehensive report on the current team behind ${crypto.name} (${crypto.symbol}) as of $currentDate. Include:\n"
      "1. Detailed profiles of key team members (at least 5), including their roles, professional backgrounds, and notable achievements\n"
      "2. Recent changes in leadership or significant hires in the last 6 months\n"
      "3. Team's latest public appearances, interviews, or statements (provide dates)\n"
      "4. Ongoing projects or initiatives led by specific team members\n"
      "5. Any controversies or praised actions involving team members in the last year\n"
      "6. Assessment of the team's transparency and communication with the community\n"
      "7. Comparison of the team's expertise with that of competitor projects\n"
      "Provide specific dates for any mentioned events or changes and focus on the most recent information available."
    );

    return analysis;
  }
}

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
        final display = item['DISPLAY']['USD'];
        
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
class CryptocurrencyDetailScreen extends StatefulWidget {
  final Cryptocurrency cryptocurrency;

  const CryptocurrencyDetailScreen({Key? key, required this.cryptocurrency}) : super(key: key);

  @override
  _CryptocurrencyDetailScreenState createState() => _CryptocurrencyDetailScreenState();
}

class _CryptocurrencyDetailScreenState extends State<CryptocurrencyDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  
  Map<String, dynamic> details = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _scrollController = ScrollController();
    fetchDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchDetails() async {
    setState(() => isLoading = true);
    try {
      final fetchedDetails = await ApiService.getCryptocurrencyDetails(widget.cryptocurrency.id);
      setState(() {
        details = fetchedDetails;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackbar('Failed to fetch cryptocurrency details');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showSimilarCryptocurrencies(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SimilarCryptocurrenciesScreen(cryptocurrency: widget.cryptocurrency),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(widget.cryptocurrency.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(blurRadius: 2.0, color: Colors.black45, offset: Offset(1.0, 1.0))],
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'crypto-${widget.cryptocurrency.id}',
                      child: CachedNetworkImage(
                        imageUrl: widget.cryptocurrency.image,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.5),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Positioned(
                      bottom: 60,
                      left: 16,
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(widget.cryptocurrency.image),
                        radius: 30,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: fetchDetails,
                ),
                IconButton(
                  icon: const Icon(Icons.compare_arrows),
                  onPressed: () => showSimilarCryptocurrencies(context),
                  tooltip: 'Similar Cryptocurrencies',
                ),
              ],
            ),
          ];
        },
        body: isLoading
            ? _buildLoadingScreen()
            : Column(
                children: [
                  _buildPriceHeader(),
                  TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Theme.of(context).primaryColor,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Chart'),
                      Tab(text: 'AI Insights'),
                      Tab(text: 'AI Q&A'),
                      Tab(text: 'Details'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        CryptocurrencyOverviewTab(cryptocurrency: widget.cryptocurrency, details: details),
                        CryptocurrencyChartTab(cryptocurrency: widget.cryptocurrency),
                        CryptocurrencyAIInsightsTab(cryptocurrency: widget.cryptocurrency),
                        CryptocurrencyAIQATab(cryptocurrency: widget.cryptocurrency),
                        CryptocurrencyDetailsTab(cryptocurrency: widget.cryptocurrency, details: details),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 80,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.cryptocurrency.symbol.toUpperCase(),
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.cryptocurrency.percentChange24h >= 0 ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${widget.cryptocurrency.percentChange24h.toStringAsFixed(2)}%',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
class CryptocurrencyOverviewTab extends StatelessWidget {
  final Cryptocurrency cryptocurrency;
  final Map<String, dynamic> details;

  const CryptocurrencyOverviewTab({Key? key, required this.cryptocurrency, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildKeyStatistics(),
        const SizedBox(height: 16),
        _buildDescription(),
        const SizedBox(height: 16),
        _buildLinks(),
      ],
    );
  }

  Widget _buildKeyStatistics() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Key Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildStatItem('Market Cap', '\$${NumberFormat("#,##0.00").format(cryptocurrency.marketCap)}'),
            _buildStatItem('24h Volume', '\$${NumberFormat("#,##0.00").format(cryptocurrency.volume24h)}'),
            _buildStatItem('Circulating Supply', '${NumberFormat("#,##0.00").format(cryptocurrency.circulatingSupply)} ${cryptocurrency.symbol.toUpperCase()}'),
            if (cryptocurrency.totalSupply != null)
              _buildStatItem('Total Supply', '${NumberFormat("#,##0.00").format(cryptocurrency.totalSupply)} ${cryptocurrency.symbol.toUpperCase()}'),
            if (cryptocurrency.maxSupply != null)
              _buildStatItem('Max Supply', '${NumberFormat("#,##0.00").format(cryptocurrency.maxSupply)} ${cryptocurrency.symbol.toUpperCase()}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(details['description']?['en'] ?? 'No description available.'),
          ],
        ),
      ),
    );
  }

  Widget _buildLinks() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Links', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (details['links']?['homepage'] != null)
              _buildLinkItem('Website', details['links']['homepage'][0]),
            if (details['links']?['blockchain_site'] != null)
              _buildLinkItem('Blockchain Explorer', details['links']['blockchain_site'][0]),
            if (details['links']?['repos_url']?['github']?.isNotEmpty ?? false)
              _buildLinkItem('GitHub', details['links']['repos_url']['github'][0]),
            if (details['links']?['twitter_screen_name'] != null)
              _buildLinkItem('Twitter', 'https://twitter.com/${details['links']['twitter_screen_name']}'),
            if (details['links']?['facebook_username'] != null)
              _buildLinkItem('Facebook', 'https://facebook.com/${details['links']['facebook_username']}'),
            if (details['links']?['subreddit_url'] != null)
              _buildLinkItem('Reddit', details['links']['subreddit_url']),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem(String label, String url) {
    return ListTile(
      title: Text(label),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => _launchURL(url),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $url');
    }
  }
}

class CryptocurrencyChartTab extends StatefulWidget {
  final Cryptocurrency cryptocurrency;

  const CryptocurrencyChartTab({Key? key, required this.cryptocurrency}) : super(key: key);

  @override
  _CryptocurrencyChartTabState createState() => _CryptocurrencyChartTabState();
}

class _CryptocurrencyChartTabState extends State<CryptocurrencyChartTab> {
  bool isChartLoading = true;
  List<FlSpot> priceData = [];
  int selectedChartDays = 7;

  @override
  void initState() {
    super.initState();
    fetchMarketChart();
  }

  Future<void> fetchMarketChart() async {
    setState(() => isChartLoading = true);
    try {
      final chartData = await ApiService.getMarketChart(widget.cryptocurrency.id, selectedChartDays);
      setState(() {
        priceData = chartData.map((point) => FlSpot(point[0].toDouble(), point[1].toDouble())).toList();
        isChartLoading = false;
      });
    } catch (e) {
      setState(() => isChartLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch market chart data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildChartButton('7D', 7),
              _buildChartButton('30D', 30),
              _buildChartButton('90D', 90),
              _buildChartButton('1Y', 365),
            ],
          ),
        ),
        Expanded(
          child: isChartLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      minX: priceData.isNotEmpty ? priceData.first.x : 0,
                      maxX: priceData.isNotEmpty ? priceData.last.x : 0,
                      minY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(min) : 0,
                      maxY: priceData.isNotEmpty ? priceData.map((spot) => spot.y).reduce(max) : 0,
                      lineBarsData: [
                        LineChartBarData(
                          spots: priceData,
                          isCurved: true,
                          color: Theme.of(context).primaryColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final flSpot = barSpot;
                              if (flSpot.x == 0 || flSpot.x.isNaN || flSpot.y == 0 || flSpot.y.isNaN) {
                                return null;
                              }
                              final DateTime date = DateTime.fromMillisecondsSinceEpoch(flSpot.x.toInt());
                              return LineTooltipItem(
                                '${DateFormat('MMM d, yyyy').format(date)}\n\$${flSpot.y.toStringAsFixed(2)}',
                                const TextStyle(color: Colors.white),
                              );
                            }).toList();
                          },
                        ),
                        handleBuiltInTouches: true,
                        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                          return spotIndexes.map((spotIndex) {
                            return TouchedSpotIndicatorData(
                              FlLine(color: Colors.blue, strokeWidth: 2),
                              FlDotData(
                                getDotPainter: (spot, percent, barData, index) {
                                  return FlDotCirclePainter(
                                    radius: 6,
                                    color: Colors.white,
                                    strokeWidth: 3,
                                    strokeColor: Colors.blue,
                                  );
                                },
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Price: \$${NumberFormat("#,##0.00").format(widget.cryptocurrency.price)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildChartButton(String label, int days) {
    return ElevatedButton(
      onPressed: () {
        setState(() => selectedChartDays = days);
        fetchMarketChart();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedChartDays == days ? Theme.of(context).primaryColor : Colors.grey.shade200,
        foregroundColor: selectedChartDays == days ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label),
    );
  }
}
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

class CryptocurrencyAIInsightsTab extends StatefulWidget {
  final Cryptocurrency cryptocurrency;

  const CryptocurrencyAIInsightsTab({Key? key, required this.cryptocurrency}) : super(key: key);

  @override
  _CryptocurrencyAIInsightsTabState createState() => _CryptocurrencyAIInsightsTabState();
}

class _CryptocurrencyAIInsightsTabState extends State<CryptocurrencyAIInsightsTab> {
  Map<String, String> aiAnalysis = {
    'general': 'Collecting Details Wait 2Min...',
    'news': 'Collecting Details Wait 2Min...',
    'fundamental': 'Collecting Details Wait 2Min...',
    'team': 'Collecting Details Wait 2Min...',
    'technical': 'Collecting Details Wait 2Min...',
    'sentiment': 'Collecting Details Wait 2Min...',
    'risk': 'Collecting Details Wait 2Min...',
  };
  bool isRefreshing = false;
  Timer? _autoRefreshTimer;
  int _failedAttempts = 0;
  final int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _initializeAnalysis();
    _setupAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  void _setupAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 30), (_) {
      if (!isRefreshing && _failedAttempts < _maxRetries) {
        fetchComprehensiveAnalysis(silent: true);
      }
    });
  }

  Future<void> _initializeAnalysis() async {
    await fetchComprehensiveAnalysis();
    _startPeriodicUpdates();
  }

  void _startPeriodicUpdates() {
    Timer.periodic(const Duration(minutes: 5), (timer) async {
      if (mounted) {
        await _updateTimeBasedAnalysis();
      }
    });
  }

  Future<void> _updateTimeBasedAnalysis() async {
    try {
      final technicalAnalysis = await AIService.generateAIResponse(
        "Generate a real-time technical analysis for ${widget.cryptocurrency.name} focusing on current price action, momentum indicators, and potential support/resistance levels."
      );
      
      final sentimentAnalysis = await AIService.generateAIResponse(
        "Analyze current market sentiment for ${widget.cryptocurrency.name} using social media metrics, news sentiment, and trading volume patterns."
      );

      if (mounted) {
        setState(() {
          aiAnalysis['technical'] = technicalAnalysis;
          aiAnalysis['sentiment'] = sentimentAnalysis;
        });
      }
    } catch (e) {
      print('Failed to update time-based analysis: $e');
    }
  }

  Future<void> fetchComprehensiveAnalysis({bool silent = false}) async {
    if (isRefreshing) return;

    setState(() {
      isRefreshing = true;
      if (!silent) {
        aiAnalysis = aiAnalysis.map((k, v) => MapEntry(k, 'Collecting Details Wait 2Min...'));
      }
    });

    try {
      final analysis = await AIService.generateComprehensiveAnalysis(widget.cryptocurrency);
      
      // Additional risk analysis
      final riskAnalysis = await AIService.generateAIResponse(
        """Provide a comprehensive risk assessment for ${widget.cryptocurrency.name} (${widget.cryptocurrency.symbol}) including:
        1. Market risk factors
        2. Technical vulnerabilities
        3. Regulatory concerns
        4. Competition analysis
        5. Volatility metrics
        6. Liquidity risks
        7. Correlation with market trends
        Please provide specific metrics and comparisons where possible."""
      );

      if (mounted) {
        setState(() {
          aiAnalysis = {
            ...analysis,
            'risk': riskAnalysis,
          };
          _failedAttempts = 0;
        });
      }
    } catch (e) {
      _failedAttempts++;
      if (!silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis failed. Attempts remaining: ${_maxRetries - _failedAttempts}'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => fetchComprehensiveAnalysis(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isRefreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => fetchComprehensiveAnalysis(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAIInsights(),
        ],
      ),
    );
  }

  Widget _buildAIInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        ...aiAnalysis.entries.map((entry) => _buildAIInsightCard(
          entry.key.capitalize(),
          entry.value,
          getInsightIcon(entry.key),
        )).toList(),
        const SizedBox(height: 16),
        _buildRefreshButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'AI Insights',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        if (isRefreshing)
          const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }

  Widget _buildAIInsightCard(String title, String content, IconData icon) {
    final isLoading = content.contains('Loading') || content.contains('Collecting Details Wait 2Min');
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: isLoading
            ? LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MarkdownBody(
                  data: content,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(height: 1.5),
                    strong: const TextStyle(fontWeight: FontWeight.w600),
                    blockquote: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
                if (!isLoading) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Last updated: ${DateFormat('MMM d, y HH:mm').format(DateTime.now())}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isRefreshing ? null : () => fetchComprehensiveAnalysis(),
        icon: const Icon(Icons.refresh),
        label: Text(isRefreshing ? 'Collecting Details Wait 2Min...' : 'Refresh All Insights'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  IconData getInsightIcon(String type) {
    switch (type.toLowerCase()) {
      case 'general':
        return Icons.analytics_outlined;
      case 'news':
        return Icons.newspaper;
      case 'fundamental':
        return Icons.foundation;
      case 'team':
        return Icons.people_outline;
      case 'technical':
        return Icons.show_chart;
      case 'sentiment':
        return Icons.mood;
      case 'risk':
        return Icons.warning_amber_outlined;
      default:
        return Icons.info_outline;
    }
  }
}
// class CryptocurrencyAIQATab extends StatefulWidget {
//   final Cryptocurrency cryptocurrency;

//   const CryptocurrencyAIQATab({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   _CryptocurrencyAIQATabState createState() => _CryptocurrencyAIQATabState();
// }

// class Message {
//   final String text;
//   final bool isUser;
//   final DateTime timestamp;
//   final MessageStatus status;

//   Message({
//     required this.text,
//     required this.isUser,
//     required this.timestamp,
//     this.status = MessageStatus.sent,
//   });
// }

// enum MessageStatus { sending, sent, error }

// class _CryptocurrencyAIQATabState extends State<CryptocurrencyAIQATab> {
//   final TextEditingController _questionController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<Message> _chatHistory = [];
//   Map<String, dynamic>? liveData;
//   Timer? _refreshTimer;
//   bool _isTyping = false;
//   String _errorMessage = '';

//   final List<String> _suggestedQuestions = [
//     'What factors are affecting the price today?',
//     'Should I invest now based on current metrics?',
//     'How does it compare to other cryptocurrencies?',
//     'What''s the technical analysis outlook?',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     fetchLiveData();
//     _refreshTimer = Timer.periodic(const Duration(minutes: 2), (_) => fetchLiveData());
//     _addWelcomeMessage();
//   }

//   void _addWelcomeMessage() {
//     final welcome = '''
// Hello! 👋 I'm your ${widget.cryptocurrency.name} assistant. I can help you with:
// • Real-time price analysis
// • Market trends and predictions
// • Technical analysis insights
// • News impact assessment

// Feel free to ask any questions or tap one of the suggested questions below!
// ''';
//     _chatHistory.add(Message(
//       text: welcome,
//       isUser: false,
//       timestamp: DateTime.now(),
//     ));
//   }

//   @override
//   void dispose() {
//     _refreshTimer?.cancel();
//     _questionController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> fetchLiveData() async {
//     try {
//       final data = await ApiService.getCombinedCryptoData(
//         widget.cryptocurrency.symbol.toUpperCase(),
//         widget.cryptocurrency.id
//       );
//       setState(() {
//         liveData = data;
//         _errorMessage = '';
//       });
//     } catch (e) {
//       setState(() => _errorMessage = 'Unable to fetch latest data. Retrying...');
//       print('Failed to fetch live data: $e');
//     }
//   }

//   Future<void> _sendMessage(String message) async {
//     if (message.trim().isEmpty) return;

//     setState(() {
//       _chatHistory.add(Message(
//         text: message,
//         isUser: true,
//         timestamp: DateTime.now(),
//       ));
//       _isTyping = true;
//       _questionController.clear();
//     });

//     _scrollToBottom();

//     try {
//       final currentPrice = liveData?['price']?['PRICE'] ?? 
//                          liveData?['price']?['current_price']?['usd'] ??
//                          widget.cryptocurrency.price;
      
//       final priceChange24h = liveData?['price']?['CHANGEPCT24HOUR'] ?? 
//                             liveData?['price']?['price_change_percentage_24h'] ??
//                             widget.cryptocurrency.percentChange24h;
      
//       final recentNews = liveData?['news']?.isNotEmpty == true
//           ? '\nRecent news: ${(liveData!['news'] as List).take(3).map((n) => n['title']).join('; ')}'
//           : '';

//       final prompt = """
//       Answer this question about ${widget.cryptocurrency.name} (${widget.cryptocurrency.symbol}) 
//       as a knowledgeable and friendly crypto expert. Use current data as of ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}:
      
//       Current Price: \$$currentPrice
//       24h Change: ${priceChange24h.toStringAsFixed(2)}%
//       Data Source: ${liveData?['source'] ?? 'Unknown'}
//       $recentNews
      
//       Question: $message
      
//       Please provide a concise, friendly response with relevant data points and clear reasoning.
//       """;

//       final answer = await AIService.generateAIResponse(prompt);
      
//       setState(() {
//         _chatHistory.add(Message(
//           text: answer,
//           isUser: false,
//           timestamp: DateTime.now(),
//         ));
//         _isTyping = false;
//       });
      
//       _scrollToBottom();
//     } catch (e) {
//       setState(() {
//         _chatHistory.add(Message(
//           text: 'Sorry, I encountered an error while processing your request. Please try again.',
//           isUser: false,
//           timestamp: DateTime.now(),
//           status: MessageStatus.error,
//         ));
//         _isTyping = false;
//       });
//     }
//   }

//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildLiveDataCard(),
//         Expanded(
//           child: Stack(
//             children: [
//               Column(
//                 children: [
//                   Expanded(
//                     child: _buildChatList(),
//                   ),
//                   _buildSuggestedQuestions(),
//                   _buildInputArea(),
//                 ],
//               ),
//               if (_errorMessage.isNotEmpty)
//                 _buildErrorBanner(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildChatList() {
//     return ListView.builder(
//       controller: _scrollController,
//       padding: const EdgeInsets.all(16),
//       itemCount: _chatHistory.length + (_isTyping ? 1 : 0),
//       itemBuilder: (context, index) {
//         if (index == _chatHistory.length && _isTyping) {
//           return _buildTypingIndicator();
//         }
//         return _buildMessageBubble(_chatHistory[index]);
//       },
//     );
//   }

//  Widget _buildTypingIndicator() {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8),
//     child: Row(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               SizedBox(
//                 width: 16,
//                 height: 16,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Colors.grey,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               const Text('Thinking...', 
//                 style: TextStyle(color: Colors.grey)),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

//   Widget _buildMessageBubble(Message message) {
//     return Align(
//       alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: message.isUser ? Theme.of(context).primaryColor : Colors.grey[200],
//           borderRadius: BorderRadius.circular(20),
//         ),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             MarkdownBody(
//               data: message.text,
//               styleSheet: MarkdownStyleSheet(
//                 p: TextStyle(
//                   color: message.isUser ? Colors.white : Colors.black87,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               DateFormat('HH:mm').format(message.timestamp),
//               style: TextStyle(
//                 fontSize: 12,
//                 color: message.isUser ? Colors.white70 : Colors.black54,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSuggestedQuestions() {
//     return Container(
//       height: 50,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: _suggestedQuestions.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: ActionChip(
//               label: Text(_suggestedQuestions[index]),
//               onPressed: () => _sendMessage(_suggestedQuestions[index]),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _questionController,
//               decoration: InputDecoration(
//                 hintText: 'Ask about ${widget.cryptocurrency.name}...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Theme.of(context).primaryColor,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//               ),
//               onSubmitted: _sendMessage,
//             ),
//           ),
//           const SizedBox(width: 8),
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: () => _sendMessage(_questionController.text),
//             color: Theme.of(context).primaryColor,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorBanner() {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       child: Material(
//         color: Colors.red[100],
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Row(
//             children: [
//               const Icon(Icons.error_outline, color: Colors.red),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   _errorMessage,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.close, color: Colors.red),
//                 onPressed: () => setState(() => _errorMessage = ''),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildLiveDataCard() {
//     if (liveData == null) {
//       return const Card(
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Center(child: CircularProgressIndicator()),
//         ),
//       );
//     }

//     final price = liveData!['price']?['PRICE'] ?? 
//                  liveData!['price']?['current_price']?['usd'] ??
//                  widget.cryptocurrency.price;
    
//     final change24h = liveData!['price']?['CHANGEPCT24HOUR'] ?? 
//                      liveData!['price']?['price_change_percentage_24h'] ??
//                      widget.cryptocurrency.percentChange24h;

//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text('Live Data (${liveData!['source']})',
//                   style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 IconButton(
//                   icon: const Icon(Icons.refresh),
//                   onPressed: fetchLiveData,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text('Price: \$${price.toStringAsFixed(2)}'),
//             Text('24h Change: ${change24h.toStringAsFixed(2)}%',
//               style: TextStyle(
//                 color: change24h >= 0 ? Colors.green : Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             if (liveData!['news']?.isNotEmpty == true) ...[
//               const SizedBox(height: 8),
//               const Text('Recent News:',
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//               ...List.generate(
//                 min(3, (liveData!['news'] as List).length),
//                 (index) => Text(
//                   '• ${liveData!['news'][index]['title']}',
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
class CryptocurrencyAIQATab extends StatefulWidget {
  final Cryptocurrency cryptocurrency;

  const CryptocurrencyAIQATab({Key? key, required this.cryptocurrency}) : super(key: key);

  @override
  _CryptocurrencyAIQATabState createState() => _CryptocurrencyAIQATabState();
}

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageStatus status;
  final String emotion;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.emotion = 'neutral',
  });
}

enum MessageStatus { sending, sent, error }

class _CryptocurrencyAIQATabState extends State<CryptocurrencyAIQATab> {
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Message> _chatHistory = [];
  Map<String, dynamic>? liveData;
  Timer? _refreshTimer;
  bool _isTyping = false;
  String _errorMessage = '';
  int _conversationDepth = 0;

  final List<String> _suggestedQuestions = [
    'How do you feel about the market today?',
    'What concerns should I watch out for?',
    'Can you help me understand the risks?',
    'What makes you optimistic about this investment?',
  ];

  final Map<String, String> _emotionalResponses = {
    'positive': 'My spark feels energized seeing these positive trends! ',
    'negative': 'I share your concern about these numbers, but remember - we\'ve faced greater challenges. ',
    'neutral': 'Let me analyze this situation with both logic and heart. ',
    'cautious': 'Like in my battles protecting Cybertron, we must proceed with careful strategy. ',
    'excited': 'This reminds me of the thrill of victory in battle! ',
  };

  @override
  void initState() {
    super.initState();
    fetchLiveData();
    _refreshTimer = Timer.periodic(const Duration(minutes: 2), (_) => fetchLiveData());
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcome = '''
Hello, my dear friend 💖

I am Elita-One, your dedicated companion in this crypto journey. Just as I stood beside Optimus Prime in countless battles, I'll be here with you, offering both strength and understanding.

Let me be your guide through:
✨ Market insights with compassion
🛡️ Protective investment strategies
💫 Emotional support during volatility
💝 Genuine care for your success

Share your thoughts or choose a question below - together, we'll forge a path through any market challenge.
''';
    _chatHistory.add(Message(
      text: welcome,
      isUser: false,
      timestamp: DateTime.now(),
      emotion: 'warm',
    ));
  }

  String _getEmotionalResponse(double priceChange) {
    if (priceChange > 5) return _emotionalResponses['excited']!;
    if (priceChange > 0) return _emotionalResponses['positive']!;
    if (priceChange < -5) return _emotionalResponses['cautious']!;
    if (priceChange < 0) return _emotionalResponses['negative']!;
    return _emotionalResponses['neutral']!;
  }

  String _addPersonalTouch() {
    _conversationDepth++;
    if (_conversationDepth > 3) {
      return '\n\nYou know, your thoughtful questions remind me of the deep conversations I used to have with Optimus. It warms my spark to guide you with the same care and wisdom.';
    }
    return '';
  }

  Future<void> fetchLiveData() async {
    try {
      final data = await ApiService.getCombinedCryptoData(
        widget.cryptocurrency.symbol.toUpperCase(),
        widget.cryptocurrency.id
      );
      setState(() {
        liveData = data;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() => _errorMessage = 'Unable to fetch latest data. Recalibrating systems...');
      print('Failed to fetch live data: $e');
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _chatHistory.add(Message(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
      _questionController.clear();
    });

    _scrollToBottom();

    try {
      final currentPrice = liveData?['price']?['PRICE'] ?? 
                         liveData?['price']?['current_price']?['usd'] ??
                         widget.cryptocurrency.price;
      
      final priceChange24h = liveData?['price']?['CHANGEPCT24HOUR'] ?? 
                            liveData?['price']?['price_change_percentage_24h'] ??
                            widget.cryptocurrency.percentChange24h;
      
      final emotionalOpening = _getEmotionalResponse(priceChange24h);
      final personalTouch = _addPersonalTouch();

      final prompt = """
      As Elita-One, respond to this question about ${widget.cryptocurrency.name} (${widget.cryptocurrency.symbol}) 
      with both emotional intelligence and technical expertise. Current data as of ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}:
      
      $emotionalOpening
      Question: $message
      $personalTouch
      """;

      final answer = await AIService.generateAIResponse(prompt);
      
      setState(() {
        _chatHistory.add(Message(
          text: answer,
          isUser: false,
          timestamp: DateTime.now(),
          emotion: priceChange24h >= 0 ? 'positive' : 'concerned',
        ));
        _isTyping = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _chatHistory.add(Message(
          text: 'My deepest apologies, dear one. Like those moments when my systems were tested in battle, I\'m experiencing a temporary glitch. Give me a moment to recalibrate, and I\'ll be right back at your side. 💝',
          isUser: false,
          timestamp: DateTime.now(),
          status: MessageStatus.error,
          emotion: 'apologetic',
        ));
        _isTyping = false;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: _buildChatList(),
                  ),
                  _buildSuggestedQuestions(),
                  _buildInputArea(),
                ],
              ),
              if (_errorMessage.isNotEmpty)
                _buildErrorBanner(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _chatHistory.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _chatHistory.length && _isTyping) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_chatHistory[index]);
      },
    );
  }

//   Widget _buildTypingIndicator() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(
//                 color: Theme.of(context).primaryColor.withOpacity(0.3)
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(
//                       Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 const Text('Analyzing ... 💫',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontStyle: FontStyle.italic,
//                   )),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageBubble(Message message) {
//     return Align(
//       alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         decoration: BoxDecoration(
//           color: message.isUser 
//               ? Theme.of(context).primaryColor 
//               : Colors.grey[200],
//           borderRadius: BorderRadius.circular(20),
//           border: !message.isUser 
//               ? Border.all(
//                   color: Theme.of(context).primaryColor.withOpacity(0.3)
//                 )
//               : null,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 5,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.75,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (!message.isUser)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 4),
//                 child: Text(
//                   'Elita-One',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Theme.of(context).primaryColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             MarkdownBody(
//               data: message.text,
//               styleSheet: MarkdownStyleSheet(
//                 p: TextStyle(
//                   color: message.isUser ? Colors.white : Colors.black87,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               DateFormat('HH:mm').format(message.timestamp),
//               style: TextStyle(
//                 fontSize: 12,
//                 color: message.isUser ? Colors.white70 : Colors.black54,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSuggestedQuestions() {
//     return Container(
//       height: 50,
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: _suggestedQuestions.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 4),
//             child: ActionChip(
//               label: Text(_suggestedQuestions[index]),
//               onPressed: () => _sendMessage(_suggestedQuestions[index]),
//               backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _questionController,
//               decoration: InputDecoration(
//                 hintText: 'Share your thoughts with me...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(24),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[100],
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 8,
//                 ),
//               ),
//               onSubmitted: _sendMessage,
//             ),
//           ),
//           const SizedBox(width: 8),
//           IconButton(
//             icon: const Icon(Icons.favorite),
//             onPressed: () => _sendMessage(_questionController.text),
//             color: Theme.of(context).primaryColor,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorBanner() {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       child: Material(
//         color: Colors.red[50],
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Row(
//             children: [
//               Icon(Icons.favorite_border, 
//                    color: Theme.of(context).primaryColor),
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   _errorMessage,
//                   style: TextStyle(
//                     color: Theme.of(context).primaryColor,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.close),
//                 onPressed: () => setState(() => _errorMessage = ''),
//                 color: Theme.of(context).primaryColor,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
 Widget _buildTypingIndicator() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? ThemeProvider.cardDark : ThemeProvider.cardLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? ThemeProvider.primaryDark : ThemeProvider.primaryLight,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? ThemeProvider.accentDark : ThemeProvider.accentLight,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Analyzing ... 💫',
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser
              ? (isDark ? ThemeProvider.primaryDark : ThemeProvider.primaryLight)
              : (isDark ? ThemeProvider.cardDark : ThemeProvider.cardLight),
          borderRadius: BorderRadius.circular(20),
          border: !message.isUser
              ? Border.all(
                  color: isDark
                      ? ThemeProvider.primaryDark.withOpacity(0.3)
                      : ThemeProvider.primaryLight.withOpacity(0.3),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'Elita-One',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? ThemeProvider.accentDark : ThemeProvider.accentLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            MarkdownBody(
              data: message.text,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: message.isUser
                      ? Colors.white
                      : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: message.isUser
                    ? Colors.white70
                    : (isDark ? Colors.white54 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedQuestions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _suggestedQuestions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ActionChip(
              label: Text(
                _suggestedQuestions[index],
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              onPressed: () => _sendMessage(_suggestedQuestions[index]),
              backgroundColor: isDark
                  ? ThemeProvider.primaryDark.withOpacity(0.2)
                  : ThemeProvider.primaryLight.withOpacity(0.1),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? ThemeProvider.cardDark : ThemeProvider.cardLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _questionController,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Share your thoughts with me...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark
                    ? ThemeProvider.backgroundDark
                    : ThemeProvider.backgroundLight,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => _sendMessage(_questionController.text),
            color: isDark ? ThemeProvider.accentDark : ThemeProvider.accentLight,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: isDark
            ? ThemeProvider.primaryDark.withOpacity(0.1)
            : ThemeProvider.primaryLight.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(
                Icons.favorite_border,
                color: isDark ? ThemeProvider.accentDark : ThemeProvider.accentLight,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _errorMessage,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _errorMessage = ''),
                color: isDark ? ThemeProvider.accentDark : ThemeProvider.accentLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class CryptocurrencyDetailsTab extends StatelessWidget {
  final Cryptocurrency cryptocurrency;
  final Map<String, dynamic> details;

  const CryptocurrencyDetailsTab({Key? key, required this.cryptocurrency, required this.details}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAllTimeHighLow(),
        const SizedBox(height: 16),
        _buildAdditionalInfo(),
      ],
    );
  }

  Widget _buildAllTimeHighLow() {
    final athDate = details['market_data']?['ath_date']?['usd'] != null
        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['ath_date']['usd']))
        : 'N/A';
    final atlDate = details['market_data']?['atl_date']?['usd'] != null
        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(details['market_data']['atl_date']['usd']))
        : 'N/A';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('All-Time High/Low', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildStatItem('All-Time High', '\$${NumberFormat("#,##0.00").format(details['market_data']?['ath']?['usd'] ?? 0)}'),
            Text('Date: $athDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
            _buildStatItem('All-Time Low', '\$${NumberFormat("#,##0.00").format(details['market_data']?['atl']?['usd'] ?? 0)}'),
            Text('Date: $atlDate', style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Additional Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildStatItem('Hashing Algorithm', details['hashing_algorithm'] ?? 'N/A'),
            _buildStatItem('Genesis Date', details['genesis_date'] ?? 'N/A'),
            _buildStatItem('Sentiment Up Votes', '${details['sentiment_votes_up_percentage']}%'),
            _buildStatItem('Sentiment Down Votes', '${details['sentiment_votes_down_percentage']}%'),
            _buildStatItem('Market Cap Rank', '#${details['market_cap_rank']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}                       