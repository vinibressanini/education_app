extension StringExt on String {
  String obscureInfo() {
    final atSignIndex = indexOf('\u0040');
    final firstChar = this[0];

    final visibleString = substring(atSignIndex);

    return '$firstChar****$visibleString';
  }
}
