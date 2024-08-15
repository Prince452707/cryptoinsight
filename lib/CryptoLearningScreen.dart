// import 'package:flutter/material.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'dart:async';


// class CryptoLearningAIScreen extends StatefulWidget {
//   @override
//   _CryptoLearningAIScreenState createState() => _CryptoLearningAIScreenState();
// }

// class _CryptoLearningAIScreenState extends State<CryptoLearningAIScreen> {
//   static const String apiKey = 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y'; 
//   final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

//   final List<LearningTopic> allTopics = [
//     LearningTopic('Tokenomics', 'The economics of cryptocurrencies and token distribution'),
//     LearningTopic('Blockchain Technology', 'The foundation of cryptocurrencies and decentralized systems'),
//     LearningTopic('DeFi (Decentralized Finance)', 'Financial services built on blockchain technology'),
//     LearningTopic('NFTs (Non-Fungible Tokens)', 'Unique digital assets and their applications'),
//     LearningTopic('Crypto Trading Strategies', 'Advanced techniques for trading cryptocurrencies'),
//     LearningTopic('Consensus Mechanisms', 'Different methods for achieving agreement in blockchain networks'),
//     LearningTopic('Crypto Regulation and Compliance', 'Legal aspects and regulatory frameworks for cryptocurrencies'),
//     LearningTopic('Layer 2 Solutions', 'Scaling solutions for blockchain networks'),
//     LearningTopic('Crypto Wallets', 'Secure storage solutions for digital assets'),
//     LearningTopic('Smart Contracts', 'Self-executing contracts with the terms directly written into code'),
//     LearningTopic('Interoperability', 'Communication and asset transfer between different blockchain networks'),
//     LearningTopic('Yield Farming', 'Strategies to maximize returns in DeFi protocols'),
//     LearningTopic('Crypto Taxation', 'Tax implications and reporting for cryptocurrency transactions'),
//     LearningTopic('Privacy Coins', 'Cryptocurrencies focused on enhancing transaction privacy'),
//     LearningTopic('DAOs (Decentralized Autonomous Organizations)', 'Blockchain-based organizational structures'),
//   ];

//   List<LearningTopic> displayedTopics = [];
//   TextEditingController searchController = TextEditingController();
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     displayedTopics = List.from(allTopics);
//     searchController.addListener(_onSearchChanged);
//   }

