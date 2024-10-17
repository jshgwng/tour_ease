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

class DetailScreen extends StatelessWidget {
  final TouristSite touristSite;

  const DetailScreen({super.key, required this.touristSite});

  Widget _renderTouristSiteDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(touristSite.description, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 16),
        Row(
          children: [
            const Icon(CupertinoIcons.star_fill, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              touristSite.rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  void _handleBookingPress(BuildContext context) {
    Navigator.pushNamed(
      context,
      'BookingTour',
      arguments: {'touristSite': touristSite},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              touristSite.imageUrl,
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
                    touristSite.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _renderTouristSiteDetails(),
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
                      child: const Text(
                        'Book Tour',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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