import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ImageUploadField.dart';
// Import the new image field

class HotelInformationDetailsPage extends StatefulWidget {
  @override
  _HotelInformationDetailsPageState createState() =>
      _HotelInformationDetailsPageState();
}

class _HotelInformationDetailsPageState
    extends State<HotelInformationDetailsPage> {
  final TextEditingController _accountHolderController =
  TextEditingController();
  final TextEditingController _accountNumberController =
  TextEditingController();

  File? _hotelMainImage; // Hotel Main Image
  List<File?> _hotelImages = []; // Hotel Images
  List<File?> _ownerImages = []; // Owner Images

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Information'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: _accountHolderController,
              label: 'Account Holder Name',
              hint: 'Enter account holder name',
            ),
            SizedBox(height: 12),
            _buildTextField(
              controller: _accountNumberController,
              label: 'Account Number',
              hint: 'Enter account number',
            ),
            SizedBox(height: 20),

            // Hotel Main Image
            _buildSingleImageField(
              title: "Upload Hotel Main Image",
              image: _hotelMainImage,
              onImagePick: _pickHotelMainImage,
            ),
            SizedBox(height: 20),

            // Hotel Images Grid
            ImageUploadField(
              title: "Upload Hotel Images",
              onImagesSelected: (images) {
                setState(() {
                  _hotelImages = images;
                });
              },
            ),
            SizedBox(height: 20),

            // Owner Images Grid
            ImageUploadField(
              title: "Upload Owner Images",
              onImagesSelected: (images) {
                setState(() {
                  _ownerImages = images;
                });
              },
            ),
            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: _submitDetails,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build single image picker
  Widget _buildSingleImageField({
    required String title,
    required File? image,
    required VoidCallback onImagePick,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: onImagePick,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: image == null
                ? Center(
              child: Text('Tap to upload an image',
                  style: TextStyle(color: Colors.grey)),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(image, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  // Picks a single image for Hotel Main Image
  Future<void> _pickHotelMainImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _hotelMainImage = File(pickedImage.path);
      });
    }
  }

  // Handles form submission
  void _submitDetails() {
    if (_accountHolderController.text.isEmpty ||
        _accountNumberController.text.isEmpty ||
        _hotelMainImage == null ||
        _hotelImages.isEmpty ||
        _ownerImages.isEmpty) {
      _showDialog('Error', 'Please fill all fields and upload required images.');
    } else {
      _showDialog('Success', 'Details submitted successfully!');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Helper to build text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}

