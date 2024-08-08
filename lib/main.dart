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
          },
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  static const Color _primaryDark = Color(0xFF6200EA);
  static const Color _primaryLight = Color(0xFF3F51B5);
  static const Color _accentDark = Color(0xFFFF4081);
  static const Color _accentLight = Color(0xFFFF9800);
  static const Color _backgroundDark = Color(0xFF121212);
  static const Color _backgroundLight = Color(0xFFF5F5F5);
  static const Color _cardDark = Color(0xFF1E1E1E);
  static const Color _cardLight = Color(0xFFFFFFFF);

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: _primaryDark,
    scaffoldBackgroundColor: _backgroundDark,
    cardColor: _cardDark,
    colorScheme: const ColorScheme.dark(
      primary: _primaryDark,
      secondary: _accentDark,
      surface: _cardDark,
      background: _backgroundDark,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
      bodyMedium: TextStyle(color: Colors.white70, fontFamily: 'Roboto'),
      displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: _accentDark,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(color: _accentDark),
  );

  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _primaryLight,
    scaffoldBackgroundColor: _backgroundLight,
    cardColor: _cardLight,
    colorScheme: const ColorScheme.light(
      primary: _primaryLight,
      secondary: _accentLight,
      surface: _cardLight,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontFamily: 'Roboto'),
      bodyMedium: TextStyle(color: Colors.black54, fontFamily: 'Roboto'),
      displayLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      labelLarge: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: _accentLight,
      textTheme: ButtonTextTheme.primary,
    ),
    iconTheme: const IconThemeData(color: _accentLight),
  );

  late ThemeData _currentTheme;

  ThemeProvider() {
    _currentTheme = _darkTheme;
  }

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

  void toggleTheme() {
    _currentTheme = isDarkMode ? _lightTheme : _darkTheme;
    notifyListeners();
  }

  void setDarkMode() {
    _currentTheme = _darkTheme;
    notifyListeners();
  }

  void setLightMode() {
    _currentTheme = _lightTheme;
    notifyListeners();
  }
}

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

class ApiService {
  static const List<String> baseUrls = [
    'https://api.coingecko.com/api/v3',
    'https://api.coingecko.com/api/v3',
    'https://api.coingecko.com/api/v3',
  ];
  static const Duration rateLimitDuration = Duration(milliseconds: 500);
  static const int maxRetries = 5;
  static final Random _random = Random();
  static DateTime _lastRequestTime = DateTime.now();

  static Future<void> _respectRateLimit() async {
    final now = DateTime.now();
    final timeSinceLastRequest = now.difference(_lastRequestTime);
    if (timeSinceLastRequest < rateLimitDuration) {
      await Future.delayed(rateLimitDuration - timeSinceLastRequest);
    }
    _lastRequestTime = DateTime.now();
  }

