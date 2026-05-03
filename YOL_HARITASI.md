# 🗺️ AIDATPANEL - KAPSAMLI YOL HARİTASI

**Versiyon:** 2.0 (Yenilenmiş)  
**Tarih:** 2026-05-04  
**Proje Versiyonu:** v0.0.8 → Hedef: v1.0.0  
**Branch:** `mobile/flutter-app`  
**Hazırlayan:** AI Co-Founder (Furkan profili ile)  
**Durum:** 🔴 **Aşama 0 (Acil Güvenlik) başlatılmalı** — Faz 2 geliştirmesi öncesi

---

## 🎯 ÖNEMLİ: ÖNCE OKU

Bu belge **tek doğruluk kaynağı (source of truth)** niteliğinde bir sprint yol haritasıdır. İçerdiği 7 aşama (0 → 6), somut checkpoint'ler ve takvim ile AidatPanel v1.0.0'a kadar gidecek tüm sürümleri tanımlar.

### Çapraz Referanslar
- `HATA_ANALIZ_RAPORU.md` — 15 kritik hata tespiti (bu belgenin Aşama 0-2 temeli)
- `analiz_raporlari/4-aidatpanel_analizi/AIDATPANEL_GAP_ANALIZI.md` — Referans vs kod gap analizi
- `analiz_raporlari/3-gorevdagilimi_analizi/GOREVDAGILIMI_GELISTIRILMIS.md` — Ekip standartları + DoD şablonları
- `planning/AIDATPANEL.md` — Master reference dökümanı

---

## 📊 GENEL DURUM ÖZETİ

### Proje Sağlık Kartı (v0.0.8)

| Metrik | Durum | Detay |
|--------|-------|-------|
| **Kod Kalitesi** | 🟡 Orta | Clean Architecture temel yapı var, 15 kritik hata (HATA_ANALIZ) |
| **Faz Tamamlama** | 🟡 %40 | Faz 1 tamam (auth + bina + daire UI), Faz 2 başlamadı |
| **Güvenlik** | 🔴 **YÜKSEK RİSK** | HTTP (HTTPS yok), token expiry hatalı, refresh döngü riski |
| **Backend Entegrasyonu** | 🔴 Eksik | Dummy data kullanılıyor, API bağlantısı yok |
| **Optimizasyon** | 🟡 Orta | Debug build, ListView perf sorunu, obfuscation yok |
| **Test Coverage** | 🔴 %0 | Unit/widget/integration test yok |
| **Dokümantasyon** | 🟢 İyi | `planning/` + analiz raporları kapsamlı |
| **Deployment Hazırlığı** | 🔴 Hazır Değil | HTTPS + ProGuard + pinning + CI/CD eksik |

### Ekip Durumu

| Üye | Rol | Mevcut Durum | Bus Factor |
|-----|-----|--------------|------------|
| **Abdullah** | Lead Developer | Backend tamam (Node.js + Prisma + 44 endpoint) | 🟢 Dağıtılabilir |
| **Furkan** | Senior Mobile | Flutter Core aktif | 🔴 **Tek sorumlu** — Faz 2/3 modül geliştirmesi |
| **Yusuf** | Junior Full-Stack | Backend destek | 🟡 Faz 2'de daha aktif |
| **Seyit** | Junior UI/UX | UI kit temel | 🟡 Bildirim/i18n aşama 3'te aktif |

