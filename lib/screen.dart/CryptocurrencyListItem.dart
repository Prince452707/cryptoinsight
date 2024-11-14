import 'package:flutter/material.dart';
import 'package:cryptoinsight/theme.dart';
import  'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/service.dart/json_and_others.dart';
import '/screen.dart/CryptocurrencyDetailScreen.dart';


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