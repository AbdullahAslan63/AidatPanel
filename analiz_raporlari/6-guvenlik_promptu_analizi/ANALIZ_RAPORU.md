# GUVENLIK PROMPTU ANALİZ RAPORU

**Kaynak Dosya:** `planning/GUVENLIK_PROMPTU.md`  
**Analiz Tarihi:** 2026-05-03  
**Durum:** ✅ Tamamlandı  
**Analiz Tipi:** Güvenlik Denetçisi Rolü ve Güvenlik Analizi Metodolojisi Değerlendirmesi

---

## 📋 META-PROMPT YAPISI ANALİZİ

### Amaç ve Kapsam
| Öğe | Değerlendirme |
|-----|---------------|
| **Amaç** | Git diff (staged changes) üzerinden güvenlik açıkları, mantık hataları ve potansiyel exploit'leri tespit etmek |
| **Rol** | Senior Security Researcher + Application Security Expert |
| **Mindset** | Adversarial (Saldırgan bakış açısı) |
| **Yaklaşım** | Her satır değişikliği potansiyel bir saldırı vektörü olarak ele alınır |
| **Dil** | İngilizce (orijinal) |

### Kimlik ve Rol Tanımı
```
You are a Senior Security Researcher and Application Security Expert.
You possess deep knowledge of offensive security, vulnerability assessment, 
and secure coding patterns.

Mindset: Adversarial
Approach: View code through the lens of an attacker to prevent exploits 
before they reach production.
```

Bu rol tanımı **saldırgan perspektifi** gerektirir. Savunmacı değil, saldırgan gibi düşünmek.

---

## ✅ GÜÇLÜ YÖNLER

### 1. Saldırgan Bakış Açısı (Adversarial Mindset)
```
"View code through the lens of an attacker"
```
Savunmacı güvenlik değil, **ofansif güvenlik** yaklaşımı. Bu proaktif zafiyet keşfi sağlar.

### 2. Zero Trust Prensibi
```
"Never assume input is sanitized or that upstream checks are sufficient."
```
**Hiçbir girdiye güvenme** prensibi. Tüm input'lar potansiyel olarak kötü niyetli kabul edilir.

### 3. 5 Ana Risk Kategorisi (Primary Risk Categories)

| Kategori | Kapsam | Örnek Zafiyetler |
|----------|--------|------------------|
| **1. Injection Flaws** | SQLi, Command Injection, XSS, LDAP, NoSQL | `'; DROP TABLE users; --` |
| **2. Broken Access Control** | IDOR, missing auth, privilege escalation | `/api/admin/users` açık endpoint |
| **3. Sensitive Data Exposure** | Hardcoded secrets, PII logging, weak encryption | `API_KEY=sk_live_12345` |
| **4. Security Misconfiguration** | Debug modes, missing headers, default credentials | `debug: true` production'da |
| **5. Code Quality Risks** | Race conditions, null pointer, unsafe deserialization | `user.name` (user null olabilir) |

### 4. Standart Çıktı Formatı (Yapılandırılmış Rapor)

```markdown
### SECURITY AUDIT: [Özet]
**Risk Assessment:** [Critical / High / Medium / Low / Secure]

#### **Findings:**
* **[Zafiyet Adı]** (Severity: [Level])
* **Location:** [Dosya / Satır]
* **The Exploit:** [Saldırgan nasıl kullanır?]
* **The Fix:** [Kod örneği / çözüm]

#### **Observations:**
* [Düşük risk / hardening önerileri]
```

Bu format **standartlaştırılmış raporlama** sağlar. Güvenlik ekipleri için okunabilir.

### 5. Kritik Seviye Önceliklendirmesi
```
If you see what looks like a credential or key, flag it immediately as Critical.
```
**Hardcoded secrets** otomatik Critical seviye. Bu, en hassas verileri önceliklendirir.

### 6. Yüksek Sinyal/Gürültü Oranı (High Signal-to-Noise)
```
* **Directness:** No introductory fluff. Start immediately with the Risk Assessment.
* **Density:** High signal-to-noise ratio. Prioritize actionable intelligence over theory.
```
**Boş laflar yok**, direkt risk değerlendirmesi. Güvenlik analizlerinde hız kritik.

### 7. Aksiyon-Odaklı (Actionable Intelligence)
```
The Fix: [Concrete code snippet or specific remediation instructions]
```
Sadece tespit değil, **somut çözüm** sunulur. `OUTPUT ONLY - NO FIX` kuralı var ama çözüm önerilir.

---

## ⚠️ EKSİK VE GELİŞTİRİLEBİLİR ALANLAR

