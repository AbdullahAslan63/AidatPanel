# Backend/Endpoints Branch - Detaylı Analiz Raporu
**Tarih:** 2026-05-03  
**Branch:** `origin/backend/endpoints`  
**Commit:** `1970760`

---

## Genel Yapı

Express.js + Prisma ORM + PostgreSQL  
**Mimari:** Layered Architecture (Routes → Controllers → Services → Prisma)

---

## API Endpoint'leri ve Veri Akışı

| Endpoint | Method | Auth Gerekli | Gönderilecek Veri | Dönen Veri |
|----------|--------|--------------|-------------------|------------|
| `/api/v1/auth/register` | POST | Hayır | `{name, email, password}` | `{success, userId}` |
| `/api/v1/auth/login` | POST | Hayır | `{identifier, password}` (email/telefon) | `{accessToken, refreshToken, user}` |
| `/api/v1/auth/refresh` | POST | Hayır | `{refreshToken}` | `{accessToken}` |
| `/api/v1/auth/logout` | POST | **Evet** | Header: `Authorization: Bearer {token}` | Başarı mesajı |
| `/api/v1/buildings` | GET | **Evet** | - | Bina listesi (yöneticiye ait) |
| `/api/v1/buildings` | POST | **Evet** | `{name, address, city}` | Yeni bina objesi |
| `/api/v1/buildings/:id` | GET | **Evet** | - | Bina detayı |
| `/api/v1/buildings/:id` | PUT | **Evet** | `{name?, address?, city?}` | Güncel bina |
| `/api/v1/buildings/:id` | DELETE | **Evet** | - | Silme onayı |
| `/api/v1/buildings/:buildingId/apartments` | GET | **Evet** | - | Daire listesi |
| `/api/v1/buildings/:buildingId/apartments` | POST | **Evet** | `{number, floor?}` | Yeni daire |
| `/api/v1/buildings/:buildingId/apartments/:id` | PUT | **Evet** | `{number?, floor?}` | Güncel daire |
| `/api/v1/buildings/:buildingId/apartments/:id` | DELETE | **Evet** | - | Silme onayı |

**Auth Header Formatı:** `Authorization: Bearer {accessToken}`

---

## Tespit Edilen Hatalar

### 🔴 Kritik Hatalar (Mutlaka Çözülmeli)

| # | Hata | Lokasyon | Etki | Çözüm |
|---|------|----------|------|-------|
| 1 | **Prisma datasource URL eksik** | `backend/prisma/schema.prisma:11-12` | Database bağlantısı çalışmaz | `url = env("DATABASE_URL")` eklenmeli |
| 2 | **cookie-parser paketi eksik** | `backend/src/middlewares/authMiddleware.js:7` | `req.cookies` çalışmaz, cookie-based auth devre dışı | `npm install cookie-parser` ve `app.use(cookieParser())` ekle |

### 🟡 Orta Öncelikli Sorunlar

| # | Sorun | Lokasyon | Risk |
|---|-------|----------|------|
| 3 | `/join` endpoint'i kapalı (yorumda) | `backend/src/controllers/authControllers.js:102-169` | Davet kodu ile apartmana katılma çalışmaz |
| 4 | Rate limiting çok agresif (15dk/5 login) | `backend/src/middlewares/rateLimitMiddleware.js:24-35` | Mobile app'te kullanıcı deneyimi kötü olabilir |
| 5 | Telefon validasyonu yok | `backend/src/controllers/authControllers.js:37-44` | Geçersiz telefon formatları kabul edilir |
| 6 | Token blacklist yok (logout stateless) | `backend/src/controllers/authControllers.js:171-179` | Çalınan token ile erişim devam eder |

### 🟢 Düşük Öncelikli İyileştirmeler

| # | Sorun | Lokasyon |
|---|-------|----------|
| 7 | Bina yöneticisi değiştirilemez | `backend/src/services/buildingService.js` |
| 8 | Daire silme - resident kontrolü yok | `backend/src/services/apartmentService.js:49-51` |
| 9 | CORS localhost:2773 portu şüpheli | `backend/index.js:26-28` |

---

## Veritabanı Şeması Durumu

### ✅ Tamamlanan Modeller (8/11)
- `User` (MANAGER/RESIDENT rolleri)
- `Building` (Yönetici ilişkisi)
- `Apartment` (Daireler)
- `Subscription` (Abonelik takibi)
- `Due` (Aidatlar)
- `Expense` (Giderler)
- `Ticket` / `TicketUpdate` (Talepler)
- `Notification` (Bildirimler)
- `InviteCode` (Davet kodları)

### ❌ Eksik Endpoint'ler (Schema var, API yok)
| Model | Endpoint Gerekli |
|-------|------------------|
| `Due` | Aidat CRUD, ödeme takibi |
| `Expense` | Gider ekleme/listeleme |
| `Ticket` | Talep oluşturma/güncelleme |
| `Notification` | Bildirim listeleme/okuma |
| `InviteCode` | Kod oluşturma/doğrulama |

---

## Mobil Entegrasyon Rehberi

### 1. Başlangıç Ayarları
```bash
# Backend .env gerekli değişkenler:
DATABASE_URL="postgresql://..."
JWT_SECRET="your-jwt-secret"
REFRESH_TOKEN_SECRET="your-refresh-secret"
PORT=3000
```

### 2. Kritik Fix'ler (Önce Yapılmalı)
1. `backend/prisma/schema.prisma` - datasource URL ekle
2. `npm install cookie-parser` + `index.js`'e import et

### 3. API Çağrı Sırası (Test Akışı)
```
1. POST /api/v1/auth/register
   → {name, email, password}
   ← {success, userId}

2. POST /api/v1/auth/login
   → {identifier: "email", password}
   ← {accessToken, refreshToken, user}

3. Header'a ekle: Authorization: Bearer {accessToken}

4. POST /api/v1/buildings
   → {name, address, city}
   ← Building objesi

5. POST /api/v1/buildings/{id}/apartments
   → {number, floor}
   ← Apartment objesi
```

---

## Risk Değerlendirmesi

| Kategori | Seviye | Açıklama |
|----------|--------|----------|
| Production Kullanım | 🔴 **YÜKSEK RISK** | Kritik hatalar çözülmeden deploy edilmemeli |
| Development/Test | 🟡 **ORTA RISK** | Dikkatli kullanılabilir |
| Mobil Entegrasyon | 🟡 **ORTA RISK** | Rate limiting ve eksik endpoint'ler bloklayabilir |

---

## Önerilen Sonraki Adımlar

1. **Hemen:** Kritik hataları düzelt (Prisma URL, cookie-parser)
2. **Faz 1:** Due/Expense/Ticket endpoint'lerini ekle
3. **Faz 2:** InviteCode/join sistemini aktifleştir
4. **Faz 3:** Rate limiting'i mobile-friendly hale getir
5. **Faz 4:** Token blacklist (Redis) implementasyonu

---

*Rapor: Cascade AI | Analiz tarihi: 2026-05-03*
