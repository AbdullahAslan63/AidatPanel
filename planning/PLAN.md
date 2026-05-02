# AidatPanel — Faz 1 Yol Haritası (Abdullah)

> Kapsam: Sadece Faz 1 (MVP) — Faz 2 ve Faz 3 dışarıda.  
> Hedef: Backend'te sağlam, test edilebilir, güvenli temel atmak.  
> Branch: `backend/endpoints`  
> Tarih: May 2026

---

## Faz 1 MVP Kapsamı

AIDATPANEL.md'ye göre Faz 1 şunları içerir:
- Auth (register, login, JWT, davet koduyla katılım)
- Bina ve daire CRUD
- Davet kodu sistemi
- Aylık aidat oluşturma (toplu) ve durum güncelleme
- Sakin: kendi aidat durumunu görme
- FCM push notification altyapısı
- RevenueCat abonelik entegrasyonu
- Landing page (web)

---

## Mevcut Durum (Faz 1 İçinde)

| Modül | Durum | Eksik |
|---|---|---|
| **Auth** | ✅ register, login, refresh, logout | `join` (davet koduyla kayıt) — commented out |
| **Building CRUD** | ✅ Tamam | — |
| **Apartment CRUD** | ⚠️ GET/POST/DELETE var | `PUT` (daire güncelleme) eksik |
| **Profile (/api/me)** | ❌ Yok | Tüm endpoint'ler |
| **Invite Code** | ❌ Yok | Üretim, doğrulama, `join` flow |
| **Due (Aidat)** | ❌ Yok | CRUD, bulk create, sakin listeleme |
| **Expense (Gider)** | ❌ Yok | CRUD |
| **Notification** | ❌ Yok | Listeleme, okundu işaretleme, FCM token update |
| **Subscription** | ❌ Yok | RevenueCat webhook, middleware |
| **Zod Validasyon** | ❌ Yok | Tüm POST/PUT body'leri savunmasız |
| **Prisma Index** | ❌ Yok | Foreign key'lerde index yok |

---

## Aşamalandırma (Sıralı — Önceki bitmeden sonrakine geçme)

### Aşama 0: Güvenlik ve Altyapı Temeli
*Hedef: Üzerine inşa edilecek sağlam bir zemini oluşturmak.*

| # | Görev | Çıktı | Süre |
|---|---|---|---|
| 0.1 | **Zod validasyon middleware** yaz | `src/middlewares/validateMiddleware.js` | 2-3 saat |
| 0.2 | **Prisma schema index** ekle (`@@index`) | Migration dosyası | 1 saat |
| 0.3 | **JWT payload'a `role` ekle**, middleware'den DB lookup kaldır | `generateTokens.js` + `authMiddleware.js` | 1 saat |
| 0.4 | **Daire güncelleme (`PUT`)** endpoint'i ekle | `apartmentController.js` + service | 1 saat |
| 0.5 | **DB Transactions** pattern'ini belirle (Prisma `$transaction`) | Kod standardı | 30 dk |

**Aşama 0 çıktısı:** Tüm sonraki geliştirmeler bu güvenlik zemini üzerine kurulur. Zod olmadan hiçbir POST/PUT endpoint'i deploy edilmez.

---

### Aşama 1: Kullanıcı Profili ve Temel CRUD
*Hedef: Kullanıcı kendi verisini yönetebilsin, daire bilgisi güncellenebilsin.*

| # | Görev | Endpoint | Süre |
|---|---|---|---|
| 1.1 | **Profile GET** | `GET /api/v1/me` | 1 saat |
| 1.2 | **Profile PUT** (name, email, phone, dil) | `PUT /api/v1/me` | 1 saat |
| 1.3 | **Şifre değiştirme** | `PUT /api/v1/me/password` | 1 saat |
| 1.4 | **Dil değiştirme** | `PUT /api/v1/me/language` | 30 dk |
| 1.5 | **KVKK — Hesap silme** | `DELETE /api/v1/me` | 1 saat |
| 1.6 | **Zod schema'ları** tüm yukarıdaki endpoint'lere uygula | Middleware | 1 saat |

