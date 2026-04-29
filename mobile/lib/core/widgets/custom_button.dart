import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Buton ekranı yatayda tam kaplasın
      height: 56, // KRİTİK: 50+ yaş kuralı için min 48px olması gereken dokunma alanını 56px yaptık
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // Senin theme dosyasından gelen lacivert
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Köşeleri hafif yumuşattık
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTypography.button.copyWith(
            color: Colors.white, // Yazı rengi beyaz
          ),
        ),
      ),
    );
  }
}