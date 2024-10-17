import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  Map<String, String> _profile = {
    'photo': 'https://images.pexels.com/photos/6626882/pexels-photo-6626882.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'name': 'John Doe',
    'email': 'johndoe@example.com',
    'password': '********',
  };
  late Map<String, String> _newProfile;

  @override
  void initState() {
    super.initState();
    _newProfile = Map.from(_profile);
  }

  void _handleEdit() {
    setState(() {
      _isEditing = true;
    });
  }

  void _handleSave() {
    setState(() {
      _profile = Map.from(_newProfile);
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  void _handleCancel() {
    setState(() {
      _newProfile = Map.from(_profile);
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPhotoSection(),
            _buildInfoSection(),
            _buildButtonSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 75,
            backgroundImage: NetworkImage(_profile['photo']!),
          ),
          if (_isEditing)
            TextButton(
              onPressed: () {
                // Implement photo change functionality
              },
              child: const Text(
                'Change Photo',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildInfoRow('Name', 'name'),
          _buildInfoRow('Email', 'email'),
          _buildInfoRow('Password', 'password', isPassword: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String key, {bool isPassword = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        _isEditing
            ? Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TextField(
              obscureText: isPassword,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
              ),
              onChanged: (value) => _newProfile[key] = value,
              controller: TextEditingController(text: _newProfile[key]),
            ),
          ),
        )
            : Text(
          _profile[key]!,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildButtonSection() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: _isEditing
          ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Save'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _handleCancel,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Cancel'),
          ),
        ],
      )
          : ElevatedButton.icon(
        onPressed: _handleEdit,
        icon: const Icon(Icons.edit),
        label: const Text('Edit Profile'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
      ),
    );
  }
}