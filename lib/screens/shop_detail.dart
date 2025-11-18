import 'package:flutter/material.dart';
import 'package:grady/models/shop.dart';

class ShopDetailPage extends StatelessWidget {
  final Shop shop;

  const ShopDetailPage({super.key, required this.shop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[300],
              child: _buildThumbnail(shop.thumbnail),
            ),
            // Product details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (shop.isFeatured)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Featured',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Rp ${shop.price.toString()}',
                    style: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildDetailRow('Category', shop.category),
                  const SizedBox(height: 12),
                  _buildDetailRow('Size', shop.size.toString()),
                  const SizedBox(height: 12),
                  _buildDetailRow('Stock', shop.stock.toString()),
                  if (shop.released != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow('Released', shop.released!),
                  ],
                  if (shop.userUsername != null) ...[
                    const SizedBox(height: 12),
                    _buildDetailRow('Seller', shop.userUsername!),
                  ],
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    shop.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Back to List'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(String? thumbnailUrl) {
    if (thumbnailUrl != null && thumbnailUrl.isNotEmpty && thumbnailUrl.trim().isNotEmpty) {
      // Use Django proxy to avoid CORS issues in Flutter web
      final proxyUrl = 'http://localhost:8000/proxy/image/?url=${Uri.encodeComponent(thumbnailUrl)}';
      
      return Image.network(
        proxyUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 300,
            width: double.infinity,
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
          print('Error loading thumbnail via proxy: $thumbnailUrl');
          return const Center(
            child: Icon(
              Icons.image_not_supported,
              size: 64,
              color: Colors.grey,
            ),
          );
        },
      );
    } else {
      return const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 64,
          color: Colors.grey,
        ),
      );
    }
  }
}