**⚠️ Kritik Not:** Furkan bus factor = 1. Knowledge transfer zorunlu (detay: `GOREVDAGILIMI_GELISTIRILMIS.md` §4).

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
│   ├── network/                 ⚠️ Dio + interceptor (refresh döngü RİSKİ)
│   ├── storage/                 ⚠️ secure_storage (token expiry HATALI)
│   └── utils/                   ✅ date_utils, currency_utils
├── features/
│   ├── auth/                    ⚠️ UI tamam, token handling hatalı
│   ├── dashboard/               ✅ Manager/Resident dashboard (temel)
│   ├── buildings/               ⚠️ UI var, DUMMY DATA kullanıyor
│   └── apartments/              ⚠️ UI var, DUMMY DATA kullanıyor
└── shared/widgets/              ✅ Loading, Error, Empty
```

#### ❌ Eksik (Faz 2-3'te Yapılacak)
```
mobile/lib/features/
├── dues/                        ❌ KLASÖR BİLE YOK — AidatPanel'in ana modülü
├── expenses/                    ❌ Faz 3
├── tickets/                     ❌ Faz 3
├── notifications/               ⚠️ FCM kurulu, handler yok
├── reports/                     ❌ PDF rapor (Faz 2)
└── subscription/                ⚠️ purchases_flutter kurulu, Purchases.configure() yok
```

### Backend (backend/) — Abdullah
- ✅ PostgreSQL + Prisma (10 model, 7 enum)
- ✅ JWT auth (access 15dk, refresh 30g)
- ✅ 44 API endpoint tanımlı ve çalışıyor
- ✅ RevenueCat webhook endpoint hazır
- ⚠️ Rate limiting yok, Helmet.js yok, Swagger yok

---

## 🚨 AŞAMA 0 — ACİL GÜVENLİK (BUGÜN, 1-2 GÜN)

> **🔴 PRODUCTION'A ÇIKMADAN ÖNCE ZORUNLU**

**Sorumlu:** Furkan (Flutter) + Abdullah (SSL)  
**Kaynak:** `HATA_ANALIZ_RAPORU.md` Aşama A + `AIDATPANEL_GAP_ANALIZI.md` A.1-A.4

### Görevler

| # | Gap | Dosya | Efor |
|---|-----|-------|------|
| 0.1 | HTTP → HTTPS protokol | `api_constants.dart:2` | 15 dk |
| 0.2 | Token expiry 30g → 15dk düzelt (3 konum) | `auth_repository_impl.dart:47-48, 79-80, 111-112` | 1 saat |
| 0.3 | DioClient refresh için ayrı Dio instance | `dio_client.dart:74-76` | 30 dk |
| 0.4 | `ListView` → `ListView.builder` (4 konum) | `invite_code_screen.dart` (2x), `add_building_screen.dart`, `invite_code_result_view.dart` | 1 saat |
| 0.5 | `version: 0.0.8` → `0.0.8+1` | `pubspec.yaml:5` | 5 dk |
| 0.6 | `intl: ^0.20.2` → `^0.19.0` | `pubspec.yaml:30` | 10 dk |

### Aşama 0 Definition of Done
- [ ] HTTPS üzerinden istekler başarılı (Cloudflare SSL Full/strict)
- [ ] Access token 15 dakika sonra refresh tetikleniyor
- [ ] Refresh başarısızlığı sonsuz döngü yaratmıyor
- [ ] 100 item'lı ListView 60 FPS scroll
- [ ] `flutter analyze` 0 issue
- [ ] Git tag: **v0.0.9** (Aşama 0 bitince)

**🔒 BLOKER:** Bu aşama tamamlanmadan Aşama 1 başlamaz.

---

## 🎯 AŞAMA 1 — AİDAT SİSTEMİ (1-2 HAFTA)

**Sorumlu:** Furkan (Primary), Abdullah (API review)  
**Hedef:** AidatPanel'in ana modülü çalışır durumda

### 1.1 Pre-Work: Dummy Data Temizliği + API Entegrasyonu (2-3 gün)

| Görev | Dosya |
|-------|-------|
| `BuildingsRemoteDatasource` oluştur | yeni |
| `BuildingsRepository` interface + impl | yeni |
| `ApartmentsRemoteDatasource` oluştur | yeni |
| `ApartmentsRepository` interface + impl | yeni |
| Provider'ları `AsyncNotifier`/`FutureProvider` ile güncelle | mevcut |
| `buildings_store.dart` sil | `buildings/data/buildings_store.dart` |
| `apartments_store.dart` sil | `apartments/data/apartments_store.dart` |
| API constants dinamik fonksiyonlara dönüştür | `api_constants.dart` |
| Shimmer loading + error state UI | feature-wide |

### 1.2 Due Modülü Data Layer (2 gün)
```
features/dues/
├── data/
│   ├── models/
│   │   ├── due_model.dart           (freezed + json_serializable)
│   │   └── due_dto.dart
│   ├── datasources/
│   │   └── dues_remote_datasource.dart
│   └── repositories/
│       └── dues_repository_impl.dart
```

### 1.3 Due Modülü Domain Layer (1 gün)
```
features/dues/domain/
├── entities/due_entity.dart         (DueStatus enum: PAID/PENDING/OVERDUE/WAIVED)
├── repositories/dues_repository.dart
└── usecases/
    ├── get_dues_by_building.dart
    ├── get_dues_by_apartment.dart
    ├── get_my_dues.dart              (Resident için)
    ├── create_bulk_dues.dart         (Manager toplu)
    └── update_due_status.dart