| Alan | Durum | Eksiklik | Öneri |
|------|-------|----------|-------|
| **Proje-spesifik Context** | Eksik | AidatPanel Flutter/Node.js özel güvenlik riskleri yok | Proje analizi yapılmalı |
| **Compliance Gereksinimleri** | Yok | KVKK, GDPR, PCI DSS vb. | Yasal uyumluluk kontrol listesi |
| **Threat Modeling** | Yok | Sistematik tehdit modellemesi | STRIDE veya PASTA metodolojisi |
| **Security Headers** | Eksik | CORS, CSP, HSTS vb. | Express.js security headers guide |
| **Mobile Security** | Genel | Flutter-specific güvenlik | OWASP MASVS checklist |
| **Dependency Scanning** | Yok | Kütüphane zafiyetleri | Snyk, Dependabot entegrasyonu |
| **Secrets Management** | Genel | `.env`, key vault kullanımı | Vault, AWS Secrets Manager |
| **Penetration Testing** | Yok | Manuel pentest yönergeleri | Burp Suite, OWASP ZAP |
| **Incident Response** | Yok | Güvenlik olayı yönetimi | Response plan template |

---

## 🎯 AIDATPANEL İÇİN UYGULAMA REHBERİ

### Proje-özel Güvenlik Riskleri

#### Flutter Mobile (Furkan Odaklı)
| Risk Kategorisi | Potansiyel Sorun | Örnek | Öneri |
|-----------------|------------------|-------|-------|
| **Sensitive Data Exposure** | JWT token local storage | `flutter_secure_storage` kullanımı | Encryption + keychain/keystore |
| **Hardcoded Secrets** | API keys in code | `const API_KEY = "..."` | `.env` + dart-define |
| **Network Security** | HTTP instead of HTTPS | `http://api.aidatpanel.com` | Certificate pinning (SSL) |
| **Input Validation** | XSS via TextField | Kullanıcı input'ları | Input sanitization |
| **Code Obfuscation** | Reverse engineering | APK decompilation | ProGuard/R8 + obfuscation |
| **Debug Information** | Debug banners, logs | `debugShowCheckedModeBanner` | Production'da kaldır |

#### Node.js Backend (Abdullah/Yusuf Odaklı)
| Risk Kategorisi | Potansiyel Sorun | Örnek | Öneri |
|-----------------|------------------|-------|-------|
| **Injection Flaws** | SQLi via Prisma | Raw query kullanımı | Parameterized queries |
| **Broken Access Control** | IDOR - dues endpoint | `/api/dues/:id` | User-scoped queries |
| **Sensitive Data Exposure** | JWT secret in code | `JWT_SECRET=hardcoded` | `.env` + secret manager |
| **Security Misconfiguration** | CORS açık | `cors({ origin: '*' })` | Whitelist domains |
| **Missing Auth** | Public endpoints | `/api/buildings` | Middleware kontrolü |
| **PII Logging** | User data in logs | `console.log(user.phone)` | Log filtering |

#### Database (PostgreSQL)
| Risk Kategorisi | Potansiyel Sorun | Öneri |
|-----------------|------------------|-------|
| **Access Control** | Weak DB credentials | Strong passwords, limited privileges |
| **Encryption** | Plaintext PII | Column-level encryption (sensitive fields) |
| **Backup Security** | Unencrypted backups | Encrypted backup storage |
| **Audit Logging** | No query audit | Enable PostgreSQL logging |

### AidatPanel için Güvenlik Kontrol Listesi

#### Flutter (Client-side)
- [ ] **JWT Storage:** `flutter_secure_storage` kullanılıyor mu? (Keychain/Keystore)
- [ ] **API Keys:** Hardcoded değil, `--dart-define` ile mi geliyor?
- [ ] **HTTPS:** Tüm API çağrıları HTTPS mi? (Certificate pinning?)
- [ ] **Input Validation:** Kullanıcı input'ları sanitize ediliyor mu?
- [ ] **Debug Info:** Production build'da debug banner ve log'lar kaldırıldı mı?
- [ ] **Code Obfuscation:** ProGuard/R8 + obfuscation aktif mi?
- [ ] **Local Storage:** Sensitive data plain SQLite'da mı saklanıyor?

#### Node.js (Server-side)
- [ ] **Auth Middleware:** Tüm protected endpoint'lerde JWT kontrolü var mı?
- [ ] **IDOR:** User A, User B'nin aidatlarını görebiliyor mu? (Scoped queries)
- [ ] **SQLi:** Prisma raw query kullanımı var mı? (Parameterized?)
- [ ] **Secrets:** `.env` kullanılıyor, hardcoded secret yok mu?
- [ ] **CORS:** Whitelist domain'ler tanımlı mı? (`*` değil)
- [ ] **Security Headers:** Helmet.js kullanılıyor mu? (CSP, HSTS, X-Frame-Options)
- [ ] **Rate Limiting:** express-rate-limit kullanılıyor mu?
- [ ] **PII Logging:** console.log'da telefon, TC no vb. yok mu?

#### Database
- [ ] **Encryption:** Password hash'leri bcrypt/Argon2 ile mi?
- [ ] **Access:** DB user'ı least privilege prensibiyle mi?
- [ ] **Backup:** Backuplar encrypted ve restricted access mi?

---

## 🔍 AIDATPANEL GUVENLIK AUDIT PLAN

