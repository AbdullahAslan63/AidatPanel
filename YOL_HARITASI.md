# 🗺️ AIDATPANEL - OPERASYONEL YOL HARİTASI

**Versiyon:** 3.0 (Operasyonel Detay + Furkan Profili)  
**Tarih:** 2026-05-04  
**Proje Versiyonu:** v0.0.8 → Hedef: v1.0.0  
**Branch:** `mobile/flutter-app`  
**Hazırlayan:** AI Co-Founder (Furkan profili ile)  
**Durum:** 🟢 **Aşama 0 (Acil Güvenlik) başlatılmaya hazır**

---

## 🎯 ÖNEMLİ: ÖNCE OKU

Bu belge **operasyonel yol haritası** — Furkan'ın Flutter geliştirmesini yönlendiren detaylı sprint planıdır. İçerdiği 7 aşama (0 → 6), somut görevler, subtask'lar, Definition of Done (DoD), risk ve takvim ile AidatPanel v1.0.0'a kadar gidecek tüm sürümleri tanımlar.

### Temel Prensipler
- **Furkan Ritmi:** 2-3 saatlik checkpoint blokları, reset molası (Genshin/Valorant), günlük standup
- **Analiz Entegrasyonu:** Her aşama, AGENTS_COMPLIANCE, SECURITY_AUDIT, OPTIMIZATIONS, GAP_ANALIZI raporlarıyla çapraz referanslanmıştır
- **Operasyonel Detay:** Aşama = Hedef + Görevler + Subtask'lar + DoD + Risk + Git tag
- **Bloker Kuralı:** Aşama 0 tamamlanmadan Aşama 1 başlamaz (production güvenliği)

### Çapraz Referanslar
- `HATA_ANALIZ_RAPORU.md` — 15 kritik hata (Aşama 0-2 kaynağı)
- `AGENTS_COMPLIANCE_AUDIT.md` — Kod uyumluluk skoru %75 (her aşamada checklist)
- `AIDATPANEL_GAP_ANALIZI.md` — Gap'ler → Aşama mapping'i
- `SECURITY_AUDIT.md` — 11 güvenlik zafiyeti (Aşama 0 + 2.2 kaynağı)
- `OPTIMIZATIONS.md` — 12 optimizasyon bulgusu (Aşama 2 kaynağı)
- `GOREVDAGILIMI_GELISTIRILMIS.md` — Ekip standartları + DoD şablonları

---

## 📊 GENEL DURUM ÖZETİ

### Proje Sağlık Kartı (v0.0.8)

| Metrik | Durum | Detay |
|--------|-------|-------|
| **Kod Kalitesi** | 🟡 Orta | Clean Architecture temel yapı var, 15 kritik hata (HATA_ANALIZ) |
| **Faz Tamamlama** | 🟡 %40 | Faz 1 tamam (auth + bina + daire UI), Faz 2 başlamadı |
| **Güvenlik** | 🔴 **YÜKSEK RİSK** | HTTP (HTTPS yok), token expiry hatalı, refresh döngü riski, 11 zafiyet |
| **Backend Entegrasyonu** | 🔴 Eksik | Dummy data kullanılıyor, API bağlantısı yok |
| **Optimizasyon** | 🟡 Orta | Debug build, ListView perf sorunu (4 konum), obfuscation yok |
| **Test Coverage** | 🔴 %0 | Unit/widget/integration test yok |
| **Dokümantasyon** | 🟢 İyi | `planning/` + 6 analiz raporu kapsamlı |
| **Deployment Hazırlığı** | 🔴 Hazır Değil | HTTPS + ProGuard + pinning + CI/CD eksik |

### Ekip Durumu

| Üye | Rol | Mevcut Durum | Bus Factor |
|-----|-----|--------------|------------|
| **Abdullah** | Lead Developer | Backend tamam (Node.js + Prisma + 44 endpoint) | 🟢 Dağıtılabilir |
| **Furkan** | Senior Mobile | Flutter Core aktif, Aşama 0-6 sorumlusu | 🔴 **Tek sorumlu** |
| **Yusuf** | Junior Full-Stack | Backend destek, Aşama 1-6'da daha aktif | 🟡 Faz 2'de yardımcı |
| **Seyit** | Junior UI/UX | UI kit temel, Aşama 3 (FCM+i18n) primary | 🟡 Aşama 3'te aktif |

