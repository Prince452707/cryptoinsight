import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../service.dart/json_and_others.dart';



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