import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';

import '../service.dart/AIService.dart';
import '../service.dart/api.dart';
import '../service.dart/json_and_others.dart';




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

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
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

  final List<String> _suggestedQuestions = [
    'What factors are affecting the price today?',
    'Should I invest now based on current metrics?',
    'How does it compare to other cryptocurrencies?',
    'What''s the technical analysis outlook?',
  ];

  @override
  void initState() {
    super.initState();
    fetchLiveData();
    _refreshTimer = Timer.periodic(const Duration(minutes: 2), (_) => fetchLiveData());
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcome = '''
Hello! 👋 I'm your ${widget.cryptocurrency.name} assistant. I can help you with:
• Real-time price analysis
• Market trends and predictions
• Technical analysis insights
• News impact assessment

Feel free to ask any questions or tap one of the suggested questions below!
''';
    _chatHistory.add(Message(
      text: welcome,
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _questionController.dispose();
    _scrollController.dispose();
    super.dispose();
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
      setState(() => _errorMessage = 'Unable to fetch latest data. Retrying...');
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
      
      final recentNews = liveData?['news']?.isNotEmpty == true
          ? '\nRecent news: ${(liveData!['news'] as List).take(3).map((n) => n['title']).join('; ')}'
          : '';

      final prompt = """
      Answer this question about ${widget.cryptocurrency.name} (${widget.cryptocurrency.symbol}) 
      as a knowledgeable and friendly crypto expert. Use current data as of ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}:
      
      Current Price: \$$currentPrice
      24h Change: ${priceChange24h.toStringAsFixed(2)}%
      Data Source: ${liveData?['source'] ?? 'Unknown'}
      $recentNews
      
      Question: $message
      
      Please provide a concise, friendly response with relevant data points and clear reasoning.
      """;

      final answer = await AIService.generateAIResponse(prompt);
      
      setState(() {
        _chatHistory.add(Message(
          text: answer,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isTyping = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _chatHistory.add(Message(
          text: 'Sorry, I encountered an error while processing your request. Please try again.',
          isUser: false,
          timestamp: DateTime.now(),
          status: MessageStatus.error,
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
        _buildLiveDataCard(),
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

 Widget _buildTypingIndicator() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
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
                    Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Thinking...', 
                style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: message.isUser ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MarkdownBody(
              data: message.text,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: message.isUser ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestedQuestions() {
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
              label: Text(_suggestedQuestions[index]),
              onPressed: () => _sendMessage(_suggestedQuestions[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
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
              decoration: InputDecoration(
                hintText: 'Ask about ${widget.cryptocurrency.name}...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).primaryColor,
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
            icon: const Icon(Icons.send),
            onPressed: () => _sendMessage(_questionController.text),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.red[100],
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => setState(() => _errorMessage = ''),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildLiveDataCard() {
    if (liveData == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final price = liveData!['price']?['PRICE'] ?? 
                 liveData!['price']?['current_price']?['usd'] ??
                 widget.cryptocurrency.price;
    
    final change24h = liveData!['price']?['CHANGEPCT24HOUR'] ?? 
                     liveData!['price']?['price_change_percentage_24h'] ??
                     widget.cryptocurrency.percentChange24h;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Live Data (${liveData!['source']})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: fetchLiveData,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Price: \$${price.toStringAsFixed(2)}'),
            Text('24h Change: ${change24h.toStringAsFixed(2)}%',
              style: TextStyle(
                color: change24h >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (liveData!['news']?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              const Text('Recent News:',
                style: TextStyle(fontWeight: FontWeight.bold)),
              ...List.generate(
                min(3, (liveData!['news'] as List).length),
                (index) => Text(
                  '• ${liveData!['news'][index]['title']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}