**⚠️ Kritik Not:** Furkan bus factor = 1. Knowledge transfer zorunlu (Yusuf/Seyit'e pair programming, haftalık review).

---

## 🏗️ MEVCUT MİMARİ DURUMU

### Flutter Uygulaması (mobile/)

#### ✅ Tamamlanan (Faz 1)
```
mobile/lib/
├── main.dart                    ✅ Entry point, Firebase init
├── core/
│   ├── constants/               ✅ api_constants, app_constants
│   ├── theme/                   ✅ app_theme, app_colors (50+ yaş), app_typography (Nunito)
│   ├── router/                  ✅ GoRouter
│   ├── network/                 ⚠️ Dio + interceptor (refresh döngü RİSKİ — Aşama 0.3)
│   ├── storage/                 ⚠️ secure_storage (token expiry HATALI — Aşama 0.2)
│   └── utils/                   ✅ date_utils, currency_utils
├── features/
│   ├── auth/                    ⚠️ UI tamam, token handling hatalı (Aşama 0.2)
│   ├── dashboard/               ✅ Manager/Resident dashboard (temel)
│   ├── buildings/               ⚠️ UI var, DUMMY DATA kullanıyor (Aşama 1.1)
│   ├── apartments/              ⚠️ UI var, DUMMY DATA kullanıyor (Aşama 1.1)
│   └── dues/                    ❌ KLASÖR BİLE YOK (Aşama 1.2-1.4)
└── shared/widgets/              ✅ Loading, Error, Empty
```

#### ❌ Eksik (Faz 2-3'te Yapılacak)
```
mobile/lib/features/
├── dues/                        ❌ KLASÖR BİLE YOK — AidatPanel'in ana modülü (Aşama 1)
├── expenses/                    ❌ Faz 3 (Aşama 6)
├── tickets/                     ❌ Faz 3 (Aşama 5)
├── notifications/               ⚠️ FCM kurulu, handler yok (Aşama 3)
├── reports/                     ❌ PDF rapor (Aşama 6)
└── subscription/                ⚠️ purchases_flutter kurulu, Purchases.configure() yok (Aşama 4)
```

### Backend (backend/) — Abdullah
- ✅ PostgreSQL + Prisma (10 model, 7 enum)
- ✅ JWT auth (access 15dk, refresh 30g)
- ✅ 44 API endpoint tanımlı ve çalışıyor
- ✅ RevenueCat webhook endpoint hazır
- ⚠️ Rate limiting yok, Helmet.js yok, Swagger yok (Aşama 2.2)

---

## 🚨 AŞAMA 0 — ACİL GÜVENLİK (1-2 GÜN)

> **🔴 PRODUCTION'A ÇIKMADAN ÖNCE ZORUNLU**

**Sorumlu:** Furkan (Flutter) + Abdullah (SSL)  
**Kaynak:** `HATA_ANALIZ_RAPORU.md` + `SECURITY_AUDIT.md` + `AIDATPANEL_GAP_ANALIZI.md`  
**Hedef:** 4 kritik güvenlik zafiyeti kapatılmış, ListView performans düzeltilmiş

### 0.1 HTTP → HTTPS Protokol Dönüşümü

**Görev:** API base URL'sini HTTPS'e çevir

| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/core/constants/api_constants.dart:2` |
| **Mevcut** | `static const String baseUrl = 'http://api.aidatpanel.com:4200';` |
| **Yeni** | `static const String baseUrl = 'https://api.aidatpanel.com:4200';` |
| **Efor** | 15 dakika |
| **Subtask'lar** | 1. api_constants.dart güncelle<br>2. Emülatörde test (HTTPS bağlantı başarılı)<br>3. Cloudflare SSL Full/Strict yapılandırması (Abdullah) |
| **Doğrulama** | `flutter run` → Network tab'da HTTPS istekleri görülüyor |
| **Risk** | Düşük (tek satır değişiklik) |

**Commit Message:**
```
fix: HTTP → HTTPS - api_constants.dart baseUrl

- api_constants.dart:2 http:// → https:// dönüşümü
- Cloudflare SSL Full/Strict yapılandırması (Abdullah)
- AGENTS_COMPLIANCE_AUDIT.md K-01 kapatıldı
- HATA_ANALIZ_RAPORU.md #1 kapatıldı
```

---

### 0.2 Token Expiry Süresi Düzeltmesi (15 dakika)

**Görev:** Access token süresi 30 gün → 15 dakika

| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/features/auth/data/repositories/auth_repository_impl.dart:47-48, 79-80, 111-112` |
| **Mevcut** | `Duration(days: 30)` (3 konum) |
| **Yeni** | `Duration(minutes: 15)` (access token)<br>`Duration(days: 30)` (refresh token — ayrı) |
| **Efor** | 1 saat |
| **Subtask'lar** | 1. auth_repository_impl.dart 3 konum güncelle<br>2. secure_storage.dart'a `saveRefreshTokenExpiry()` ekle<br>3. Token expiry check logic test et<br>4. 15 dakika sonra token refresh tetikleniyor mu test et |
| **Doğrulama** | Settings tab'da "Token Süresi Kontrol" test butonu → 15 dakika sonra logout |
| **Risk** | Orta (auth flow'u etkileyebilir) |

**Commit Message:**
```
fix: Token expiry 30g → 15dk - auth_repository_impl.dart

- auth_repository_impl.dart:47-48, 79-80, 111-112 Duration(minutes: 15)
- secure_storage.dart saveRefreshTokenExpiry() ekle
- Backend ile eşleşme sağlandı (access 15dk, refresh 30g)
- AGENTS_COMPLIANCE_AUDIT.md K-02 kapatıldı
- HATA_ANALIZ_RAPORU.md #2 kapatıldı
```

---

### 0.3 DioClient Refresh Token Döngü Riski Düzeltmesi

**Görev:** Refresh request'i ayrı Dio instance'ında yap (interceptor bypass)

| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/core/network/dio_client.dart:74-76` |
| **Mevcut** | `_dio.post(ApiConstants.refresh, ...)` (kendi interceptor'ını çağırıyor) |
| **Yeni** | Ayrı `refreshDio` instance (interceptor yok) |
| **Efor** | 30 dakika |
| **Subtask'lar** | 1. dio_client.dart'da refreshDio oluştur<br>2. Refresh request'i refreshDio ile yap<br>3. Sonsuz döngü testi (token 401 alırsa ne olur?)<br>4. Refresh başarısızlığında graceful error handling |
| **Doğrulama** | Token refresh başarısız olduğunda sonsuz döngü yok, logout tetikleniyor |
| **Risk** | Orta (auth flow'u etkileyebilir) |

**Commit Message:**
```
fix: DioClient refresh döngü riski - dio_client.dart

- dio_client.dart:74-76 ayrı refreshDio instance oluştur
- Refresh request'i interceptor olmadan yap
- Sonsuz döngü riski ortadan kaldırıldı
- AGENTS_COMPLIANCE_AUDIT.md K-03 kapatıldı
- HATA_ANALIZ_RAPORU.md #3 kapatıldı
```

---

### 0.4 ListView Performans Düzeltmesi (4 konum)

**Görev:** `ListView(children:)` → `ListView.builder` dönüşümü

| Alan | Detay |
|------|-------|
| **Dosyalar** | `invite_code_screen.dart` (2 konum)<br>`add_building_screen.dart` (1 konum)<br>`invite_code_result_view.dart` (1 konum) |
| **Mevcut** | `ListView(children: [...])`  |
| **Yeni** | `ListView.builder(itemCount: ..., itemBuilder: ...)` |
| **Efor** | 1 saat |
| **Subtask'lar** | 1. 4 dosyada ListView.builder'a dönüştür<br>2. itemCount ve itemBuilder doğru ayarla<br>3. 100 item'lı liste 60 FPS scroll testi<br>4. Memory profiling (DevTools) |
| **Doğrulama** | Flutter DevTools Performance → 60 FPS, frame time <16ms |
| **Risk** | Düşük (UI-only değişiklik) |

**Commit Message:**
```
perf: ListView → ListView.builder (4 konum)

- invite_code_screen.dart (2x) ListView.builder
- add_building_screen.dart ListView.builder
- invite_code_result_view.dart ListView.builder
- 100 item'lı liste 60 FPS scroll (DevTools verified)
- 50+ yaş UX iyileştirmesi
- AGENTS_COMPLIANCE_AUDIT.md K-04 kapatıldı
- HATA_ANALIZ_RAPORU.md #4 kapatıldı
```

---

### 0.5 Versiyon Formatı Düzeltmesi

**Görev:** `pubspec.yaml` versiyon `0.0.8` → `0.0.8+1`

| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/pubspec.yaml:5` |
| **Mevcut** | `version: 0.0.8` |
| **Yeni** | `version: 0.0.8+1` |
| **Efor** | 5 dakika |
| **Subtask'lar** | 1. pubspec.yaml güncelle<br>2. app_constants.dart senkronize et (versiyon referansı varsa)<br>3. Flutter pub get |
| **Doğrulama** | `flutter pub get` hata yok |
| **Risk** | Düşük |

---

### 0.6 intl Paket Uyumsuzluğu Düzeltmesi

**Görev:** `intl: ^0.20.2` → `^0.19.0` (Flutter 3.11.5 uyumluluğu)

| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/pubspec.yaml:30` |
| **Mevcut** | `intl: ^0.20.2` |
| **Yeni** | `intl: ^0.19.0` (dependency_overrides) |
| **Efor** | 10 dakika |
| **Subtask'lar** | 1. pubspec.yaml güncelle<br>2. `flutter pub get`<br>3. Compile hata yok |
| **Doğrulama** | `flutter analyze` 0 issue |
| **Risk** | Düşük |

---

### Aşama 0 Definition of Done

- [ ] HTTPS üzerinden istekler başarılı (Cloudflare SSL Full/strict)
- [ ] Access token 15 dakika sonra refresh tetikleniyor
- [ ] Refresh başarısızlığı sonsuz döngü yaratmıyor
- [ ] 100 item'lı ListView 60 FPS scroll (DevTools verified)
- [ ] `flutter analyze` 0 issue
- [ ] `flutter test` (temel smoke test)
- [ ] Emülatör test (`emulator-5554`) — login → bina seç → daire seç akışı
- [ ] Git tag: **v0.0.9** oluştur
- [ ] CHANGELOG.md güncelle (Aşama 0 özeti)
- [ ] GitHub'a push et

**🔒 BLOKER:** Bu aşama tamamlanmadan Aşama 1 başlamaz.

---

## 🎯 AŞAMA 1 — AİDAT SİSTEMİ (1-2 HAFTA)

**Sorumlu:** Furkan (Primary), Abdullah (API review)  
**Hedef:** AidatPanel'in ana modülü (Due) çalışır durumda, dummy data temizlenmiş

### 1.1 Pre-Work: Dummy Data Temizliği + API Entegrasyonu (2-3 gün)

**Görev:** Hardcoded bina/daire verilerini API'ye bağla

| Görev | Dosya | Efor | Subtask'lar |
|-------|-------|------|-------------|
| BuildingsRemoteDatasource oluştur | `mobile/lib/features/buildings/data/datasources/buildings_remote_datasource.dart` | 2 saat | 1. Dio client inject<br>2. `getBuildings()` → `GET /api/v1/buildings`<br>3. Error handling |
| BuildingsRepository impl | `mobile/lib/features/buildings/data/repositories/buildings_repository_impl.dart` | 1 saat | 1. Interface implement<br>2. RemoteDatasource call<br>3. Exception handling |
| ApartmentsRemoteDatasource oluştur | `mobile/lib/features/apartments/data/datasources/apartments_remote_datasource.dart` | 2 saat | 1. `getApartmentsByBuilding(buildingId)` → `GET /api/v1/buildings/:id/apartments`<br>2. Error handling |
| ApartmentsRepository impl | `mobile/lib/features/apartments/data/repositories/apartments_repository_impl.dart` | 1 saat | 1. Interface implement<br>2. RemoteDatasource call |
| Provider'ları AsyncNotifier'a dönüştür | `mobile/lib/features/buildings/presentation/providers/`<br>`mobile/lib/features/apartments/presentation/providers/` | 2 saat | 1. `FutureProvider` → `AsyncNotifierProvider`<br>2. Loading/error state UI<br>3. Shimmer loading |
| buildings_store.dart sil | `mobile/lib/features/buildings/data/buildings_store.dart` | 15 dk | 1. Dosya sil<br>2. Import'ları güncelle |
| apartments_store.dart sil | `mobile/lib/features/apartments/data/apartments_store.dart` | 15 dk | 1. Dosya sil<br>2. Import'ları güncelle |
| API constants dinamik fonksiyonlara dönüştür | `mobile/lib/core/constants/api_constants.dart` | 30 dk | 1. `static String buildingApartments(String id)` ekle<br>2. Diğer dinamik endpoint'ler |

**Doğrulama:**
- Emülatörde login → bina listesi API'den çekiliyor (dummy data yok)
- Bina seç → daire listesi API'den çekiliyor
- Loading state gösteriliyor, error handling çalışıyor

**Commit Message:**
```
feat: Dummy data → API entegrasyonu (Aşama 1.1)

- BuildingsRemoteDatasource + Repository
- ApartmentsRemoteDatasource + Repository
- Provider'ları AsyncNotifier'a dönüştür
- buildings_store.dart ve apartments_store.dart sil
- API constants dinamik fonksiyonlar
- Shimmer loading + error state UI
- HATA_ANALIZ_RAPORU.md #5 kapatıldı
- AIDATPANEL_GAP_ANALIZI.md G05-G08 kapatıldı
```

---

### 1.2 Due Modülü Data Layer (2 gün)

**Yapılacak:**
```
features/dues/data/
├── models/
│   ├── due_model.dart           (freezed + json_serializable)
│   └── due_dto.dart             (API response mapping)
├── datasources/
│   └── dues_remote_datasource.dart
│       - getBuildings() → GET /api/v1/buildings/:id/dues
│       - createBulkDues() → POST /api/v1/buildings/:id/dues/bulk
│       - updateDueStatus() → PATCH /api/v1/dues/:id/status
└── repositories/
    └── dues_repository_impl.dart
```

**Subtask'lar:**
1. DueModel (freezed): id, buildingId, apartmentId, amount (Decimal), dueDate, status (PAID/PENDING/OVERDUE/WAIVED), createdAt
2. DueDTO: API response mapping
3. DuesRemoteDatasource: 3 endpoint
4. DuesRepository impl: exception handling

**Doğrulama:**
- `flutter analyze` 0 issue
- Model serialization test

---

### 1.3 Due Modülü Domain Layer (1 gün)

**Yapılacak:**
```
features/dues/domain/
├── entities/due_entity.dart     (DueStatus enum)
├── repositories/dues_repository.dart
└── usecases/
    ├── get_dues_by_building.dart
    ├── get_dues_by_apartment.dart
    ├── get_my_dues.dart          (Resident)
    ├── create_bulk_dues.dart     (Manager)
    └── update_due_status.dart
```

**Subtask'lar:**
1. DueEntity + DueStatus enum
2. DuesRepository interface
3. 5 UseCase (Clean Architecture)

---

### 1.4 Due Modülü Presentation Layer (4-5 gün)

**Yapılacak:**
```
features/dues/presentation/
├── providers/
│   ├── dues_provider.dart       (AsyncNotifier)
│   └── due_form_provider.dart   (Form state)
├── screens/
│   ├── manager_dues_screen.dart      (bina bazlı liste + filtre)
│   ├── apartment_dues_screen.dart    (daire bazlı)
│   ├── create_bulk_dues_screen.dart  (ay/tutar formu)
│   └── resident_dues_screen.dart     (Aidatlarım)
└── widgets/
    ├── due_list_item.dart
    ├── due_status_badge.dart         (renk+yazı birlikte)
    ├── due_filter_chip.dart
    └── mark_paid_dialog.dart         (geri dönülemez → onay zorunlu)
```

**Subtask'lar:**
1. Manager dues screen: Tüm aidatlar, bina/daire/durum filtresi, pull-to-refresh
2. Apartment dues screen: Daire bazlı aidatlar
3. Create bulk dues: Ay seç + tutar gir + toplu oluştur
4. Resident dues screen: Kendi aidatları, durum göster
5. Widgets: Status badge (renk+yazı), filter chip, mark paid dialog
6. Error handling + loading state

**Doğrulama:**
- Manager: Tüm aidatları görüyor, filtreleme çalışıyor, toplu oluşturma çalışıyor
- Resident: Kendi aidatlarını görüyor
- 50+ yaş uyumlu (16sp font, 48dp touch)

---

### 1.5 Router Entegrasyonu

**Yapılacak:**
1. GoRouter'a rotalar ekle:
   - `/manager/dues` → manager_dues_screen
   - `/manager/dues/create` → create_bulk_dues_screen
   - `/manager/apartment/:id/dues` → apartment_dues_screen
   - `/resident/dues` → resident_dues_screen

2. Manager BottomNav'a "Aidat" tab'ı ekle
3. Resident BottomNav'a "Aidatlarım" tab'ı ekle

---

### Aşama 1 Definition of Done

- [ ] Manager: Tüm aidatları görme + filtreleme (bina/daire/durum)
- [ ] Manager: Toplu aidat oluşturma (ay + tutar)
- [ ] Manager: Ödendi/Ödenmedi işaretleme (onay dialog zorunlu)
- [ ] Resident: Kendi aidat geçmişi (pull-to-refresh)
- [ ] Backend 44 endpoint'ten 4 adet (dues CRUD) tam entegrasyon
- [ ] Dummy data hiçbir yerde yok
- [ ] 50+ yaş uyumlu (16sp font, 48dp touch, BottomNav)
- [ ] `flutter analyze` 0 issue
- [ ] Emülatör test: Login → bina seç → aidat listesi → toplu aidat oluştur → ödendi işaretle
- [ ] Git tag: **v0.1.0** oluştur
- [ ] CHANGELOG.md güncelle

**Tahmini Süre:** 1-2 hafta (Furkan %40 yük)

---

## 🛡️ AŞAMA 2 — GÜVENLİK HARDENING (1 HAFTA)

**Sorumlu:** Furkan (Flutter) + Abdullah (Backend) + Yusuf (destek)  
**Hedef:** Production-ready güvenlik, <200ms API latency

### 2.1 Flutter Güvenlik (2-3 gün)

**Yapılacak:**
- [ ] Input validation (tüm form'lar: regex + min/max)
- [ ] Debug log'ları `kDebugMode` check ile koru
- [ ] ProGuard/R8 obfuscation (`android/app/build.gradle`)
- [ ] iOS release build `--obfuscate` flag
- [ ] Certificate pinning (`ssl_pinning_plugin`)
- [ ] `getStoredUser()` tam veri saklar (JSON encode)

**Doğrulama:**
- Release APK decompile → class isimleri okunmaz
- Charles Proxy MITM → bağlantı reddedildi

---

### 2.2 Backend Güvenlik (Abdullah, 2-3 gün)

**Yapılacak:**
- [ ] Helmet.js entegrasyonu (security headers)
- [ ] `express-rate-limit` (auth endpoint'lerde 5/dk)
- [ ] Input sanitization middleware
- [ ] CORS whitelist (sadece `aidatpanel.com` + development)
- [ ] Joi/Zod ile request body validation

---

### 2.3 Optimizasyon (2 gün)

**Yapılacak:**
- [ ] Prisma query optimization (N+1 detection)
- [ ] API pagination (default limit 50)
- [ ] Image caching (`cached_network_image` + shimmer)
- [ ] Backend response compression (gzip)

**Doğrulama:**
- API ortalama yanıt süresi <200ms (10 test)
- Flutter 60 FPS (DevTools Performance)

---

### Aşama 2 Definition of Done

- [ ] Security audit: Critical/High zafiyet sıfır
- [ ] API ortalama yanıt süresi <200ms
- [ ] Flutter 60 FPS (DevTools verified)
- [ ] Release APK decompile → class isimleri okunmaz
- [ ] Charles Proxy MITM → bağlantı reddedildi
- [ ] Git tag: **v0.2.0**

---

## 🔔 AŞAMA 3 — BİLDİRİM & i18n (1 HAFTA)

**Sorumlu:** Seyit (Primary) + Abdullah (FCM backend) + Furkan (Flutter entegrasyon)

### 3.1 FCM Push Notification (3-4 gün)

**Yapılacak:**
- [ ] `FirebaseMessaging.instance.requestPermission()` (main.dart)
- [ ] Foreground handler: `onMessage.listen(...)`
- [ ] Background handler: `onBackgroundMessage`
- [ ] Notification tap: `onMessageOpenedApp` (deep link)
- [ ] Local notifications (`flutter_local_notifications`)
- [ ] FCM token sync: `PUT /api/me/fcm-token`
- [ ] Notification listesi ekranı
- [ ] Backend: bildirim tetikleyici service

---

### 3.2 i18n (2-3 gün)

**Yapılacak:**
- [ ] `app_tr.arb` doldur (tüm UI string'leri)
- [ ] `app_en.arb` çevirisi
- [ ] `flutter_localizations` setup
- [ ] Tüm UI'da hardcoded string temizliği
- [ ] Dil değiştirme persistence
- [ ] Settings ekranı: dil seçimi dropdown

---

### Aşama 3 Definition of Done

- [ ] Firebase Console'dan manuel push → cihazda gözüküyor
- [ ] Arka planda push → tıklayınca ilgili ekran açılıyor
- [ ] Türkçe/İngilizce tam çeviri
- [ ] UI'da yasak terimler yok (dashboard, sync, toggle, payload, cache)
- [ ] Git tag: **v0.3.0**

---

## 💳 AŞAMA 4 — REVENUECAT ABONELİK (1 HAFTA)

**Sorumlu:** Furkan (Flutter) + Abdullah (Backend webhook)  
**Hedef:** İş modeli aktif (aylık ₺99 / yıllık ₺799)

### 4.1 RevenueCat Flutter (3-4 gün)

**Yapılacak:**
- [ ] `Purchases.configure()` (main.dart)
- [ ] API key'ler `.env` + `--dart-define`
- [ ] `SubscriptionProvider` (Riverpod): status stream
- [ ] `features/subscription/presentation/paywall_screen.dart`
- [ ] Offerings/Packages fetch + UI kartları
- [ ] Purchase flow + error handling
- [ ] Restore purchases butonu
- [ ] Subscription durum ekranı (Profil)

---

### 4.2 Kilit Mantığı (Manager Özellikleri)

**Yapılacak:**
- [ ] Yeni bina ekleme → subscription.active check → paywall fallback
- [ ] Yeni aidat oluşturma → aynı
- [ ] PDF rapor → aynı
- [ ] Toplu bildirim → aynı

---

### 4.3 Backend Webhook (Abdullah, 2 gün)

**Yapılacak:**
- [ ] `POST /api/subscription/webhook/revenuecat` (5 event handler)
- [ ] `INITIAL_PURCHASE` → subscription aktifle
- [ ] `RENEWAL` → süre uzat
- [ ] `CANCELLATION` → kapatma işaretle
- [ ] `EXPIRATION` → pasifle, FCM bildir
- [ ] `BILLING_ISSUE` → mail + push
- [ ] Webhook signature verification

---

### Aşama 4 Definition of Done

- [ ] App Store sandbox / Play Store test track satın alma başarılı
- [ ] Abonelik dolunca manager özellikleri kilitleniyor
- [ ] Webhook event'leri DB'ye yansıyor
- [ ] Grace period handling test edildi
- [ ] Git tag: **v0.4.0** (🎉 Faz 2 Tamamlandı — MVP-2)

---

## 🎫 AŞAMA 5 — TICKET SİSTEMİ (2 HAFTA) — FAZ 3

**Sorumlu:** Furkan (Primary)

### 5.1 Ticket Modülü (Clean Architecture)

```
features/tickets/
├── data/models, datasources, repositories
├── domain/entities, repositories, usecases
└── presentation/
    ├── providers/
    └── screens/
        ├── resident_create_ticket_screen.dart
        ├── resident_ticket_list_screen.dart
        ├── manager_ticket_list_screen.dart
        └── manager_ticket_detail_screen.dart  (chat-like UI)
```

### 5.2 Özellikler

- [ ] Sakin: Ticket oluşturma (kategori + açıklama + opsiyonel foto)
- [ ] Sakin: Kendi ticket'larının listesi + durumu
- [ ] Yönetici: Bina bazlı tüm ticket'lar + filtreleme
- [ ] Yönetici: Ticket detay + durum değiştirme + yanıt (TicketUpdate)
- [ ] Chat-like UI (message bubble)
- [ ] Bildirim: Ticket güncellemesi → sakine push

---

### Aşama 5 Definition of Done

- [ ] 4 ekran tamam, API entegrasyonu tam
- [ ] Durum değişimlerinde otomatik push
- [ ] Git tag: **v0.5.0**

---

## 📄 AŞAMA 6 — GİDER & PDF RAPOR (2 HAFTA) — FAZ 3

**Sorumlu:** Yusuf (Gider API desteği), Furkan (Flutter), Abdullah (PDF backend)

### 6.1 Gider Kaydı (1 hafta)

**Yapılacak:**
- [ ] Expense modülü (Clean Architecture)
- [ ] 8 kategori: CLEANING, ELEVATOR, ELECTRICITY, WATER, INSURANCE, REPAIR, GARDEN, OTHER
- [ ] Aylık gider listesi + kategori filtresi
- [ ] Gider ekleme formu (+ opsiyonel fiş foto)
- [ ] Aylık özet endpoint: `GET /api/buildings/:id/expenses/summary`

---

### 6.2 PDF Rapor (1 hafta)

**Yapılacak:**
- [ ] Backend PDF generation (Abdullah — puppeteer veya pdfkit)
- [ ] Template: Aylık aidat durumu + gelir/gider özeti
- [ ] Flutter'da PDF indirme (`dio` + platform download)
- [ ] Flutter'da PDF görüntüleme (`flutter_pdfview`)
- [ ] Yönetici ekranı: "Aylık Rapor İndir" butonu (subscription kilidi)

---

### Aşama 6 Definition of Done

- [ ] 8 kategoride gider kaydı çalışıyor
- [ ] PDF rapor hem iOS hem Android'de açılıyor
- [ ] Abonelik kilidi aktif
- [ ] Git tag: **v1.0.0-rc1** (🎉 Faz 3 Tamamlandı — MVP Final)

---

## 📅 TAKVİM

| Aşama | Süre | Başlangıç | Bitiş | Sürüm |
|-------|------|-----------|-------|-------|
| **Aşama 0** | 1-2 gün | 2026-05-04 | 2026-05-05 | v0.0.9 |
| **Aşama 1** | 1-2 hafta | 2026-05-05 | 2026-05-19 | v0.1.0 |
| **Aşama 2** | 1 hafta | 2026-05-19 | 2026-05-26 | v0.2.0 |
| **Aşama 3** | 1 hafta | 2026-05-26 | 2026-06-02 | v0.3.0 |
| **Aşama 4** | 1 hafta | 2026-06-02 | 2026-06-09 | **v0.4.0 (Faz 2 ✅)** |
| **Aşama 5** | 2 hafta | 2026-06-09 | 2026-06-23 | v0.5.0 |
| **Aşama 6** | 2 hafta | 2026-06-23 | 2026-07-07 | **v1.0.0-rc1 (Faz 3 ✅)** |
| **Buffer + QA** | 1 hafta | 2026-07-07 | 2026-07-14 | v1.0.0 |

**🎯 HEDEF:** 2026-07-14'te **AidatPanel v1.0.0** App Store + Play Store'a hazır.

**Toplam süre:** ~10 hafta (buffer dahil)

---

## ⚠️ RİSK MATRİSİ

| # | Risk | Olasılık | Etki | Azaltma |
|---|------|----------|------|---------|
| 1 | **Furkan bus factor = 1** | Orta | 🔴 Kritik | Knowledge transfer (haftalık pair programming, Yusuf/Seyit mentorluğu), checkpoint ilerleme |
| 2 | Aşama 0 uygulanmadan production deploy | Düşük | 🔴 Kritik | Aşama 0 bloker kuralı, v0.0.9 tag'i olmadan deploy yasak |
| 3 | Backend API değişikliği | Düşük | 🟡 Yüksek | `/api/v1/` versioning, Swagger dokümantasyonu (Aşama 2'ye eklenecek) |
| 4 | RevenueCat sandbox karmaşası | Orta | 🟡 Yüksek | Backend webhook önce hazır, Apple Developer + Play Console erken kurulum |
| 5 | 50+ yaş UX sorunları | Orta | 🟡 Orta | Erken beta (Furkan'ın babası + tanıdık ağı), feedback döngüsü |
| 6 | Test coverage %0 | Yüksek | 🟡 Orta | Her aşamada min 3 kritik path test (Aşama 5+'te hedef %30) |
| 7 | KVKK uyumu | Düşük | 🔴 Kritik | `DELETE /api/me` Aşama 1'de, Gizlilik politikası landing page'de |
| 8 | App Store reddi (Kids Category) | Düşük | 🟡 Orta | "Finance" kategorisi seçimi, gizlilik anketleri doğru doldur |

---

## 🎛️ CHECKPOINT PROTOKOLÜ

Furkan'ın çalışma stili: **2-3 saatte bir checkpoint + Genshin/Valorant reset molası**.

### Günlük Ritim

- **09:00–12:00** Sabah bloğu (2 checkpoint)
- **12:00–13:00** Öğle + reset
- **13:00–17:00** Öğleden sonra bloğu (2-3 checkpoint)
- **17:00–17:15** Günlük standup (Abdullah + Furkan async Discord)

### Her Checkpoint Sonrası

- [ ] Git commit (semantic message)
- [ ] Emülatör test (`emulator-5554`)
- [ ] `flutter analyze` 0 issue
- [ ] PR güncelle / yorum ekle
- [ ] Lokal checkpoint dosyası: `checkpoints/YYYY-MM-DD_HH-MM.checkpoint.md`

### Haftalık Review (Cuma 17:00)

- Tamamlanan checkpoint'ler
- Bloker/risk güncellemesi
- Sonraki hafta planı
- Knowledge transfer (junior pair programming)

### Aşama Bitiş Review

- [ ] Aşama DoD tam
- [ ] Git tag (vX.Y.Z)
- [ ] CHANGELOG.md güncellemesi
- [ ] Demo (ekibe 15 dk)
- [ ] Sonraki aşama kick-off

---

## ✅ HEMEN YAPILACAKLAR (TODAY)

1. **Aşama 0.1 başla** — `api_constants.dart` HTTPS dönüşümü (15 dk)
2. **Abdullah haberdar** — SSL sertifikası + CloudPanel reverse proxy SSL termination
3. **Paralel:** Aşama 0.5-0.6 (versiyon + intl) — 15 dk
4. **Bugün sonuna kadar:** Aşama 0 tam bitmeli → **v0.0.9** tag
5. **Lokal checkpoint:** `checkpoints/2026-05-04_14-XX.checkpoint.md` oluştur

---

## 🎯 KRİTİK BAŞARI FAKTÖRLERİ

1. **Aşama 0 zorunluluğu** — Hiçbir feature geliştirmesi kritik güvenlik hatalarıyla canlıya çıkmaz
2. **Furkan ritmi** — Checkpoint + reset molası + günlük standup
3. **Abdullah review hızı** — PR'lar 24 saat içinde review (bottleneck olmasın)
4. **Yusuf/Seyit aktivasyonu** — Aşama 3+'te knowledge transfer başlasın
5. **50+ yaş odağı** — Her feature'da erişilebilirlik checklist
6. **Test kültürü başlangıcı** — Aşama 5'ten itibaren %30 coverage hedef

---

## 📁 ÇAPRAZ REFERANSLAR

| Dosya | Amaç |
|-------|------|
| `planning/AIDATPANEL.md` | Master reference (stack, DB, API, UI) |
| `planning/MASTER_PROMPTU.md` | AI Co-Founder kişilik prompt'u |
| `planning/AGENTS_PROMPTU.md` | AGENTS.md üretim talimatı |
| `planning/GOREVDAGILIMI.md` | Orijinal ekip yapısı (v1.0) |
| `HATA_ANALIZ_RAPORU.md` | 15 kritik hata tespiti (Aşama 0-2 kaynağı) |
| `AGENTS_COMPLIANCE_AUDIT.md` | Kod uyumluluk skoru %75 (her aşamada checklist) |
| `analiz_raporlari/4-aidatpanel_analizi/AIDATPANEL_GAP_ANALIZI.md` | Gap'ler → Aşama mapping'i |
| `analiz_raporlari/6-guvenlik_promptu_analizi/SECURITY_AUDIT.md` | 11 güvenlik zafiyeti (Aşama 0 + 2.2 kaynağı) |
| `analiz_raporlari/5-optimizasyon_promptu_analizi/OPTIMIZATIONS.md` | 12 optimizasyon bulgusu (Aşama 2 kaynağı) |
| `analiz_raporlari/3-gorevdagilimi_analizi/GOREVDAGILIMI_GELISTIRILMIS.md` | Ekip standartları + DoD şablonları (v3.0) |

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-03 | İlk yol haritası (6 aşama, Faz 2-3 planı) |
| v2.0 | 2026-05-04 | Yenilenmiş versiyon: Aşama 0 eklendi, HATA_ANALIZ entegrasyonu |
| **v3.0** | **2026-05-04** | **Operasyonel detay + Furkan profili:**<br>• Aşama 0-6 tam detaylandırıldı (görevler, subtask'lar, DoD, risk)<br>• Furkan ritmi entegre edildi (2-3 saatlik checkpoint blokları, reset molası)<br>• Analiz raporlarıyla çapraz referanslar (AGENTS_COMPLIANCE, SECURITY, OPTIMIZATIONS, GAP_ANALIZI)<br>• Her aşamada AGENTS.md checklist'i (50+ yaş, Türkçe, ListView.builder, HTTPS, JWT)<br>• Commit message template'leri eklendi<br>• Risk matrisi 8 risk × azaltma stratejisi<br>• Checkpoint protokolü (lokal dosya + hard reset mekanizması)<br>• Takvim: 10 hafta, buffer haftası, v1.0.0 hedefi 2026-07-14 |

---

**🚀 SONRAKİ ADIM:** Aşama 0.1 başlat — `api_constants.dart` HTTP → HTTPS (15 dakika).

**Durum:** 🟢 Yol haritası operasyonel, ekip başlamaya hazır.
