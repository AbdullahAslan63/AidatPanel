# AidatPanel — Abdullah Analiz ve Yol Haritası

> Kaynaklar: AIDATPANEL.md, GOREVDAGILIMI.md, AGENTS.md, MASTER_SYSTEM_PROMPT.md  
> Branch: `backend/endpoints` | Abdullah — Lead Developer (Backend, DevOps, Entegrasyonlar)

---

## 1. Proje Genel Durum

Flutter + Node.js/Express/Prisma + PostgreSQL apartman aidat yönetim platformu. Backend iskeleti sağlam ama ~25 endpoint'ten sadece 8-10'u implemente. Faz 1 %60 tamamlanmış. Mobile klasörü silindi.

---

## 2. Faz 1 MVP-1: Abdullah Görev Durumu

| Görev (GOREVDAGILIMI) | Durum | Eksik |
|---|---|---|
| PostgreSQL + Prisma şema | ✅ | `@@index` eklenecek |
| JWT Auth (Access/Refresh) | ✅ | `role` payload'a eklenecek |
| API mimarisi (`/api/v1`) | ✅ | — |
| Profile endpoint'leri | ❌ | Tümü (`GET/PUT /api/me`, şifre, dil) |
| Apartment PUT | ❌ | Güncelleme eksik |
| Zod validasyon | ❌ | Middleware yok |

**Ek not:** Yusuf'a verilen "Bina/Daire CRUD" backend'de Abdullah yapmış. Yusuf Faz 1'de boşta kalma riskinde.

---

## 3. Teknik Borç — Faz 1'de Çözülmeli

| Risk | Seviye | Çözüm |
|---|---|---|
| No Zod validation | **KRİTİK** | `validateMiddleware` yaz, tüm POST/PUT route'lara uygula |
| JWT payload sadece `id` | **Yüksek** | `role` ekle, middleware DB lookup kaldır |
| No DB transactions | **Yüksek** | `join` + bulk due `$transaction` ile |
| No Prisma indexes | **Orta** | Foreign key'lere `@@index` ekle |

**Faz 1 DIŞI:** Pagination, Redis rate limiter, PDF rapor, Twilio, Ticket sistemi, online ödeme.

---

## 4. Abdullah'ın Aşamalandırılmış Faz 1 Sırası

### Aşama 0: Temel (1 gün)
1. Zod `validateMiddleware`
2. Prisma `@@index` migration
3. JWT payload `role` + middleware kaldırma
4. Daire `PUT` endpoint

### Aşama 1: Profil (1 gün)
5. `GET/PUT /api/me`
6. Şifre/dil değiştirme

### Aşama 2: Davet Kodu + Join (1.5 gün)
7. Invite code üretim/validasyon
8. `join` uncomment + transaction

### Aşama 3: Aidat (2 gün)
9. Due CRUD + bulk create
10. Sakin listeleme (`/api/me/dues`)

### Aşama 4: Abonelik + Bildirim (2 gün)
11. RevenueCat webhook + middleware
12. Notification CRUD + FCM token update

### Aşama 5: Gider (1 gün)
13. Expense CRUD + aylık özet

### Aşama 6: El Sıkışma (1.5 gün)
14. API dokümantasyonu (Furkan için)
15. Test coverage (auth + building + apartment)

**Toplam: ~10 gün**

---

## 5. Faz 2 Önizleme (MVP-2 — Güncellenecek)

Abdullah:
- Davet kodu algoritması (üretim, doğrulama, 7 gün TTL)
- Toplu aidat bulk creation
- RevenueCat subscription middleware + webhook

Yusuf'a devredilebilecek:
- Sakin dashboard API (`GET /api/me/dues`, filtreleme)

Furkan mobilde:
- Manager dashboard (daire listesi, davet kodu popup)
- Aidat durumu manuel değiştirme

---

## 6. Faz 3 Önizleme (Final — Güncellenecek)

Abdullah:
- PDF rapor servisi (aylık bina özeti)
- Twilio WhatsApp/SMS hatırlatıcı

Yusuf:
- Gider CRUD + aylık özet API

Furkan:
- Ticket sistemi mobil arayüzü

---

## 7. Takım Koordinasyonu

| Üye | Abdullah'dan Beklediği | Abdullah'ın İhtiyacı |
|---|---|---|
| Furkan (Mobile Lead) | Endpoint dokümanı + auth flow | Mobil mockup'lar, API ihtiyaçları |
| Yusuf (Junior) | Scaffolded görevler | Due/Expense endpoint'lerine destek |
| Seyit (UI/Web) | Landing page için API dok. yok | Statik landing + KVKK metni |

**Kural (GOREVDAGILIMI):** Abdullah tüm MR'leri inceleyip onay verir. Herkes kendi branch'inde çalışır.

---

## 8. Tasarım Kısıtları (50+ Yaş Kullanıcı)

AIDATPANEL.md'den:
- Min font: **16sp**
- Min dokunma alanı: **48dp**
- Hamburger menü yerine **Bottom Navigation**
- Hata mesajları: teknik terimlerden arındırılmış Türkçe

---

*Bu plan Faz 1 odaklıdır. Faz 2 ve Faz 3 MVP'ye ulaşıldığında güncellenecektir.*