//   @override
//   void dispose() {
//     searchController.removeListener(_onSearchChanged);
//     searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       if (searchController.text.isEmpty) {
//         setState(() => displayedTopics = List.from(allTopics));
//       } else {
//         setState(() {
//           displayedTopics = allTopics
//               .where((topic) =>
//                   topic.title.toLowerCase().contains(searchController.text.toLowerCase()) ||
//                   topic.description.toLowerCase().contains(searchController.text.toLowerCase()))
//               .toList();
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AI-Powered Crypto Learning'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 labelText: 'Search Topics',
//                 hintText: 'Enter a keyword',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: displayedTopics.isEmpty
//                 ? Center(child: Text('No topics found'))
//                 : ListView.builder(
//                     itemCount: displayedTopics.length,
//                     itemBuilder: (context, index) {
//                       return _buildLearningTopicCard(displayedTopics[index]);
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLearningTopicCard(LearningTopic topic) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: ExpansionTile(
//         title: Text(topic.title, style: TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(topic.description),
//         children: [
//           FutureBuilder<String>(
//             future: _generateContent(topic),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               } else if (snapshot.hasError) {
//                 return Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Text('Error: ${snapshot.error}'),
//                 );
//               } else {
//                 return Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(snapshot.data ?? 'No content available'),
//                       SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () => _launchDetailedLearning(context, topic),
//                         child: Text('Learn More'),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<String> _generateContent(LearningTopic topic) async {
//     try {
//       final content = [
//         Content.text('Provide a brief overview of ${topic.title} in the context of cryptocurrencies. '
//             'Include 3-4 key points and their importance. '
//             'The explanation should be concise and suitable for someone with basic knowledge of cryptocurrencies.')
//       ];
//       final response = await model.generateContent(content);
//       return response.text ?? 'No content generated';
//     } catch (e) {
//       return 'Error generating content: $e';
//     }
//   }

//   void _launchDetailedLearning(BuildContext context, LearningTopic topic) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DetailedLearningScreen(topic: topic, model: model),
//       ),
//     );
//   }
// }

// class DetailedLearningScreen extends StatelessWidget {
//   final LearningTopic topic;
//   final GenerativeModel model;

//   DetailedLearningScreen({required this.topic, required this.model});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(topic.title),
//       ),
//       body: FutureBuilder<String>(
//         future: _generateDetailedContent(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(topic.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 8),
//                   Text(topic.description, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
//                   SizedBox(height: 16),
//                   Text(snapshot.data ?? 'No content available'),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<String> _generateDetailedContent() async {
//     try {
//       final content = [
//         Content.text('Provide a comprehensive explanation of ${topic.title} in the context of cryptocurrencies. '
//             'Include the following sections:\n'
//             '1. Introduction\n'
//             '2. Key Concepts\n'
//             '3. Importance in the Crypto Ecosystem\n'
//             '4. Real-world Applications\n'
//             '5. Challenges and Limitations\n'
//             '6. Future Outlook\n'
//             'The explanation should be detailed and suitable for someone looking to gain in-depth knowledge about this topic.')
//       ];
//       final response = await model.generateContent(content);
//       return response.text ?? 'No content generated';
//     } catch (e) {
//       return 'Error generating content: $e';
//     }
//   }
// }

// class LearningTopic {
//   final String title;
//   final String description;

//   LearningTopic(this.title, this.description);
// }















// import 'package:flutter/material.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

// class CryptoLearningAIScreen extends StatefulWidget {
//   @override
//   _CryptoLearningAIScreenState createState() => _CryptoLearningAIScreenState();
// }

// class _CryptoLearningAIScreenState extends State<CryptoLearningAIScreen> {
//   static const String apiKey = 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y'; 
//   final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

//   List<LearningTopic> allTopics = [];
//   List<LearningTopic> displayedTopics = [];
//   TextEditingController searchController = TextEditingController();
//   Timer? _debounce;
//   List<String> searchHistory = [];
//   bool isAdvancedSearch = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadTopics();
//     searchController.addListener(_onSearchChanged);
//     _loadSearchHistory();
//   }

//   @override
//   void dispose() {
//     searchController.removeListener(_onSearchChanged);
//     searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   Future<void> _loadTopics() async {
//     allTopics = await _generateRandomTopics(15);
//     setState(() {
//       displayedTopics = List.from(allTopics);
//     });
//   }

//   Future<List<LearningTopic>> _generateRandomTopics(int count) async {
//     List<LearningTopic> topics = [];
//     for (int i = 0; i < count; i++) {
//       topics.add(LearningTopic(
//         'Topic ${i + 1}',
//         'Description for Topic ${i + 1}',
//         keywords: ['keyword1', 'keyword2', 'keyword3'],
//       ));
//     }
//     return topics;
//   }

//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       _performSearch(searchController.text);
//     });
//   }

//   void _performSearch(String query) {
//     if (query.isEmpty) {
//       setState(() => displayedTopics = List.from(allTopics));
//     } else {
//       setState(() {
//         displayedTopics = allTopics.where((topic) {
//           if (isAdvancedSearch) {
//             return _advancedSearch(topic, query);
//           } else {
//             return topic.title.toLowerCase().contains(query.toLowerCase()) ||
//                    topic.description.toLowerCase().contains(query.toLowerCase());
//           }
//         }).toList();
//       });
//     }
//     _addToSearchHistory(query);
//   }

//   bool _advancedSearch(LearningTopic topic, String query) {
//     final queryParts = query.toLowerCase().split(' ');
//     return queryParts.every((part) =>
//         topic.title.toLowerCase().contains(part) ||
//         topic.description.toLowerCase().contains(part) ||
//         topic.keywords.any((keyword) => keyword.toLowerCase().contains(part)));
//   }

//   Future<void> _loadSearchHistory() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       searchHistory = prefs.getStringList('searchHistory') ?? [];
//     });
//   }

//   Future<void> _addToSearchHistory(String query) async {
//     if (query.isNotEmpty && !searchHistory.contains(query)) {
//       setState(() {
//         searchHistory.insert(0, query);
//         if (searchHistory.length > 10) searchHistory.removeLast();
//       });
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setStringList('searchHistory', searchHistory);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AI-Powered Crypto Learning'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.history),
//             onPressed: _showSearchHistory,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       labelText: 'Search Topics',
//                       hintText: 'Enter keywords',
//                       prefixIcon: Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       isAdvancedSearch = !isAdvancedSearch;
//                     });
//                     _performSearch(searchController.text);
//                   },
//                   child: Text(isAdvancedSearch ? 'Simple' : 'Advanced'),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: displayedTopics.isEmpty
//                 ? Center(child: Text('No topics found'))
//                 : ListView.builder(
//                     itemCount: displayedTopics.length,
//                     itemBuilder: (context, index) {
//                       return _buildLearningTopicCard(displayedTopics[index]);
//                     },
//                   ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLearningTopicCard(LearningTopic topic) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       child: ExpansionTile(
//         title: Text(topic.title, style: TextStyle(fontWeight: FontWeight.bold)),
//         subtitle: Text(topic.description),
//         children: [
//           FutureBuilder<String>(
//             future: _generateContent(topic),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               } else if (snapshot.hasError) {
//                 return Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Text('Error: ${snapshot.error}'),
//                 );
//               } else {
//                 return Padding(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       MarkdownBody(data: snapshot.data ?? 'No content available'),
//                       SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () => _launchDetailedLearning(context, topic),
//                             child: Text('Learn More'),
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.share),
//                             onPressed: () => _shareTopic(topic),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Future<String> _generateContent(LearningTopic topic) async {
//     try {
//       final content = [
//         Content.text('Provide a brief overview of ${topic.title} in the context of cryptocurrencies. '
//             'Include 3-4 key points and their importance. '
//             'The explanation should be concise and suitable for someone with basic knowledge of cryptocurrencies. '
//             'Use Markdown formatting for better readability.')
//       ];
//       final response = await model.generateContent(content);
//       return response.text ?? 'No content generated';
//     } catch (e) {
//       return 'Error generating content: $e';
//     }
//   }