**Aşama 1 çıktısı:** Kullanıcı profil yönetimi tam. Mobil ekran bağlanabilir.

---

### Aşama 2: Sakin Onboarding — Davet Kodu Sistemi
*Hedef: Yönetici daireye sakin davet edebilsin, sakin kodla kaydolabilsin. Bu Faz 1'in en kritik akışı.*

| # | Görev | Endpoint / Dosya | Süre |
|---|---|---|---|
| 2.1 | **Invite code üretim** servisi | `POST /api/v1/apartments/:id/invite-code` | 2 saat |
| 2.2 | **Invite code doğrulama** servisi | `GET /api/v1/invite-codes/:code/validate` | 1 saat |
| 2.3 | **Join controller'ı uncomment et**, transaction ile güvenli hale getir | `authControllers.js` | 2 saat |
| 2.4 | **Zod schema** (invite code üretim + join body) | `src/validators/` | 1 saat |
| 2.5 | **Invite code temizleme** — 7 gün dolmuş kullanılmamış kodları sil (opsiyonel cron) | Prisma query | 30 dk |

**Aşama 2 çıktısı:** Sakin onboarding akışı uçtan uca çalışır. Yönetici kod üretir, sakin kodla kaydolur ve otomatik daireye atanır.

---

### Aşama 3: Aidat (Due) Sistemi
*Hedef: Yönetici aidat oluştursun, sakin kendi aidatını görsün.*

| # | Görev | Endpoint | Süre |
|---|---|---|---|
| 3.1 | **Due model** schema kontrolü (mevcut ama doğrula) | `schema.prisma` | 30 dk |
| 3.2 | **Toplu aidat oluşturma** (bulk — tüm dairelere aynı ay/yıl) | `POST /api/v1/buildings/:id/dues/bulk` | 3 saat |
| 3.3 | **Aidat listeleme** (yönetici — bina bazlı) | `GET /api/v1/buildings/:id/dues` | 1 saat |
| 3.4 | **Aidat durum güncelleme** (ödendi/ödenmedi) | `PATCH /api/v1/dues/:id/status` | 1 saat |
| 3.5 | **Sakin aidat geçmişi** | `GET /api/v1/me/dues` | 1 saat |
| 3.6 | **Aidat silme** (yönetici — hatalı girişi düzeltme) | `DELETE /api/v1/dues/:id` | 1 saat |
| 3.7 | **Zod schema** (due body validation) | `src/validators/` | 1 saat |

**Aşama 3 çıktısı:** Aidat döngüsü tamamen çalışır. Yönetici oluşturur, günceller, sakin görür.

---

### Aşama 4: Abonelik ve Bildirim Altyapısı
*Hedef: Yönetici abonelik kontrolü altında çalışsın, bildirim sistemi hazır olsun.*

| # | Görev | Endpoint / Dosya | Süre |
|---|---|---|---|
| 4.1 | **RevenueCat webhook** endpoint'i | `POST /api/v1/subscription/webhook/revenuecat` | 2 saat |
| 4.2 | **Subscription middleware** — aboneliksiz yöneticinin yazma işlemlerini engelle | `src/middlewares/subscriptionMiddleware.js` | 2 saat |
| 4.3 | **Subscription status GET** | `GET /api/v1/me/subscription` | 1 saat |
| 4.4 | **Notification listeleme** | `GET /api/v1/notifications` | 1 saat |
| 4.5 | **Notification okundu işaretleme** (tek ve tümü) | `PATCH /api/v1/notifications/:id/read`, `PATCH /api/v1/notifications/read-all` | 1 saat |
| 4.6 | **FCM token güncelleme** | `PUT /api/v1/me/fcm-token` | 1 saat |
| 4.7 | **FCM push servisi** altyapısı (Firebase Admin SDK init + send fonksiyonu) | `src/services/notificationService.js` | 2 saat |

