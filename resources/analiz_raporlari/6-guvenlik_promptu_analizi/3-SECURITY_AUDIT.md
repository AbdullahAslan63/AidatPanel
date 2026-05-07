# 3️⃣ SECURITY_AUDIT.md

## AIDATPANEL v0.0.9 - SECURITY AUDIT REPORT

**Versiyon:** 1.2 (Kod senkronizasyonu)  
**Tarih:** 2026-05-04 (19:45)  
**Kod Versiyonu:** v0.0.9  
**Hedef:** YOL_HARITASI.md v3.1 → Aşama 0 %90 tamamlandı, Aşama 2.2 beklemede  
**Denetçi:** AI Co-Founder (Senior Security Researcher rolünde)  
**Format:** GUVENLIK_PROMPTU.md standardı (Adversarial Mindset)

---

## ### SECURITY AUDIT: AidatPanel v0.0.9 Production Readiness

**Risk Assessment:** � **HIGH** (3 Critical zafiyet kapatıldı, 2 yeni konum önemli — Production'a çıkmadan K-03 ve K-08 düzeltilmeli)

### Durum Özeti
| Seviye | Toplam | Kapatıldı | Açık |
|--------|--------|-----------|------|
| 🔴 Critical | 3 | 3 | 0 |
| 🟡 High | 2 | 0 | 2 |
| 🟡 Medium | 4 | 0 | 4 |
| 🟢 Low | 2 | 0 | 2 |

---

#### **Findings:**

* **[HTTP instead of HTTPS]** (Severity: ✅ **KAPATILDI — 2026-05-04**)
* **Location:** `mobile/lib/core/constants/api_constants.dart:2`
* **The Exploit:** ❌ Artık uygulanamaz — zafiyet kapatıldı
  ```dart
  // ESKİ (önceden):
  static const String baseUrl = 'http://api.aidatpanel.com:4200'; // ❌ KAPATILDI
  // YENİ (şimdi):
  static const String baseUrl = 'https://api.aidatpanel.com:4200'; // ✅
  ```
* **Doğrulama:**
  - Android `network_security_config.xml` eklendi (`res/xml/`)
  - `usesCleartextTraffic="false"` ayarlandı
  - Cloudflare SSL yapılandırması (Abdullah tarafından yapılacak)
* **Kapatma Tarihi:** 2026-05-04
* **İlgili Raporlar:** `AGENTS_COMPLIANCE_AUDIT.md` K-03, `AIDATPANEL_GAP_ANALIZI.md` G01

---

* **[JWT Token Mismatch (Client 30g vs Server 15dk)]** (Severity: ✅ **KAPATILDI — 2026-05-04**)
* **Location:** `mobile/lib/features/auth/data/repositories/auth_repository_impl.dart:51,83,115` + `auth_provider.dart:124`
* **The Exploit:** ❌ Artık uygulanamaz — zafiyet kapatıldı
  ```dart
  // ESKİ (önceden): Duration(days: 30) ❌
  // YENİ (şimdi, 4 konum):
  await _secureStorage.saveTokenExpiry(
    DateTime.now().add(const Duration(minutes: 15)), // ✅ Doğru
  );
  ```
* **Doğrulama:**
  - 3 konumda `auth_repository_impl.dart` 15 dakika olarak ayarlandı
  - Mock login (`auth_provider.dart:124`) da aynı standarda çekildi
  - Aşama 0 fix'i bypass edilmiyor
* **Kapatma Tarihi:** 2026-05-04
* **İlgili Raporlar:** `AGENTS_COMPLIANCE_AUDIT.md` K-02, `AIDATPANEL_GAP_ANALIZI.md` G02

---

* **[DioClient Refresh Token Infinite Loop Risk]** (Severity: ✅ **KAPATILDI — 2026-05-04**)
* **Location:** `mobile/lib/core/network/dio_client.dart:37-44, 82-120`
* **The Exploit:** ❌ Artık uygulanamaz — zafiyet kapatıldı
  ```dart
  // ESKİ (önceden): _dio.post(ApiConstants.refresh, ...) — interceptor'lı ❌
  // YENİ (şimdi):
  class DioClient {
    late Dio _dio;
    late Dio _refreshDio; // ✅ Interceptor'sız instance
    
    // Constructor'da oluşturulup cached (satır 37-44)
    _refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    
    // Refresh'te _refreshDio kullanılıyor (satır 87)
    final response = await _refreshDio.post(ApiConstants.refresh, ...);
  }
  ```
* **Doğrulama:**
  - `_refreshDio` constructor'da oluşturulup cached (tek bir instance)
  - Her 401'de reuse ediliyor (memory allocation azaltıldı)
  - Interceptor'sız olduğu için sonsuz döngü engellendi
  - Refresh başarısız olursa clearAll + logout (satır 111-118)
* **Kapatma Tarihi:** 2026-05-04
* **İlgili Raporlar:** `AGENTS_COMPLIANCE_AUDIT.md` O-02, `AIDATPANEL_GAP_ANALIZI.md` G03

---

* **[API Constants Static String Pattern (ID Injection Risk)]** (Severity: **High**)
* **Location:** `mobile/lib/core/constants/api_constants.dart` (tüm endpoint'ler)
* **The Exploit:**
  ```dart
  static const String apartments = '$apiVersion/buildings/:id/apartments';
  // Kullanım: url.replaceAll(':id', id) // ❌ String manipulation
  ```
  Statik string'ler üzerinden dinamik ID yerleştirme:
  - ID sanitization yok (path injection riski)
  - Null/empty ID'ler 404 yerine farklı hatalara yol açabilir
  - URL encoding hataları
* **The Fix:**
  ```dart
  // Type-safe fonksiyonlar
  static String buildingApartments(String buildingId) =>
    '$apiVersion/buildings/$buildingId/apartments';
    
  static String buildingApartment(String buildingId, String apartmentId) =>
    '$apiVersion/buildings/$buildingId/apartments/$apartmentId';
  
  // Null/empty kontrolü
  static String _validateId(String id) {
    if (id.isEmpty) throw ArgumentError('ID cannot be empty');
    return Uri.encodeComponent(id);
  }
  ```

---

* **[Dummy Data in Production Code (Logic Bypass)]** (Severity: **High**)
* **Location:** `mobile/lib/features/buildings/data/stores/buildings_store.dart:11-41`
* **The Exploit:**
  ```dart
  Future<void> loadBuildings() async {
    // Gerçek API entegrasyonu yok, hardcoded data
    final dummyBuildings = [
      Building(id: '1', name: 'Güneş Apartmanı'),
      Building(id: '2', name: 'Mavi Gözler Sitesi'),
    ];
  }
  ```
  - Production'da mock data = gerçek veri yok
  - Kullanıcı kendi binalarını göremez, test verileri görür
  - "Works on my machine" problemi
  - Security boundary bypass: mock data gerçek auth kontrolüne sahip olmayabilir
* **The Fix:**
  - RemoteDatasource implementasyonu (`YOL_HARITASI.md` Aşama 1.1)
  - API contract validasyonu
  - Feature flag veya flavor bazlı mock/remote switch

---

* **[Token Storage: SecureStorage Implementation Review Required]** (Severity: **Medium**)
* **Location:** `mobile/lib/core/storage/secure_storage.dart`
* **The Exploit:**
  `flutter_secure_storage` kullanılıyor (iyi), ancak:
  - iOS Keychain accessibility level `kSecAttrAccessibleWhenUnlocked` mı?
  - Android Keystore key rotation policy var mı?
  - Root/jailbreak tespiti ve encryption fallback stratejisi yok
* **The Fix:**
  ```dart
  const storage = FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  ```
  - Root/jailbreak tespiti: `root_check` paketi
  - Obfuscation + encryptedSharedPreferences birlikte

---

* **[Debug Information Exposure in Production]** (Severity: **Medium**)
* **Location:** `mobile/lib/main.dart`, çeşitli `print` ve `debugPrint` kullanımları
* **The Exploit:**
  ```dart
  print('Token: $token'); // ❌ Production log'larında görünebilir
  debugPrint('API Response: $response');
  ```
  - Release build'da debug log'lar kaldırılmamışsa:
  - JWT token'lar logcat/console'a düşer
  - PII (telefon numarası) log'lara düşer
  - APK decompile edildiğinde log pattern'ler görülebilir
* **The Fix:**
  ```dart
  import 'package:flutter/foundation.dart';
  
  void logSecure(String message, {Object? sensitiveData}) {
    if (kDebugMode) {
      print(message);
      // sensitiveData debug modda bile log'lama
    }
    // Production'da Sentry veya benzeri (PII filtering ile)
  }
  ```

---

* **[Backend: Security Headers Missing (Predicted)]** (Severity: **Medium**)
* **Location:** `backend/` (Helmet.js kullanımı bekleniyor)
* **The Exploit:**
  Express.js default güvensiz headers:
  - `X-Powered-By: Express` → fingerprinting
  - CORS wildcard (`*`) → CSRF riski
  - CSP yok → XSS payload injection
  - HSTS yok → SSL downgrade saldırıları
* **The Fix:**
  ```javascript
  const helmet = require('helmet');
  
  app.use(helmet({
    contentSecurityPolicy: {
      directives: {
        defaultSrc: ["'self'"],
        scriptSrc: ["'self'"],
      },
    },
    hsts: {
      maxAge: 31536000,
      includeSubDomains: true,
      preload: true,
    },
  }));
  
  // CORS whitelist
  app.use(cors({
    origin: ['https://aidatpanel.com', 'https://app.aidatpanel.com'],
    credentials: true,
  }));
  ```

---

* **[Backend: IDOR Risk (Predicted)]** (Severity: **Medium**)
* **Location:** `backend/src/routes/dues.routes.js` (tahmini)
* **The Exploit:**
  ```javascript
  // Saldırgan kendi token'ı ile başka user'ın aidatını çeker
  GET /api/dues/123 // User A'nın due'u
  // Eğer user-scoped query yoksa:
  GET /api/dues/456 // User B'nin due'u da görülebilir
  ```
  - User A, User B'nin aidat bilgilerini görebilir
  - Invoice ID brute-force ile diğer dairelerin aidatları elde edilebilir
* **The Fix:**
  ```javascript
  // Her query'de userId filtresi
  const dues = await prisma.due.findMany({
    where: {
      apartmentId: req.params.apartmentId,
      apartment: {
        building: {
          userId: req.user.id, // JWT'den gelen user
        },
      },
    },
  });
  ```

---

* **[Code Obfuscation Missing (Reverse Engineering Risk)]** (Severity: **Low**)
* **Location:** `android/app/build.gradle` (default config)
* **The Exploit:**
  Release build default ayarları:
  - `minifyEnabled false` → ProGuard/R8 kapalı
  - `shrinkResources false` → Kullanılmayan resource'lar APK'ta
  - API key'ler, endpoint URL'leri plaintext
  - Reverse engineering kolaylaşır
* **The Fix:**
  ```gradle
  android {
    buildTypes {
      release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        
        // API key'ler dart-define ile
        buildConfigField "String", "API_KEY", "\"${System.getenv('API_KEY')}\""
      }
    }
  }
  ```

---

* **[Certificate Pinning Missing]** (Severity: **Low**)
* **Location:** Mobile network layer
* **The Exploit:**
  - SSL sertifikası değiştirilirse veya MITM proxy kullanılırsa
  - Kullanıcı habersiz farklı bir sertifikaya güvenir
* **The Fix:**
  - `ssl_pinning_plugin` veya `http_certificate_pinning`
  - Cloudflare public key pinning
  - Fallback: certificate validation callback

---

#### **Observations:**

* **Rate Limiting:** Backend'de `express-rate-limit` kullanımı yok. Brute-force login, enumeration saldırıları mümkün.
* **Dependency Scanning:** `pubspec.lock` ve `package-lock.json` için Snyk/Dependabot entegrasyonu yok. `npm audit` çalıştırılmamış.
* **Input Validation:** Flutter `TextField` input'ları için server-side validation yok (tahmini).
* **PII Logging:** Backend `console.log` kullanımı gözden geçirilmeli (telefon, TC no, IBAN gibi).
* **Backup Encryption:** PostgreSQL backup'ları encrypted mı? S3 bucket public access var mı?
* **Incident Response:** Güvenlik olayı durumunda playbook yok.

---

## 📊 ZAFİYET ÖZET TABLOSU

| ID | Zafiyet | Seviye | Aşama | Dosya |
|----|---------|--------|-------|-------|
| S-01 | HTTP instead of HTTPS | 🔴 Critical | 0.1 | `api_constants.dart:2` |
| S-02 | JWT Token Mismatch (30g vs 15dk) | 🔴 Critical | 0.2 | `auth_repository_impl.dart` (3x) |
| S-03 | DioClient Refresh Infinite Loop | 🔴 Critical | 0.3 | `dio_client.dart:74-76` |
| S-04 | API Constants Static Strings | 🟡 High | 1.1 | `api_constants.dart` |
| S-05 | Dummy Data in Production | 🟡 High | 1.1 | `buildings_store.dart` |
| S-06 | SecureStorage Config Review | 🟡 Medium | 2.1 | `secure_storage.dart` |
| S-07 | Debug Log Exposure | 🟡 Medium | 2.1 | `main.dart`, çeşitli |
| S-08 | Backend Security Headers Missing | 🟡 Medium | 2.2 | `backend/` |
| S-09 | IDOR Risk (Predicted) | 🟡 Medium | 2.2 | `dues.routes.js` (tahmini) |
| S-10 | Code Obfuscation Missing | 🟢 Low | 2.1 | `build.gradle` |
| S-11 | Certificate Pinning Missing | 🟢 Low | 2.1 | Network layer |

---

## 🎯 KRİTİK HEDEFLER (Aşama 0 — Acil)

**Production'a çıkmadan önce ZORUNLU:**

1. **S-01 (HTTPS):** Cloudflare SSL + HTTPS geçişi
2. **S-02 (Token expiry):** 15dk/30g doğrulama
3. **S-03 (DioClient):** Refresh ayrı instance

**Bu 3 zafiyet kapanmadan production deployment RİSKLİ.**

---

## 🔧 QUICK SECURITY FIXES (Aşama 1 Haftası)

| # | Fix | Dosya | Efor |
|---|-----|-------|------|
| 1 | `http://` → `https://` | `api_constants.dart` | 15 dk |
| 2 | Token expiry 15dk | `auth_repository_impl.dart` | 1 saat |
| 3 | DioClient refresh instance | `dio_client.dart` | 30 dk |
| 4 | API constants fonksiyonlar | `api_constants.dart` | 30 dk |
| 5 | Dummy data temizliği | `buildings_store.dart` | 2 saat |
| 6 | SecureStorage config | `secure_storage.dart` | 30 dk |
| 7 | Debug log temizliği | `main.dart` | 1 saat |

---

## 🏗️ DEEPER SECURITY (Aşama 2 ve Sonrası)

| Zafiyet | Çözüm | Efor |
|---------|-------|------|
| S-08 (Security headers) | Helmet.js entegrasyonu | 2 saat |
| S-09 (IDOR) | User-scoped Prisma queries | 3-4 saat |
| S-10 (Obfuscation) | ProGuard/R8 config | 2 saat |
| S-11 (Pinning) | SSL pinning implementasyonu | 2 saat |
| Rate limiting | express-rate-limit | 1 saat |
| Dependency scanning | Snyk/Dependabot | 2 saat |

---

## 🔗 İLGİLİ DOSYALAR

| Dosya | Amaç |
|-------|------|
| `YOL_HARITASI.md` v2.0 | Aşama planı (Aşama 0 — Acil Güvenlik) |
| `AIDATPANEL_GAP_ANALIZI.md` | Gap tespiti (G01-G06 güvenlik) |
| `HATA_ANALIZ_RAPORU.md` | 15 kritik hata (güvenlik içerikli) |
| `resources/planning/GUVENLIK_PROMPTU.md` | Bu raporun üretim prompt'u |
| `OPTIMIZATIONS.md` | Performans-güvenlik crossover (F-07 vs S-01) |

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-04 | İlk güvenlik denetimi: v0.0.8 kodu için 11 zafiyet (3 kritik, 2 yüksek, 4 orta, 2 düşük), prompt standardı formatında rapor |

---

**🚨 KRİTİK UYARI:** Aşama 0 (3 kritik zafiyet) kapanmadan production deployment yapılmamalıdır.
