# AidatPanel Changelog

Tüm versiyon değişikliklerinin kaydı.

---

## Hot Fixes (f0.0.7 sonrası)
**Tarih:** 2025-04-29

### 🐛 Düzeltmeler
- Login ekranı layout iyileştirmesi: MainAxisAlignment.center eklendi
- Dinamik height sabit AppSizes.spacingL ile değiştirildi
- Responsive layout daha tutarlı hale getirildi
- Login ekranına copyright metni eklendi (© Vefa Yazılım f0.0.7)

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

---

## f0.0.5 - Bina Sekmesi ve Dashboard Temelleri
**Tarih:** Önceki dönem

### 🚀 Yeni Özellikler
- **Bina Sekmesi**: Bina listesi görünümü ve detaylı kartlar
- **Yönetici Dashboard**: Dummy verili yönetici ana ekranı
- **Sakin Dashboard**: Dummy verili sakin ana ekranı
- **Tab Navigasyonu**: Yönetici ve sakin için alt menü navigasyonu

### ✨ İyileştirmeler
- Telefon girişi: +90 prefix ve max 10 haneli validasyon
- İsim ipucu metni: "Furkan Kaya" placeholder

### 🔧 Teknik Değişiklikler
- Clean Architecture iskelet klasör yapısı oluşturuldu
- Lint hataları düzeltildi (unused fields, deprecated APIs)
- Async safety iyileştirmeleri

---

## f0.0.4 - Dashboard ve Kimlik Doğrulama
**Tarih:** Önceki dönem

### 🚀 Yeni Özellikler
- **Yönetici Dashboard**: Bina ve sakin yönetimi için ana ekran
- **Sakin Dashboard**: Aidat ve bildirim görünümü için ana ekran
- **Çıkış Akışı**: Auth state temizleme ve splash yönlendirmesi

### 🔧 Teknik Değişiklikler
- Merge: Backend API endpoints entegrasyonu
- Kimlik doğrulama flow'u tamamlandı

---

## f0.0.3 - Splash ve Katılım Ekranları
**Tarih:** Önceki dönem

### 🚀 Yeni Özellikler
- **Splash Ekranı**: Logo ve marka sunumu
- **Katılım Ekranları**: Yeni kullanıcı kayıt ve davet kodu ile katılım
- **Kimlik Doğrulama Akışı**: Login → Dashboard yönlendirmesi

### ✨ İyileştirmeler
- Splash animasyonu: Yukarıdan kayan geçiş efekti
- Geri butonları: Tüm auth ekranlarına eklendi

---

## f0.0.2 - Giriş ve Kayıt Ekranları
**Tarih:** Önceki dönem

### 🚀 Yeni Özellikler
- **Giriş Ekranı**: Auth providers ve repository'ler ile login
- **Kayıt Ekranı**: Validasyonlu kullanıcı kaydı
- **Telefon Girişi**: +90 ön ekli, max 10 haneli format

### 🔧 Teknik Değişiklikler
- Riverpod state management entegrasyonu
- GoRouter navigasyon yapılandırması
- Repository pattern uygulandı

---

## f0.0.1 - Flutter Projesi Başlangıcı
**Tarih:** Önceki dönem

### 🚀 Yeni Özellikler
- Flutter projesi başlatıldı
- Clean Architecture klasör yapısı oluşturuldu
- Temel bağımlılıklar eklendi (Riverpod, GoRouter, vs.)

### 🔧 Teknik Değişiklikler
- Proje iskeleti kuruldu
- Geliştirme ortamı hazırlandı

