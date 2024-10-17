import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Add functionality if needed
                      },
                      child: Image.asset(
                        "assets/earth-icon.png",
                        width: 120,
                        height: 120,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Discover Uganda with Ease',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Your Adventure, Our Guide!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildGradientButton(
                        context,
                        'Login',
                        [const Color(0xFFFF7043), const Color(0xFFFF5722)],
                            () => Navigator.pushNamed(context, '/login'),
                      ),
                      const SizedBox(height: 15),
                      _buildGradientButton(
                        context,
                        'Register',
                        [const Color(0xFF4CAF50), const Color(0xFF45a049)],
                            () => Navigator.pushNamed(context, '/register'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton(
      BuildContext context,
      String text,
      List<Color> colors,
      VoidCallback onPressed,
      ) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}