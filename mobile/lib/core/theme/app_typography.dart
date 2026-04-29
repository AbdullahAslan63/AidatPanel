import 'package:flutter/material.dart';

class AppTypography {
  static const fontFamily = 'Nunito';

  // Büyük Başlıklar (Örn: Bina adı, Toplam Borç)
  static const h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  // KRİTİK: Yaşlı kullanıcılar için 16sp alt sınır!
  static const body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  // Buton Metinleri (Tıklaması ve okuması kolay)
  static const button = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
}