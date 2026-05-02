# AidatPanel Changelog

Tüm versiyon değişikliklerinin kaydı.

---

## Hot Fixes (0.0.8+1 sonrası)
**Tarih:** 2026-05-02 03:20

### 🔐 Güvenlik İyileştirmeleri
- Token expiry (süre dolma) kontrolü eklendi
- `secure_storage.dart`: `saveTokenExpiry()`, `getTokenExpiry()`, `isTokenExpired()` metodları eklendi
- `dio_client.dart`: API çağrısı öncesi token süresi kontrolü
- `auth_provider.dart`: Mock login'de token ve expiry kaydetme
- `auth_repository_impl.dart`: Login/Register/Join işlemlerinde expiry kaydetme (3 yer)

### 🧪 Test Özellikleri
- Ayarlar sekmesine "Token Süresi Kontrol (Test)" butonu eklendi
- Debug modda token süresi manuel kontrol edilebilir
- Süre dolunca otomatik login ekranına yönlendirme

### 🔧 Teknik Değişiklikler
- `app_constants.dart`: `tokenExpiryKey` eklendi
- 6 dosya güncellendi, token yönetimi altyapısı hazırlandı
- Backend entegrasyonuna hazır (süre backend'den ayarlanacak)

---

## 0.0.8 - Türkçe prompt_data
**Tarih:** 2026-05-02

### 🌍 Yeni Özellikler
- prompt_data klasörü tamamen Türkçe'ye çevrildi
- AGENTS.md → Agent kuralları ve kısıtlamaları (Türkçe)
- AI_COFOUNDER_PROMPTU.md → Furkan için AI Co-Founder sistem prompt'u (Türkçe)
- GUVENLIK_ANALIZI.md → Güvenlik denetimi ve risk analizi (Türkçe)
- OPTIMIZASYON_ANALIZI.md → Performans optimizasyon stratejileri (Türkçe)

### ✨ İyileştirmeler
- promp_ciktilari klasörü prompt_data olarak yeniden adlandırıldı
- Tüm dokümantasyon tek dilde birleştirildi
- Fazla dosya oluşturulmadan doğrudan çeviri yapıldı
- Bundan sonraki geliştirmeler Türkçe devam edecek

### 🔧 Teknik Değişiklikler
- 7 dosya güncellendi, 154 satır değiştirildi
- Eski İngilizce dosyalar temizlendi
- Checkpoint-2026-05-02-turkce oluşturuldu

---

## Hot Fixes (0.0.7 sonrası)
**Tarih:** 2026-04-30 04:20

### 🔧 Teknik Değişiklikler
- UserData sınıfı duplicate'ı kaldırıldı (3 dosyadan tek dosyaya)
- features/auth/data/models/user_data.dart oluşturuldu
- login_response.dart, register_response.dart, join_response.dart'dan duplicate UserData silindi
- Kod tekrarı azaltıldı, bakım kolaylaştırıldı

---

## Hot Fixes (0.0.7 sonrası)
**Tarih:** 2026-04-30 03:30

### 🐛 Düzeltmeler
- Uygulama versiyonu 0.0.7 yapıldı (pubspec.yaml, appConstants, settings)
- LFS kaldırıldı, APK'ler GitHub'dan silindi
- APK yedekleme script'i oluşturuldu (D:\AidatPanel\build_apk_backup.bat)
- Versiyon referansları dinamik hale getirildi (login, register, join ekranları)
- Login ekranı layout iyileştirmesi: MainAxisAlignment.center eklendi
- Dinamik height sabit AppSizes.spacingL ile değiştirildi
- Responsive layout daha tutarlı hale getirildi
- Copyright metni dinamik versiyon referansı kullanıyor

---

## 0.0.7 - Davet Kodu Sistemi ve Bina Yönetimi
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

## 0.0.6 - Toast Sistemi ve Ayarlar Sekmesi
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

## 0.0.5 - Bina Sekmesi ve Dashboard Temelleri
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

## 0.0.4 - Dashboard ve Kimlik Doğrulama
**Tarih:** Önceki dönem

### 🚀 Yeni Özellikler
- **Yönetici Dashboard**: Bina ve sakin yönetimi için ana ekran
- **Sakin Dashboard**: Aidat ve bildirim görünümü için ana ekran
- **Çıkış Akışı**: Auth state temizleme ve splash yönlendirmesi

### 🔧 Teknik Değişiklikler
- Merge: Backend API endpoints entegrasyonu
- Kimlik doğrulama flow'u tamamlandı

---

## 0.0.3 - Splash ve Katılım Ekranları
**Tarih:** Önceki dönem

### 🚀 Yeni Özellikler
- **Splash Ekranı**: Logo ve marka sunumu
- **Katılım Ekranları**: Yeni kullanıcı kayıt ve davet kodu ile katılım
- **Kimlik Doğrulama Akışı**: Login → Dashboard yönlendirmesi

### ✨ İyileştirmeler
- Splash animasyonu: Yukarıdan kayan geçiş efekti
- Geri butonları: Tüm auth ekranlarına eklendi

---

## 0.0.2 - Giriş ve Kayıt Ekranları
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

## 0.0.1 - Flutter Projesi Başlangıcı
**Tarih:** Önceki dönem

### 🚀 Yeni Özellikler
- Flutter projesi başlatıldı
- Clean Architecture klasör yapısı oluşturuldu
- Temel bağımlılıklar eklendi (Riverpod, GoRouter, vs.)

### 🔧 Teknik Değişiklikler
- Proje iskeleti kuruldu
- Geliştirme ortamı hazırlandı

