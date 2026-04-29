# AidatPanel Changelog

Tüm versiyon değişikliklerinin kaydı.

---

## f0.0.7 - Davet Kodu Sistemi ve Bina Yönetimi
**Tarih:** 2025-04-29

### 🚀 Yeni Özellikler
- **Davet Kodu Üretim Akışı**: 3 adımlı bina → daire → kod akışı
- **Native Paylaşım**: Uygulamalar arası paylaşım + panoya kopyalama
- **Aktif Kod Yönetimi**: Aynı daireye tekrar kod üretimini engelleme
- **Kod İptal (Revoke)**: Aktif kodun manuel iptali
- **Bina Ekleme Ekranı**: Şehir/ilçe seçimli, kat/daire sayısı girişi
- **Dinamik Daire Oluşturma**: Kat × Daire sayısı otomatik daire listesi

### ✨ İyileştirmeler
- Ana menüye dönüş butonu (Davet kodu sonuç ekranı)
- Kod geçerlilik süresi: Gün + saat detaylı gösterim
- Bina kartları: Detaylı bilgi ve tıklanabilir navigasyon
- Daire etiket formatı: "1. Kat - Daire A" gösterimi

### 🔧 Teknik Değişiklikler
- `invite_code_screen.dart` modüler yapıya bölündü (938 satır → 6 dosya)
  - `invite_code_helpers.dart` (yardımcı fonksiyonlar)
  - `invite_step_indicator.dart` (adım göstergesi)
  - `invite_selectable_tile.dart` (seçilebilir kart)
  - `invite_confirm_dialogs.dart` (onay diyalogları)
  - `invite_code_result_view.dart` (sonuç görünümü)
- Buildings ve Apartments state management (Riverpod)
- Davet kodu formatı: `AP425-1A-X7K9` (planning'e uygun)

---

## f0.0.6 - Toast Sistemi ve Ayarlar Sekmesi
**Tarih:** Önceki checkpoint

### 🚀 Yeni Özellikler
- Stacked toast sistemi (max 3 görünür, en eskisi fade out)
- Kapsamlı Ayarlar sekmesi (profil, dil, hakkında, çıkış)
- Clean Architecture klasör yapısı

### ✨ İyileştirmeler
- Stat kartı görünürlüğü: Beyaz metin, primary arka plan
- Hata mesajları: SnackBar → Toast sistemi geçişi
- Tab navigasyonu: BottomNavigationBar + TabBarView senkronizasyonu

### 🔧 Teknik Değişiklikler
- Back button: push/pop navigasyon düzeltmesi
- Splash: Yukarı kayan animasyon
- Register/Join: Back button eklendi

