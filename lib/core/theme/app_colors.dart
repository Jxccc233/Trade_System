import 'package:flutter/material.dart';

/// A 股习惯配色：红涨绿跌
class AppColors {
  AppColors._();

  static const Color seed = Color(0xFF2F6FED);

  static const Color up = Color(0xFFD93026); // 上涨 / 盈利
  static const Color down = Color(0xFF0E9F6E); // 下跌 / 亏损
  static const Color flat = Color(0xFF8A8F99); // 持平

  static Color ofPnl(double value) {
    if (value > 0) return up;
    if (value < 0) return down;
    return flat;
  }
}
