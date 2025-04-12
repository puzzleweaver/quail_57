import 'dart:math';

class ReportBoxer {
  static String format(String contents) {
    Iterable<String> lines = contents.split("\n");
    int maxLength = lines.map((line) => line.length).reduce(max);
    String hr = ["+-", for (int i = 0; i < maxLength; i++) "-", "-+"].join("");
    return [
      hr,
      for (String line in lines)
        [
          "| $line",
          for (int i = 0; i < maxLength - line.length; i++) " ",
          " |",
        ].join(""),
      hr,
    ].join("\n");
  }
}
