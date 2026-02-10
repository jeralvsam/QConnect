import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isDarkMode = false;
  VoidCallback toggleTheme = () {};

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _closePersonController = TextEditingController();

  bool _isLoadingData = true;
  bool _dataUpdated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      isDarkMode = args['isDarkMode'] ?? false;
      toggleTheme = args['toggleTheme'] ?? () {};
    }
    _loadProfileImage();
    _fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _closePersonController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profile_pic.png');
    if (await file.exists()) {
      setState(() => _profileImage = file);
    } else {
      setState(() => _profileImage = null);
    }
  }

  Future<void> _saveProfileImage(File image) async {
    final dir = await getApplicationDocumentsDirectory();
    final localImage = await image.copy('${dir.path}/profile_pic.png');
    setState(() => _profileImage = localImage);
    _dataUpdated = true;
  }

  Future<void> _removeProfileImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/profile_pic.png');
    if (await file.exists()) await file.delete();
    setState(() => _profileImage = null);
    _dataUpdated = true;
  }

  Future<void> _fetchUserData() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    if (user != null) {
      final response = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      if (response != null) {
        setState(() {
          _nameController.text = response['name'] ?? '';
          _emailController.text = response['email'] ?? '';
          _addressController.text = response['address'] ?? '';
          _phoneController.text = response['phone'] ?? '';
          _closePersonController.text = response['close_person'] ?? '';
        });
      }
    }
    setState(() => _isLoadingData = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      final updates = {
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': _phoneController.text.trim(),
        'close_person': _closePersonController.text.trim(),
      };

      final response = await supabase
          .from('users')
          .update(updates)
          .eq('id', user.id)
          .select();

      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        _dataUpdated = true;
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile.')),
        );
      }
    }
  }

  Future<void> _pickImageOptions() async {
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
                  if (pickedFile != null)
                    await _saveProfileImage(File(pickedFile.path));
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
                  if (pickedFile != null)
                    await _saveProfileImage(File(pickedFile.path));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remove Profile Picture',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _removeProfileImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final fillColor = isDarkMode ? Colors.grey[900]! : Colors.grey[100]!;
    final defaultIconColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
    final defaultIconBg = isDarkMode ? Colors.grey[800]! : Colors.grey[300]!;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(_dataUpdated),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoadingData
          ? Center(
              child: CircularProgressIndicator(color: Colors.blue.shade600),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 64,
                          backgroundColor: defaultIconBg,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : null,
                          child: _profileImage == null
                              ? Icon(
                                  Icons.person,
                                  size: 64,
                                  color: defaultIconColor,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickImageOptions,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 4, color: textColor),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                color: Colors.blue.shade600,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextFormField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    icon: Icons.person_outline,
                    textColor: textColor,
                    fillColor: fillColor,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email_outlined,
                    textColor: textColor,
                    fillColor: fillColor,
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _addressController,
                    labelText: 'Address',
                    icon: Icons.location_on_outlined,
                    textColor: textColor,
                    fillColor: fillColor,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _phoneController,
                    labelText: 'Phone Number',
                    icon: Icons.phone_outlined,
                    textColor: textColor,
                    fillColor: fillColor,
                  ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: _closePersonController,
                    labelText: 'Close Person',
                    icon: Icons.group_outlined,
                    textColor: textColor,
                    fillColor: fillColor,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required Color textColor,
    required Color fillColor,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey.shade600),
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: (value) => (value == null || value.isEmpty)
              ? 'This field cannot be empty'
              : null,
        ),
      ],
    );
  }
}
