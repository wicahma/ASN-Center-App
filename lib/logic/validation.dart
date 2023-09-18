class Validation {
  bool nullCheck(String? input) {
    if (input == null || input.isEmpty || "null".contains(input)) return true;
    return false;
  }

  bool isNumeric(String input) {
    final RegExp regex = RegExp(r'^[0-9]+$');
    return !regex.hasMatch(input);
  }

  bool isTypeCorrect({required String path, required List<String> listType}) {
    String extension = path.split('.').last.toLowerCase();
    if (!listType.contains(extension)) return false;
    return true;
  }

  bool isSizeCorrect({required int size, required double maxSize}) {
    // 2 MB limit
    if (size > (maxSize * 1048576)) {
      return false;
    } else {
      return true;
    }
  }
}
