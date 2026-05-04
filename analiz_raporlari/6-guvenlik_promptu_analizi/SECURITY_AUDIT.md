# 3️⃣ SECURITY_AUDIT.md

## AIDATPANEL v0.0.8 - SECURITY AUDIT REPORT

**Versiyon:** 1.1  
**Tarih:** 2026-05-04  
**Kod Versiyonu:** v0.0.8  
**Hedef:** YOL_HARITASI.md v3.0 → Aşama 0 (Acil Güvenlik), Aşama 2.2  
**Denetçi:** AI Co-Founder (Senior Security Researcher rolünde)  
**Format:** GUVENLIK_PROMPTU.md standardı (Adversarial Mindset)

---

## ### SECURITY AUDIT: AidatPanel v0.0.8 Production Readiness

**Risk Assessment:** 🔴 **CRITICAL** (Acil Aksiyon Gerekli — Production'a Çıkış Engellenmeli)

---

#### **Findings:**

* **[HTTP instead of HTTPS]** (Severity: **Critical**)
* **Location:** `mobile/lib/core/constants/api_constants.dart:2`
* **The Exploit:** 
  ```dart
  static const String baseUrl = 'http://api.aidatpanel.com:4200';
  ```
  Tüm API trafiği plaintext HTTP üzerinden. Man-in-the-middle (MITM) saldırılarıyla:
  - JWT token'lar ele geçirilebilir
  - Kullanıcı telefon numaraları ve aidat bilgileri okunabilir
  - POST/PUT istekleri modifiye edilebilir
  - Play Store "Cleartext Traffic" policy violation sebebiyle reddedilebilir
* **The Fix:**
  ```dart
  static const String baseUrl = 'https://api.aidatpanel.com';
  ```
  Cloudflare Full/Strict SSL yapılandırması yapılacak. Android `network_security_config.xml` ve iOS `Info.plist` güncellenecek.

---

* **[JWT Token Mismatch (Client 30g vs Server 15dk)]** (Severity: **Critical**)
* **Location:** `mobile/lib/features/auth/data/repositories/auth_repository_impl.dart:47-48, 79-80, 111-112`
* **The Exploit:**
  ```dart
  await _secureStorage.saveTokenExpiry(
    DateTime.now().add(const Duration(days: 30)), // ❌ Yanlış
  );
  ```
  Backend access token'ı 15 dakika olarak üretiyor, client 30 gün geçerli sanıyor. Bu mismatch sonucu:
  - Sessiz 401'lar (kullanıcı session'ı aniden kopar)
  - Token expiry check bypass edilebilir (client tarafında geçerli, server reddeder)
  - Session management tutarsızlığı
* **The Fix:**
  ```dart
  // Access token: 15 dakika (backend ile eşleşmeli)
  await _secureStorage.saveTokenExpiry(
    DateTime.now().add(const Duration(minutes: 15)),
  );
  
  // Refresh token: 30 gün (ayrı alan)
  await _secureStorage.saveRefreshTokenExpiry(
    DateTime.now().add(const Duration(days: 30)),
  );
  ```

---

* **[DioClient Refresh Token Infinite Loop Risk]** (Severity: **Critical**)
* **Location:** `mobile/lib/core/network/dio_client.dart:74-76`
* **The Exploit:**
  ```dart
  // 401 alındığında interceptor refresh dener
  final response = await _dio.post(ApiConstants.refresh, ...);
  ```
  Refresh request'i interceptor ile aynı `Dio` instance'ı kullanıyor. Refresh başarısız olursa:
  - 401 → refresh dene → 401 → refresh dene ... (sonsuz döngü)
  - Backend'e DDoS benzeri trafik (rate limit bypass)
  - Cihaz bataryası hızlı tükenir, kullanıcı deneyimi bozulur
* **The Fix:**
  ```dart
  class DioClient {
    late final Dio _dio;
    final Dio _refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
    
    Future<void> _refreshToken() async {
      try {
        // Interceptor'sız instance kullan
        final response = await _refreshDio.post(ApiConstants.refresh, ...);
      } catch (e) {
        _handleRefreshFailure(); // Login'e yönlendir
      }
    }
  }
  ```

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
| `planning/GUVENLIK_PROMPTU.md` | Bu raporun üretim prompt'u |
| `OPTIMIZATIONS.md` | Performans-güvenlik crossover (F-07 vs S-01) |

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-04 | İlk güvenlik denetimi: v0.0.8 kodu için 11 zafiyet (3 kritik, 2 yüksek, 4 orta, 2 düşük), prompt standardı formatında rapor |

---

**🚨 KRİTİK UYARI:** Aşama 0 (3 kritik zafiyet) kapanmadan production deployment yapılmamalıdır.
