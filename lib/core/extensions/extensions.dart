// This file is no longer needed as flutter_screenutil provides these extensions automatically
// Keeping for any custom extensions we might need

import 'package:flutter/material.dart';

extension DurationExtensions on Duration {
  String get formattedTime {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

extension ListExtensions<T> on List<T> {
  T? getOrNull(int index) {
    if (index >= 0 && index < length) return this[index];
    return null;
  }

  List<List<T>> chunk(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size).clamp(0, length)));
    }
    return chunks;
  }
}

extension ColorExtensions on Color {
  Color withBrightness(double factor) {
    return Color.fromARGB(
      a.toInt(),
      (r * factor).clamp(0, 255).toInt(),
      (g * factor).clamp(0, 255).toInt(),
      (b * factor).clamp(0, 255).toInt(),
    );
  }

  Color get lighter => withBrightness(1.2);
  Color get darker => withBrightness(0.8);
}