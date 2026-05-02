# Changelog

Tüm önemli değişiklikler bu dosyada kronolojik olarak listelenmektedir.

Format: [Tarih - Saat] - Değişiklik özeti

---

## [2026-05-02 - 03:38] - AGENTS.md Oluşturuldu
- `planning/AGENTS_PROMPTU.md` promptu çalıştırıldı
- Repo-spesifik kritik kısıtlamalar dokümante edildi:
  - ES Modules `.js` uzantı zorunluluğu
  - PrismaNeon → PrismaPg adapter geçişi
  - `/api/v1` route prefix
  - Zod schema merkezileştirme (`validate.js`)
  - Service layer kullanım zorunluluğu
  - MANAGER auto-create, RESIDENT invite-only
  - managerId IDOR koruması

## [2026-05-02 - 03:38] - MASTER_SYSTEM_PROMPT.md Oluşturuldu
- `planning/MASTER_PROMPTU.md` promptu çalıştırıldı
- AI Co-Founder persona: Abdullah Aslan profiline göre özelleştirildi
- Holding yapısı, baştan-sağlam mühendislik, öğret-ve-büyüt modeli

## [2026-05-02 - 03:52] - Test Dosyaları Silindi & Adapter Değişimi
- `backend/__tests__/auth.test.js` silindi
- `backend/__tests__/setup.js` silindi
- `backend/test_register.py` silindi
- `backend/jest.config.js` silindi
- `backend/__tests__/` klasörü silindi
- `package.json`: test scriptleri ve bağımlılıklar (`jest`, `supertest`, `@jest/globals`) kaldırıldı
- Database adapter: `PrismaNeon` → `PrismaPg` + `pg.Pool`
- AGENTS.md güncellendi (PrismaPg kuralı)

## [2026-05-02 - 04:03] - Backend Response Standardizasyonu - Adım 1 (Auth Controllers)
- `authControllers.js`:
  - `register`: `error:` → `message:`, HTTP 400 → 409, `try/catch` + `next(error)`
  - `login`: `error:` → `message:`, HTTP 400 → 401, `try/catch` + `next(error)`
  - `refreshToken`: `error:` → `message:`, HTTP 404 → 401, manuel catch → `next(error)`
  - Tüm fonksiyonlara `(req, res, next)` signature eklendi

## [2026-05-02 - 04:12] - Backend Response Standardizasyonu - Adım 2 (Auth Middleware)
- `authMiddleware.js`:
  - `error:` → `message:` + `success: false`
  - JWT hataları manuel yakalama → `next(error)` (global handler'a yönlendirme)

## [2026-05-02 - 04:18] - Backend Response Standardizasyonu - Adım 3 (Building & Apartment Controllers)
- `buildingController.js`: Tüm 5 fonksiyondan manuel `try/catch` kaldırıldı (Express 5 otomatik yakalar)
  - `createBuilding`, `getBuildings`, `getBuildingById`, `updateBuilding`, `deleteBuilding`
  - Kod ~148 satırdan ~98 satıra indi
- `apartmentController.js`: Tüm 3 fonksiyondan manuel `try/catch` kaldırıldı
  - `getApartments`, `createApartment`, `deleteApartment`
  - Kod ~109 satırdan ~79 satıra indi
- Artık tüm Prisma/Zod/JWT hataları global `errorHandler.js` üzerinden akıyor

## [2026-05-02 - 04:27] - CORS Yapılandırması & Port Güncellemesi
- `backend/index.js`: CORS güncellendi
  - Dinamik origin fonksiyonu (mobil uyumlu - `!origin` kontrolü)
  - `api.aidatpanel.com:2773`, `aidatpanel.com` eklendi
  - `PATCH` metodu eklendi
- `mobile/lib/core/constants/api_constants.dart`: Port 4200 → 2773
- `AGENTS.md`: Port referansı 4200 → 2773 güncellendi

## [2026-05-02 - 04:36] - Email + Telefon Girişi Desteği
- `prisma/schema.prisma`: `phone String?` → `phone String? @unique`
- `src/middlewares/validate.js`: `login` schema `email` → `identifier` (email veya telefon)
- `src/controllers/authControllers.js`: Login fonksiyonu dual-mode
  - `identifier.includes('@')` kontrolü ile email/telefon tespiti
  - Dinamik `where: { email }` veya `where: { phone }` sorgusu
- AGENTS.md: Login identifier kuralı eklendi

## Yapılacaklar (Manuel)
- [ ] `npx prisma migrate dev --name add_phone_unique` çalıştır
- [ ] Flutter tarafında login request body: `email` → `identifier` güncelle
- [ ] Veritabanında çakışan telefon numaraları varsa temizle

---

## Önceki Değişiklikler (Özet)

### Auth Sistemi
- JWT-based authentication (accessToken + refreshToken)
- Stateless JWT (blacklist yok, client-side token silme)
- `authMiddleware` tüm protected route'larda aktif

### Building / Apartment CRUD
- Manager-scoped: tüm sorgularda `managerId` filtresi
- RESTful nested routes: `/api/v1/buildings/:buildingId/apartments`
- Zod validasyon: `validate.js` merkezi schema yönetimi

### Güvenlik
- Helmet (HTTP headers)
- Rate limiting (`apiLimiter`: 15dk/100 istek)
- CORS (mobil + web uyumlu)
- `bcryptjs` password hashing (salt rounds: 10)

### Hata Yönetimi
- Global `errorHandler.js`: Zod, Prisma (P2002, P2003, P2025), JWT, Rate limit
- Standard response: `{ success: boolean, message: string, data?: any }`