```

### 1.4 Due Modülü Presentation Layer (4-5 gün)
```
features/dues/presentation/
├── providers/
│   ├── dues_provider.dart
│   └── due_form_provider.dart
├── screens/
│   ├── manager_dues_screen.dart      (bina bazlı liste + filtre)
│   ├── apartment_dues_screen.dart    (daire bazlı)
│   ├── create_bulk_dues_screen.dart  (ay/tutar formu)
│   └── resident_dues_screen.dart     (Aidatlarım)
└── widgets/
    ├── due_list_item.dart
    ├── due_status_badge.dart         (renk+yazı birlikte, sadece renk YASAK)
    ├── due_filter_chip.dart
    └── mark_paid_dialog.dart         (geri dönülemez → onay zorunlu)
```

### 1.5 Entegrasyon
- [ ] Router'a rotalar (`/manager/dues`, `/manager/dues/create`, `/manager/apartment/:id/dues`, `/resident/dues`)
- [ ] Manager BottomNav'a "Aidat" tab'ı ekle
- [ ] Resident BottomNav'a "Aidatlarım" tab'ı ekle

### Aşama 1 Definition of Done
- [ ] Manager: Tüm aidatları görme + filtreleme (bina/daire/durum)
- [ ] Manager: Toplu aidat oluşturma (ay + tutar)
- [ ] Manager: Ödendi/Ödenmedi işaretleme (onay dialog zorunlu)
- [ ] Resident: Kendi aidat geçmişi (pull-to-refresh)
- [ ] Backend 44 endpoint'ten 4 adet (dues CRUD) tam entegrasyon
- [ ] Dummy data hiçbir yerde yok
- [ ] 50+ yaş uyumlu (16sp font, 48dp touch, BottomNav)
- [ ] `flutter analyze` 0 issue
- [ ] Git tag: **v0.1.0** (Faz 2 başlangıcı)

---

## 🛡️ AŞAMA 2 — GÜVENLİK HARDENING (1 HAFTA)

**Sorumlu:** Furkan (Flutter) + Abdullah (Backend) + Yusuf (destek)  
**Hedef:** Production-ready güvenlik

### 2.1 Flutter Güvenlik (2-3 gün)
- [ ] Input validation (tüm form'lar için regex + min/max)
- [ ] Debug log'ları `kDebugMode` check ile koru
- [ ] ProGuard/R8 obfuscation (`android/app/build.gradle`)
- [ ] iOS release build `--obfuscate` flag
- [ ] Certificate pinning (`dio_certificate_pinning` veya `ssl_pinning_plugin`)
- [ ] `getStoredUser()` tam veri saklar (JSON encode)

### 2.2 Backend Güvenlik (Abdullah, 2-3 gün)
- [ ] Helmet.js entegrasyonu (security headers)
- [ ] `express-rate-limit` yapılandırması (auth endpoint'lerde 5/dk)
- [ ] Input sanitization middleware (xss-clean, express-mongo-sanitize alternatifi)
- [ ] CORS whitelist (sadece `aidatpanel.com` + development)
- [ ] Joi/Zod ile request body validation

### 2.3 Optimizasyon (2 gün)
- [ ] Prisma query optimization (N+1 detection, `include`/`select` review)
- [ ] API pagination (default limit 50, cursor-based)
- [ ] Image caching stratejisi (`cached_network_image` + shimmer)
- [ ] Backend response compression (gzip)

### Aşama 2 Definition of Done
- [ ] Security audit: Critical/High zafiyet sıfır
- [ ] API ortalama yanıt süresi <200ms (10 test)
- [ ] Flutter 60 FPS (DevTools Performance ile doğrulanmış)
- [ ] Release APK decompile edildiğinde class isimleri okunmaz
- [ ] Charles Proxy MITM → bağlantı reddedildi
- [ ] Git tag: **v0.2.0**

---

## 🔔 AŞAMA 3 — BİLDİRİM & i18n (1 HAFTA)

**Sorumlu:** Seyit (Primary) + Abdullah (FCM backend) + Furkan (Flutter entegrasyon)

### 3.1 FCM Push Notification (3-4 gün)
- [ ] `FirebaseMessaging.instance.requestPermission()` (main.dart)
- [ ] Foreground handler: `FirebaseMessaging.onMessage.listen(...)`
- [ ] Background handler (top-level fonksiyon): `onBackgroundMessage`
- [ ] Notification tap: `onMessageOpenedApp` (deep link)
- [ ] Local notifications (`flutter_local_notifications`)
- [ ] FCM token sync: `PUT /api/me/fcm-token`
- [ ] Notification listesi ekranı (Seyit)
- [ ] Backend: bildirim tetikleyici service (aidat hatırlatma cron)

### 3.2 i18n (2-3 gün)
- [ ] `app_tr.arb` doldur (tüm UI string'leri)
- [ ] `app_en.arb` çevirisi
- [ ] `flutter_localizations` setup
- [ ] Tüm UI'da hardcoded string temizliği → `AppLocalizations.of(context)`
- [ ] Dil değiştirme persistence (`SharedPreferences` veya `SecureStorage`)
- [ ] Settings ekranı: dil seçimi dropdown

### Aşama 3 Definition of Done
- [ ] Firebase Console'dan manuel push → cihazda gözüküyor
- [ ] Arka planda push → tıklayınca ilgili ekran açılıyor
- [ ] Türkçe/İngilizce tam çeviri (hardcoded string kalmadı)
- [ ] UI'da yasak terimler yok (dashboard, sync, toggle, payload, cache)
- [ ] Git tag: **v0.3.0**

---

## 💳 AŞAMA 4 — REVENUECAT ABONELİK (1 HAFTA)

**Sorumlu:** Furkan (Flutter) + Abdullah (Backend webhook)  
**Hedef:** İş modeli aktif (aylık ₺99 / yıllık ₺799)

### 4.1 RevenueCat Flutter (3-4 gün)
- [ ] `Purchases.configure()` (main.dart, platform-aware)
- [ ] API key'ler `.env` + `--dart-define`
- [ ] `SubscriptionProvider` (Riverpod): status stream
- [ ] `features/subscription/presentation/paywall_screen.dart`
- [ ] Offerings/Packages fetch + UI kartları
- [ ] Purchase flow + error handling
- [ ] Restore purchases butonu
- [ ] Subscription durum ekranı (Profil altında)

### 4.2 Kilit Mantığı (Manager Özellikleri)
- [ ] Yeni bina ekleme → subscription.active check → paywall fallback
- [ ] Yeni aidat oluşturma → aynı
- [ ] PDF rapor → aynı
- [ ] Toplu bildirim → aynı
- [ ] Kilit UI: "Aboneliğinizi yenileyin" + abonelik butonu

### 4.3 Backend Webhook (Abdullah, 2 gün)
- [ ] `POST /api/subscription/webhook/revenuecat` (5 event handler)
- [ ] `INITIAL_PURCHASE` → subscription aktifle
- [ ] `RENEWAL` → süre uzat
- [ ] `CANCELLATION` → kapatma işaretle
- [ ] `EXPIRATION` → pasifle, FCM bildir
- [ ] `BILLING_ISSUE` → kullanıcıya mail + push
- [ ] Webhook signature verification

### Aşama 4 Definition of Done
- [ ] App Store sandbox / Google Play test track satın alma başarılı
- [ ] Abonelik dolunca manager özellikleri kilitleniyor
- [ ] Webhook event'leri DB'ye yansıyor (test log ile kanıt)
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

### Aşama 5 Definition of Done
- [ ] 4 ekran tamam, API entegrasyonu tam
- [ ] Durum değişimlerinde otomatik push
- [ ] Git tag: **v0.5.0**

---

## 📄 AŞAMA 6 — GİDER & PDF RAPOR (2 HAFTA) — FAZ 3

**Sorumlu:** Yusuf (Gider API desteği), Furkan (Flutter), Abdullah (PDF backend)

### 6.1 Gider Kaydı (1 hafta)
- [ ] Expense modülü (Clean Architecture)
- [ ] 8 kategori: CLEANING, ELEVATOR, ELECTRICITY, WATER, INSURANCE, REPAIR, GARDEN, OTHER
- [ ] Aylık gider listesi + kategori filtresi
- [ ] Gider ekleme formu (+ opsiyonel fiş foto)
- [ ] Aylık özet endpoint: `GET /api/buildings/:id/expenses/summary`

### 6.2 PDF Rapor (1 hafta)
- [ ] Backend PDF generation (Abdullah — puppeteer veya pdfkit)
- [ ] Template: Aylık aidat durumu + gelir/gider özeti
- [ ] Flutter'da PDF indirme (`dio` + platform download)
- [ ] Flutter'da PDF görüntüleme (`flutter_pdfview` veya native intent)
- [ ] Yönetici ekranı: "Aylık Rapor İndir" butonu (subscription kilidi)

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
| 1 | **Furkan bus factor = 1** | Orta | 🔴 Kritik | Knowledge transfer (haftalık pair programming, `GOREVDAGILIMI_GELISTIRILMIS.md` §4), checkpoint ilerleme |
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

1. **v0.0.8 checkpoint al** — mevcut durumu git tag olarak kaydet (`v0.0.8-pre-hardening`)
2. **Aşama 0.1 başla** — `api_constants.dart` HTTPS dönüşümü
3. **Abdullah haberdar** — SSL sertifikası + CloudPanel reverse proxy SSL termination
4. **Paralel:** Aşama 0.5-0.6 (versiyon + intl) — 15 dk
5. **Bugün sonuna kadar:** Aşama 0 tam bitmeli → **v0.0.9** tag

---

## 🎯 KRİTİK BAŞARI FAKTÖRLERİ

1. **Aşama 0 zorunluluğu** — Hiçbir feature geliştirmesi kritik güvenlik hatalarıyla canlıya çıkmaz
2. **Furkan ritmi** — Checkpoint + reset molası + günlük standup
3. **Abdullah review hızı** — PR'lar 24 saat içinde review (bottleneck olmasın)
4. **Yusuf/Seyit aktivasyonu** — Aşama 3+'te knowledge transfer başlasın
5. **50+ yaş odağı** — Her feature'da erişilebilirlik checklist (`AIDATPANEL.md` §10)
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
| `analiz_raporlari/1-master_promptu_analizi/FURKAN_AI_COFUNDER_MASTER_PROMPT.md` | Üretilen nihai master prompt |
| `analiz_raporlari/2-agents_promptu_analizi/AGENTS.md` | Üretilen AGENTS.md |
| `analiz_raporlari/3-gorevdagilimi_analizi/GOREVDAGILIMI_GELISTIRILMIS.md` | Ekip standartları + DoD şablonları (v2.0) |
| `analiz_raporlari/4-aidatpanel_analizi/AIDATPANEL_GAP_ANALIZI.md` | Gap analizi — bu belgenin Aşama 0-2 girdisi |

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-03 | İlk yol haritası (6 aşama, Faz 2-3 planı) |
| **v2.0** | **2026-05-04** | **Yenilenmiş versiyon:**<br>• Aşama 0 (Acil Güvenlik) eklendi — HATA_ANALIZ entegrasyonu<br>• Versiyon `0.0.8+1` hatası düzeltildi<br>• Dummy data temizliği + API constants hataları Aşama 1'e eklendi<br>• `features/dues/` klasörünün olmadığı doğrulandı (placeholder değil — sıfır)<br>• ListView performans gap'i Aşama 0'a dahil<br>• `intl` versiyonu uyumsuzluğu Aşama 0'da<br>• Her aşama için git tag + DoD zorunluluğu<br>• Çapraz referanslar (HATA_ANALIZ, GAP_ANALIZI, GELISTIRILMIS) eklendi<br>• Conversational kapanış yerine profesyonel doküman tonu<br>• Buffer haftası + v1.0.0 release hedefi (2026-07-14) |

---

**🚀 SONRAKİ ADIM:** Aşama 0.1 başlat — `api_constants.dart` HTTP → HTTPS (15 dakika).

**Durum:** 🟢 Yol haritası güncel, ekip hazırlanabilir.
