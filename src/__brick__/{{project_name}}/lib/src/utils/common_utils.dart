import 'dart:convert';
import 'dart:developer';

class CommonUtils {
  static void printAndRecordLog(dynamic error, String stackTrace) {
    //TODO tidy up log and record to log monitoring
    log(error.toString());
    log(stackTrace);
  }

  static Map<String, dynamic> decodeTokenAsJson(String code) {
    final normalizedSource = base64Url.normalize(code.split(".")[1]);
    final result = utf8.decode(base64Url.decode(normalizedSource));

    return json.decode(result);
  }

  static bool isEmpty(dynamic value) {
    if (value == null ||
        value == '' ||
        value == 'null' ||
        value.isEmpty ||
        value.length == 0) {
      return true;
    }
    return false;
  }

  /// Adds thousands separators to a numeric string.
  ///
  /// This method takes a string representation of a number and adds a separator
  /// character every three digits from the right. It handles negative numbers
  /// by preserving the negative sign.
  ///
  /// Parameters:
  /// * [value] - The numeric string to format (e.g., "1234567" or "-1234567")
  /// * [separator] - The character to use as thousands separator (defaults to ',')
  ///
  /// Returns a [String] with thousands separators added.
  ///
  /// Example:
  /// ```dart
  /// String formatted = CommonUtils.addThousandsSeparator("1234567");
  /// print(formatted); // Output: "1,234,567"
  ///
  /// String negativeFormatted = CommonUtils.addThousandsSeparator("-1234567");
  /// print(negativeFormatted); // Output: "-1,234,567"
  ///
  /// String customSeparator = CommonUtils.addThousandsSeparator("1234567", separator: ".");
  /// print(customSeparator); // Output: "1.234.567"
  /// ```
  static String addThousandsSeparator(String value, {String separator = ','}) {
    // Check if the value is negative
    bool isNegative = value.startsWith('-');

    // Remove the negative sign for processing
    String processValue = isNegative ? value.substring(1) : value;

    // Split into integer and decimal parts
    final parts = processValue.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? '.${parts[1]}' : '';

    // Format the integer part
    final integerChars = integerPart.split('').reversed.toList();
    final formatted = <String>[];

    for (var i = 0; i < integerChars.length; i++) {
      if (i > 0 && i % 3 == 0) {
        formatted.add(separator);
      }
      formatted.add(integerChars[i]);
    }

    // Combine parts and add negative sign back if needed
    String result = formatted.reversed.join() + decimalPart;
    return isNegative ? '-$result' : result;
  }
}