  static Future<dynamic> _getRequest(String endpoint, {int retryCount = 0}) async {
    await _respectRateLimit();
    await ThrottleService.throttle(endpoint);
    
    final cachedData = await CacheService.getCache(endpoint);
    if (cachedData != null) {
      return json.decode(cachedData);
    }

    final baseUrlIndex = _random.nextInt(baseUrls.length);
    try {
      final response = await http.get(Uri.parse('${baseUrls[baseUrlIndex]}$endpoint'));
      if (response.statusCode == 200) {
        await CacheService.setCache(endpoint, response.body);
        return json.decode(response.body);
      } else if (response.statusCode == 429 && retryCount < maxRetries) {
        final retryDelay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
        await Future.delayed(retryDelay);
        return _getRequest(endpoint, retryCount: retryCount + 1);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      if (retryCount < maxRetries) {
        final delay = Duration(milliseconds: pow(2, retryCount).toInt() * 1000);
        await Future.delayed(delay);
        return _getRequest(endpoint, retryCount: retryCount + 1);
      } else {
        rethrow;
      }
    }
  }

  static Future<List<Cryptocurrency>> getCryptocurrencies({int page = 1, int perPage = 100}) async {
    final cacheKey = 'cryptocurrencies_$page$perPage';
    final cachedData = await CacheService.getCache(cacheKey);
    if (cachedData != null) {
      return (json.decode(cachedData) as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
    }

    final data = await _getRequest('/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$perPage&page=$page&sparkline=false');
    await CacheService.setCache(cacheKey, json.encode(data));
    return (data as List).map<Cryptocurrency>((json) => Cryptocurrency.fromJson(json)).toList();
  }

  static Future<Map<String, dynamic>> getCryptocurrencyDetails(String id) async {
    return await _getRequest('/coins/$id?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false');
  }

  static Future<Cryptocurrency?> getSearchedCryptocurrency(String query) async {
    final data = await _getRequest('/search?query=$query');
    final coins = data['coins'] as List;
    
    if (coins.isEmpty) {
      return null;
    }

    final firstCoin = coins.first;
    try {
      final detailData = await getCryptocurrencyDetails(firstCoin['id']);
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

  static Future<List<List<dynamic>>> getMarketChart(String id, int days) async {
    final data = await _getRequest('/coins/$id/market_chart?vs_currency=usd&days=$days');
    return List<List<dynamic>>.from(data['prices']);
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
  bool isChartLoading = true;
  List<FlSpot> priceData = [];
  int selectedChartDays = 7;
  Map<String, String> aiAnalysis = {
    'general': 'Loading...',
    'news': 'Loading...',
    'fundamental': 'Loading...',
    'team': 'Loading...',
  };
  String aiQuestion = '';
  String aiAnswer = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _scrollController = ScrollController();
    fetchDetails();
    fetchComprehensiveAnalysis();
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
      fetchMarketChart();
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackbar('Failed to fetch cryptocurrency details');
    }
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
      _showErrorSnackbar('Failed to fetch market chart data');
    }
  }

  Future<void> fetchComprehensiveAnalysis() async {
    try {
      final analysis = await AIService.generateComprehensiveAnalysis(widget.cryptocurrency);
      setState(() {
        aiAnalysis = analysis;
      });
    } catch (e) {
      _showErrorSnackbar('Failed to fetch AI analysis');
    }
  }
  Future<void> askAIQuestion() async {
  if (aiQuestion.isEmpty) return;

  setState(() => aiAnswer = 'Loading...');

  try {
    // Use the latest details from the WebSocket connection
    final response = await AIService.generateAIResponse(
      "Answer this question about ${details['name']} (${details['symbol']}) as of ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}: $aiQuestion"
    );
    setState(() => aiAnswer = response);
  } catch (e) {
    setState(() => aiAnswer = 'Failed to get AI response');
  }
}

  // Future<void> askAIQuestion() async {
  //   if (aiQuestion.isEmpty) return;
  //   setState(() => aiAnswer = 'Loading...');
  //   try {
  //     final answer = await AIService.generateAIResponse(
  //       "Answer this question about ${widget.cryptocurrency.name}: $aiQuestion"
  //     );
  //     setState(() => aiAnswer = answer);
  //   } catch (e) {
  //     setState(() => aiAnswer = 'Failed to get AI response');
  //   }
  // }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
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
                        _buildOverviewTab(),
                        _buildChartTab(),
                        _buildAIInsightsTab(),
                        _buildAIQATab(),
                        _buildDetailsTab(),
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

  Widget _buildOverviewTab() {
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

  Widget _buildChartTab() {
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

  Widget _buildAIInsightsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAIInsights(),
      ],
    );
  }

  Widget _buildAIInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('AI Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildAIInsightCard('General Analysis', aiAnalysis['general']!),
        _buildAIInsightCard('Latest News', aiAnalysis['news']!),
        _buildAIInsightCard('Fundamental Analysis', aiAnalysis['fundamental']!),
        _buildAIInsightCard('Team Details', aiAnalysis['team']!),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: fetchComprehensiveAnalysis,
          child: const Text('Refresh AI Insights'),
        ),
      ],
    );
  }

  Widget _buildAIInsightCard(String title, String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(content),
          ),
        ],
      ),
    );
  }

  Widget _buildAIQATab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ask AI about this Cryptocurrency', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => setState(() => aiQuestion = value),
            decoration: InputDecoration(
              hintText: 'Enter your question here',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: askAIQuestion,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('AI Answer:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(aiAnswer),
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildAllTimeHighLow(),
        const SizedBox(height: 16),
        _buildAdditionalInfo(),
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
            _buildStatItem('Market Cap', '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.marketCap)}'),
            _buildStatItem('24h Volume', '\$${NumberFormat("#,##0.00").format(widget.cryptocurrency.volume24h)}'),
            _buildStatItem('Circulating Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.circulatingSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
            if (widget.cryptocurrency.totalSupply != null)
              _buildStatItem('Total Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.totalSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
            if (widget.cryptocurrency.maxSupply != null)
              _buildStatItem('Max Supply', '${NumberFormat("#,##0.00").format(widget.cryptocurrency.maxSupply)} ${widget.cryptocurrency.symbol.toUpperCase()}'),
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
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      _showErrorSnackbar('Could not launch $url');
    }
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
}
