# AidatPanel.md - Master Reference Analiz Raporu

## Analiz Tarihi
2026-05-06

## Analiz Edilen Kaynak
**Dosya:** `planning/AIDATPANEL.md`  
**Tür:** Proje Master Reference Dokümantasyonu  
**Kapsam:** Full-stack mobil aidat yönetim platformu

---

## Proje Özeti

**AidatPanel**, Türk apartman ve site yöneticileri için geliştirilmiş bir mobil aidat yönetim platformudur.

### Teknik Özellikler

| Özellik | Değer |
|---------|-------|
| **Domain** | aidatpanel.com (Cloudflare) |
| **Platform** | iOS + Android (Flutter) |
| **Backend** | Node.js + Express |
| **Veritabanı** | PostgreSQL |
| **ORM** | Prisma |
| **Web** | Statik Landing Page |
| **Deployment** | Contabo VPS (OkulOptik ile ortak) |

---

## Backend Stack Analizi

### Çalışma Zamanı ve Framework
- **Runtime:** Node.js 20+
- **Framework:** Express.js
- **ORM:** Prisma
- **Veritabanı:** PostgreSQL

### Harici Servisler
- **Auth:** JWT (access: 15dk, refresh: 30 gün)
- **Email:** Resend (noreply@aidatpanel.com)
- **Push Notification:** Firebase Admin SDK (FCM)
- **SMS/WhatsApp:** Twilio
- **Abonelik:** RevenueCat REST API
- **Deployment:** PM2 + CloudPanel
- **Subdomain:** api.aidatpanel.com

### Ortam Değişkenleri (.env)
```
PORT=4200
DATABASE_URL=postgresql://aidatpanel:PASSWORD@localhost:5432/aidatpanel
JWT_SECRET=...
JWT_REFRESH_SECRET=...
RESEND_API_KEY=...
FIREBASE_SERVICE_ACCOUNT_JSON=...
TWILIO_ACCOUNT_SID=...
TWILIO_AUTH_TOKEN=...
TWILIO_WHATSAPP_FROM=whatsapp:+14155238886
REVENUECAT_API_KEY=...
REVENUECAT_WEBHOOK_SECRET=...
```

---

## Veritabanı Şeması Analizi

### Entity Relationship Diagram (Prisma)

```
User (1) ←→ (N) Building (Manager)
User (1) ←→ (0..1) Apartment (Resident)
Building (1) ←→ (N) Apartment
Apartment (1) ←→ (N) Due
Apartment (1) ←→ (N) InviteCode
Apartment (1) ←→ (N) Ticket
User (1) ←→ (0..1) Subscription
User (1) ←→ (N) Notification
Building (1) ←→ (N) Expense
Ticket (1) ←→ (N) TicketUpdate
```

### Modeller

#### User Model
- `id`, `email`, `passwordHash`, `name`, `phone`
- `role`: MANAGER | RESIDENT
- `fcmToken`, `language` (default: "tr")
- **İlişkiler:** managedBuildings, apartment, notifications, tickets, subscription

#### Building Model
- `id`, `name`, `address`, `city`
- **İlişkiler:** manager (User), apartments, expenses

#### Apartment Model
- `id`, `number` ("B-12", "3A"), `floor`
- **İlişkiler:** building, residents, dues, inviteCodes, tickets

#### Due (Aidat) Model
- `id`, `amount` (Decimal), `currency` (default: "TRY")
- `month` (1-12), `year`, `status`: PENDING | PAID | OVERDUE | WAIVED
- `paidAt`, `note`

