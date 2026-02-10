import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:telephony/telephony.dart';

class SOSService {
  static final SupabaseClient supabase = Supabase.instance.client;
  static final Telephony telephony = Telephony.instance;

  static Future<void> triggerSOS(
    BuildContext context, {
    required bool isDarkMode,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _LoadingDialog(
        isDarkMode: isDarkMode,
        message: 'Requesting permissions...',
      ),
    );

    try {
      // 1️⃣ Request location permission
      if (!await Permission.location.isGranted) {
        final locStatus = await Permission.location.request();
        if (!locStatus.isGranted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return;
        }
      }

      // 2️⃣ Request SMS permission
      if (!await Permission.sms.isGranted) {
        final smsStatus = await Permission.sms.request();
        if (!smsStatus.isGranted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('SMS permission denied')),
          );
          return;
        }
      }

      // 3️⃣ Update loading
      _LoadingDialog.updateMessage(context, 'Fetching number...');

      // 4️⃣ Get logged-in user
      final user = supabase.auth.currentUser;
      if (user == null) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not logged in')));
        return;
      }

      // 5️⃣ Fetch close_person number from Supabase
      final response = await supabase
          .from('users')
          .select('close_person')
          .eq('id', user.id)
          .maybeSingle();

      final closePersonNumber = response?['close_person'] as String?;
      if (closePersonNumber == null || closePersonNumber.isEmpty) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No close person number found')),
        );
        return;
      }

      // 6️⃣ Update loading
      _LoadingDialog.updateMessage(context, 'Fetching location...');

      // 7️⃣ Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String locationUrl =
          'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

      // 8️⃣ Update loading
      _LoadingDialog.updateMessage(context, 'Sending SOS message...');

      // 9️⃣ Send SMS automatically
      await telephony.sendSms(
        to: closePersonNumber,
        message: "Help! I'm in trouble. My location: $locationUrl",
      );

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SOS message sent successfully')),
      );
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send SOS: $e')));
    }
  }
}

/// Loading dialog widget
class _LoadingDialog extends StatefulWidget {
  final bool isDarkMode;
  final String message;

  const _LoadingDialog({
    super.key,
    required this.isDarkMode,
    required this.message,
  });

  static void updateMessage(BuildContext context, String newMessage) {
    final state = context.findAncestorStateOfType<_LoadingDialogState>();
    state?.updateMessage(newMessage);
  }

  @override
  State<_LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<_LoadingDialog> {
  late String message;

  @override
  void initState() {
    super.initState();
    message = widget.message;
  }

  void updateMessage(String newMessage) {
    if (mounted) {
      setState(() {
        message = newMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.isDarkMode ? Colors.grey[900] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: widget.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
