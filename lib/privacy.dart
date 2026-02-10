import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
          'Privacy Policy',
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
            'Qaltrix ("us", "we", or "our") operates the Qaltrix mobile application (the "Service"). This page informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service.',
            secondaryTextColor,
          ),
          _buildSectionHeader('1. Information Collection and Use', textColor),
          _buildParagraph(
            'We collect several different types of information for various purposes to provide and improve our Service to you. This may include, but is not limited to, your email address, name, and usage data.',
            secondaryTextColor,
          ),
          _buildSectionHeader('2. Use of Data', textColor),
          _buildParagraph(
            'Qaltrix uses the collected data for various purposes: to provide and maintain the Service, to notify you about changes to our Service, to provide customer care and support, and to monitor the usage of the Service.',
            secondaryTextColor,
          ),
          _buildSectionHeader('3. Security of Data', textColor),
          _buildParagraph(
            'The security of your data is important to us, but remember that no method of transmission over the Internet or method of electronic storage is 100% secure. While we strive to use commercially acceptable means to protect your Personal Data, we cannot guarantee its absolute security.',
            secondaryTextColor,
          ),
          _buildSectionHeader("4. Children's Privacy", textColor),
          _buildParagraph(
            'Our Service does not address anyone under the age of 13 ("Children"). We do not knowingly collect personally identifiable information from anyone under the age of 13.',
            secondaryTextColor,
          ),
          _buildSectionHeader('5. Changes to This Privacy Policy', textColor),
          _buildParagraph(
            'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.',
            secondaryTextColor,
          ),
          _buildSectionHeader('6. Contact Us', textColor),
          _buildParagraph(
            'If you have any questions about this Privacy Policy, please contact us at qaltrix0@gmail.com.',
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
