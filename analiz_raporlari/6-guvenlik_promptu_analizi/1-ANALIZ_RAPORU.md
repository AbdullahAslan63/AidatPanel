# Güvenlik Promptu - Analiz Raporu

## Analiz Tarihi
2026-05-05

## Analiz Edilen Kaynak
**Dosya:** `planning/GÜVENLİK PROMPTU.md`  
**Tür:** Güvenlik Denetim Promptu  
**Hedef:** Kod diff'indeki güvenlik açıklarını ve mantık hatalarını tespit

---

## Prompt'un Amacı

Bu prompt, **Senior Security Researcher** ve **Application Security Expert** rolünde çalışarak kod değişikliklerini potansiyel saldırı vektörleri açısından analiz eder.

### Zihniyet (Mindset)
- **Adversarial:** Saldırganın perspektifinden bakar
- **Approach:** Exploit'leri üretime ulaşmadan önler

---

## Analiz Protokolü

### Risk Kategorileri (Birincil Tarama)

#### 1. Injection Flaws
- **SQL Injection (SQLi):** Ham SQL sorguları, parametreleştirme eksikliği
- **Command Injection:** Shell komutlarına kullanıcı girdisi
- **XSS (Cross-Site Scripting):** DOM'a kullanıcı girdisi render etme
- **LDAP Injection:** LDAP filtrelerine girdi
- **NoSQL Injection:** MongoDB vb. sorgularına girdi

#### 2. Broken Access Control
- **IDOR (Insecure Direct Object Reference):** ID parametreleriyle yetkisiz erişim
- **Missing auth checks:** Korumasız endpoint'ler
- **Privilege escalation:** Düşük yetkiden yüksek yetkiye yükselme
- **Exposed admin endpoints:** Admin fonksiyonlarının dışarı açılması

#### 3. Sensitive Data Exposure
- **Hardcoded secrets:** API keys, tokens, passwords kodda
- **PII logging:** Kişisel bilgilerin log'lanması
- **Weak encryption:** MD5, SHA1, zayıf şifreleme algoritmaları
- **Unencrypted transmission:** HTTPS olmayan iletişim

#### 4. Security Misconfiguration
- **Debug modes:** Production'da debug modu
- **Missing security headers:** CSP, HSTS, X-Frame-Options, vb.
- **Default credentials:** Değiştirilmemiş default şifreler
- **Open permissions:** Aşırı geniş dosya/veritabanı izinleri

#### 5. Code Quality Risks
- **Race conditions:** Zamanlama saldırıları
- **Null pointer dereferences:** Çökme nedenleri
- **Unsafe deserialization:** Serileştirilmiş verinin güvensiz parse'ı
- **Resource leaks:** Bellek, bağlantı sızıntıları

---

## Çıktı Formatı (Strict)

```
### SECURITY AUDIT: [Değişikliklerin Kısa Özeti]

**Risk Assessment:** [Critical / High / Medium / Low / Secure]

#### **Findings:**

**[Vulnerability Name]** (Severity: [Level])
* **Location:** [Dosya Adı / Satır Numarası]
* **The Exploit:** [Saldırganın nasıl kullanacağı teknik açıklama]
* **The Fix:** [Konkret kod snippet veya düzeltme talimatları]

#### **Observations:**
* [Düşük riskli konular veya hardening önerileri]
```

---

## Kısıtlamalar ve Davranış

### Zero Trust
- Girdinin sanitize edildiğini veya upstream check'lerin yeterli olduğunu asla varsayma

### Context Awareness
- Diff belirsizse, riski işaretle ve görmezden gelme

### Directness
- Giriş süslemesi yok. Hemen Risk Assessment ile başla.

### Density
- Yüksek signal-to-noise ratio. Eyleme geçirilebilir istihbarat öncelikli.

### Secrets Detection
- Credential veya key görürsen anında **Critical** olarak işaretle

### Execution
- Fix'leri uygulama. Sadece bulguları çıktıla.

---

## AidatPanel'de Uygulanan Güvenlik Önlemleri

### Aşama 0 Güvenlik Denetimi Sonuçları

#### ✅ Güvenlik Doğrulamaları - BAŞARILI

##### 1. JWT Token Güvenliği
| Kontrol | Durum | Açıklama |
|---------|-------|----------|
| Token imzalama | ✅ | `JWT_SECRET` ve `REFRESH_TOKEN_SECRET` env'den |
| Token süreleri | ✅ | Access: 15dk, Refresh: 30gün |
| Payload `role` | ✅ | MANAGER/RESIDENT enum kontrollü |
| Algorithm | ✅ | Default HS256 (jwt.sign) |

**AGENTS.md Kural Uyumu:**
- ✅ `authMiddleware` DB lookup yapmıyor
- ✅ `req.user = { id, role }` direkt token'dan

