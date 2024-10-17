import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_ease/screens/details.dart';
import 'package:tour_ease/screens/tourist_site.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingScreen extends StatefulWidget {
  final TouristSite touristSite;
  const BookingScreen({super.key, required this.touristSite});

  @override
  // ignore: library_private_types_in_public_api
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late DateTime checkInDate;
  late DateTime checkOutDate;
  int guests = 1;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime.now();
    checkOutDate = DateTime.now().add(const Duration(days: 1));
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? checkInDate : checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  Future<void> _saveBookingToSupabase() async {
    try {
      await _supabase.from('tourist_site_bookings').insert({
        'tourist_site_id': widget.touristSite.id,
        'check_in_date': checkInDate.toIso8601String(),
        'check_out_date': checkOutDate.toIso8601String(),
        'guests': guests,
        'user_id': _supabase.auth.currentUser?.id
      });

      // if (response.error != null) {
      //   throw response.error!;
      // }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking Confirmed and Saved!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving booking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.touristSite.name}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  widget.touristSite.imageUrl,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.black.withOpacity(0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.touristSite.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.touristSite.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDateRow(
                    icon: Icons.calendar_today,
                    label: 'Check-in',
                    date: checkInDate,
                    onTap: () => _selectDate(context, true),
                  ),
                  const SizedBox(height: 20),
                  _buildDateRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Check-out',
                    date: checkOutDate,
                    onTap: () => _selectDate(context, false),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(Icons.person_outline),
                      const SizedBox(width: 10),
                      const Text('Guests:', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                          ),
                          controller: TextEditingController(text: guests.toString()),
                          onChanged: (value) {
                            setState(() {
                              guests = int.tryParse(value) ?? 1;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total Price:  x $guests guests',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _saveBookingToSupabase,
                    child: const Text(
                      'Confirm Booking',
                      style: TextStyle(fontSize: 18),
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

  Widget _buildDateRow({
    required IconData icon,
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(
            '$label: ${DateFormat('yyyy-MM-dd').format(date)}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}