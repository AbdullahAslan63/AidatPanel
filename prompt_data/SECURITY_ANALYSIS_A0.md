# Aşama 0 — Güvenlik Açığı Kontrol Raporu

> Tarih: 2026-05-03 04:57+  
> Kapsam: JWT role, Auth middleware, Zod validasyon, Apartment PUT

---

## ✅ Güvenlik Doğrulamaları — BAŞARILI

### 1. JWT Token Güvenliği — ✅ GÜVENLİ

| Kontrol | Durum | Açıklama |
|---|---|---|
| Token imzalama | ✅ | `JWT_SECRET` ve `REFRESH_TOKEN_SECRET` env'den |
| Token süreleri | ✅ | Access: 15dk, Refresh: 30gün (güvenli) |
| Payload `role` | ✅ | `MANAGER`/`RESIDENT` enum kontrollü |
| Algorithm | ✅ | Default HS256 (jwt.sign) |

**AGENTS.md Kural Uyumu:**
- ✅ `authMiddleware` DB lookup yapmıyor
- ✅ `req.user = { id, role }` direkt token'dan

### 2. Zod Validasyon Güvenliği — ✅ GÜVENLİ

| Endpoint | Body Validasyon | Params Validasyon | Durum |
|---|---|---|---|
| `POST /register` | ✅ name, email, password | — | Güvenli |
| `POST /login` | ✅ identifier, password | — | Güvenli |
| `POST /refresh` | ✅ refreshToken | — | Güvenli |
| `GET /buildings/:id` | — | ✅ UUID | Güvenli |
| `PUT /buildings/:id` | ✅ name, address, city (opsiyonel) | ✅ UUID | Güvenli |
| `POST /apartments` | ✅ number, floor | ✅ buildingId UUID | Güvenli |
| `PUT /apartments/:id` | ✅ number, floor (opsiyonel) | ✅ buildingId, id UUID | ✅ **YENİ** |
| `DELETE /apartments/:id` | — | ✅ buildingId, id UUID | Güvenli |

**Zod Şema Güvenliği:**
- ✅ Email: `.email()` format kontrolü
- ✅ Şifre: min 6, max 100 karakter
- ✅ UUID: `.uuid()` format kontrolü tüm ID'lerde
- ✅ Türkçe hata mesajları (UX dostu)

### 3. Rate Limiting — ✅ AKTİF

```javascript
// authRoutes.js
declare
router.use(authLimiter);  // Brute force koruması
```

- ✅ Auth endpoint'lerinde rate limiting aktif
- ✅ `authLimiter` memory store (Faz 1 için kabul edilebilir)

### 4. Authorization (Yetkilendirme) — ✅ GÜVENLİ

| Servis | Yetki Kontrolü | Durum |
|---|---|---|
| `buildingService` | `managerId` kontrolü | ✅ Sadece kendi binaları |
| `apartmentService` | `managerId` + `buildingId` kontrolü | ✅ Sadece kendi daireleri |
| `updateApartment` | Bina yöneticisi mi kontrolü | ✅ **YENİ** güvenli |

---

## ⚠️ Düşük Risk Gözlemler

### 1. Zod Error Handling — İzleme Önerisi

```javascript
// validate.js
} catch (error) {
  next(error);  // Error handler middleware'a gidiyor mu?
}
```

**Durum:** ✅ `next(error)` kullanımı doğru.  
**Kontrol:** `errorHandler` middleware'ın ZodError'ları `{ success: false, message, errors }` formatına çevirdiğinden emin olun.

### 2. Login `identifier` Ayrıştırma — Kontrol Gerekli

```javascript
// loginSchema'da:
identifier: z.string().min(1)  // Email VEYA telefon

// Controller'da ayrıştırma mantığı olmalı:
// - @ içeriyorsa → email olarak ara
// - @ içermiyorsa → telefon olarak ara
```

**Öneri:** `authControllers.js` login fonksiyonunda identifier ayrıştırma mantığını doğrula.

### 3. JWT Token Revocation — Faz 2'de Değerlendirilecek

**Risk:** Kullanıcı silinirse veya rol değişirse eski token hâlâ geçerli (15dk/30gün).  
**Çözüm:** Faz 2'de Redis tabanlı token revocation list veya shorter refresh token TTL değerlendirilebilir.

---

## 🔍 Yeni PUT Endpoint Güvenlik Analizi

**Endpoint:** `PUT /api/v1/buildings/:buildingId/apartments/:id`

| Katman | Güvenlik Önlemi | Durum |
|---|---|---|
| Route | `authMiddleware` | ✅ Token zorunlu |
| Route | `validate(apartmentSchemas.update)` | ✅ UUID + body validasyonu |
| Service | `building.managerId !== managerId` kontrolü | ✅ Yetki kontrolü |
| Service | `apartment.findFirst({ id, buildingId })` | ✅ Daire binaya ait mi |

**Sonuç:** ✅ Yeni PUT endpoint tam güvenlik kapsamında.

---

## 📊 Güvenlik Özeti

| Kategori | Durum | Notlar |
|---|---|---|
| Authentication | ✅ GÜVENLİ | JWT + role doğru implemente |
| Authorization | ✅ GÜVENLİ | managerId kontrolleri aktif |
| Input Validation | ✅ GÜVENLİ | Zod tüm endpoint'leri koruyor |
| Rate Limiting | ✅ GÜVENLİ | Brute force koruması var |
| Token Yönetimi | ⚠️ İZLENDİ | Revocation Faz 2'de ele alınacak |

---

## 🎯 Öneriler

1. **Hemen:** `authControllers.js` login fonksiyonunda identifier ayrıştırma mantığını kontrol et
2. **Faz 2:** Redis token revocation veya kısa refresh token TTL değerlendir
3. **Sürekli:** Zod error formatının `{ success: false, errors: [...] }` olduğunu doğrula

**Sonuç:** Aşama 0 güvenlik açısından **BAŞARILI**. Kritik açık tespit edilmedi.
