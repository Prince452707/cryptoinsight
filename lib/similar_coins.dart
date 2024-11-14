// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'main.dart'; // This imports the existing file

// class SimilarCryptocurrenciesScreen extends StatefulWidget {
//   final Cryptocurrency cryptocurrency;

//   const SimilarCryptocurrenciesScreen({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   _SimilarCryptocurrenciesScreenState createState() => _SimilarCryptocurrenciesScreenState();
// }

// class _SimilarCryptocurrenciesScreenState extends State<SimilarCryptocurrenciesScreen> {
//   List<Cryptocurrency> similarCryptos = [];
//   bool isLoading = true;
//   String aiComparison = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchSimilarCryptocurrencies();
//   }

//   Future<void> fetchSimilarCryptocurrencies() async {
//     setState(() => isLoading = true);
//     try {
//       // Fetch similar cryptocurrencies based on market cap
//       final response = await http.get(Uri.parse(
//           'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=10&page=1&sparkline=false'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         similarCryptos = data.map((json) => Cryptocurrency.fromJson(json)).toList();
//         similarCryptos.removeWhere((crypto) => crypto.id == widget.cryptocurrency.id);
//         similarCryptos = similarCryptos.take(5).toList(); // Limit to 5 similar cryptos
//         await generateAIComparison();
//       } else {
//         throw Exception('Failed to load similar cryptocurrencies');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> generateAIComparison() async {
//     try {
//       final model = GenerativeModel(
//         model: 'gemini-pro',
//         apiKey: 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y', // Replace with your actual API key
//       );

//       final prompt = '''
//       Compare and contrast ${widget.cryptocurrency.name} with the following cryptocurrencies:
//       ${similarCryptos.map((c) => c.name).join(', ')}.
//       Focus on their key features, use cases, market position, and technological differences.
//       Provide a concise summary of how they are similar and different.
//       ''';

//       final content = [Content.text(prompt)];
//       final response = await model.generateContent(content);

//       setState(() {
//         aiComparison = response.text ?? 'Unable to generate comparison.';
//       });
//     } catch (e) {
//       setState(() {
//         aiComparison = 'Error generating AI comparison: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Similar to ${widget.cryptocurrency.name}'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 Text(
//                   'Similar Cryptocurrencies',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 const SizedBox(height: 16),
//                 ...similarCryptos.map((crypto) => CryptocurrencyListItem(cryptocurrency: crypto)),
//                 const SizedBox(height: 24),
//                 Text(
//                   'AI-Generated Comparison',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(aiComparison),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DetailedComparisonScreen(
//                         baseCrypto: widget.cryptocurrency,
//                         similarCryptos: similarCryptos,
//                       ),
//                     ),
//                   ),
//                   child: const Text('View Detailed Comparison'),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class DetailedComparisonScreen extends StatelessWidget {
//   final Cryptocurrency baseCrypto;
//   final List<Cryptocurrency> similarCryptos;

//   const DetailedComparisonScreen({
//     Key? key,
//     required this.baseCrypto,
//     required this.similarCryptos,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detailed Comparison'),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           columns: [
//             const DataColumn(label: Text('Feature')),
//             DataColumn(label: Text(baseCrypto.name)),
//             ...similarCryptos.map((crypto) => DataColumn(label: Text(crypto.name))),
//           ],
//           rows: [
//             _buildDataRow('Price', (c) => '\$${c.price.toStringAsFixed(2)}'),
//             _buildDataRow('Market Cap', (c) => '\$${c.marketCap.toStringAsFixed(0)}'),
//             _buildDataRow('24h Volume', (c) => '\$${c.volume24h.toStringAsFixed(0)}'),
//             _buildDataRow('24h Change', (c) => '${c.percentChange24h.toStringAsFixed(2)}%'),
//             _buildDataRow('Circulating Supply', (c) => c.circulatingSupply.toStringAsFixed(0)),
//           ],
//         ),
//       ),
//     );
//   }

//   DataRow _buildDataRow(String feature, String Function(Cryptocurrency) getValue) {
//     return DataRow(
//       cells: [
//         DataCell(Text(feature)),
//         DataCell(Text(getValue(baseCrypto))),
//         ...similarCryptos.map((crypto) => DataCell(Text(getValue(crypto)))),
//       ],
//     );
//   }
// }





































// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'main.dart';

// class SimilarCryptocurrenciesScreen extends StatefulWidget {
//   final Cryptocurrency cryptocurrency;

