import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final bool isDarkMode = args != null && args['isDarkMode'] == true;
    final backgroundColor = isDarkMode ? const Color(0xFF010101) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      // 1. Header AppBar
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 1,
        shadowColor: isDarkMode ? Colors.transparent : Colors.grey.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Terms of Service',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        titleSpacing: 0,
      ),
      // 2. Main Content
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            'Last updated: August 27, 2025',
            style: TextStyle(fontSize: 14, color: secondaryTextColor),
          ),
          const SizedBox(height: 16),
          _buildParagraph(
            'Please read these Terms of Service ("Terms", "Terms of Service") carefully before using the Qaltrix mobile application (the "Service") operated by Qaltrix ("us", "we", or "our").',
            secondaryTextColor,
          ),
          _buildSectionHeader('1. Introduction', textColor),
          _buildParagraph(
            'Your access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users, and others who access or use the Service.',
            secondaryTextColor,
          ),
          _buildSectionHeader('2. User Accounts', textColor),
          _buildParagraph(
            'When you create an account with us, you must provide us with information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of your account on our Service.',
            secondaryTextColor,
          ),
          _buildSectionHeader('3. Content', textColor),
          _buildParagraph(
            'Our Service allows you to post, link, store, share and otherwise make available certain information, text, graphics, videos, or other material ("Content"). You are responsible for the Content that you post to the Service, including its legality, reliability, and appropriateness.',
            secondaryTextColor,
          ),
          _buildSectionHeader('4. Termination', textColor),
          _buildParagraph(
            'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
            secondaryTextColor,
          ),
          _buildSectionHeader('5. Changes to Terms', textColor),
          _buildParagraph(
            "We reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material we will try to provide at least 30 days' notice prior to any new terms taking effect.",
            secondaryTextColor,
          ),
          _buildSectionHeader('6. Contact Us', textColor),
          _buildParagraph(
            'If you have any questions about these Terms, please contact us at qaltrix0@gmail.com.',
            secondaryTextColor,
          ),
        ],
      ),
    );
  }

  // Helper widget for section headers
  Widget _buildSectionHeader(String title, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  // Helper widget for paragraphs
  Widget _buildParagraph(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, color: textColor, height: 1.6),
      ),
    );
  }
}