**Aşama 4 çıktısı:** Abonelik kontrolü aktif. Bildirim altyapısı backend'te hazır. Mobil FCM entegrasyonu bekler.

---

### Aşama 5: Gider (Expense) Temeli
*Hedef: Yönetici bina giderlerini kaydedebilsin.*

| # | Görev | Endpoint | Süre |
|---|---|---|---|
| 5.1 | **Expense CRUD** | `GET/POST /api/v1/buildings/:id/expenses`, `PUT/DELETE /api/v1/expenses/:id` | 2 saat |
| 5.2 | **Aylık gider özeti** | `GET /api/v1/buildings/:id/expenses/summary` | 1 saat |
| 5.3 | **Zod schema** (expense validation) | `src/validators/` | 30 dk |

**Aşama 5 çıktısı:** Gider kaydı ve listeleme çalışır.

---

### Aşama 6: Dokümantasyon ve El Sıkışma
*Hedef: Mobil takımın (Furkan) bağlanabileceği endpoint listesi.*

| # | Görev | Çıktı | Süre |
|---|---|---|---|
| 6.1 | **Tüm Faz 1 endpoint'lerinin dokümantasyonu** | `backend/API.md` veya Postman collection | 2-3 saat |
| 6.2 | **Auth flow diagram** (login → refresh → logout) | Markdown şema | 30 dk |
| 6.3 | **Hata kodları ve mesajları** standardizasyonu | Kod + doküman | 1 saat |
| 6.4 | **Test coverage** — auth + building + apartment için temel testler | `__tests__/` | 3-4 saat |

**Aşama 6 çıktısı:** Backend Faz 1 tamamlanmış ve dokümante edilmiş. Mobil takım entegrasyona başlayabilir.

---

## Teknik Borç — Faz 1 İçinde Çözülecek

| Risk | Aşama | Çözüm |
|---|---|---|
| No Input Validation (Zod) | **Aşama 0.1** | Zod middleware tüm POST/PUT route'lara uygulanır |
| No DB Transactions | **Aşama 2.3** | `join` ve bulk due creation `$transaction` ile yazılır |
| No Prisma Indexes | **Aşama 0.2** | Foreign key'lere `@@index` eklenir |
| JWT sadece `id` | **Aşama 0.3** | `role` eklenir, DB lookup kaldırılır |

**Faz 1 DIŞINDA bırakılacaklar:** Pagination, cursor-based pagination, Redis rate limiter, PDF raporlama, Twilio entegrasyonu, Ticket sistemi, online ödeme (İyzico/PayTR), çoklu yönetici, istatistik dashboard.

---

## Takım Koordinasyonu (Faz 1 Sınırlarında)

| Takım Üyesi | Faz 1'de Abdullah'dan Beklediği | Abdullah'ın Onlara İhtiyacı |
|---|---|---|
| **Furkan** (Mobile Lead) | Endpoint listesi + auth flow dokümanı | Mobil ekran mockup'ları ve API ihtiyaçları |
| **Yusuf** | Building/apartment endpoint'leri zaten hazır | Due veya Expense endpoint'lerine destek (isteğe bağlı) |
| **Seyit** | Landing page için API dokümantasyonu yok — statik sayfa yeter | Web landing page tasarımı ve KVKK metni |

---

## Tahmini Faz 1 Süresi (Abdullah, tek başına)

| Aşama | Süre |
|---|---|
| Aşama 0 | 1 gün |
| Aşama 1 | 1 gün |
| Aşama 2 | 1.5 gün |
| Aşama 3 | 2 gün |
| Aşama 4 | 2 gün |
| Aşama 5 | 1 gün |
| Aşama 6 | 1.5 gün |
| **Toplam** | **~10 gün** (full-time odaklanarak) |

---

*Bu plan sadece Faz 1 (MVP) ile sınırlıdır. Faz 2 ve Faz 3 bu planın kapsamı dışındadır.*
