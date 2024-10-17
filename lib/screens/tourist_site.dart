import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_ease/screens/details.dart';

// class TouristSite {
//   final int id;
//   final String name;
//   final String description;
//   final String imageUrl;
//   final double rating;

//   TouristSite({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.imageUrl,
//     required this.rating,
//   });

//   factory TouristSite.fromJson(Map<String, dynamic> json) {
//     return TouristSite(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       imageUrl: json['imageUrl'],
//       rating: json['rating'].toDouble(),
//     );
//   }
// }

class TouristSitesScreen extends StatefulWidget {
  const TouristSitesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TouristSitesScreenState createState() => _TouristSitesScreenState();
}

class _TouristSitesScreenState extends State<TouristSitesScreen> {
  List<TouristSite> touristSites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTouristSites();
  }

  Future<void> fetchTouristSites() async {
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
          await Supabase.instance.client.from('tourist_sites').select();

      final List<dynamic> data = response;
      setState(() {
        print(data);
        touristSites = data.map((site) => TouristSite.fromJson(site)).toList();
        isLoading = false;
      });
    } on PostgrestException catch (error) {
      if (kDebugMode) {
        print("Postgrest Error fetching tourist sites: ${error.message}");
      }
      setState(() => isLoading = false);
    } catch (error) {
      print("Error fetching tourist sites: $error");
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
        itemCount: touristSites.length,
        itemBuilder: (context, index) {
          return TouristSiteCard(
            site: touristSites[index],
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: {
                  'item': touristSites[index], // your TouristSite object
                  'itemType': 'touristSite',
                },
              );
            },
          );
        },
      ),
    );
  }
}

class TouristSiteCard extends StatelessWidget {
  final TouristSite site;
  final VoidCallback onTap;

  const TouristSiteCard({
    super.key,
    required this.site,
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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    site.imageUrl,
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
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6)
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          site.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          site.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              site.rating.toStringAsFixed(1),
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