//   const SimilarCryptocurrenciesScreen({Key? key, required this.cryptocurrency}) : super(key: key);

//   @override
//   _SimilarCryptocurrenciesScreenState createState() => _SimilarCryptocurrenciesScreenState();
// }

// class _SimilarCryptocurrenciesScreenState extends State<SimilarCryptocurrenciesScreen> {
//   List<Cryptocurrency> similarCryptos = [];
//   bool isLoading = true;
//   String aiComparison = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchSimilarCryptocurrencies();
//   }

//   Future<void> fetchSimilarCryptocurrencies() async {
//     setState(() => isLoading = true);
//     try {
//       final response = await http.get(Uri.parse(
//           'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));
//       if (response.statusCode == 200) {
//         final List<dynamic> data = json.decode(response.body);
//         List<Cryptocurrency> allCryptos = data.map((json) => Cryptocurrency.fromJson(json)).toList();
        
//         similarCryptos = allCryptos.where((crypto) => 
//           crypto.id != widget.cryptocurrency.id &&
//           (crypto.marketCap / widget.cryptocurrency.marketCap).abs() < 0.5
//         ).take(5).toList();
        
//         await generateAIComparison();
//       } else {
//         throw Exception('Failed to load similar cryptocurrencies');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> generateAIComparison() async {
//     try {
//       final model = GenerativeModel(
//         model: 'gemini-pro',
//         apiKey: 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y',
//       );

//       final prompt = '''
//       Compare ${widget.cryptocurrency.name} (Rank: ${widget.cryptocurrency.rank}) with these cryptocurrencies:
//       ${similarCryptos.map((c) => "${c.name} (Rank: ${c.rank})").join(', ')}.
//       Focus on:
//       1. Similar use cases or problem spaces they address
//       2. Technological similarities in their blockchain or consensus mechanisms
//       3. Target markets or industries they serve
//       4. Key differentiating features
//       5. How their market positions (ranks) compare and what it might indicate
//       Provide a concise summary of how they are similar in their field of operation, how they differ, and what their rankings suggest about their market positions.
//       ''';

//       final content = [Content.text(prompt)];
//       final response = await model.generateContent(content);

//       setState(() {
//         aiComparison = response.text ?? 'Unable to generate comparison.';
//       });
//     } catch (e) {
//       setState(() {
//         aiComparison = 'Error generating AI comparison: $e';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Similar to ${widget.cryptocurrency.name}'),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 Text(
//                   'Similar Cryptocurrencies',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 const SizedBox(height: 16),
//                 ...similarCryptos.map((crypto) => CryptocurrencyListItem(cryptocurrency: crypto)),
//                 const SizedBox(height: 24),
//                 Text(
//                   'AI-Generated Comparison',
//                   style: Theme.of(context).textTheme.titleLarge,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(aiComparison),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DetailedComparisonScreen(
//                         baseCrypto: widget.cryptocurrency,
//                         similarCryptos: similarCryptos,
//                       ),
//                     ),
//                   ),
//                   child: const Text('View Detailed Comparison'),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class DetailedComparisonScreen extends StatelessWidget {
//   final Cryptocurrency baseCrypto;
//   final List<Cryptocurrency> similarCryptos;

//   const DetailedComparisonScreen({
//     Key? key,
//     required this.baseCrypto,
//     required this.similarCryptos,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detailed Comparison'),
//       ),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: DataTable(
//           columns: [
//             const DataColumn(label: Text('Feature')),
//             DataColumn(label: Text(baseCrypto.name)),
//             ...similarCryptos.map((crypto) => DataColumn(label: Text(crypto.name))),
//           ],
//           rows: [
//             _buildDataRow('Price', (c) => '\$${c.price.toStringAsFixed(2)}'),
//             _buildDataRow('Market Cap', (c) => '\$${c.marketCap.toStringAsFixed(0)}'),
//             _buildDataRow('24h Volume', (c) => '\$${c.volume24h.toStringAsFixed(0)}'),
//             _buildDataRow('24h Change', (c) => '${c.percentChange24h.toStringAsFixed(2)}%'),
//             _buildDataRow('Circulating Supply', (c) => c.circulatingSupply.toStringAsFixed(0)),
//           ],
//         ),
//       ),
//     );
//   }

