import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportCrimePage extends StatefulWidget {
  const ReportCrimePage({super.key});

  @override
  State<ReportCrimePage> createState() => _ReportCrimePageState();
}

class _ReportCrimePageState extends State<ReportCrimePage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _dateController.dispose();
    _subjectController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _dateController.text =
              "${pickedDate.toIso8601String().split('T')[0]} ${pickedTime.format(context)}";
        });
      }
    }
  }

  Future<void> _pickFile(bool isDarkMode) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 70,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _selectedFile = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                title: Text(
                  'Gallery',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 70,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      _selectedFile = File(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _uploadToCloudinary(File file) async {
    const cloudName = 'dqcbchzkx'; // replace with your cloud name
    const uploadPreset = 'qaltrixconnect'; // replace with your upload preset

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);
      return data['secure_url'];
    } else {
      return null;
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Submitting report...')));

    String? imageUrl;
    if (_selectedFile != null) {
      imageUrl = await _uploadToCloudinary(_selectedFile!);
      if (imageUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image.')),
        );
        return;
      }
    }

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User not logged in.')));
      return;
    }

    // Split date & time
    final dateTimeParts = _dateController.text.split(' ');
    final date = dateTimeParts.isNotEmpty ? dateTimeParts[0] : '';
    final time = dateTimeParts.length > 1 ? dateTimeParts[1] : '';

    try {
      await supabase.from('crime_reports').insert({
        'user_id': user.id,
        'subject': _subjectController.text,
        'date': date,
        'time': time,
        'location': _locationController.text,
        'description': _descriptionController.text,
        'image_url': imageUrl ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error submitting report: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final bool isDarkMode = args != null && args['isDarkMode'] == true;

    final backgroundColor = isDarkMode ? const Color(0xFF010101) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkMode
        ? Colors.grey[400]!
        : Colors.grey[700]!;
    final fieldFillColor = isDarkMode ? Colors.grey[900]! : Colors.grey.shade50;
    final borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 1,
        shadowColor: isDarkMode ? Colors.transparent : Colors.grey.shade200,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report an Incident',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              'Your submission is confidential.',
              style: TextStyle(color: secondaryTextColor, fontSize: 12),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            _buildTextFormField(
              controller: _subjectController,
              labelText: 'Subject',
              placeholder: 'Enter incident subject',
              isDarkMode: isDarkMode,
              fieldFillColor: fieldFillColor,
              borderColor: borderColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            const SizedBox(height: 24),
            _buildTextFormField(
              controller: _dateController,
              labelText: 'Date & Time',
              icon: Icons.calendar_today_outlined,
              readOnly: true,
              onTap: () => _selectDateTime(context),
              isDarkMode: isDarkMode,
              fieldFillColor: fieldFillColor,
              borderColor: borderColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            const SizedBox(height: 24),
            _buildTextFormField(
              controller: _locationController,
              labelText: 'Location',
              icon: Icons.location_on_outlined,
              placeholder: 'e.g., Street Name, City',
              isDarkMode: isDarkMode,
              fieldFillColor: fieldFillColor,
              borderColor: borderColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            const SizedBox(height: 24),
            _buildTextFormField(
              controller: _descriptionController,
              labelText: 'Description',
              placeholder: 'Provide a detailed description...',
              maxLines: 4,
              isDarkMode: isDarkMode,
              fieldFillColor: fieldFillColor,
              borderColor: borderColor,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            const SizedBox(height: 24),
            _buildFileUploadField(
              isDarkMode,
              fieldFillColor,
              borderColor,
              textColor,
            ),
            const SizedBox(height: 32),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String labelText,
    TextEditingController? controller,
    IconData? icon,
    String? placeholder,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    required bool isDarkMode,
    required Color fieldFillColor,
    required Color borderColor,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          decoration: _inputDecoration(
            hintText: placeholder,
            prefixIcon: icon,
            isDarkMode: isDarkMode,
            fillColor: fieldFillColor,
            borderColor: borderColor,
          ),
          style: TextStyle(color: textColor),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field cannot be empty';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFileUploadField(
    bool isDarkMode,
    Color fillColor,
    Color borderColor,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upload Evidence (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickFile(isDarkMode),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_file, color: textColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedFile != null
                        ? _selectedFile!.path.split('/').last
                        : 'Attach Photos or Videos',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitReport,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade600,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: const Text(
        'Submit Secure Report',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    String? hintText,
    IconData? prefixIcon,
    required bool isDarkMode,
    required Color fillColor,
    required Color borderColor,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
      ),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
            )
          : null,
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
      ),
    );
  }
}
