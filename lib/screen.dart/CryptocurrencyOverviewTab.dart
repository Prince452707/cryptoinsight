import 'package:cryptoinsight/service.dart/json_and_others.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';




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
