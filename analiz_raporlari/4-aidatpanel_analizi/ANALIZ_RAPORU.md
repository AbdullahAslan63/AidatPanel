# AIDATPANEL ANALİZ RAPORU

**Kaynak Dosya:** `planning/AIDATPANEL.md`  
**Analiz Tarihi:** 2026-05-03  
**Durum:** ✅ Tamamlandı  
**Analiz Tipi:** Teknik Referans ve Mimari Değerlendirme

---

## 📋 PROJE ÖZETİ ANALİZİ

### Temel Bilgiler
| Özellik | Değer |
|---------|-------|
| **Tür** | Türk apartman/site aidat yönetim platformu |
| **Platform** | iOS + Android (Flutter) |
| **Backend** | Node.js + Express + Prisma + PostgreSQL |
| **Domain** | aidatpanel.com (Cloudflare) |
| **Web** | Sadece landing page (statik HTML/CSS/JS) |
| **Dil** | Türkçe + İngilizce (i18n hazır) |

### Hedef Kullanıcılar
- **Yöneticiler (MANAGER):** Birden fazla apartmanı tek hesaptan yönetenler
- **Sakinler (RESIDENT):** Kendi aidat durumlarını görüntüleyen, arıza/talep bildirenler

---

## 🏗️ MİMARİ ANALİZİ

### Backend Stack
| Bileşen | Teknoloji | Kullanım Amacı |
|---------|-----------|----------------|
| **Runtime** | Node.js 20+ | Server runtime |
| **Framework** | Express.js | API framework |
| **ORM** | Prisma | Database abstraction |
| **Database** | PostgreSQL | Relational data |
| **Auth** | JWT (15dk access, 30 gün refresh) | Authentication |
| **Email** | Resend | Transactional emails |
| **Push** | Firebase Admin SDK (FCM) | Push notifications |
| **SMS/WhatsApp** | Twilio | Messaging service |
| **Payments** | RevenueCat REST API | Subscription validation |
| **Deployment** | PM2 + Contabo VPS | Production hosting |
| **API URL** | api.aidatpanel.com:4200 | Backend endpoint |

### Backend Yapısı
```
backend/
├── src/
│   ├── routes/       # API route tanımları
│   ├── controllers/  # İş mantığı
│   ├── models/       # Veri modelleri
│   ├── middleware/   # Auth, validation
│   ├── services/     # Business logic
│   └── utils/        # Yardımcı fonksiyonlar
├── prisma/
│   └── schema.prisma # Database şema
└── index.js          # Entry point
```

---

## 🗄️ VERİTABANI ŞEMA ANALİZİ

### Entity Relationship Model

```
User (1) ────────┬──────── (N) Building (MANAGER)
       │         │
       │         └──────── (N) Apartment
       │                         │
       │                         ├─────── (N) Due
       │                         ├─────── (N) InviteCode
       │                         ├─────── (N) Ticket
       │                         │         │
       │                         │         └──── (N) TicketUpdate
       │                         │
       │                         └─────── (N) Expense
       │
       └───────────────────────── (1) Apartment (RESIDENT)
       │
       ├───────────────────────── (N) Notification
       │
       └───────────────────────── (1) Subscription
```

### Kritik Modeller

| Model | Amaç | Kritik Alanlar |
|-------|------|----------------|
| **User** | Yönetici ve sakinler | Role (MANAGER/RESIDENT), apartment ilişkisi |
| **Building** | Apartman bilgisi | managerId ilişkisi, apartments array |
| **Apartment** | Daire bilgisi | buildingId, residents, dues ilişkileri |
| **Due** | Aidat kaydı | amount (Decimal), status (PAID/PENDING/OVERDUE), month/year |
| **InviteCode** | Davet kodu | code (unique), apartmentId, usedAt, expiresAt |
| **Ticket** | Arıza/talep | status (OPEN/IN_PROGRESS/RESOLVED), category |
| **Subscription** | Abonelik | status (ACTIVE/EXPIRED/CANCELLED), revenuecatId |

