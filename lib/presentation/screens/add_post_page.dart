import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/core/utils/app_colors.dart';

class AddPostPage extends StatefulWidget {
  const AddPostPage({super.key});

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? selectedFile; // Holds the selected image/GIF
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        selectedFile = File(pickedFile.path);
      });
    }
  }

  void _savePost() {
    final String title = titleController.text.trim();
    final String description = descriptionController.text.trim();

    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image or GIF.")),
      );
      return;
    }

    if (title.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and description cannot be empty.")),
      );
      return;
    }

    // Save the post to your backend or local state here
    // print("Title: $title");
    // print("Description: $description");
    // print("File Path: ${selectedFile!.path}");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Post added successfully!")),
    );

    Navigator.pop(context); // Return to the previous screen
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.inputBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.inputBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Add Post",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Selected Image/GIF:",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              selectedFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.file(
                        selectedFile!,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Text("No image or GIF selected"),
                      ),
                    ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.photo_library),
                      label: Text(
                        "Gallery",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        iconColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text("Camera"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Text("Caption"),
              const SizedBox(
                height: 8,
              ),
              _buildTextField(
                  "Enter Catchy Caption for your post", titleController),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _savePost,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 16.0),
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "Save Post",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
