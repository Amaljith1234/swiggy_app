import 'package:flutter/material.dart';
import 'package:swiggy_app/Utils/Network_Utils.dart';

class BankDetailsPage extends StatefulWidget {
  @override
  _BankDetailsPageState createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
  final TextEditingController _bankdetailsaccountnameController = TextEditingController();
  final TextEditingController _bankdetailsaccountnumberController = TextEditingController();
  final TextEditingController _bankdetailsbanknameController = TextEditingController();
  final TextEditingController _bankdetailsifscCodeController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Bank Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Bank Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  controller: _bankdetailsaccountnameController,
                  label: 'Account Holder Name',
                  hint: 'Enter account holder name'),
              const SizedBox(height: 12),
              _buildTextField(
                  controller: _bankdetailsaccountnumberController,
                  label: 'Account Number',
                  hint: 'Enter account number'),
              const SizedBox(height: 12),
              _buildTextField(
                  controller: _bankdetailsbanknameController,
                  label: 'Bank Name',
                  hint: 'Enter bank name'),
              const SizedBox(height: 12),
              _buildTextField(
                  controller: _bankdetailsifscCodeController,
                  label: 'IFSC Code',
                  hint: 'Enter IFSC code',
                  textCapitalization: TextCapitalization.characters),
              const SizedBox(height: 20),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    _submitDetails();
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  void _submitDetails() {
    String accountHolder = _bankdetailsaccountnameController.text;
    String accountNumber = _bankdetailsaccountnumberController.text;
    String bankName = _bankdetailsbanknameController.text;
    String ifscCode = _bankdetailsifscCodeController.text;

    if (accountHolder.isEmpty ||
        accountNumber.isEmpty ||
        bankName.isEmpty ||
        ifscCode.isEmpty) {
      _showDialog('Error', 'All fields are required.');
    } else {
      setState(() => _isLoading = true);

      submitBankDetails(
        accountHolder,
        accountNumber,
        bankName,
        ifscCode,
      ).then((success) {
        setState(() => _isLoading = false);

        if (success) {
          _showDialog('Success', 'Bank details submitted successfully.');
        } else {
          _showDialog('Error', 'Failed to submit bank details.');
        }
      });
    }
  }

  // ✅ API function to submit bank details
  Future<bool> submitBankDetails(
      String accountHolder,
      String accountNumber,
      String bankName,
      String ifscCode,
      ) async {
    Map<String, String> data = {
      'accountName': accountHolder,
      'accountNumber': accountNumber,
      'bankName': bankName,
      'ifscCode': ifscCode,
    };

    try {
      final response = await NetworkUtil.post(NetworkUtil.ADD_UPDATE_ADDRESS_URL, body: data);

      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        return true;
      } else {
        print('Failed: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
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
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
