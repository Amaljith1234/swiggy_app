class Validate {
  // RegEx pattern for validating email addresses.
  static String emailPattern = r"^[^@]+@[^@]+\.[^@]+";
  static RegExp emailRegEx = RegExp(emailPattern);

  // Validates an email address.
  static bool isEmail(String value) {
    if (emailRegEx.hasMatch(value.trim())) {
      return true;
    }
    return false;
  }

  /*
   * Returns an error message if email does not validate.
   */
  static String? validateEmail(String value) {
    String email = value.trim();
    if (email.isEmpty) {
      return 'Email is required.';
    }
    if (!isEmail(email)) {
      return 'Valid email required.';
    }
    return null;
  }

  /*
   * Returns an error message if required field is empty.
   */
  static String? requiredField(String value, String message) {
    if (value.trim().isEmpty) {
      return message;
    }
    return null;
  }
}
