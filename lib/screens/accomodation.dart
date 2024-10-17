import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_ease/screens/details.dart';

// class Accommodation {
//   final int id;
//   final String name;
//   final String description;
//   final String image;
//   final double rating;
//   final int price;

//   Accommodation({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.image,
//     required this.rating,
//     required this.price,
//   });

//   factory Accommodation.fromJson(Map<String, dynamic> json) {
//     return Accommodation(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       image: json['imageUrl'],
//       rating: json['rating'].toDouble(),
//       price: json['price'],
//     );
//   }
// }

class AccommodationsScreen extends StatefulWidget {
  const AccommodationsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AccommodationsScreenState createState() => _AccommodationsScreenState();
}

class _AccommodationsScreenState extends State<AccommodationsScreen> {
  List<Accommodation> accommodations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAccommodations();
  }

  Future<void> fetchAccommodations() async {
        final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (kDebugMode) {
        print("No user logged in");
      }
      setState(() => isLoading = false);
      return;
    }

    setState(() => isLoading = true);

    try {
      final response =
          await Supabase.instance.client.from('accommodations').select();

      final List<dynamic> data = response;
      setState(() {
        if (kDebugMode) {
          print(data);
        }
        accommodations = data.map((site) => Accommodation.fromJson(site)).toList();
        isLoading = false;
      });
    } on PostgrestException catch (error) {
      if (kDebugMode) {
        print("Postgrest Error fetching tourist sites: ${error.message}");
      }
      setState(() => isLoading = false);
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching tourist sites: $error");
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: accommodations.length,
        itemBuilder: (context, index) {
          return AccommodationCard(
            accommodation: accommodations[index],
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: {
                  'item': accommodations[index],
                  'itemType': 'accommodation'
                },
              );
            },
          );
        },
      ),
    );
  }
}

class AccommodationCard extends StatelessWidget {
  final Accommodation accommodation;
  final VoidCallback onTap;

  const AccommodationCard({
    super.key,
    required this.accommodation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 3,
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    accommodation.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          accommodation.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          accommodation.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  accommodation.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${accommodation.price}/night',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}