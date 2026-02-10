import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatefulWidget {
  const HelpAndSupportPage({super.key});

  @override
  State<HelpAndSupportPage> createState() => _HelpAndSupportPageState();
}

late bool isDarkMode;
late VoidCallback toggleTheme;

class _HelpAndSupportPageState extends State<HelpAndSupportPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    isDarkMode = args['isDarkMode'];
    toggleTheme = args['toggleTheme'];
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDarkMode
        ? const Color(0xFF010101)
        : Colors.grey[50];
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[600]!;
    final cardColor = isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          // Header
          Text(
            'Help & Support',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We're here to help you with anything you need.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: secondaryTextColor),
          ),
          const SizedBox(height: 40),

          // FAQ Section
          _buildSectionHeader('Frequently Asked Questions', textColor),
          const SizedBox(height: 16),
          _buildFaqTile(
            'How do I reset my password?',
            cardColor,
            textColor,
            secondaryTextColor,
            answer:
                '1. Go to the login screen of the app.\n'
                '2. Tap "Forgot Password?" below the password field.\n'
                '3. Enter your registered email or phone number.\n'
                '4. Check your email or SMS for a password reset link or code.\n'
                '5. Follow the link or enter the code to create a new password.\n'
                '6. Login using your new password.\n\n'
                'Tip: Check your spam/junk folder if you don’t see the email, and choose a strong password you haven’t used before.',
          ),
          const SizedBox(height: 12),
          _buildFaqTile(
            'How can I update my profile information?',
            cardColor,
            textColor,
            secondaryTextColor,
            answer:
                '1. Open the app and go to the Profile page.\n'
                '2. Tap "Edit Profile".\n'
                '3. Update your information like name, email, or phone number.\n'
                '4. Tap "Save" to apply the changes.\n\n'
                'Your profile will be updated immediately in the app.',
          ),
          const SizedBox(height: 12),
          _buildFaqTile(
            'Is my data secure?',
            cardColor,
            textColor,
            secondaryTextColor,
            answer:
                'Yes! We take your privacy and data security seriously. All sensitive data is encrypted and stored securely on our servers. '
                'We follow best practices to ensure your information remains protected.',
          ),
          const SizedBox(height: 40),

          // Contact Us Section
          _buildSectionHeader('Contact Us', textColor),
          const SizedBox(height: 16),
          _buildContactTile(
            icon: Icons.email_outlined,
            title: 'Email Us',
            subtitle: 'qaltrix0@gmail.com',
            onTap: () {},
            cardColor: cardColor,
            titleColor: textColor,
            subtitleColor: secondaryTextColor,
            arrowColor: secondaryTextColor,
          ),
          const SizedBox(height: 12),
          /*_buildContactTile(
            icon: Icons.phone_outlined,
            title: 'Call Us',
            subtitle: '8590372314',
            onTap: () {},
            cardColor: cardColor,
            titleColor: textColor,
            subtitleColor: secondaryTextColor,
            arrowColor: secondaryTextColor,
          ),*/
          const SizedBox(height: 60),

          // Footer
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

  Widget _buildSectionHeader(String title, Color textColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }

  Widget _buildFaqTile(
    String question,
    Color cardColor,
    Color textColor,
    Color subtitleColor, {
    String answer =
        'Here you can provide a detailed answer to the frequently asked question. This content will be shown when the user expands the tile.',
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(fontWeight: FontWeight.w600, color: textColor),
        ),
        backgroundColor: cardColor,
        collapsedBackgroundColor: cardColor,
        children: <Widget>[
          Container(
            color: cardColor,
            padding: const EdgeInsets.all(16.0),
            child: Text(answer, style: TextStyle(color: subtitleColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color cardColor,
    required Color titleColor,
    required Color subtitleColor,
    required Color arrowColor,
  }) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue.shade600, size: 28),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: subtitleColor),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, size: 16, color: arrowColor),
            ],
          ),
        ),
      ),
    );
  }
}
