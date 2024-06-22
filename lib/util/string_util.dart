class StringUtil {

  static String slitEmailString(String text) {
    int atIndex = text.indexOf('@');
    text = atIndex != -1 ? text.substring(0, atIndex) : text;
    return text;
  }

  static String toTitleCase(String text) {
    return text.toLowerCase().split(' ').map((word) {
      return word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '';
    }).join(' ');
    }

  static String removeLetters(String input) {
    return input.replaceAll(RegExp(r'[a-zA-Z]'), '');
  }

  static String removeNumbers(String input) {
    return input.replaceAll(RegExp(r'[0-9]'), '');
  }
  

}