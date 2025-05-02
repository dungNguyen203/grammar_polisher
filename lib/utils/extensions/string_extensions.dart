extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String toTitle() {
    // replace a special character with a space
    return replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), ' ')
        .trim()
        .split(' ')
        .map((word) => word.capitalize())
        .join(' ');
  }
}
