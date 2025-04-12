extension StringIdFormat on String? {
  String get idFormat {
    String? str = this;
    if (str == null) return "null";
    if (str.length < 4) return str;
    return str.substring(0, 4);
  }
}
