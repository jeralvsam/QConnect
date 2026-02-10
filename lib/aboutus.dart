import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final bool isDarkMode = args != null && args['isDarkMode'] == true;
    final backgroundColor = isDarkMode
        ? const Color(0xFF010101)
        : Colors.grey[50];
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          // 1. Header Section
          Text(
            'QALTRIX',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Where Innovation Meets Play',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'We are a creative studio dedicated to crafting unforgettable digital experiences. From captivating mobile games to intuitive, life-enhancing applications, we turn bold ideas into reality.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: secondaryTextColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // 2. Qaltrix Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/Qaltrix.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 40),

          // 3. Our Story Section
          _buildSectionHeader('Our Story', textColor),
          const SizedBox(height: 16),
          Text(
            'Founded in 2025, Qaltrix started with a simple mission: to build apps and games that matter. We saw a world full of digital noise and wanted to create products with purpose, quality, and a touch of magic. Our journey began in a small office with a big dream, and has since grown into a passionate team of creators, thinkers, and innovators.',
            style: TextStyle(
              fontSize: 16,
              color: secondaryTextColor,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),

          // 4. What We Create Section
          _buildSectionHeader('What We Create', textColor),
          const SizedBox(height: 24),
          _buildServiceCard(
            icon: Icons.phone_android,
            title: 'Application Development',
            description:
                'We design and build beautiful, high-performance mobile and web applications that solve real-world problems and provide seamless user experiences.',
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildServiceCard(
            icon: Icons.gamepad_outlined,
            title: 'Game Development',
            description:
                'Our team creates immersive and engaging games for various platforms. We focus on compelling storytelling, stunning visuals, and addictive gameplay.',
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 40),

          // 5. Meet Our Team Section
          _buildSectionHeader('Meet Our Team', textColor),
          const SizedBox(height: 24),
          _buildTeamGrid(isDarkMode, textColor, secondaryTextColor),
          const SizedBox(height: 60),

          // 6. Footer
          Text(
            '© 2025 Qaltrix. All rights reserved.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: secondaryTextColor),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Section Header Widget
  static Widget _buildSectionHeader(String title, Color textColor) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  // Service Card Widget
  static Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue.shade600, size: 32),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Team Grid Widget
  static Widget _buildTeamGrid(
    bool isDarkMode,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final teamMembers = [
      {
        'name': 'Jeral V Sam',
        'position': 'Founder & Developer',
        'image': 'assets/jeral.jpg',
      },
      {
        'name': 'Emmanuel J Joseph',
        'position': 'Founder & Managing Director',
        'image': 'assets/emmanuel.jpg', // ✅ Added Emmanuel's image
      },
      {
        'name': 'Unni Adharsh',
        'position': 'Graphic Designer & Social Media Handler',
        'image': 'assets/unni.jpg',
      },
      {
        'name': 'Joyan Prakash',
        'position': 'Social Media Analyst',
        'image': 'assets/joyan.jpg',
      },
      {'name': 'Suryadev', 'position': 'Beta Tester', 'image': null},
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 24.0,
      runSpacing: 24.0,
      children: teamMembers.map((member) {
        return _buildTeamMember(
          name: member['name']!,
          position: member['position']!,
          image: member['image'],
          isDarkMode: isDarkMode,
          textColor: textColor,
          secondaryTextColor: secondaryTextColor,
        );
      }).toList(),
    );
  }

  // Team Member Widget
  static Widget _buildTeamMember({
    required String name,
    required String position,
    String? image,
    required bool isDarkMode,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return SizedBox(
      width: 120,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: isDarkMode
                ? const Color(0xFF1A1A1A)
                : Colors.grey[200],
            backgroundImage: image != null
                ? AssetImage(image) as ImageProvider
                : null,
            child: image == null
                ? Icon(
                    Icons.person,
                    size: 40,
                    color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                  )
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            position,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: secondaryTextColor),
          ),
        ],
      ),
    );
  }
}
