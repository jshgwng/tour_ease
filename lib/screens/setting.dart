import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile {
  final String? fullName;
  final String? email;
  final String? avatarUrl;

  Profile({this.fullName, this.email, this.avatarUrl});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      fullName: json['full_name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String language = 'English';
  bool notificationsEnabled = true;
  Profile? profile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
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
      print(user);
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .single();

      final data = response;
      setState(() {
        if (kDebugMode) {
          print(data);
        }
        profile = Profile.fromJson(data);
        // accommodations =
        //     data.map((site) => Accommodation.fromJson(site)).toList();
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

  void handleLogout() async {
    await Supabase.instance.client.auth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacementNamed('/welcome');
  }

  void handleCreatePress() {
    Navigator.of(context).pushNamed('/create');
  }

  @override
  Widget build(BuildContext context) {
        if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      profile?.avatarUrl ??
                          'https://images.pexels.com/photos/6626882/pexels-photo-6626882.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    profile?.fullName ?? "John Doe",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    profile?.email ?? "johndoe@example.com",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Edit Profile'),
                    onTap: () => Navigator.of(context).pushNamed('/profile'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.language_outlined),
                    title: Text('Language: $language'),
                    trailing: ElevatedButton(
                      child: const Text('Change'),
                      onPressed: () {
                        // Implement language change logic
                      },
                    ),
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_outlined),
                    title: const Text('Notifications'),
                    value: notificationsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        notificationsEnabled = value;
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline),
                    title: const Text('Add Location/Accommodation'),
                    onTap: handleCreatePress,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.redAccent,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: handleLogout,
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