//   void _launchDetailedLearning(BuildContext context, LearningTopic topic) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DetailedLearningScreen(topic: topic, model: model),
//       ),
//     );
//   }

//   void _shareTopic(LearningTopic topic) {
//     print('Sharing topic: ${topic.title}');
//   }

//   void _showSearchHistory() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return ListView.builder(
//           itemCount: searchHistory.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(searchHistory[index]),
//               onTap: () {
//                 searchController.text = searchHistory[index];
//                 _performSearch(searchHistory[index]);
//                 Navigator.pop(context);
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class DetailedLearningScreen extends StatelessWidget {
//   final LearningTopic topic;
//   final GenerativeModel model;

//   DetailedLearningScreen({required this.topic, required this.model});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(topic.title),
//       ),
//       body: FutureBuilder<String>(
//         future: _generateDetailedContent(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             return SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(topic.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 8),
//                   Text(topic.description, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
//                   SizedBox(height: 16),
//                   MarkdownBody(data: snapshot.data ?? 'No content available'),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () => _startQuiz(context),
//                     child: Text('Take a Quiz'),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<String> _generateDetailedContent() async {
//     try {
//       final content = [
//         Content.text('Provide a comprehensive explanation of ${topic.title} in the context of cryptocurrencies. '
//             'Include the following sections:\n'
//             '1. Introduction\n'
//             '2. Key Concepts\n'
//             '3. Importance in the Crypto Ecosystem\n'
//             '4. Real-world Applications\n'
//             '5. Challenges and Limitations\n'
//             '6. Future Outlook\n'
//             'The explanation should be detailed and suitable for someone looking to gain in-depth knowledge about this topic. '
//             'Use Markdown formatting for better readability, including headers, bullet points, and emphasis where appropriate.')
//       ];
//       final response = await model.generateContent(content);
//       return response.text ?? 'No content generated';
//     } catch (e) {
//       return 'Error generating content: $e';
//     }
//   }

//   void _startQuiz(BuildContext context) {
//     print('Starting quiz for: ${topic.title}');
//   }
// }

// class LearningTopic {
//   final String title;
//   final String description;
//   final List<String> keywords;

//   LearningTopic(this.title, this.description, {this.keywords = const []});
// }



































































import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class CryptoLearningScreen extends StatefulWidget {
  @override
  _CryptoLearningScreenState createState() => _CryptoLearningScreenState();
}

class _CryptoLearningScreenState extends State<CryptoLearningScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  String _searchQuery = '';
  String _aiResponse = '';
  bool _isLoading = false;
  List<String> _bookmarks = [];
  List<String> _history = [];
  Map<String, List<String>> _categories = {
    'Basics': ['Blockchain', 'Cryptocurrency', 'Bitcoin', 'Ethereum'],
    'Advanced': ['Smart Contracts', 'DeFi', 'NFTs', 'Layer 2'],
    'Trading': ['Exchanges', 'Market Analysis', 'Trading Strategies'],
    'Technology': ['Consensus Mechanisms', 'Cryptography', 'Scalability'],
    'Economics': ['Tokenomics', 'Market Cap', 'Inflation'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBookmarksAndHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarksAndHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _bookmarks = prefs.getStringList('bookmarks') ?? [];
      _history = prefs.getStringList('history') ?? [];
    });
  }

  Future<void> _saveBookmarksAndHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('bookmarks', _bookmarks);
    await prefs.setStringList('history', _history);
  }

  Future<void> _generateAIResponse(String prompt) async {
    setState(() {
      _isLoading = true;
      _aiResponse = '';
    });

    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: 'AIzaSyALPelkD_VVKoYNVzk1XuKadvpDayOQw1Y', // Replace with your actual Gemini API key
      );

      final content = [
        Content.text(
          'Provide a comprehensive explanation about the following cryptocurrency topic: $prompt. '
          'Include key concepts, real-world applications, advantages, disadvantages, and current trends. '
          'Mention some popular projects or platforms related to this topic. '
          'Format the response using Markdown, including headers, bullet points, and emphasis where appropriate. '
          'If relevant, include code snippets or examples.'
        )
      ];

      final response = await model.generateContent(content);

      setState(() {
        _aiResponse = response.text ?? 'No response generated';
        _isLoading = false;
      });

      // Add to history
      if (!_history.contains(prompt)) {
        _history.insert(0, prompt);
        if (_history.length > 20) _history.removeLast();
        _saveBookmarksAndHistory();
      }

      // Scroll to the top of the response
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } catch (e) {
      setState(() {
        _aiResponse = 'Error generating response: $e';
        _isLoading = false;
      });
    }
  }

  void _toggleBookmark(String topic) {
    setState(() {
      if (_bookmarks.contains(topic)) {
        _bookmarks.remove(topic);
      } else {
        _bookmarks.add(topic);
      }
      _saveBookmarksAndHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Learning'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Learn'),
            Tab(text: 'Bookmarks'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLearnTab(),
          _buildBookmarksTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildLearnTab() {
    return Column(
      children: [
        _buildSearchBar(),
        Expanded(
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildBookmarksTab() {
    return ListView.builder(
      itemCount: _bookmarks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_bookmarks[index]),
          onTap: () {
            _searchController.text = _bookmarks[index];
            _generateAIResponse(_bookmarks[index]);
            _tabController.animateTo(0);
          },
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _toggleBookmark(_bookmarks[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      itemCount: _history.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_history[index]),
          onTap: () {
            _searchController.text = _history[index];
            _generateAIResponse(_history[index]);
            _tabController.animateTo(0);
          },
        );
      },
    );
  }
  Widget _buildSearchBar() {
  final TextTheme textTheme = Theme.of(context).textTheme;
  final ColorScheme colorScheme = Theme.of(context).colorScheme;

  return Container(
    padding: EdgeInsets.all(16),
    color: Theme.of(context).primaryColor,
    child: Column(
      children: [
        TextField(
          controller: _searchController,
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Search cryptocurrency topics...',
            hintStyle: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
            fillColor: colorScheme.surface,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: colorScheme.onSurface),
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  _generateAIResponse(_searchController.text);
                }
              },
            ),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _generateAIResponse(value);
            }
          },
        ),
        SizedBox(height: 16),
        _buildCategoryTabs(),
      ],
    ),
  );
}

  // Widget _buildSearchBar() {
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     color: Theme.of(context).primaryColor,
  //     child: Column(
  //       children: [
  //         TextField(
  //           controller: _searchController,
  //           decoration: InputDecoration(
  //             hintText: 'Search cryptocurrency topics...',
  //             fillColor: Colors.white,
  //             filled: true,
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(30),
  //               borderSide: BorderSide.none,
  //             ),
  //             suffixIcon: IconButton(
  //               icon: Icon(Icons.search),
  //               onPressed: () {
  //                 if (_searchController.text.isNotEmpty) {
  //                   _generateAIResponse(_searchController.text);
  //                 }
  //               },
  //             ),
  //           ),
  //           onSubmitted: (value) {
  //             if (value.isNotEmpty) {
  //               _generateAIResponse(value);
  //             }
  //           },
  //         ),
  //         SizedBox(height: 16),
  //         _buildCategoryTabs(),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildCategoryTabs() {
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _categories.keys.map((category) {
          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () {
                _showCategoryTopics(category);
              },
              child: Text(category),
              style: ElevatedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor, backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showCategoryTopics(String category) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _categories[category]!.length,
          itemBuilder: (context, index) {
            final topic = _categories[category]![index];
            return ListTile(
              title: Text(topic),
              onTap: () {
                Navigator.pop(context);
                _searchController.text = topic;
                _generateAIResponse(topic);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (_aiResponse.isNotEmpty) {
      return SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _searchController.text,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    _bookmarks.contains(_searchController.text) ? Icons.bookmark : Icons.bookmark_border,
                  ),
                  onPressed: () => _toggleBookmark(_searchController.text),
                ),
              ],
            ),
            SizedBox(height: 16),
            MarkdownBody(
              data: _aiResponse,
              onTapLink: (text, url, title) {
                if (url != null) {
                  launchUrl(Uri.parse(url));
                }
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _generateAIResponse(_searchController.text + " Provide more advanced information on this topic.");
                  },
                  child: Text('Learn More'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _generateAIResponse(_searchController.text + " Give me a practical example or use case.");
                  },
                  child: Text('Practical Example'),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Search for a cryptocurrency topic to start learning',
              style: TextStyle(fontSize: 18, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
}