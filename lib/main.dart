import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tour_ease/screens/booking_accomodation.dart';
import 'package:tour_ease/screens/booking_tourist_site.dart';
import 'package:tour_ease/screens/create.dart';
import 'package:tour_ease/screens/details.dart';
import 'package:tour_ease/screens/home.dart';
import 'package:tour_ease/screens/login.dart';
import 'package:tour_ease/screens/profile.dart';
import 'package:tour_ease/screens/register.dart';
import 'package:tour_ease/screens/tourist_site.dart';
import 'package:tour_ease/screens/welcome.dart';
import 'package:tour_ease/screens/accomodation.dart';

late final SupabaseClient supabase;

Future<void> initializeSupabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tqtxhkaloetwjwgchnkz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRxdHhoa2Fsb2V0d2p3Z2Nobmt6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg0NjQ0OTgsImV4cCI6MjA0NDA0MDQ5OH0.BV-2UcMjVIxHo2k_FiTbE90L4Q6rPx3v5dNUy5RubWU',
  );

  supabase = Supabase.instance.client;
}

void main() async {
  await initializeSupabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tour Ease',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/create': (context) => const CreateItemScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DetailScreen(
              item: args['item'],
              itemType: args['itemType'],
            ),
          );
        }
        if (settings.name == '/bookTour') {
          final touristSite = settings.arguments as TouristSite;
          
          return MaterialPageRoute(
            builder: (context) => BookingScreen(touristSite: touristSite),
          );
        }
        if (settings.name == '/bookAccommodation') {
          final accommodation = settings.arguments as Accommodation;
          return MaterialPageRoute(
            builder: (context) => BookingAccommodation(accommodation: accommodation,),
          );
        }
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());
      },
    );
  }
}

// Add this to your WelcomeScreen, HomeScreen, and ProfileScreen
class ProtectedRoute extends StatelessWidget {
  final Widget child;

  const ProtectedRoute({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!AuthService.isLoggedIn()) {
      // If not logged in, redirect to login page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return Container(); // Return an empty container while redirecting
    }
    return child;
  }
}

class AuthService {
  static bool isLoggedIn() {
    return Supabase.instance.client.auth.currentUser != null;
  }
}
