import 'dart:async';

import 'package:cryptoinsight/screen.dart/CryptocurrencyChartTab.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../service.dart/AIService.dart';
import '/service.dart/json_and_others.dart';
import 'package:flutter/material.dart';

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