import 'package:flutter/material.dart';
import 'package:grady/menu.dart';

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
  String _selectedCategory = 'General';
  bool _isFeatured = false;

  final List<String> _categories = [
    'General',
    'Transfer News',
    'Match Reports',
    'Player News',
    'Club News',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold menyediakan struktur dasar halaman dengan AppBar dan body.
    return Scaffold(
      // AppBar adalah bagian atas halaman yang menampilkan judul.
      appBar: AppBar(
        // Judul aplikasi "Add New News" dengan teks hijau dan tebal.
        title: const Text(
          'Add New News',
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
                  'Add New Football News',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              // Input field untuk nama/title news.
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'News Title',
                    hintText: 'Enter the news title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'News title cannot be empty';
                    }
                    if (value.length < 3) {
                      return 'News title must be at least 3 characters';
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
                    hintText: 'Enter the news description',
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
                    if (value.length < 10) {
                      return 'Description must be at least 10 characters';
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
                    labelText: 'Thumbnail URL',
                    hintText: 'Enter the thumbnail image URL',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: const Icon(Icons.image),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Thumbnail URL cannot be empty';
                    }
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.hasScheme) {
                      return 'Please enter a valid URL';
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
              // Switch untuk featured news.
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SwitchListTile(
                  title: const Text('Featured News'),
                  subtitle: const Text('Mark this news as featured'),
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showDataDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Save',
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

  // Method untuk menampilkan dialog dengan data form.
  void _showDataDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'News Data',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDialogRow('Title', _nameController.text),
                _buildDialogRow('Price', 'Rp ${_priceController.text}'),
                _buildDialogRow('Description', _descriptionController.text),
                _buildDialogRow('Thumbnail URL', _thumbnailController.text),
                _buildDialogRow('Category', _selectedCategory),
                _buildDialogRow('Featured', _isFeatured ? 'Yes' : 'No'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog first
                Navigator.pop(context);
                // Then redirect to home page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ),
                );
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Method untuk membuat row di dialog.
  Widget _buildDialogRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
