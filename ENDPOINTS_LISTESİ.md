# AidatPanel Backend - Aktif Endpoint Listesi

> Son güncelleme: 2026-05-05  
> Not: Test eden kişi response detaylarını keşfedecektir.

---

## 🔐 Auth (`/api/v1/auth`)

Tüm auth endpoint'leri rate limit koruması altındadır (15 dk'da 100 istek).

### POST /register
Yeni kullanıcı kaydı (yönetici oluşturur).

**req.body:**
```json
{
  "name": "string (min 2, max 50)",
  "email": "string (email format)",
  "password": "string (min 6, max 100)"
}
```

---

### POST /login
Kullanıcı girişi. **identifier** parametresi email veya telefon numarası olabilir - şu an sadece email destekleniyor.

**req.body:**
```json
{
  "identifier": "string - Email veya telefon numarası (şu an sadece email)",
  "password": "string"
}
```

> 💡 **Not:** `identifier` ismi gelecekte telefon numarası desteği için seçildi. Şu an sadece email gönderin.

---

### POST /refresh
Access token'ı yenilemek için refresh token kullan.

**req.body:**
```json
{
  "refreshToken": "string"
}
```

---

### POST /logout
Aktif kullanıcıyı çıkış yap. **Auth header gerekli.**

**Headers:**
```
Authorization: Bearer {accessToken}
```

**req.body:** Yok

---

## 🏢 Buildings (`/api/v1/buildings`)

Tüm endpoint'ler **auth gerekli** (Authorization header).

### POST /
Yeni bina oluştur. Otomatik olarak giriş yapmış kullanıcıya (manager) atanır.

**req.body:**
```json
{
  "name": "string (min 2, max 100)",
  "address": "string (min 5, max 200)",
  "city": "string (min 2, max 50)"
}
```

---

### GET /
Giriş yapmış yöneticiye ait tüm binaları listele.

**req.body:** Yok  
**req.query:** Yok

---

### GET /:id
Belirli bir binanın detaylarını getir.

**URL Params:**
- `id`: UUID string

**req.body:** Yok

---

### PUT /:id
Bina bilgilerini güncelle. Sadece kendi binaları güncellenebilir.

**URL Params:**
- `id`: UUID string

**req.body:** (tüm alanlar optional)
```json
{
  "name": "string (min 2, max 100)",
  "address": "string (min 5, max 200)",
  "city": "string (min 2, max 50)"
}
```

---

### DELETE /:id
Bina sil. Daireler cascade olarak silinir.

**URL Params:**
- `id`: UUID string

**req.body:** Yok

---

## 🏠 Apartments (`/api/v1/buildings/:buildingId/apartments`)

Tüm endpoint'ler **auth gerekli**. Bir binaya ait daire işlemleri.

### GET /
Belirli bir binadaki tüm daireleri listele.

**URL Params:**
- `buildingId`: UUID string

**req.body:** Yok

---

### POST /
Bir binaya yeni daire ekle.

**URL Params:**
- `buildingId`: UUID string

**req.body:**
```json
{
  "number": "string (min 1, max 10) - Örn: 'A-101', 'Daire 5'",
  "floor": "number (integer, min -5, max 200) - opsiyonel"
}
```

---

### PUT /:id
Daire bilgilerini güncelle.

**URL Params:**
- `buildingId`: UUID string
- `id`: UUID string (daire ID)

**req.body:** (tüm alanlar optional)
```json
{
  "number": "string (min 1, max 10)",
  "floor": "number (integer, min -5, max 200)"
}
```

---

### DELETE /:id
Daire sil.

**URL Params:**
- `buildingId`: UUID string
- `id`: UUID string (daire ID)

**req.body:** Yok

---

## 📋 Özet Tablo

| Endpoint | Metod | Auth | Açıklama |
|----------|-------|------|----------|
| `/api/v1/auth/register` | POST | - | Kayıt |
| `/api/v1/auth/login` | POST | - | Giriş |
| `/api/v1/auth/refresh` | POST | - | Token yenileme |
| `/api/v1/auth/logout` | POST | ✅ | Çıkış |
| `/api/v1/buildings` | POST | ✅ | Bina oluştur |
| `/api/v1/buildings` | GET | ✅ | Binaları listele |
| `/api/v1/buildings/:id` | GET | ✅ | Bina detayı |
| `/api/v1/buildings/:id` | PUT | ✅ | Bina güncelle |
| `/api/v1/buildings/:id` | DELETE | ✅ | Bina sil |
| `/api/v1/buildings/:buildingId/apartments` | GET | ✅ | Daireleri listele |
| `/api/v1/buildings/:buildingId/apartments` | POST | ✅ | Daire ekle |
| `/api/v1/buildings/:buildingId/apartments/:id` | PUT | ✅ | Daire güncelle |
| `/api/v1/buildings/:buildingId/apartments/:id` | DELETE | ✅ | Daire sil |

---

**Not:** Tüm endpoint'ler `Content-Type: application/json` header'ı bekler.
