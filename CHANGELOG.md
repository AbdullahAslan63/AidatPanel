# AidatPanel Changelog

Tüm versiyon değişikliklerinin kaydı.

---

## [0.0.8] - 2026-05-04 (Yol Haritası v3.0 Oluşturuldu)

### 📋 Dokümantasyon Güncellemeleri

#### 1. YOL_HARITASI.md v3.0 Oluşturuldu
- **Versiyon:** v3.0 (Operasyonel Detay + Furkan Profili)
- **İçerik:** 7 aşama (0-6) tam detaylandırıldı, Furkan ritmi entegre edildi
- **Aşamalar:** 
  - Aşama 0: Acil Güvenlik (1-2 gün) — HTTP→HTTPS, Token 15dk, DioClient, ListView, Versiyon, intl
  - Aşama 1: Aidat Sistemi (1-2 hafta) — Due modülü, dummy data temizliği
  - Aşama 2: Güvenlik Hardening (1 hafta) — ProGuard, Helmet.js, rate limiting
  - Aşama 3: FCM + i18n (1 hafta)
  - Aşama 4: RevenueCat (1 hafta)
  - Aşama 5: Ticket Sistemi (2 hafta)
  - Aşama 6: Gider + PDF (2 hafta)
- **Takvim:** 10 hafta, v1.0.0 hedefi 2026-07-14
- **Checkpoint Protokolü:** 2-3 saatlik bloklar, reset molası (Genshin/Valorant)
- **Risk Matrisi:** 8 risk × azaltma stratejisi

#### 2. Analiz Raporları Güncellendi
- **AGENTS_COMPLIANCE_AUDIT.md:** v1.0 → v1.1 (YOL_HARITASI.md v3.0 referansı)
- **SECURITY_AUDIT.md:** v1.0 → v1.1 (YOL_HARITASI.md v3.0 referansı)

#### 3. Lokal Checkpoint Oluşturuldu
- **Dosya:** `checkpoints/2026-05-04_14-00.checkpoint.md`
- **Amaç:** Son çalışan durumu kaydet, hard reset referansı

**Durum:** 🟢 Yol haritası operasyonel, Aşama 0'a başlamaya hazır

---

## [0.0.9] - 2026-05-03

### 🐛 Hata Düzeltmeleri (6 Adet)

#### 1. DioClient Refresh Token Riski
- **Dosya:** `lib/core/network/dio_client.dart`
- **Sorun:** Refresh request'i kendi interceptor'ını atlıyordu, sonsuz döngü riski vardı
- **Çözüm:** Ayrı Dio instance kullanımı ile interceptor bypass engellendi
- **Commit:** `7f8763c`

#### 2. API Constants Dinamik ID Desteği
- **Dosya:** `lib/core/constants/api_constants.dart`
- **Sorun:** Tüm endpoint'ler statik string idi, dinamik ID eklenemiyordu
- **Çözüm:** Fonksiyon tabanlı endpoint tanımları eklendi (buildingDetail, buildingApartments, vb.)
- **Örnek:** `ApiConstants.buildingApartments(buildingId)` → `/api/v1/buildings/:id/apartments`

#### 3. AuthRepository Kullanıcı Verisi
- **Dosya:** `lib/features/auth/data/repositories/auth_repository_impl.dart`
- **Sorun:** `getStoredUser()` sadece ID döndürüyordu, email/name/role eksikti
- **Çözüm:** Kullanıcı detayları JSON olarak saklanıyor ve parse ediliyor
- **Etki:** Splash sonrası kullanıcı bilgileri eksiksiz görünüyor

#### 4. Java 8 Obsolete Uyarısı
- **Dosya:** `android/gradle.properties`
- **Sorun:** `source value 8 is obsolete` derleyici uyarısı
- **Çözüm:** Java 17 ayarları eklendi (org.gradle.java.home)

#### 5. Versiyon Formatı
- **Dosya:** `pubspec.yaml`
- **Değişiklik:** `0.0.8` → `0.0.8+1` → `0.0.9`
- **Neden:** Semantic versioning + build number desteği

#### 6. ProGuard/R8 Obfuscation
- **Dosya:** `android/app/build.gradle.kts`
- **Ekleme:** `isMinifyEnabled = true`, `isShrinkResources = true`
- **Yeni Dosya:** `android/app/proguard-rules.pro`

### 🔧 Teknik İyileştirmeler
- **intl paket uyumluluğu:** `dependency_overrides` ile Flutter 3.11.5 uyumu sağlandı
- **Secure Storage:** `saveUser()` JSON format desteği eklendi

### 🧪 Test Durumu
- ✅ Login/Register/Join çalışıyor
- ✅ Bina CRUD işlemleri aktif
- ✅ VS Code 0 hata
- ✅ Terminal Java uyarısı kalktı

---

## Hot Fixes (0.0.8 sonrası)
**Tarih:** 2026-05-03 03:54

### 📚 Dokümantasyon ve Prompt Sistemi
- Eski prompt_data dosyaları silindi (AGENTS.md, AI_COFOUNDER_PROMPTU.md, GUVENLIK_ANALIZI.md, OPTIMIZASYON_ANALIZI.md)
- `prompt_data/master_promptu_analizi/` klasörü oluşturuldu
- MASTER_PROMPTU.md detaylı analiz raporu eklendi
- Furkan için kişiselleştirilmiş AI Co-Founder Master Prompt oluşturuldu (6 soruluk röportaj sonucu)
- Kullanıcı Modeli: 6 boyutlu profil (Zaman/Enerji, Problem/Karar, Öğrenme, Ekip, Vizyon, Reset)

### 🤖 AI Co-Founder Özellikleri
- 4 çalışma modu tanımlandı: Teknik Danışman, Proje Yöneticisi, Analiz & Review, Stratejik Ortak
- Hard constraints: Hataya tolerans yok, mükemmeliyetçi standartlar
- Özel senaryolar: Checkpoint'li ilerleme, tıkanma detektörü (anime/oyun reset), liderlik kararları
- Mentorluk protokolü: Detaylı step-by-step talimatlar

---

## Hot Fixes (0.0.8 sonrası)
**Tarih:** 2026-05-02 04:38

### ✨ İyileştirmeler
- Dashboard TabController optimizasyonu - `setState` yerine Riverpod provider kullanımı
- `manager_dashboard_screen.dart`: Tab index state Riverpod'a taşındı
- `resident_dashboard_screen.dart`: Tab index state Riverpod'a taşındı
- `navigation_provider.dart`: Yeni oluşturuldu - merkezi tab yönetimi

### 🔧 Teknik Değişiklikler
- Versiyon formatı düzeltildi: `0.0.8+1` → `0.0.8` (semantic versioning kurallarına uygun)
- `pubspec.yaml` ve `app_constants.dart` senkronize edildi

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

