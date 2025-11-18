import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grady/models/shop.dart';
import 'package:grady/screens/shop_detail.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:grady/services/auth_service.dart';
import 'dart:async';

class ShopListPage extends StatefulWidget {
  final bool showMyItemsOnly;
  
  const ShopListPage({super.key, this.showMyItemsOnly = false});

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  Future<List<Shop>> fetchShop() async {
    try {
      var url = Uri.parse('http://localhost:8000/json/');
      print('Fetching products from: $url');
      
      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json", "Accept": "application/json"},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          var data = shopListFromJson(response.body);
          print('Parsed ${data.length} products');
          
          // Debug: Print thumbnail info for each product
          for (var shop in data) {
            print('Product: ${shop.name}, Thumbnail: ${shop.thumbnail}');
          }
          
          if (widget.showMyItemsOnly) {
            // Filter to show only items from logged-in user
            final currentUsername = await AuthService.getUsername();
            print('Filtering for user: $currentUsername');
            if (currentUsername != null) {
              data = data.where((shop) => shop.userUsername == currentUsername).toList();
              print('Filtered to ${data.length} products');
            }
          }
          
          return data;
        } catch (e) {
          print('JSON parsing error: $e');
          print('Response body: ${response.body}');
          throw Exception('Failed to parse product data: $e');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.showMyItemsOnly ? 'My Products' : 'All Products',
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder(
        future: fetchShop(),
        builder: (context, AsyncSnapshot<List<Shop>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading products',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {});
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No products available',
                style: TextStyle(fontSize: 18),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Shop shop = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShopDetailPage(shop: shop),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _buildThumbnail(shop.thumbnail, 100, 100),
                          ),
                          const SizedBox(width: 16),
                          // Product info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shop.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rp ${shop.price.toString()}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  shop.category,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (shop.description.isNotEmpty)
                                  Text(
                                    shop.description.length > 50 
                                      ? '${shop.description.substring(0, 50)}...'
                                      : shop.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                if (shop.isFeatured)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Featured',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildThumbnail(String? thumbnailUrl, double width, double height) {
    if (thumbnailUrl != null && thumbnailUrl.isNotEmpty && thumbnailUrl.trim().isNotEmpty) {
      // Use Django proxy to avoid CORS issues in Flutter web
      final proxyUrl = 'http://localhost:8000/proxy/image/?url=${Uri.encodeComponent(thumbnailUrl)}';
      print('Loading thumbnail via proxy: $proxyUrl');
      
      return Image.network(
        proxyUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        headers: {
          'Accept': 'image/*',
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            print('Thumbnail loaded successfully via proxy');
            return child;
          }
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('ERROR loading thumbnail via proxy: $thumbnailUrl');
          print('Proxy URL: $proxyUrl');
          print('Error type: ${error.runtimeType}');
          print('Error details: $error');
          print('Stack trace: $stackTrace');
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported, color: Colors.grey),
          );
        },
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }
  }
}

