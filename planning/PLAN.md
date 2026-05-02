# AidatPanel — Abdullah Planlama Notları

> Hazırlayan: Abdullah (Lead Developer)  
> Tarih: May 2026  
> Branch: `backend/endpoints`

---

## 1. Mevcut Durum Özeti

| Modül | Durum | Not |
|---|---|---|
| **Auth** | ✅ Temel yapı var | `register`, `login`, `refresh`, `logout` çalışıyor. `join` (davet koduyla kayıt) **commented out** — implemente edilmemiş |
| **Building CRUD** | ✅ Tamam | Service + Controller + Routes mevcut |
| **Apartment CRUD** | ✅ Temel tamam | `GET/POST/DELETE` var, `PUT` (daire güncelleme) **eksik** |
| **Due (Aidat)** | ❌ Yok | Schema var, endpoint yok |
| **Expense (Gider)** | ❌ Yok | Schema var, endpoint yok |
| **Ticket** | ❌ Yok | Schema var, endpoint yok |
| **Notification** | ❌ Yok | Schema var, endpoint yok |
| **Invite Code** | ❌ Yok | Schema var, `join` commented |
| **Reports/PDF** | ❌ Yok | Henüz başlanmamış |
| **Subscription/RevenueCat** | ❌ Yok | Webhook endpoint yok |
| **Profile (/api/me)** | ❌ Yok | Schema var, endpoint yok |
| **FCM Push** | ❌ Yok | Schema'da `fcmToken` alanı var, servis yok |
| **Twilio WhatsApp/SMS** | ❌ Yok | Başlanmamış |

**Yargı:** Backend mimarisinin iskeleti (auth middleware, Prisma, error handling, rate limiting) sağlam kurulmuş. Ancak ~25 endpoint'ten sadece 8-10'u implemente edilmiş. Faz 1'in %60'ı tamamlanmış, Faz 2 ve Faz 3 henüz başlamamış.

---

## 2. Abdullah'ın Yapılacakları — Önceliklendirilmiş Sıra

### A. Kritik — Faz 1'i Tamamla (Önce Bunlar)

1. **Zod Validasyon Middleware** — Tüm POST/PUT body'leri için schema validasyonu. Güvenlik kritik.
2. **Daire Güncelleme (`PUT`)** — `apartmentController.js` + service eksik.
3. **Profile Endpoint'leri (`/api/me`)**
   - `GET /api/me`
   - `PUT /api/me`
   - `PUT /api/me/password`
   - `PUT /api/me/language`
4. **Invite Code Sistemi**
   - `POST /api/apartments/:id/invite-code` (üretim)
   - Validation servisi
   - `join` controller uncomment + transaction güvenliği
5. **Due (Aidat) CRUD + Bulk**
   - `GET /api/buildings/:id/dues`
   - `POST /api/buildings/:id/dues/bulk`
   - `PATCH /api/dues/:id/status`
   - `GET /api/me/dues`

### B. Yüksek Öncelik — Faz 2 Devam

6. **RevenueCat Subscription Middleware** — Aboneliksiz yöneticinin yazma işlemlerini kilitle.
7. **Notification Altyapısı**
8. **Expense (Gider) CRUD**

### C. Orta Öncelik — Faz 3

9. **Ticket Sistemi API** (Yusuf'a devredilebilir)
10. **PDF Raporlama** (`puppeteer` veya `pdfkit`)
11. **Twilio WhatsApp/SMS**
12. **FCM Push Notification Servisi**

---

## 3. Teknik Borç ve Riskler

| Risk | Seviye | Açıklama |
|---|---|---|
| JWT içinde sadece `id` var | Orta | Middleware her istekte DB'den user çekiyor. Token'a `role` eklenmeli ve DB lookup kaldırılmalı. |
| No Input Validation (Zod) | Yüksek | Controller'lar `req.body`'yi doğrudan servise iletiyor. `zod` middleware'i yazılmalı. |
| No DB Transactions | Yüksek | Çok adımlı işlemlerde (örn. `join`) transaction yok. Veri tutarsızlığı riski. |
| No Pagination | Orta | `findMany()` sınır yok, büyüdükçe patlar. |
| No Prisma Indexes | Orta | Foreign key'lerde index yok. |
| Rate Limit MemoryStore | Orta | Tek instance için çalışıyor, PM2 cluster'a geçince çöküyor. |

---

## 4. Takım Koordinasyonu

- **Furkan** (Mobile Lead): Endpoint listesi dokümante edilmeli, mobil ekranlar açılabilir.
- **Yusuf** (Building API): Backend'de bina/daire sen yapmışsın, Yusuf boşta kalma riskinde — Due veya Expense ona verilebilir.
- **Seyit** (UI/Web): Landing page statik olarak başlayabilir.

---

## 5. Önerilen 4 Haftalık Sıra

| Hafta | Görevler |
|---|---|
| **Hafta 1** | Zod middleware, Prisma index, daire PUT, profile endpoints, auth token role |
| **Hafta 2** | Invite code sistemi, Due CRUD + bulk, subscription middleware |
| **Hafta 3** | Notification CRUD, Expense CRUD, FCM entegrasyonu başlangıç |
| **Hafta 4** | PDF rapor, Twilio servisi, rate limiter Redis'e geçiş |

---

*Bu plan Abdullah tarafından oluşturulmuştur ve branch'e commitlenecektir.*
