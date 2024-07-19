import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColor {
  static final orange = Colors.orange.shade800;
}

extension Format on Timestamp {
  String format() {
    return DateFormat(
      'HH:mm dd MMMM, yyyy',
    ).format(toDate());
  }

  String toMonth() {
    return DateFormat(
      'MMMM',
    ).format(toDate());
  }

  String toDay() {
    return DateFormat(
      'dd',
    ).format(toDate());
  }
}
