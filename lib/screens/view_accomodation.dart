import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Accommodation {
  final int id;
  final String name;
  final String description;
  final String image;
  final double rating;
  final int price;

  Accommodation({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.rating,
    required this.price,
  });

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['imageUrl'],
      rating: json['rating'].toDouble(),
      price: json['price'],
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Accommodation accommodation;

  const DetailScreen({super.key, required this.accommodation});

  Widget _renderAccommodationDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(accommodation.description, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(CupertinoIcons.star_fill, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  accommodation.rating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text(
              '\$${accommodation.price}/night',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }

  void _handleBookingPress(BuildContext context) {
    Navigator.pushNamed(
      context,
      'BookingAccommodation',
      arguments: {'accommodation': accommodation},
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
              accommodation.image,
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
                    accommodation.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _renderAccommodationDetails(),
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
                        'Book Now',
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