//   DataRow _buildDataRow(String feature, String Function(Cryptocurrency) getValue) {
//     return DataRow(
//       cells: [
//         DataCell(Text(feature)),
//         DataCell(Text(getValue(baseCrypto))),
//         ...similarCryptos.map((crypto) => DataCell(Text(getValue(crypto)))),
//       ],
//     );
//   }
// }


























import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'screen.dart/CryptocurrencyListItem.dart';
import '/service.dart/json_and_others.dart';

class SimilarCryptocurrenciesScreen extends StatefulWidget {
  final Cryptocurrency cryptocurrency;

  const SimilarCryptocurrenciesScreen({Key? key, required this.cryptocurrency}) : super(key: key);

  @override
  _SimilarCryptocurrenciesScreenState createState() => _SimilarCryptocurrenciesScreenState();
}

class _SimilarCryptocurrenciesScreenState extends State<SimilarCryptocurrenciesScreen> {
  List<Cryptocurrency> similarCryptos = [];
  bool isLoading = true;
  String aiComparison = '';

  @override
  void initState() {
    super.initState();
    fetchSimilarCryptocurrencies();
  }

  Future<void> fetchSimilarCryptocurrencies() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Cryptocurrency> allCryptos = data.map((json) => Cryptocurrency.fromJson(json)).toList();
        
        similarCryptos = allCryptos.where((crypto) => 
          crypto.id != widget.cryptocurrency.id &&
          (crypto.marketCap / widget.cryptocurrency.marketCap).abs() < 0.5
        ).take(5).toList();
        
        await generateAIComparison();
      } else {
        throw Exception('Failed to load similar cryptocurrencies');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> generateAIComparison() async {
    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y',
      );

      final prompt = '''
      Compare **${widget.cryptocurrency.name}** (Rank: ${widget.cryptocurrency.rank}) with these cryptocurrencies:
      ${similarCryptos.map((c) => "**${c.name}** (Rank: ${c.rank})").join(', ')}.
      Focus on:
      1. **Similar use cases** or problem spaces they address
      2. **Technological similarities** in their blockchain or consensus mechanisms
      3. **Target markets** or industries they serve
      4. **Key differentiating features**
      5. How their **market positions** (ranks) compare and what it might indicate
      Provide a concise summary of how they are similar in their field of operation, how they differ, and what their rankings suggest about their market positions.
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState(() {
        aiComparison = response.text ?? 'Unable to generate comparison.';
      });
    } catch (e) {
      setState(() {
        aiComparison = 'Error generating AI comparison: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Similar to ${widget.cryptocurrency.name}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Similar Cryptocurrencies',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...similarCryptos.map((crypto) => CryptocurrencyListItem(cryptocurrency: crypto)),
                const SizedBox(height: 24),
                Text(
                  'AI-Generated Comparison',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Markdown(
                  data: aiComparison,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedComparisonScreen(
                        baseCrypto: widget.cryptocurrency,
                        similarCryptos: similarCryptos,
                      ),
                    ),
                  ),
                  child: const Text('View Detailed Comparison'),
                ),
              ],
            ),
    );
  }
}

class DetailedComparisonScreen extends StatelessWidget {
  final Cryptocurrency baseCrypto;
  final List<Cryptocurrency> similarCryptos;

  const DetailedComparisonScreen({
    Key? key,
    required this.baseCrypto,
    required this.similarCryptos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Comparison'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            const DataColumn(label: Text('Feature')),
            DataColumn(label: Text(baseCrypto.name)),
            ...similarCryptos.map((crypto) => DataColumn(label: Text(crypto.name))),
          ],
          rows: [
            _buildDataRow('Price', (c) => '\$${c.price.toStringAsFixed(2)}'),
            _buildDataRow('Market Cap', (c) => '\$${c.marketCap.toStringAsFixed(0)}'),
            _buildDataRow('24h Volume', (c) => '\$${c.volume24h.toStringAsFixed(0)}'),
            _buildDataRow('24h Change', (c) => '${c.percentChange24h.toStringAsFixed(2)}%'),
            _buildDataRow('Circulating Supply', (c) => c.circulatingSupply.toStringAsFixed(0)),
          ],
        ),
      ),
    );
  }

  DataRow _buildDataRow(String feature, String Function(Cryptocurrency) getValue) {
    return DataRow(
      cells: [
        DataCell(Text(feature)),
        DataCell(Text(getValue(baseCrypto))),
        ...similarCryptos.map((crypto) => DataCell(Text(getValue(crypto)))),
      ],
    );
  }
}