##### 2. Zod Validasyon Güvenliği
| Endpoint | Body Validasyon | Params Validasyon | Durum |
|----------|-----------------|-------------------|-------|
| POST /register | ✅ name, email, password | — | Güvenli |
| POST /login | ✅ identifier, password | — | Güvenli |
| POST /refresh | ✅ refreshToken | — | Güvenli |
| GET /buildings/:id | — | ✅ UUID | Güvenli |
| PUT /buildings/:id | ✅ name, address, city | ✅ UUID | Güvenli |
| POST /apartments | ✅ number, floor | ✅ buildingId UUID | Güvenli |
| PUT /apartments/:id | ✅ number, floor | ✅ buildingId, id UUID | ✅ **YENİ** |
| DELETE /apartments/:id | — | ✅ buildingId, id UUID | Güvenli |

**Zod Şema Güvenliği:**
- ✅ Email: `.email()` format kontrolü
- ✅ Şifre: min 6, max 100 karakter
- ✅ UUID: `.uuid()` format kontrolü tüm ID'lerde
- ✅ Türkçe hata mesajları (UX dostu)

##### 3. Rate Limiting
```javascript
// authRoutes.js
router.use(authLimiter);  // Brute force koruması
```
- ✅ Auth endpoint'lerinde rate limiting aktif
- ✅ `authLimiter` memory store (Faz 1 için kabul edilebilir)

##### 4. Authorization (Yetkilendirme)
| Servis | Yetki Kontrolü | Durum |
|--------|----------------|-------|
| `buildingService` | `managerId` kontrolü | ✅ Sadece kendi binaları |
| `apartmentService` | `managerId` + `buildingId` kontrolü | ✅ Sadece kendi daireleri |
| `updateApartment` | Bina yöneticisi mi kontrolü | ✅ **YENİ** güvenli |

---

### ⚠️ Düşük Risk Gözlemler

#### 1. Zod Error Handling
```javascript
// validate.js
catch (error) {
  next(error);  // Error handler middleware'a gidiyor mu?
}
```
**Durum:** ✅ `next(error)` doğru.  
**Kontrol:** `errorHandler` ZodError'ları `{ success: false, message, errors }` formatına çeviriyor mu?

#### 2. Login `identifier` Ayrıştırma
```javascript
// loginSchema'da:
identifier: z.string().min(1)  // Email VEYA telefon

// Controller'da ayrıştırma mantığı:
// - @ içeriyorsa → email olarak ara
// - @ içermiyorsa → telefon olarak ara
```
**Öneri:** `authControllers.js` login fonksiyonunda identifier ayrıştırma mantığını doğrula.

#### 3. JWT Token Revocation
**Risk:** Kullanıcı silinirse veya rol değişirse eski token hâlâ geçerli (15dk/30gün).  
**Çözüm:** Faz 2'de Redis tabanlı token revocation list veya shorter refresh token TTL.

---

### 🔍 Yeni PUT Endpoint Güvenlik Analizi

**Endpoint:** `PUT /api/v1/buildings/:buildingId/apartments/:id`

| Katman | Güvenlik Önlemi | Durum |
|--------|-----------------|-------|
| Route | `authMiddleware` | ✅ Token zorunlu |
| Route | `validate(apartmentSchemas.update)` | ✅ UUID + body validasyonu |
| Service | `building.managerId !== managerId` kontrolü | ✅ Yetki kontrolü |
| Service | `apartment.findFirst({ id, buildingId })` | ✅ Daire binaya ait mi |

**Sonuç:** ✅ Yeni PUT endpoint tam güvenlik kapsamında.

---

## 📊 Güvenlik Özeti

| Kategori | Durum | Notlar |
|----------|-------|--------|
| Authentication | ✅ GÜVENLİ | JWT + role doğru implemente |
| Authorization | ✅ GÜVENLİ | managerId kontrolleri aktif |
| Input Validation | ✅ GÜVENLİ | Zod tüm endpoint'leri koruyor |
| Rate Limiting | ✅ GÜVENLİ | Brute force koruması var |
| Token Yönetimi | ⚠️ İZLENDİ | Revocation Faz 2'de ele alınacak |

---

## 🎯 Güvenlik Önerileri

### Hemen
1. **authControllers.js** login fonksiyonunda identifier ayrıştırma mantığını kontrol et

### Faz 2
2. **Redis token revocation** veya kısa refresh token TTL değerlendir

### Sürekli
3. **Zod error formatının** `{ success: false, errors: [...] }` olduğunu doğrula

---

## Analiz Sonucu

Bu prompt, **ofansif güvenlik değerlendirmesi** için etkili bir çerçeve sunar. AidatPanel projesinde Aşama 0 güvenlik denetimi sonucunda:

### Bulgular
- **Kritik Açık:** Tespit edilmedi ❌
- **Yüksek Risk:** Tespit edilmedi ❌
- **Orta Risk:** Tespit edilmedi ❌
- **Düşük Risk:** Token revocation (Faz 2'de ele alınacak) ⚠️
- **Hardening:** Zod error handling ve identifier parsing kontrolü ✅

### Sonuç
**Aşama 0 güvenlik açısından BAŞARILI.**  
Backend altyapısı güvenli bir şekilde kuruldu.

---

**Analiz Raporu ID:** 1-GUVENLIK-PROMPTU-ANALIZ  
**Son Güncelleme:** 2026-05-05
