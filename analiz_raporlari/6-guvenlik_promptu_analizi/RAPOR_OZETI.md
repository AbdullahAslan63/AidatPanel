# GUVENLIK PROMPTU ANALİZ ÖZETİ

**Tarih:** 2026-05-03  
**Kaynak:** planning/GUVENLIK_PROMPTU.md  
**Durum:** ✅ Analiz Tamamlandı

---

## 🎯 ÖZET

Bu meta-prompt, **Senior Security Researcher** rolünde **adversarial mindset** ile git diff üzerinden güvenlik zafiyetleri tespiti için talimatlar sunar.

---

## ✅ GÜÇLÜ YÖNLER

- ✅ **Adversarial Mindset:** Saldırgan bakış açısı ile kod inceleme
- ✅ **Zero Trust:** Hiçbir girdiye veya upstream kontrole güvenme
- ✅ **5 Ana Risk Kategorisi:** Injection, Access Control, Data Exposure, Misconfiguration, Code Quality
- ✅ **Standart Çıktı Formatı:** SECURITY AUDIT → Risk Assessment → Findings → Observations
- ✅ **Kritik Seviye:** Hardcoded secrets otomatik Critical
- ✅ **High Signal-to-Noise:** Boş laflar yok, direkt tespit ve çözüm

---

## 🔍 5 ANA RISK KATEGORİSİ

| Kategori | Örnek Zafiyetler |
|----------|------------------|
| **1. Injection Flaws** | SQLi, Command Injection, XSS, LDAP, NoSQL |
| **2. Broken Access Control** | IDOR, missing auth, privilege escalation |
| **3. Sensitive Data Exposure** | Hardcoded secrets, PII logging, weak encryption |
| **4. Security Misconfiguration** | Debug modes, missing headers, default credentials |
| **5. Code Quality Risks** | Race conditions, null pointer, unsafe deserialization |

---

## 📝 STANDART ÇIKTI FORMATI

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

---

## ⚠️ EKSİK ALANLAR

| Alan | Öneri |
|------|-------|
| Compliance (KVKK, GDPR) | Yasal uyumluluk kontrol listesi |
| Threat Modeling | STRIDE/PASTA metodolojisi |
| Mobile Security (Flutter) | OWASP MASVS checklist |
| Dependency Scanning | Snyk, Dependabot entegrasyonu |
| Secrets Management | Vault, AWS Secrets Manager |
| Incident Response | Response plan template |

---

## 🎯 AIDATPANEL İÇİN GÜVENLIK KONTROL LİSTESİ

### Flutter (Client-side)
- [ ] JWT Storage: `flutter_secure_storage` (Keychain/Keystore)
- [ ] API Keys: Hardcoded değil, `--dart-define` kullan
- [ ] HTTPS: Tüm API çağrıları HTTPS + certificate pinning
- [ ] Input Validation: TextField'lar sanitize ediliyor
- [ ] Debug Info: Production'da debug banner ve log'lar kaldırıldı
- [ ] Code Obfuscation: ProGuard/R8 + obfuscation aktif

### Node.js (Server-side)
- [ ] Auth Middleware: Tüm protected endpoint'lerde JWT kontrolü
- [ ] IDOR: User-scoped queries (user A, B'nin aidatlarını göremez)
- [ ] SQLi: Prisma raw query yok veya parameterized
- [ ] Secrets: `.env` kullanılıyor, hardcoded secret yok
- [ ] CORS: Whitelist domain'ler ("*" değil)
- [ ] Security Headers: Helmet.js (CSP, HSTS, X-Frame-Options)
- [ ] Rate Limiting: express-rate-limit
- [ ] PII Logging: console.log'da telefon, TC no yok

### Database
- [ ] Encryption: Password hash'leri bcrypt/Argon2
- [ ] Access: DB user'ı least privilege prensibiyle
- [ ] Backup: Backuplar encrypted ve restricted access

---

## 🛠️ TOOL ÖNERİLERİ

### Flutter
| Tool | Amaç |
|------|------|
| flutter_secure_storage | Secure storage |
| ssl_pinning_plugin | Certificate pinning |
| dart-define | Environment variables |

### Node.js
| Tool | Amaç |
|------|------|
| helmet | Security headers |
| express-rate-limit | Rate limiting |
| bcrypt / argon2 | Password hashing |
| dotenv | Environment variables |

### Scanning
| Tool | Amaç |
|------|------|
| Snyk | Dependency vulnerability |
| OWASP ZAP | Web app security testing |
| npm audit | Node.js package audit |

---

## 🚀 SONRAKİ ADIM

1. AidatPanel kod güvenlik audit (Flutter + Node.js)
2. Static analysis (`flutter analyze`, `npm audit`, Snyk)
3. Dynamic testing (Auth bypass, IDOR, input validation)
4. Dependency scanning
5. Security report ve fix implementation

---

**Hazır:** Evet, AidatPanel kodları için güvenlik audit yapılabilir
