import 'package:cryptoinsight/screen.dart/CryptocurrencyOverviewTab.dart';
import 'package:cryptoinsight/service.dart/json_and_others.dart';
import 'package:flutter/material.dart';
import '/service.dart/api.dart';
import '/similar_coins.dart';
import  'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

import 'AIInsightsTab.dart';
import 'CryptocurrencyChartTab.dart';
import 'CryptocurrencyDetailsTab.dart';
import 'aiQ&A.dart';




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