import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateItemScreen extends StatefulWidget {
  const CreateItemScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateItemScreenState createState() => _CreateItemScreenState();
}

class _CreateItemScreenState extends State<CreateItemScreen> {
  String _itemType = 'touristSite';
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ratingController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  final _supabase = Supabase.instance.client;

  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        String tableName =
            _itemType == 'touristSite' ? 'tourist_sites' : 'accommodations';

        Map<String, dynamic> newItem = {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'rating': double.parse(_ratingController.text),
          'imageUrl': _imageUrlController.text,
        };

        if (_itemType == 'accommodation') {
          newItem['price'] = double.parse(_priceController.text);
        }

        await _supabase.from(tableName).insert(newItem);

        // if (response) throw response.error!;

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${_itemType == 'touristSite' ? 'Tourist site' : 'Accommodation'} created successfully!')),
        );

        _resetForm();
      } catch (error) {
        if (kDebugMode) {
          print('Error creating item: $error');
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to create item. Please try again.')),
        );
      }
    }
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _ratingController.clear();
    _priceController.clear();
    _imageUrlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Create New ${_itemType == 'touristSite' ? 'Tourist Site' : 'Accommodation'}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _itemType,
                decoration: const InputDecoration(labelText: 'Item Type'),
                items: const [
                  DropdownMenuItem(
                      value: 'touristSite', child: Text('Tourist Site')),
                  DropdownMenuItem(
                      value: 'accommodation', child: Text('Accommodation')),
                ],
                onChanged: (value) => setState(() => _itemType = value!),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(labelText: 'Rating (1-5)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter a rating';
                  final rating = double.tryParse(value);
                  if (rating == null || rating < 1 || rating > 5) {
                    return 'Please enter a valid rating between 1 and 5';
                  }
                  return null;
                },
              ),
              if (_itemType == 'accommodation')
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a price' : null,
                ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter an image URL' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Text(
                    'Create ${_itemType == 'touristSite' ? 'Site' : 'Accommodation'}'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _ratingController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
