import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internsharks/app/routes/app_pages.dart';
import 'package:internsharks/app/core/utils/app_colors.dart';
import 'package:internsharks/core/const_file/app_text_style.dart';

class ProfilePage extends StatefulWidget {
  final bool showBack;
   const ProfilePage({super.key, this.showBack=false});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController(text: 'Vishva');
  final TextEditingController phoneController = TextEditingController(text: '+91 6356789890');
  final TextEditingController emailController = TextEditingController(text: 'sureshs12@gmail.com');

  bool isEditing = false;

  String? _profileImagePath;

  // -------------------- IMAGE PICK + CROP LOGIC --------------------
  Future<void> _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();

    // Bottom sheet open
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => SizedBox(
        height: 140,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text("Camera", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text("Gallery", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    // Crop image
    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );

    if (cropped != null) {
      setState(() {
        _profileImagePath = cropped.path;
      });
    }
  }

  // --------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.appColor,
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/assets/images/login_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ---------------- HEADER ----------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (widget.showBack) // <-- only show when true
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 25),
                        onPressed: () => Navigator.pop(context),
                      ),

                    const SizedBox(width: 5),

                    const Text(
                      'Profile',
                      style: AppTextStyles.yellow24Bold,
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(isEditing ? Icons.check : Icons.edit, color: Colors.red, size: 28),
                  onPressed: () {
                    setState(() => isEditing = !isEditing);
                    if (!isEditing) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ---------------- BODY ----------------
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ------------- PROFILE IMAGE ----------------
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: _profileImagePath == null
                                    ? const NetworkImage(
                                    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400')
                                    : FileImage(File(_profileImagePath!)) as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          if (isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickProfileImage,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00CED1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt, color: Colors.black, size: 20),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ---------------- NAME FIELD ----------------
                    _buildField("Name", Icons.person_outline, nameController),

                    const SizedBox(height: 24),

                    // ---------------- PHONE FIELD ----------------
                    _buildField("Mobile Number", Icons.phone_outlined, phoneController),

                    const SizedBox(height: 24),

                    // ---------------- EMAIL FIELD ----------------
                    _buildField("Email Address", Icons.email_outlined, emailController),

                    const SizedBox(height: 40),

                    // ---------------- MANAGE RESUME ----------------
                    if (isEditing!=true)
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.manageResumePage,

                        );

                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1c2121),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: const Color(0xFF3A3A3A)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.description_outlined,
                                color: Color(0xFF00CED1), size: 28),
                            SizedBox(width: 16),
                            Text(
                              'Manage Resume',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------- FIELD BUILDER ---------------------
  Widget _buildField(String title, IconData icon, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFF1c2121),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFF3A3A3A)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.appBlue, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: isEditing,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
