import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

double roundToTwoDecimalPlaces(String numberString) {
  double number = double.parse(numberString);
  double roundedNumber = double.parse(number.toStringAsFixed(2));
  return roundedNumber;
}

String parseAndFormatAbsolute(String numberString) {
  double number = double.parse(numberString);
  double absoluteNumber = number.abs();
  final NumberFormat formatter = NumberFormat('#,###.00');
  String formattedNumber = formatter.format(absoluteNumber);
  return formattedNumber;
}

String formatWithThousandSeparator(String numberString) {
  double number = double.parse(numberString);
  List<String> parts = number.toString().split('.');
  final NumberFormat formatter = NumberFormat('#,###');
  String integerPart = formatter.format(int.parse(parts[0]));
  String formattedNumber =
      parts.length > 1 ? '$integerPart.${parts[1]}' : integerPart;
  return formattedNumber;
}

Color conditionalTextColor(
    BuildContext context, bool isNegative, bool isNeutral) {
  final errorColor = Theme.of(context).colorScheme.error;
  return isNegative
      ? errorColor
      : isNeutral
          ? Colors.grey
          : Colors.green[900] ?? Colors.green;
}

String formatTimestamp(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  String formattedDate = DateFormat('HH:mm:ss').format(date);
  return formattedDate;
}

double formatWithThousandSeparatorToNum(String numberString) {
  double number = double.parse(numberString);
  return number;
}

bool showToast(String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black.withOpacity(0.7),
    textColor: Colors.white,
    fontSize: 14.0,
  );
  return true;
}