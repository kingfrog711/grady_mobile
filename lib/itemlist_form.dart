import 'package:flutter/material.dart';
import 'package:grady/screens/menu.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemListFormPage extends StatefulWidget {
  const ItemListFormPage({super.key});

  @override
  State<ItemListFormPage> createState() => _ItemListFormPageState();
}

class _ItemListFormPageState extends State<ItemListFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController();
  final _sizeController = TextEditingController();
  final _stockController = TextEditingController();
  String _selectedCategory = 'jersey';
  bool _isFeatured = false;
  bool _isLoading = false;

  final List<String> _categories = [
    'jersey',
    'shoes',
    'ball',
    'accessories',
    'equipment',
    'fan_merch',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    _sizeController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _publishProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = context.read<CookieRequest>();
      
      // Prepare data
      // Parse price - handle both integer and decimal input
      int priceValue;
      try {
        final priceDouble = double.tryParse(_priceController.text.replaceAll(',', '').trim());
        if (priceDouble == null) {
          throw Exception('Invalid price format');
        }
        priceValue = priceDouble.round(); // Round to nearest integer
      } catch (e) {
        throw Exception('Price must be a valid number');
      }
      
      // Parse size and stock
      int sizeValue = 0;
      if (_sizeController.text.isNotEmpty) {
        final sizeDouble = double.tryParse(_sizeController.text.replaceAll(',', '').trim());
        sizeValue = sizeDouble?.round() ?? 0;
      }
      
      int stockValue = 0;
      if (_stockController.text.isNotEmpty) {
        final stockDouble = double.tryParse(_stockController.text.replaceAll(',', '').trim());
        stockValue = stockDouble?.round() ?? 0;
      }
      
      // Convert all values to strings for CookieRequest.post() compatibility
      // CookieRequest might send as form data which expects strings
      final productData = <String, dynamic>{
        'name': _nameController.text,
        'price': priceValue.toString(),
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'is_featured': _isFeatured.toString(),
        'size': sizeValue.toString(),
        'stock': stockValue.toString(),
      };
      
      // Only include thumbnail if it's not empty (Django URLField doesn't accept empty strings)
      if (_thumbnailController.text.isNotEmpty) {
        productData['thumbnail'] = _thumbnailController.text;
      }

      print('Publishing product: $productData');

      // Send POST request to Django
      final response = await request.post(
        "http://localhost:8000/publish_product_ajax/",
        productData,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timed out');
        },
      );

      print('Publish response: $response');

      if (response['status'] == 'success' || response['status'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Product published successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Clear form
          _formKey.currentState!.reset();
          _nameController.clear();
          _priceController.clear();
          _descriptionController.clear();
          _thumbnailController.clear();
          _sizeController.clear();
          _stockController.clear();
          _selectedCategory = 'jersey';
          _isFeatured = false;
          
          // Navigate back to home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
            ),
          );
        }
      } else {
        if (mounted) {
          String errorMessage = 'Failed to publish product';
          if (response['error'] != null) {
            if (response['error'] is Map) {
              errorMessage = (response['error'] as Map).values
                  .expand((e) => e is List ? e : [e])
                  .join(', ');
            } else {
              errorMessage = response['error'].toString();
            }
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Error publishing product: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur dasar halaman dengan AppBar dan body.
    return Scaffold(
        // AppBar adalah bagian atas halaman yang menampilkan judul.
      appBar: AppBar(
        // Judul aplikasi "Publish Product" dengan teks hijau dan tebal.
        title: const Text(
          'Publish Product',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Warna latar belakang AppBar diambil dari skema warna tema aplikasi.
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      // Body halaman dengan form untuk menambahkan news baru.
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // Padding di sekeliling form.
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Judul form dengan padding di bawah.
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Publish New Product',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              // Input field untuk nama/title product.
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    hintText: 'Enter the product name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Product name cannot be empty';
                    }
                    if (value.length < 3) {
                      return 'Product name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
              ),
              // Input field untuk price.
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter the price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Price cannot be empty';
                    }
                    final price = double.tryParse(value);
                    if (price == null) {
                      return 'Price must be a valid number';
                    }
                    if (price < 0) {
                      return 'Price cannot be negative';
                    }
                    return null;
                  },
                ),
              ),
              // Input field untuk description.
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter the product description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 5,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Description cannot be empty';
                    }
                    if (value.length < 5) {
                      return 'Description must be at least 5 characters';
                    }
                    return null;
                  },
                ),
              ),
              // Input field untuk thumbnail URL.
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: _thumbnailController,
                  decoration: InputDecoration(
                    labelText: 'Thumbnail URL (Optional)',
                    hintText: 'Enter the thumbnail image URL',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.image),
                  ),
                  validator: (String? value) {
                    if (value != null && value.isNotEmpty) {
                      final uri = Uri.tryParse(value);
                      if (uri == null || !uri.hasScheme) {
                        return 'Please enter a valid URL';
                      }
                    }
                    return null;
                  },
                ),
              ),
              // Dropdown untuk category.
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Category cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              // Input field untuk size.
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: _sizeController,
                  decoration: InputDecoration(
                    labelText: 'Size',
                    hintText: 'Enter the size',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.straighten),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value != null && value.isNotEmpty) {
                      final size = int.tryParse(value);
                      if (size == null) {
                        return 'Size must be a valid number';
                      }
                      if (size < 0) {
                        return 'Size cannot be negative';
                      }
                    }
                    return null;
                  },
                ),
              ),
              // Input field untuk stock.
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: _stockController,
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    hintText: 'Enter the stock quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.inventory),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value != null && value.isNotEmpty) {
                      final stock = int.tryParse(value);
                      if (stock == null) {
                        return 'Stock must be a valid number';
                      }
                      if (stock < 0) {
                        return 'Stock cannot be negative';
                      }
                    }
                    return null;
                  },
                ),
              ),
              // Switch untuk featured news.
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SwitchListTile(
                  title: const Text('Featured Product'),
                  subtitle: const Text('Mark this product as featured'),
                  value: _isFeatured,
                  onChanged: (bool value) {
                    setState(() {
                      _isFeatured = value;
                    });
                  },
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                  activeThumbColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              // Tombol Save untuk menyimpan data form.
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _publishProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Publish Product',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

}