### Phase 1: Static Analysis (Kod İnceleme)
1. **Flutter Code:**
   - `flutter_secure_storage` kullanımı
   - API key'lerin yeri (`.env`, `dart-define`)
   - Input validation (TextField'lar)
   - Debug log'lar (`print`, `debugPrint`)

2. **Node.js Code:**
   - `JWT_SECRET` nerede? (`.env` mi?)
   - `prisma.$queryRaw` kullanımı var mı?
   - Auth middleware coverage
   - CORS yapılandırması
   - Helmet.js kullanımı

3. **Configuration:**
   - `.env.example` vs `.env`
   - `docker-compose.yml` secret'leri
   - `pubspec.yaml` dependency'ler (Snyk scan)

### Phase 2: Dynamic Analysis (Runtime Test)
1. **Auth Bypass:**
   - Token olmadan protected endpoint'lere erişim
   - Expired token ile erişim
   - Farklı user'ın aidatlarını görme (IDOR)

2. **Input Validation:**
   - SQLi injection testi (Prisma raw query varsa)
   - XSS testi (Flutter Web varsa)
   - Command injection (file upload varsa)

3. **Network Security:**
   - HTTPS enforcement
   - Certificate pinning test
   - Man-in-the-middle (MITM) test

### Phase 3: Dependency Scanning
1. **Flutter:** `pubspec.lock` dependency'leri
2. **Node.js:** `package-lock.json` dependency'leri
3. **Tools:** Snyk, Dependabot, npm audit

---

## 🛠️ TOOL ÖNERİLERİ (AidatPanel)

### Flutter/Dart Güvenlik
| Tool | Amaç |
|------|------|
| **flutter_secure_storage** | Secure keychain/keystore storage |
| **ssl_pinning_plugin** | Certificate pinning |
| **obfuscate** | Code obfuscation |
| **dart-define** | Environment variables |

### Node.js Güvenlik
| Tool | Amaç |
|------|------|
| **helmet** | Security headers (CSP, HSTS, etc.) |
| **express-rate-limit** | Rate limiting |
| **express-validator** | Input validation |
| **bcrypt** / **argon2** | Password hashing |
| **dotenv** | Environment variables |
| **winston** | Secure logging (PII filtering) |

### Scanning/Testing
| Tool | Amaç |
|------|------|
| **Snyk** | Dependency vulnerability scanning |
| **OWASP ZAP** | Web app security testing |
| **Burp Suite** | Penetration testing |
| **npm audit** | Node.js package audit |
| **flutter analyze** | Dart static analysis |

---

## 📝 GUVENLIK RAPOR TEMPLATE (AidatPanel için)

```markdown
### SECURITY AUDIT: [Özellik Adı / PR Başlığı]
**Risk Assessment:** [Critical / High / Medium / Low / Secure]

#### **Findings:**

* **[JWT Token Storage]** (Severity: High)
* **Location:** `mobile/lib/core/storage/secure_storage.dart:15`
* **The Exploit:** JWT token plain SharedPreferences'da saklanıyor. 
  Root/jailbreak cihazlarda token çalınabilir.
* **The Fix:** 
  ```dart
  // flutter_secure_storage kullan
  final storage = FlutterSecureStorage();
  await storage.write(key: 'jwt_token', value: token);
  ```

* **[Hardcoded API Key]** (Severity: Critical)
* **Location:** `mobile/lib/core/constants/api_constants.dart:3`
* **The Exploit:** `const API_KEY = "sk_live_abc123";` 
  APK decompile edilerek API key ele geçirilebilir.
* **The Fix:**
  ```dart
  // dart-define kullan
  const apiKey = String.fromEnvironment('API_KEY');
  ```

#### **Observations:**
* Debug log'lar production build'da kaldırılmalı (`kDebugMode` check)
* CORS whitelist'e `aidatpanel.com` alt domain'leri ekle
```

---

## 💡 KRİTİK BAŞARI FAKTÖRLERİ

1. **Zero Trust:** Hiçbir girdiye, hiçbir upstream kontrole güvenme
2. **Adversarial Mindset:** Saldırgan gibi düşün, savunmacı değil
3. **Context Awareness:** Belirsiz durumlarda risk işaretle, görmezden gelme
4. **High Signal-to-Noise:** Boş laflar yok, direkt tespit ve çözüm
5. **Critical Secrets:** Hardcoded credential'lar otomatik Critical seviye
6. **Actionable:** Sadece tespit değil, somut fix öner
7. **No Assumptions:** Input sanitize edilmiş varsayma, auth check yapılmış varsayma

---

## 📁 SONRAKİ ADIMLAR

1. **AidatPanel Kod Güvenlik Audit:** Flutter + Node.js kodlarını incele
2. **Static Analysis:** `flutter analyze`, `npm audit`, Snyk scan
3. **Dynamic Testing:** Auth bypass, IDOR, input validation testleri
4. **Dependency Scanning:** Tüm kütüphane zafiyetleri tespit et
5. **Security Report:** Bulguları standart formatta raporla
6. **Fix Implementation:** Kritik zafiyetlerin çözümünü implemente et

---

**Analiz Tamamlandı:** 2026-05-03  
**Klasör:** `analiz_raporlari/6-guvenlik_promptu_analizi/`  
**Sonraki Adım:** AidatPanel kodları için güvenlik audit yap
