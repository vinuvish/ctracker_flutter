class ZValidators {
  static String email(String value) {
    value = value.toLowerCase();
    if (value.isEmpty) {
      return 'Email can\'t empty';
    }
    if (value.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Please Enter a valid email address';
    }
    return null;
  }

  static String username(String value) {
    value = value.toLowerCase();
    if (value.isEmpty) {
      return 'Userame can\'t be empty';
    }
    if (value.length < 3) {
      return 'User Name should be more than 3 letters';
    }
    return null;
  }

  static String none(String value) {
    return null;
  }

  static String getMessageFromErrorCode(errorCode) {
    print(errorCode.code);
    switch (errorCode.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
        break;

      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
        break;

      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
        break;

      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
        break;

      case "too-many-requests":
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
        break;

      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        return "Server error, please try again later.";
        break;

      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
        break;

      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No account found with this email";
        break;

      default:
        return "Login failed. Please try again.";
        break;
    }
  }

  static String password(String value) {
    value = value.toLowerCase();
    if (value.isEmpty) {
      return 'Password can\'t be empty';
    }
    if (value.length < 5) {
      return 'Password should be more than 6 letters';
    }
    return null;
  }

  static String mobile(String value) {
    if (value.isEmpty) {
      return 'Mobile can\'t be Empty';
    }
    return null;
  }
}