#### InviteCode Model
- `id`, `code` (unique, 12 karakter)
- `usedAt`, `usedBy`, `expiresAt`
- **Format:** "AP3-B12-X7K9" (bina ve daire ID'sine bağlı)

#### Subscription Model
- `id`, `status`: ACTIVE | EXPIRED | CANCELLED | TRIAL
- `plan`: "monthly" | "annual", `platform`: "ios" | "android"
- `currentPeriodStart`, `currentPeriodEnd`

---

## API Endpoint'leri Analizi

### Auth Endpoints
```
POST   /api/auth/register          # Yönetici kaydı
POST   /api/auth/login             # Giriş
POST   /api/auth/refresh           # Token yenile
POST   /api/auth/logout            # Çıkış
POST   /api/auth/join              # Sakin davet koduyla kaydolur
POST   /api/auth/forgot-password   # Şifre sıfırlama maili
POST   /api/auth/reset-password    # Yeni şifre set
```

### Buildings (Yönetici only)
```
GET    /api/buildings              # Tüm apartmanlar
POST   /api/buildings              # Yeni apartman ekle
GET    /api/buildings/:id          # Apartman detayı
PUT    /api/buildings/:id          # Güncelle
DELETE /api/buildings/:id          # Sil
```

### Apartments (Yönetici only)
```
GET    /api/buildings/:id/apartments                    # Daire listesi
POST   /api/buildings/:id/apartments                    # Daire ekle
PUT    /api/buildings/:buildingId/apartments/:id      # Güncelle ✅
DELETE /api/buildings/:buildingId/apartments/:id       # Sil
POST   /api/apartments/:id/invite-code                 # Davet kodu üret
```

### Dues (Aidat)
```
GET    /api/buildings/:id/dues               # Tüm aidat listesi (Yönetici)
POST   /api/buildings/:id/dues/bulk          # Toplu aidat oluştur (Yönetici) ⏳
PATCH  /api/dues/:id/status                  # Ödendi işaretle (Yönetici) ⏳
GET    /api/me/dues                          # Kendi aidatlarım (Sakin) ⏳
```

### Expenses (Gider)
```
GET    /api/buildings/:id/expenses           # Gider listesi (Yönetici) ⏳
POST   /api/buildings/:id/expenses           # Gider ekle (Yönetici) ⏳
PUT    /api/expenses/:id                     # Güncelle (Yönetici) ⏳
DELETE /api/expenses/:id                     # Sil (Yönetici) ⏳
GET    /api/buildings/:id/expenses/summary   # Aylık özet (Yönetici) ⏳
```

### Tickets (Arıza/Talep)
```
GET    /api/buildings/:id/tickets            # Tüm talepler (Yönetici) ⏳
GET    /api/tickets/:id                      # Talep detayı ⏳
POST   /api/apartments/:id/tickets           # Yeni talep (Sakin) ⏳
POST   /api/tickets/:id/updates             # Güncelleme ekle (Yönetici) ⏳
PATCH  /api/tickets/:id/status              # Durum değiştir (Yönetici) ⏳
GET    /api/me/tickets                       # Kendi taleplerim (Sakin) ⏳
```

### Notifications, Reports, Subscription, Profile
⏳ Faz 2 ve Faz 3'te implemente edilecek

**Durum:**
- ✅ Tamamlandı
- 🔄 Devam ediyor
- ⏳ Planlandı

---

## Flutter Uygulaması Yapısı

### Temel Paketler (pubspec.yaml)
```yaml
dependencies:
  flutter_riverpod: ^2.5.0      # State Management
  go_router: ^13.0.0             # Navigation
  dio: ^5.4.0                    # HTTP Client
  flutter_secure_storage: ^9.0.0 # JWT Token Storage
  firebase_core: ^3.0.0          # Firebase
  firebase_messaging: ^15.0.0    # Push Notifications
  purchases_flutter: ^7.0.0      # RevenueCat IAP
```

### Klasör Yapısı
```
mobile/lib/
├── core/
│   ├── constants/          # api_constants.dart
│   ├── theme/              # app_colors.dart, app_typography.dart
│   ├── router/             # app_router.dart (GoRouter)
│   ├── network/            # dio_client.dart
│   └── storage/            # secure_storage.dart
├── l10n/                   # app_tr.arb, app_en.arb
├── features/
│   ├── auth/               # login, register, join
│   ├── dashboard/          # manager_dashboard, resident_dashboard
│   ├── buildings/
│   ├── apartments/
│   ├── dues/
│   ├── expenses/
│   ├── tickets/
│   ├── notifications/
│   ├── reports/
│   └── subscription/       # paywall_screen.dart
└── shared/
    ├── widgets/            # loading, error, empty_state
    └── models/
```

---

## Kullanıcı Rolleri ve Yetkiler

### MANAGER (Yönetici)
**Abonelik Aktifken:**
- Birden fazla apartman yönetme
- Daire ekleme/düzenleme/silme
- Davet kodu üretme (tek kullanımlık, 7 gün geçerli)
- Aylık aidat oluşturma (toplu)
- Aidat ödendi/ödenmedi işaretleme
- Gider kaydı (kategorili)
- Aylık PDF rapor alma
- Arıza/talep takibi ve güncelleme
- FCM push bildirimi gönderme

**Abonelik Dolduğunda (Kilitlenen Özellikler):**
- Yeni apartman/daire ekleme
- Yeni aidat oluşturma
- PDF rapor alma
- Toplu bildirim gönderme

*(Mevcut veriler okunabilir, sakinler etkilenmez)*

### RESIDENT (Sakin)
**Abonelikten Bağımsız Erişebilir:**
- Kendi aylık aidat durumu (PENDING/PAID/OVERDUE)
- Aidat geçmişi (tüm aylar)
- Arıza/talep oluşturma ve takip
- Bildirimlerini görme
- Uygulama dilini değiştirme

---

## Sakin Onboarding Akışı (Davet Kodu)

```
1. Yönetici → Daire detayından "Davet Kodu Üret" butonu
2. Backend → 12 karakterlik kod üretir ("APB3-K7X9-M2")
   - Koda daire ID'si bağlıdır
   - 7 gün geçerlilik süresi
   - Tek kullanımlık
3. Yönetici kodu sakine iletir (WhatsApp/kağıt/sözlü)
4. Sakin uygulamayı indirir → "Davet Koduyla Katıl" ekranı
5. Kodu girer → Backend doğrular, daire/bina bilgisi döner
6. Sakin ad, email, şifre belirler → Kayıt tamamlanır
7. Direkt sakin dashboard'una yönlendirilir
```

---

## Bildirim Sistemi

### Firebase FCM (Push Notification)
**Kullanım Senaryoları:**
- Aylık aidat hatırlatıcısı
- Arıza talebi güncellemesi
- Duyurular (yöneticiden tüm sakine)

### WhatsApp (Twilio)
**Kullanım Senaryoları:**
- Aidat hatırlatma mesajı
- Şablon: "Sayın {residentName}, {buildingName} apartmanı {month}/{year} dönemi aidatınız ({amount}₺) henüz ödenmemiştir."

### SMS (Twilio — fallback)
- WhatsApp iletilemezse SMS olarak düşer

---

## Abonelik Sistemi (RevenueCat)

### Neden RevenueCat?
- iOS + Android aboneliklerini tek API'dan yönetir
- Receipt validation backend'i üstlenir
- Webhook ile anlık abonelik olayları

### Abonelik Planları
| Plan | ID | Fiyat |
|------|-------|---------|
| Aylık | `aidatpanel_monthly` | ₺99/ay |
| Yıllık | `aidatpanel_annual` | ₺799/yıl |

### Webhook Olayları
```javascript
{
  'INITIAL_PURCHASE': activateSubscription(),
  'RENEWAL': extendSubscription(),
  'CANCELLATION': markCancelled(),
  'EXPIRATION': expireSubscription(),
  'BILLING_ISSUE': notifyBillingIssue()
}
```

---

## Deployment

### Backend (VPS)
```javascript
// ecosystem.config.js
module.exports = {
  apps: [{
    name: 'aidatpanel-api',
    script: 'index.js',
    env: { NODE_ENV: 'production', PORT: 4200 }
  }]
};
```

### Subdomain Yapısı
| Subdomain | Hedef |
|-----------|-------|
| `aidatpanel.com` | Web landing page |
| `api.aidatpanel.com` | Node.js backend (port 4200) |

---

## MVP Geliştirme Önceliği

### Faz 1 — Çekirdek (MVP) - Hedef: %100 Tamamlandı
- [x] Auth (register, login, JWT, davet kodu ile katılım)
- [x] Bina ve daire CRUD
- [x] Davet kodu sistemi (Tamamlandı)
- [ ] Aylık aidat oluşturma (toplu) ve durum güncelleme
- [ ] Sakin: kendi aidat durumunu görme
- [ ] FCM push notification altyapısı
- [ ] RevenueCat abonelik entegrasyonu
- [ ] Landing page (web)

### Faz 2 — Tamamlama
- [ ] Gider kaydı ve kategorileme
- [ ] Arıza/talep sistemi (Ticket)
- [ ] Yönetici → Sakin bildirim gönderme
- [ ] WhatsApp aidat hatırlatma
- [ ] PDF rapor (aylık özet)
- [ ] i18n (TR/EN)

### Faz 3 — Büyüme
- [ ] Online ödeme entegrasyonu (İyzico/PayTR)
- [ ] Çoklu yönetici (personel atama)
- [ ] Aidat geçmişi grafiği / istatistik dashboard
- [ ] Belge paylaşımı

---

## Teknik Kararlar ve Gerekçeleri

| Karar | Seçim | Gerekçe |
|-------|-------|---------|
| State management | Riverpod | OkulOptik'te zaten biliniyor |
| Navigation | GoRouter | Flutter best practice, deep link |
| ORM | Prisma | Type-safe, migration kolay |
| Abonelik | RevenueCat | iOS + Android tek entegrasyon |
| Push | Firebase FCM | Cross-platform standart |
| WhatsApp | Twilio | Sandbox ile hızlı test, Türkiye desteği |
| i18n | Flutter ARB | Flutter native çözüm |

---

## Tasarım Sistemi (50+ Yaş Kullanıcılar)

### Hedef Kitle Felsefesi
**Temel İlke:** Sade, güvenilir, net. Şova gerek yok — işlevsellik ön planda.

### Renk Paleti
```dart
static const primary       = Color(0xFF1B3A6B); // Koyu lacivert
static const primaryLight  = Color(0xFF2D5FA8);
static const accent        = Color(0xFFF59E0B); // Amber
static const success       = Color(0xFF16A34A);
static const error         = Color(0xFFDC2626);
static const warning       = Color(0xFFF59E0B);
```

### Tipografi (Nunito Font)
```dart
static const h1 = TextStyle(fontSize: 28, fontWeight: FontWeight.w700);
static const h2 = TextStyle(fontSize: 22, fontWeight: FontWeight.w700);
static const h3 = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
static const body1 = TextStyle(fontSize: 16, fontWeight: FontWeight.w400); // Minimum!
static const body2 = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
static const label = TextStyle(fontSize: 14, fontWeight: FontWeight.w600); // Alt sınır
```

**Kritik Kural:** `textScaleFactor` hiçbir yerde kısıtlanmamalı.

### Dokunma Alanları
- Minimum dokunma alanı: **48x48dp**
- İdeal: **56x56dp+**
- Ana buton yüksekliği: **56.0**

### Navigasyon
**Her zaman BottomNavigationBar kullan — hamburger menü yasak.**

```dart
// Yönetici tab'ları
1. Ana Sayfa (Apartments overview)
2. Aidat
3. Giderler
4. Bildirimler
5. Profil

// Sakin tab'ları
1. Aidatlarım
2. Taleplerim
3. Bildirimler
4. Profil
```

---

## Dil Kuralları (UI Metinleri)

| ✅ Doğru | ❌ Yanlış |
|---------|----------|
| "Aidat Ekle" | "Add Due" |
| "Ödendi İşaretle" | "Mark as Paid" |
| "Geri Dön" | "Navigate Back" |
| "Telefon numarası hatalı" | "Error 422: Validation failed" |
| "Bu işlemi geri alamazsınız" | "This action is irreversible" |

**Kural:** Dashboard, sync, toggle, payload, cache gibi teknik terimler UI'da asla görünmemeli.

---

## Erişilebilirlik Kontrol Listesi

Her ekran tamamlanmadan önce:
- [ ] Tüm metinler minimum 16sp
- [ ] Kontrast oranı 4.5:1+ (WCAG AA)
- [ ] Tüm butonlar minimum 48dp yükseklik
- [ ] Her buton/ikonun `Semantics` label'ı var
- [ ] `textScaleFactor` hiçbir yerde kısıtlanmıyor
- [ ] Hata mesajları Türkçe ve anlaşılır
- [ ] Geri dönülemez işlemler onay dialog'u içeriyor
- [ ] Her tab'da ikon + yazı birlikte görünüyor

---

## Geliştirici Notları

- OkulOptik ile **aynı PostgreSQL instance** kullanılabilir ama **ayrı veritabanı** (`aidatpanel`)
- Port çakışması olmaması için OkulOptik portunu kontrol et, 4200 müsait değilse 4201 kullan
- Tüm API route'ları `/api/v1/` prefix'i ile başlamalı
- KVKK uyumu için kullanıcı verisi silme endpoint'i (`DELETE /api/me`) Faz 1'de yazılmalı
- Apple App Store'da "Kids Category" seçilmemeli, "Finance" kategorisi uygundur

---

## Analiz Sonucu

**AidatPanel.md**, projenin teknik ve ürün yönünden **kapsamlı bir master reference**'dır. Backend, Flutter, veritabanı şeması, API endpoint'leri, kullanıcı rolleri, tasarım sistemi ve deployment detaylarını tek bir dokümanda birleştirir.

### Güçlü Yönler
- ✅ Detaylı veritabanı şeması
- ✅ Tam API endpoint dokümantasyonu
- ✅ Kullanıcı rolü ve yetki matrisi
- ✅ 50+ yaş erişilebilirlik kuralları
- ✅ Abonelik ve bildirim sistemi tasarımı

### Eksik/Geliştirilebilir Alanlar
- 🔄 API endpoint'lerindeki ✅/⏳ işaretleri güncellenmeli (mevcut duruma göre)
- 🔄 Swagger/OpenAPI dokümantasyonu oluşturulmalı
- 🔄 Postman collection export edilmeli

---

**Analiz Raporu ID:** 1-AIDATPANEL-ANALIZ  
**Son Güncelleme:** 2026-05-06
