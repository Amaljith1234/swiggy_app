import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageUploadField extends StatefulWidget {
  final String title; // Title for the image grid
  final int maxImageCount; // Maximum number of images
  final Function(List<File>) onImagesSelected; // Callback to return selected images

  const ImageUploadField({
    Key? key,
    required this.title,
    this.maxImageCount = 4,
    required this.onImagesSelected,
  }) : super(key: key);

  @override
  _ImageUploadFieldState createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  final List<File> _selectedImages = [];

  // Pick image and update the list
  Future<void> _pickImage() async {
    if (_selectedImages.length >= widget.maxImageCount) return;

    final ImagePicker picker = ImagePicker();
    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
      widget.onImagesSelected(_selectedImages);
    }
  }

  // Remove image
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
    widget.onImagesSelected(_selectedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            // Image slots
            ...List.generate(
              widget.maxImageCount,
                  (index) {
                if (index < _selectedImages.length) {
                  return _buildImageTile(_selectedImages[index], index);
                } else {
                  return _buildAddImageTile();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  // Widget to display selected image with remove option
  Widget _buildImageTile(File imageFile, int index) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      width: 60, // Reduced width
      height: 60, // Reduced height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: FileImage(imageFile),
          fit: BoxFit.cover,
        ),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: GestureDetector(
          onTap: () => _removeImage(index),
          child: Icon(Icons.cancel, color: Colors.red, size: 18),
        ),
      ),
    );
  }

  // Widget for empty slots (add button)
  Widget _buildAddImageTile() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        margin: EdgeInsets.only(right: 8),
        width: 72, // Reduced width
        height: 72, // Reduced height
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