### Veritabanı Kararları
- **Decimal kullanımı:** `amount @db.Decimal(10, 2)` - Finansal hassasiyet
- **Enum kullanımı:** UserRole, DueStatus, TicketStatus, SubscriptionStatus - Tip güvenliği
- **İlişki tasarımı:** Çoğul (N) ilişkiler collection olarak tutuluyor
- **Soft delete yok:** Hard delete kullanılıyor (onay dialog'u zorunlu)

---

## 🔌 API ENDPOINT YAPISI

### API Kategorileri (Toplam 40+ endpoint)

| Kategori | Endpoint Sayısı | Rol | Kritiklik |
|----------|-----------------|-----|-----------|
| **Auth** | 6 | Herkes | Çok Yüksek |
| **Buildings** | 5 | Yönetici | Yüksek |
| **Apartments** | 4 | Yönetici | Yüksek |
| **Dues** | 4 | Karma | Çok Yüksek |
| **Expenses** | 4 | Yönetici | Orta |
| **Tickets** | 5 | Karma | Yüksek |
| **Notifications** | 4 | Herkes | Orta |
| **Reports** | 2 | Yönetici | Orta |
| **Subscription** | 2 | Herkes | Yüksek |
| **Profile** | 4 | Herkes | Orta |

### API Tasarım Kalıpları
- ✅ RESTful yapı (`/api/resource/:id/action`)
- ✅ HTTP method kullanımı (GET/POST/PUT/PATCH/DELETE)
- ✅ Version prefix (`/api/v1/`)
- ✅ Authorization middleware (role-based)

### Kritik Endpoint'ler

**Auth:**
```
POST /api/auth/register          # Yönetici kaydı
POST /api/auth/login             # Giriş
POST /api/auth/join              # Sakin davet koduyla kaydolur
```

**Dues (Aidat):**
```
POST /api/buildings/:id/dues/bulk  # Toplu aidat oluştur
PATCH /api/dues/:id/status         # Ödendi/ödenmedi işaretle
GET /api/me/dues                   # Kendi aidat geçmişim
```

**Invite Code:**
```
POST /api/apartments/:id/invite-code  # Davet kodu üret
```

---

## 📱 FLUTTER UYGULAMASI ANALİZİ

### State Management Stack
| Paket | Versiyon | Amaç |
|-------|----------|------|
| **flutter_riverpod** | ^2.5.0 | State management |
| **riverpod_annotation** | ^2.3.0 | Code generation |
| **go_router** | ^13.0.0 | Navigation |
| **dio** | ^5.4.0 | HTTP client |
| **flutter_secure_storage** | ^9.0.0 | Token storage |

### Özellik Stack'i
| Paket | Amaç |
|-------|------|
| **firebase_core** + **firebase_messaging** | Push notifications |
| **purchases_flutter** | RevenueCat IAP |
| **flutter_localizations** + **intl** | i18n (TR/EN) |
| **cached_network_image** | Image caching |
| **shimmer** | Skeleton loading |
| **equatable** + **json_annotation** + **freezed_annotation** | Data models |

### Flutter Klasör Yapısı (Clean Architecture)
```
mobile/lib/
├── core/
│   ├── constants/      # API URL'ler, sabitler
│   ├── theme/          # Colors, typography, sizes
│   ├── router/         # GoRouter tanımları
│   ├── network/        # Dio client, interceptors
│   ├── storage/        # Secure storage (JWT)
│   └── utils/          # Date, currency utils
├── l10n/               # ARB dosyaları (TR/EN)
├── features/           # Feature-based modules
│   ├── auth/
│   ├── dashboard/
│   ├── buildings/
│   ├── apartments/
│   ├── dues/
│   ├── expenses/
│   ├── tickets/
│   ├── notifications/
│   ├── reports/
│   └── subscription/
└── shared/             # Ortak widgets/models
    ├── widgets/
    └── models/
```

### Clean Architecture Uygulaması
Her feature modülünde:
- `data/` - Repository, datasource, models
- `domain/` - Entities, use cases
- `presentation/` - Screens, providers, widgets

---

## 🎨 TASARIM SİSTEMİ ANALİZİ

### Hedef Kitle: 50+ Yaş
**Temel İlke:** Sade, güvenilir, net. Şov değil, işlevsellik.

### Renk Paleti
| Renk | Hex | Kullanım |
|------|-----|----------|
| **primary** | #1B3A6B | Ana renk - güven, resmiyet |
| **accent** | #F59E0B | Amber - aksiyon butonları |
| **success** | #16A34A | Ödendi, tamamlandı |
| **error** | #DC2626 | Gecikmiş, hata |
| **warning** | #F59E0B | Beklemede |
| **background** | #F8FAFC | Ana arka plan |

### Tipografi (Nunito Fontu)
| Stil | Boyut | Kullanım |
|------|-------|----------|
| **h1** | 28sp, bold | Ana başlıklar |
| **h2** | 22sp, bold | Alt başlıklar |
| **h3** | 18sp, semibold | Kart başlıkları |
| **body1** | 16sp, regular | Ana metin |
| **body2** | 16sp, semibold | Vurgulu metin |
| **label** | 14sp, semibold | Etiketler |
| **button** | 17sp, bold | Buton metni |

**Kritik Kural:** `textScaleFactor` kısıtlanmamalı!

### Boyutlandırma (50+ Yaş Uyumlu)
| Öğe | Minimum Boyut |
|-----|---------------|
| Font | 16sp (asla altına inme) |
| Buton yüksekliği | 56dp (primary), 48dp (secondary) |
| Dokunma alanı | 48x48dp |
| İkon | 24dp |
| Kart köşe radius | 12dp |

### Navigasyon Kuralı
**BottomNavigationBar zorunlu - Hamburger menü YASAK!**

### UI Metin Kuralları
```
✅ DOĞRU              ❌ YANLIŞ
"Aidat Ekle"          "Add Due"
"Ödendi İşaretle"     "Mark as Paid"
"Telefon numarası hatalı"  "Error 422"
```

Teknik terimler (dashboard, sync, toggle, payload, cache) UI'da **yasak**!

---

## 👥 KULLANICI ROLLERİ VE YETKİLER

### MANAGER (Yönetici)

**Abonelik Aktifken:**
- Birden fazla apartman yönetimi
- Daire CRUD + davet kodu üretme (7 gün geçerli, tek kullanımlık)
- Toplu aidat oluşturma (bulk)
- Aidat ödendi/ödenmedi işaretleme
- Gider kaydı (kategorili: TEMİZLİK, ASANSÖR, ELEKTRİK, vb.)
- Aylık PDF rapor
- Arıza/talep takibi
- FCM push bildirimi (tüm sakinlere)

**Abonelik Dolduğunda (Kilitlenen Özellikler):**
- Yeni apartman/daire ekleme
- Yeni aidat oluşturma
- PDF rapor alma
- Toplu bildirim gönderme

*Mevcut veriler okunabilir, sakinler etkilenmez.*

### RESIDENT (Sakin)

**Abonelikten Bağımsız (Her Zaman):**
- Kendi aidat durumu (PENDING/PAID/OVERDUE)
- Aidat geçmişi
- Arıza/talep oluşturma ve takip
- Bildirimleri görme
- Dil değiştirme

---

## 🔑 SAKİN ONBOARDING AKIŞI

```
1. Yönetici → "Davet Kodu Üret" butonu
2. Backend → 12 karakterlik benzersiz kod üret (Örn: "APB3-K7X9-M2")
   - Koda daire ID'si bağlı
   - 7 gün geçerlilik
   - Tek kullanımlık
3. Yönetici → kodu sakine iletir (WhatsApp/kağıt/sözlü)
4. Sakin → "Davet Koduyla Katıl" seçer
5. Kod doğrulama → daire/bina bilgisi döner
6. Sakin → ad, email, şifre belirler → kayıt tamamlanır
7. Otomatik yönlendirme → sakin dashboard
```

---

## 🔔 BİLDİRİM SİSTEMİ

### 1. Firebase FCM (Push Notification)
**Kullanım senaryoları:**
- Aylık aidat hatırlatıcısı
- Arıza talebi güncellemesi
- Duyurular

### 2. WhatsApp (Twilio)
**Kullanım senaryosu:**
- Aidat hatırlatma mesajı

```
"Sayın {residentName}, {buildingName} apartmanı {month}/{year} 
dönemi aidatınız ({amount}₺) henüz ödenmemiştir."
```

### 3. SMS (Twilio — fallback)
WhatsApp iletilemezse SMS olarak düşer.

---

## 💳 ABONELİK SİSTEMİ (RevenueCat)

### Neden RevenueCat?
- App Store (iOS) + Google Play (Android) tek entegrasyon
- Receipt validation backend üstlenir
- Webhook ile anlık abonelik olayları

### Planlar
| Plan | ID | Fiyat |
|------|-------|-------|
| Aylık | `aidatpanel_monthly` | ₺99/ay |
| Yıllık | `aidatpanel_annual` | ₺799/yıl |

### Webhook Olayları
- `INITIAL_PURCHASE` - İlk satın alma
- `RENEWAL` - Yenileme
- `CANCELLATION` - İptal
- `EXPIRATION` - Süre dolma
- `BILLING_ISSUE` - Ödeme sorunu

---

## 🚀 MVP GELİŞTİRME ÖNCESİĞİ

### Faz 1 — Çekirdek (MVP)
- [ ] Auth (register, login, JWT, davet kodu)
- [ ] Bina ve daire CRUD
- [ ] Davet kodu sistemi
- [ ] Aylık aidat oluşturma (toplu) ve durum güncelleme
- [ ] Sakin: kendi aidat durumunu görme
- [ ] FCM push notification altyapısı
- [ ] RevenueCat abonelik entegrasyonu (iOS + Android)
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
- [ ] Belge paylaşımı (yönetim kararları)

---

## ⚙️ TEKNİK KARARLAR VE GEREKÇELERİ

| Karar | Seçim | Gerekçe |
|-------|-------|---------|
| State management | Riverpod | OkulOptik'te biliniyor |
| Navigation | GoRouter | Deep link desteği, best practice |
| ORM | Prisma | Type-safe, migration kolay |
| Abonelik | RevenueCat | iOS + Android tek API |
| Push | Firebase FCM | Cross-platform standart |
| WhatsApp | Twilio | Sandbox test, Türkiye desteği |
| i18n | Flutter ARB | Flutter native çözüm |

---

## ⚠️ EKSİK VE GELİŞTİRİLEBİLİR ALANLAR

| Alan | Durum | Eksiklik | Öneri |
|------|-------|----------|-------|
| **API Dokümantasyonu** | Eksik | Swagger/OpenAPI yok | Swagger UI ekle |
| **Rate Limiting** | Belirsiz | API rate limit tanımlı değil | Express rate limit middleware |
| **Caching Stratejisi** | Yok | Redis/memory cache yok | Redis entegrasyonu düşün |
| **API Versioning** | Kısmi | `/api/v1/` var ama v2 planı yok | Version stratejisi belirle |
| **Monitoring** | Yok | Health check, metrics yok | PM2 + monitoring tool |
| **Testing** | Belirsiz | Unit/integration test planı yok | Test stratejisi ekle |
| **Backup** | Eksik | Database backup stratejisi yok | PostgreSQL backup planı |
| **Security Headers** | Belirsiz | Helmet, CORS yapılandırması? | Security audit yap |

---

## 🎯 KRİTİK BAŞARI FAKTÖRLERİ

1. **50+ Yaş Uyumu** - UI/UX her kararda bu gerçeği gözetmeli
2. **Offline-First Düşünce** - Cache stratejisi kritik (50+ yaş kullanıcılar bağlantı sorunları yaşayabilir)
3. **Türkçe Dil Önceliği** - i18n var ama primary TR olmalı
4. **Abonelik Kilit Mekanizması** - Faz 1'de RevenueCat entegrasyonu kritik
5. **Davet Kodu Akışı** - Onboarding'in kritik noktası, hatasız çalışmalı
6. **PDF Rapor** - Yöneticiler için olmazsa olmaz (Faz 2)

---

## 📁 SONRAKİ ADIMLAR

1. **API Dokümantasyonu:** Swagger/OpenAPI ekle
2. **Rate Limiting:** Express rate limit middleware
3. **Caching:** Redis entegrasyonu değerlendir
4. **Testing:** Unit/integration test stratejisi
5. **Monitoring:** Health check ve metrics
6. **Security:** Security headers ve audit

---

**Analiz Tamamlandı:** 2026-05-03  
**Klasör:** `analiz_raporlari/aidatpanel_analizi/`  
**Sonraki Adım:** Eksik alanların planlanması (API dokümantasyonu, rate limiting, testing)
