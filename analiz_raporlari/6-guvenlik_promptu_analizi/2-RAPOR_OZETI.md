# Güvenlik Promptu - Rapor Özeti

## 🎯 Prompt Amacı
**Güvenlik denetimi** için AI agent talimatı  
**Odak:** Kod diff'indeki güvenlik açıklarını ve mantık hatalarını tespit  
**Rol:** Senior Security Researcher (Adversarial mindset)

## 📋 Risk Kategorileri

| Kategori | Tehditler |
|----------|-----------|
| **Injection Flaws** | SQLi, Command Injection, XSS, LDAP/NoSQL Injection |
| **Broken Access Control** | IDOR, missing auth, privilege escalation |
| **Sensitive Data Exposure** | Hardcoded secrets, PII logging, weak encryption |
| **Security Misconfiguration** | Debug modes, missing headers, default creds |
| **Code Quality Risks** | Race conditions, null pointer, unsafe deserialization |

## 🏗️ Çıktı Formatı

```
### SECURITY AUDIT: [Değişiklik Özeti]

**Risk Assessment:** [Critical / High / Medium / Low / Secure]

#### **Findings:**
**[Vulnerability]** (Severity: [Level])
* Location: [Dosya:Satır]
* The Exploit: [Saldırgan perspektifi]
* The Fix: [Konkret çözüm]

#### **Observations:**
* [Düşük risk önerileri]
```

## 🔐 AidatPanel Güvenlik Durumu (Aşama 0)

### ✅ Güvenli Bulunanlar

| Katman | Kontrol | Durum |
|--------|---------|-------|
| JWT | HS256, 15dk/30gün süre, env secrets | ✅ Güvenli |
| Auth Middleware | DB lookup yok, {id, role} token'dan | ✅ Güvenli |
| Zod Validasyon | .email(), .uuid(), min/max kontrolleri | ✅ Güvenli |
| Rate Limiting | authLimiter brute force koruması | ✅ Güvenli |
| Authorization | managerId + buildingId kontrolleri | ✅ Güvenli |

### ⚠️ İzleme Önerileri

| Konu | Risk | Öneri |
|------|------|-------|
| Token Revocation | Düşük | Faz 2'de Redis revocation list |
| Zod Error Handling | Düşük | Format doğrulaması |
| Login Identifier | Düşük | Ayrıştırma mantığı kontrolü |

## 📊 Güvenlik Matrisi

| Kategori | Durum |
|----------|-------|
| Authentication | ✅ GÜVENLİ |
| Authorization | ✅ GÜVENLİ |
| Input Validation | ✅ GÜVENLİ |
| Rate Limiting | ✅ GÜVENLİ |
| Token Yönetimi | ⚠️ İZLENDİ |

## ⚠️ Kritik Davranışlar

### Zero Trust
- Girdi sanitize edildi varsayma
- Upstream check'ler yeterli varsayma

### Secrets Detection
- Credential/key görürsen → **Critical**

### Execution
- Fix uygulama, sadece bulguları raporla

## 🎯 Sonuç

**Aşama 0 Güvenlik Denetimi:** ✅ **BAŞARILI**  
**Kritik Açık:** Yok  
**Risk Seviyesi:** Düşük

---

**Rapor Özeti ID:** 2-GUVENLIK-PROMPTU-OZET
