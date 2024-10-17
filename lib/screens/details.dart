import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TouristSite {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;

  TouristSite({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
  });

  factory TouristSite.fromJson(Map<String, dynamic> json) {
    return TouristSite(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
    );
  }
}

class Accommodation {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int price;

  Accommodation({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.price,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      price: json['price'],
    );
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic item;
  final String itemType;

  const DetailScreen({super.key, required this.item, required this.itemType});

  Widget _renderDetails() {
    if (itemType == 'touristSite') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.description, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(CupertinoIcons.star_fill, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                item.rating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      );
    } else if (itemType == 'accommodation') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.description, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(CupertinoIcons.star_fill, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    item.rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '\$${item.price}/night',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        ],
      );
    }
    return const SizedBox.shrink(); // Return an empty widget if itemType is neither
  }

  void _handleBookingPress(BuildContext context) {
    if (itemType == 'touristSite') {
      Navigator.pushNamed(
        context,
        '/bookTour',
        arguments:  item,
      );
    } else if (itemType == 'accommodation') {
      Navigator.pushNamed(
        context,
        '/bookAccommodation',
        arguments:  item,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details"),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              itemType == 'touristSite' ? item.imageUrl : item.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _renderDetails(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _handleBookingPress(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        itemType == 'touristSite' ? 'Book Tour' : 'Book Now',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}