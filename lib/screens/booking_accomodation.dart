import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tour_ease/screens/details.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingAccommodation extends StatefulWidget {
  final Accommodation accommodation;
  const BookingAccommodation({super.key, required this.accommodation});

  @override
  // ignore: library_private_types_in_public_api
  _BookingAccommodationState createState() => _BookingAccommodationState();
}

class _BookingAccommodationState extends State<BookingAccommodation> {
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
       await _supabase.from('accommodation_bookings').insert({
        'accommodation_id': widget.accommodation.id,
        'check_in_date': checkInDate.toIso8601String(),
        'check_out_date': checkOutDate.toIso8601String(),
        'guests': guests,
        'user_id': _supabase.auth.currentUser?.id
      });

      // if (response.error != null) {
      //   throw response.error!;
      // }

      _showBookingConfirmation();
    } catch (e) {
      _showErrorDialog('Error saving booking: $e');
    }
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Confirmed'),
          content: Text(
            'You have successfully booked ${widget.accommodation.name} for $guests guest(s) from ${DateFormat('yyyy-MM-dd').format(checkInDate)} to ${DateFormat('yyyy-MM-dd').format(checkOutDate)}.',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.accommodation.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDateSection('Check-in Date', checkInDate, true),
            const SizedBox(height: 16),
            _buildDateSection('Check-out Date', checkOutDate, false),
            const SizedBox(height: 16),
            _buildGuestsSection(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _saveBookingToSupabase,
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(String label, DateTime date, bool isCheckIn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context, isCheckIn),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(DateFormat('yyyy-MM-dd').format(date)),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Number of Guests',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          controller: TextEditingController(text: guests.toString()),
          onChanged: (value) {
            setState(() {
              guests = int.tryParse(value) ?? 1;
            });
          },
        ),
      ],
    );
  }
}