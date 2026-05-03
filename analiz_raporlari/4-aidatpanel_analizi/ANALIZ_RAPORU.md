# AIDATPANEL - DETAYLI ANALİZ RAPORU

**Kaynak Dosya:** `planning/AIDATPANEL.md` (995 satır)  
**Analiz Tarihi:** 2026-05-03  
**Versiyon:** 1.0  
**Analiz Tipi:** Master Reference Dökümanı Değerlendirmesi + Gap Analizi  
**Durum:** ✅ Detaylı analiz + executive summary + gap analizi üretildi

---

## 📋 BELGE KİMLİĞİ

| Özellik | Değer |
|---------|-------|
| **Tür** | Master Reference (referans dokümanı) |
| **Hedef Kullanıcı** | AI coding agent + insan geliştirici |
| **Kapsam** | Stack + DB + API + UI + Roller + Deployment + Tasarım |
| **Uzunluk** | 995 satır |
| **Yaklaşım** | "Olması gereken" durumu tanımlayan referans |
| **Dil** | Türkçe (teknik terimler İngilizce korunmuş) |

**Önemli Not:** Bu dosya meta-prompt değil. Diğer prompt'lardan farklı olarak **AI için üretim talimatı** yerine **ortak referans sözleşmesi** niteliğindedir.

---

## 🏗️ 1. PROJE KİMLİĞİ

| Özellik | Değer |
|---------|-------|
| **Ad** | AidatPanel |
| **Sektör** | Apartman/site aidat yönetimi (Türkiye pazarı) |
| **Platform** | iOS + Android (Flutter) + Web landing (statik) |
| **Domain** | aidatpanel.com (Cloudflare) |
| **API Subdomain** | api.aidatpanel.com:4200 |
| **Hedef Kitle** | 50+ yaş apartman yöneticileri ve sakinleri |
| **İş Modeli** | Abonelik (RevenueCat üzerinden IAP) |
| **Deployment** | Ortak Contabo VPS (OkulOptik ile) |
| **Hosting Yaklaşımı** | PM2 + CloudPanel reverse proxy |

---

## 🖥️ 2. BACKEND MİMARİ

### Stack
| Bileşen | Teknoloji | Versiyon/Detay |
|---------|-----------|----------------|
| Runtime | Node.js | 20+ |
| Framework | Express.js | - |
| ORM | Prisma | Type-safe, migration yönetimi |
| Database | PostgreSQL | - |
| Auth | JWT | Access: 15dk, Refresh: 30g |
| Email | Resend | noreply@aidatpanel.com |
| Push | Firebase Admin SDK | FCM |
| SMS/WhatsApp | Twilio | Netgsm alternatifi |
| IAP | RevenueCat REST API | iOS + Android tek API |
| Process Manager | PM2 | - |

### Environment Variables (.env)
12 adet zorunlu env değişkeni: `PORT, DATABASE_URL, JWT_SECRET, JWT_REFRESH_SECRET, RESEND_API_KEY, FIREBASE_SERVICE_ACCOUNT_JSON, TWILIO_*, REVENUECAT_*`

### Klasör Yapısı
```
backend/
├── src/
│   ├── routes/        # Express route tanımları
│   ├── controllers/   # İş mantığı
│   ├── models/        # Veri modelleri
│   ├── middleware/    # Auth, validation
│   ├── services/      # Business logic (notification, payment, pdf)
│   └── utils/         # Yardımcılar
├── prisma/schema.prisma
├── .env.example
├── package.json
└── index.js
```

### Kritik Konfigürasyon
- **Port:** 4200 (OkulOptik ile çakışırsa 4201)
- **API prefix:** `/api/v1/` (gelecek versiyonlama için)
- **DB:** OkulOptik ile aynı PostgreSQL instance, **ayrı veritabanı** (`aidatpanel`)

---

## 🗄️ 3. VERİTABANI ŞEMASI (PRISMA)

### Entity İlişkileri
```
User (1) ──┬── (N) Building [MANAGER rolünde]
           │          └── (N) Apartment
           │                  ├── (N) Due
           │                  ├── (N) InviteCode
           │                  ├── (N) Ticket ──── (N) TicketUpdate
           │                  └── (N) Expense
           │                  
User (1) ──┼── (1) Apartment [RESIDENT rolünde]
User (1) ──┼── (N) Notification
User (1) ──┴── (1) Subscription
```

### Modeller (9 adet)

| # | Model | Amaç | Kritik Alanlar | Enum |
|---|-------|------|----------------|------|
| 1 | **User** | Yönetici + sakin | role, apartmentId, fcmToken, language | UserRole (MANAGER/RESIDENT) |
| 2 | **Subscription** | Abonelik durumu | status, plan, platform, revenuecatId, currentPeriodEnd | SubscriptionStatus (ACTIVE/EXPIRED/CANCELLED/TRIAL) |
| 3 | **Building** | Apartman | name, address, city, managerId | - |
| 4 | **Apartment** | Daire | number (örn B-12), floor, buildingId | - |
| 5 | **InviteCode** | Davet kodu | code (unique 12 kar.), expiresAt (7g), usedAt, usedBy | - |
| 6 | **Due** | Aidat | amount Decimal(10,2), currency (TRY), month, year, status, paidAt | DueStatus (PENDING/PAID/OVERDUE/WAIVED) |
| 7 | **Expense** | Gider | title, amount Decimal, category, date, receiptUrl | ExpenseCategory (8 kategori) |
| 8 | **Ticket** | Arıza/talep | title, description, category, status, userId | TicketCategory (COMPLAINT/REQUEST/MALFUNCTION/OTHER), TicketStatus (OPEN/IN_PROGRESS/RESOLVED/CLOSED) |
| 9 | **TicketUpdate** | Talep yanıtları | message, fromRole | - |
| 10 | **Notification** | Bildirimler | title, body, type, isRead, data (JSON) | NotificationType (5 tip) |

### Veritabanı Tasarım Kararları
- ✅ **Decimal(10,2)** finansal alanlarda (yuvarlama hatası yok)
- ✅ **Enum** tip güvenliği için (UserRole, DueStatus, vb.)
- ✅ **UUID primary key** (sekans tahmin edilemez)
- ✅ **Hard delete** (soft delete yok → onay dialog zorunlu)
- ✅ **Zaman damgaları** createdAt + updatedAt her modelde
- ⚠️ **Index yok** (performance audit'te gözden geçirilmeli)
- ⚠️ **Cascade delete kuralları** Prisma şemasında explicit değil

---

## 🔌 4. API ENDPOINT YAPISI (40+ Endpoint)

### Kategoriler ve Endpoint Sayısı

| Kategori | Endpoint | Yetki | Kritiklik |
|----------|----------|-------|-----------|
| **Auth** | 7 (register, login, refresh, logout, join, forgot, reset) | Herkes | Çok Yüksek |
| **Buildings** | 5 (GET all/detail, POST, PUT, DELETE) | Manager | Yüksek |
| **Apartments** | 5 (GET, POST, PUT, DELETE, invite-code) | Manager | Yüksek |
| **Dues** | 4 (GET all, POST bulk, PATCH status, GET /me/dues) | Karma | Çok Yüksek |
| **Expenses** | 5 (GET, POST, PUT, DELETE, summary) | Manager | Orta |
| **Tickets** | 6 (GET all, detail, POST new, POST update, PATCH status, GET /me) | Karma | Yüksek |
| **Notifications** | 4 (GET, PATCH read, PATCH read-all, PUT fcm-token) | Herkes | Orta |
| **Reports** | 2 (monthly PDF, summary) | Manager | Orta |
| **Subscription** | 2 (webhook, GET /me/subscription) | Herkes | Yüksek |
| **Profile** | 4 (GET /me, PUT /me, PUT password, PUT language) | Herkes | Orta |
| **Toplam** | **44 endpoint** | - | - |

### API Tasarım Desenleri
- ✅ **RESTful** yapı (`/api/resource/:id/action`)
- ✅ **Nested resource** (`/api/buildings/:id/apartments`)
- ✅ **Me pattern** (`/api/me/*` self-referential)
- ✅ **Bulk operations** (`/api/buildings/:id/dues/bulk`)
- ✅ **HTTP method semantic** (GET/POST/PUT/PATCH/DELETE)
- ✅ **Version prefix** (`/api/v1/`)

### Belgede Belirtilmemiş Ama Gerekli
- ❌ API response standardı (success/error shape)
- ❌ Pagination stratejisi (query params?)
- ❌ Filtering/sorting konvansiyonu
- ❌ Rate limiting sınırları
- ❌ Swagger/OpenAPI dokümantasyonu

---

## 📱 5. FLUTTER UYGULAMASI

### Paketler (14 production + 4 dev)

#### State & Navigation
| Paket | Versiyon |
|-------|----------|
| flutter_riverpod | ^2.5.0 |
| riverpod_annotation | ^2.3.0 |
| go_router | ^13.0.0 |

#### Network & Storage
| Paket | Versiyon |
|-------|----------|
| dio | ^5.4.0 |
| flutter_secure_storage | ^9.0.0 |

#### Servisler
| Paket | Versiyon |
|-------|----------|
| firebase_core | ^3.0.0 |
| firebase_messaging | ^15.0.0 |
| purchases_flutter | ^7.0.0 (RevenueCat) |

#### UI & i18n
| Paket | Versiyon |
|-------|----------|
| flutter_localizations | SDK |
| intl | ^0.19.0 (v1.0 referansta 0.19.0, kodda 0.20.2 — **uyumsuzluk riski**) |
| cached_network_image | ^3.3.0 |
| shimmer | ^3.0.0 |

#### Utility
| Paket | Versiyon |
|-------|----------|
| equatable | ^2.0.5 |
| json_annotation | ^4.8.1 |
| freezed_annotation | ^2.4.0 |

#### Dev Dependencies
- build_runner ^2.4.0, riverpod_generator ^2.3.0, freezed ^2.4.0, json_serializable ^6.7.0

### Klasör Yapısı (Clean Architecture)

```
mobile/lib/
├── main.dart
├── firebase_options.dart
├── core/
│   ├── constants/        # api_constants, app_constants
│   ├── theme/            # app_theme, app_colors, app_typography
│   ├── router/           # app_router (GoRouter)
│   ├── network/          # dio_client (interceptors, refresh), api_exception
│   ├── storage/          # secure_storage (JWT)
│   └── utils/            # date_utils, currency_utils
├── l10n/
│   ├── app_tr.arb
│   └── app_en.arb
├── features/             # Feature-based modules
│   ├── auth/ (data/domain/presentation)
│   │   └── presentation/ {login,register,join}_screen.dart
│   ├── dashboard/        # manager_dashboard, resident_dashboard
│   ├── buildings/
│   ├── apartments/
│   ├── dues/
│   ├── expenses/
│   ├── tickets/
│   ├── notifications/
│   ├── reports/
│   └── subscription/     # paywall_screen (RevenueCat)
└── shared/
    ├── widgets/          # loading, error, empty_state widget'lar
    └── models/
```

### Clean Architecture Kat Dağılımı
Her feature altında:
- **data/** — Repository impl, datasource, model
- **domain/** — Entity, use case
- **presentation/** — Screen, provider, widget

---

## 👥 6. KULLANICI ROLLERİ VE YETKİLER

### MANAGER (Yönetici)

#### Abonelik AKTİF iken yapabildikleri
- Birden fazla apartman oluşturma/yönetme
- Daire CRUD
- Davet kodu üretme (12 karakter, 7 gün, tek kullanımlık)
- Toplu aylık aidat oluşturma
- Aidat ödeme durumu değiştirme
- Gider kaydı (8 kategori)
- Aylık PDF rapor
- Arıza/talep takibi + yanıt
- Tüm sakinlere duyuru FCM push

#### Abonelik DOLDUĞUNDA kilitlenen özellikler
- ❌ Yeni apartman/daire ekleme
- ❌ Yeni aidat oluşturma
- ❌ PDF rapor alma
- ❌ Toplu bildirim

#### Abonelik dolduğunda bile erişilebilir
- ✅ Mevcut verileri okuma (read-only)
- ✅ Sakinler etkilenmez (aidat görme/ödeme akışları çalışmaya devam)

### RESIDENT (Sakin)

**Abonelikten bağımsız, her zaman erişebilir:**
- Kendi aylık aidat durumu (PENDING/PAID/OVERDUE)
- Aidat geçmişi (tüm aylar, filtreleme)
- Arıza/talep oluşturma ve takip
- Bildirimleri görüntüleme
- Uygulama dil tercihi

---

## 🔑 7. SAKİN ONBOARDING AKIŞI

```
1. MANAGER → Daire detayından "Davet Kodu Üret" butonu
2. BACKEND → 12 karakterlik benzersiz kod (Örn: "APB3-K7X9-M2")
           → Koda apartmentId bağlı
           → 7 gün geçerlilik süresi
           → Tek kullanımlık (usedAt set edildikten sonra geçersiz)
3. MANAGER → Kodu WhatsApp / kağıt / sözlü olarak sakine iletir
4. RESIDENT → Uygulamayı indirir → "Davet Koduyla Katıl" seçer
5. RESIDENT → Kodu girer → Backend doğrular, daire/bina bilgisi döner
6. RESIDENT → Ad, email, şifre belirler → kayıt tamamlanır
7. SYSTEM → Otomatik yönlendirme → Resident Dashboard
```

### Kritik Güvenlik Noktaları
- 🔒 Race condition: Aynı kod 2 kişi tarafından girilirse ne olacak? (Transaction + lock gerekli)
- 🔒 Brute-force koruması: Çok fazla yanlış kod denemesi sonrası rate limit
- 🔒 Kod entropi: 12 karakter * alfabe genişliği = kaba kuvvet dirençli

---

## 🔔 8. BİLDİRİM SİSTEMİ

### Kanal 1: Firebase FCM (Push Notification)
- **Aktivasyon:** Otomatik (aidat hatırlatıcı) + Manuel (yönetici duyuru)
- **Kullanım senaryoları:** Aylık aidat hatırlatma, ticket güncelleme, duyuru
- **Teknik:** `FirebaseMessaging.onMessage` + `onBackgroundMessage` handler
- **Bildirim tipleri:** 5 enum (DUE_REMINDER, DUE_PAID, TICKET_UPDATE, ANNOUNCEMENT, SYSTEM)

### Kanal 2: WhatsApp (Twilio)
- **Kullanım:** Aidat hatırlatma (manuel, "Hatırlat" butonu ile)
- **Şablon mesajı:**
  > "Sayın {residentName}, {buildingName} apartmanı {month}/{year} dönemi aidatınız ({amount}₺) henüz ödenmemiştir. Detaylar için AidatPanel uygulamasını açınız."

### Kanal 3: SMS (Twilio fallback)
- **Kullanım:** WhatsApp ileti iletilemezse otomatik SMS
- **Alternatif:** Netgsm (Türkiye native alternatifi)

### Kanal 4: Email (Resend)
- **Kullanım:** Şifre reset, account ile ilgili sistem bildirimleri

---

## 💳 9. ABONELİK (REVENUECAT)

### Neden RevenueCat?
- iOS (App Store) + Android (Google Play) aboneliği **tek API**
- Receipt validation backend'i devredışı bırakıyor
- Webhook ile anlık event (ödeme olaylarını dinleme)

### Planlar
| Plan | Product ID | Fiyat |
|------|-----------|-------|
| Aylık | `aidatpanel_monthly` | ₺99/ay |
| Yıllık | `aidatpanel_annual` | ₺799/yıl (~%33 indirim) |

### Webhook Eventleri (5 adet)
| Event | Aksiyon |
|-------|---------|
| INITIAL_PURCHASE | Subscription aktifle |
| RENEWAL | Subscription süresi uzat |
| CANCELLATION | Kapatma zamanı işaretle |
| EXPIRATION | Subscription pasifle, kilitleri uygula |
| BILLING_ISSUE | Kullanıcıyı bilgilendir |

### Flutter Konfigürasyon
```dart
await Purchases.setLogLevel(LogLevel.debug);
final config = Platform.isAndroid 
  ? PurchasesConfiguration(androidApiKey) 
  : PurchasesConfiguration(iosApiKey);
await Purchases.configure(config);
```

---

## 🎨 10. TASARIM SİSTEMİ (50+ YAŞ)

### Temel İlke
> **Sade, güvenilir, net. Şova gerek yok — işlevsellik ön planda.**

### Renk Paleti (16 renk)

#### Ana Renkler
| Renk | Hex | Kullanım |
|------|-----|----------|
| primary | `#1B3A6B` | Koyu lacivert — güven, resmiyet |
| primaryLight | `#2D5FA8` | Hover/pressed |
| accent | `#F59E0B` | Amber — aksiyon butonları |

#### Durum Renkleri
| Renk | Hex | Kullanım |
|------|-----|----------|
| success | `#16A34A` | Ödendi, tamamlandı |
| error | `#DC2626` | Gecikmiş, hata |
| warning | `#F59E0B` | Beklemede |
| info | `#2563EB` | Bilgi |

#### Nötr Renkler
| Renk | Hex | Kullanım |
|------|-----|----------|
| background | `#F8FAFC` | Ana arka plan |
| surface | `#FFFFFF` | Kart, modal |
| border | `#E2E8F0` | Ayırıcı çizgi |
| textPrimary | `#0F172A` | Ana metin |
| textSecondary | `#475569` | İkincil metin |
| textDisabled | `#94A3B8` | Devre dışı |

#### Badge Arka Planları
| Renk | Hex |
|------|-----|
| successBg | `#DCFCE7` |
| errorBg | `#FEE2E2` |
| warningBg | `#FEF3C7` |

### Tipografi (Nunito Font)

> **Seçim gerekçesi:** Yuvarlak hatları sayesinde sıcak ve okunabilir, yaşlı kullanıcılar için Inter/Roboto'dan daha az yorucu.

| Stil | Boyut | Weight | Line Height | Kullanım |
|------|-------|--------|-------------|----------|
| h1 | 28sp | 700 | 1.3 | Ana başlık |
| h2 | 22sp | 700 | 1.3 | Alt başlık |
| h3 | 18sp | 600 | 1.4 | Kart başlığı |
| body1 | **16sp** | 400 | 1.6 | Ana metin |
| body2 | **16sp** | 600 | 1.6 | Vurgulu metin |
| label | 14sp | 600 | 1.4 | Etiket |
| caption | 14sp | 400 | 1.4 | Alt yazı |
| button | 17sp | 700 | - | Buton |

🔒 **Kritik kural:** `textScaleFactor` hiçbir yerde kısıtlanmayacak.

### Boyutlandırma

| Öğe | Değer | Kural |
|-----|-------|-------|
| **Min font** | 16sp | Asla altına inilmez |
| **Primary buton** | 56dp height | Ana aksiyon |
| **Secondary buton** | 48dp height | İkincil aksiyon |
| **Dokunma alanı** | 48x48dp min | Tüm tıklanabilirler |
| **İkon** | 24dp | İçerik ikonu |
| **İkon touch target** | 48dp | İkon etrafında alan |
| **Kart köşe radius** | 12dp | - |
| **Buton köşe radius** | 10dp | - |
| **Input köşe radius** | 10dp | - |
| **Liste öğesi yükseklik** | 72dp | Kolay tıklama |

### Boşluk Sistemi
| Token | Değer |
|-------|-------|
| spacingXS | 4dp |
| spacingS | 8dp |
| spacingM | 16dp |
| spacingL | 24dp |
| spacingXL | 32dp |
| spacingXXL | 48dp |

### Buton Stilleri (Kod Örnekleri)

**Primary Buton (tam genişlik, belirgin):**
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 56),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    textStyle: AppTypography.button,
    elevation: 0,
  ),
)
```

**Aksiyon Buton (Ödendi işaretle, Davet kodu üret, vb.):**
- `backgroundColor: AppColors.accent`
- Aynı boyut, amber renk

### Navigasyon Kuralı

> 🔒 **Her zaman `BottomNavigationBar` — hamburger menü YASAK.**

#### Manager Tab'ları (5)
1. Ana Sayfa (Apartments overview)
2. Aidat
3. Giderler
4. Bildirimler
5. Profil

#### Resident Tab'ları (4)
1. Aidatlarım
2. Taleplerim
3. Bildirimler
4. Profil

**Kural:** Her tab'da **ikon + yazı birlikte** gösterilmeli. Sadece ikon yasak.

### Dil Kuralları (UI Metinleri)

| ✅ DOĞRU | ❌ YANLIŞ |
|----------|----------|
| Aidat Ekle | Add Due |
| Ödendi İşaretle | Mark as Paid |
| Geri Dön | Navigate Back |
| Telefon numarası hatalı | Error 422: Validation failed |
| Bu işlemi geri alamazsınız | This action is irreversible |
| Emin misiniz? | Confirm action? |
| Yükleniyor... | Loading... (bu kabul edilebilir) |

**Kesin yasak terimler (UI'da):** dashboard, sync, toggle, payload, cache

### Onay Dialog (Geri Dönülemez İşlemler)

Her silme, ödendi işaretleme, toplu işlemde zorunlu:
```dart
showDialog(
  context: context,
  builder: (_) => AlertDialog(
    title: const Text('Emin misiniz?'),
    content: const Text('Bu daireyi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.'),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('İptal')),
      ElevatedButton(
        onPressed: () { /* işlemi yap */ },
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
        child: const Text('Sil'),
      ),
    ],
  ),
);
```

### Durum Badge'leri (DueStatus)

Renk + yazı birlikte, sadece renk yasak:
| Status | Metin | Renk | Arka plan |
|--------|-------|------|-----------|
| PAID | Ödendi | success | successBg |
| PENDING | Bekliyor | warning | warningBg |
| OVERDUE | Gecikmiş | error | errorBg |
| WAIVED | Muaf | textSecondary | border |

### Animasyon Kuralları

| Parametre | Değer |
|-----------|-------|
| Geçiş süresi | **200ms** (hızlı + sade) |
| Curve | `Curves.easeInOut` |
| PageTransition | Slide (sola/sağa) |
| Loading | `CircularProgressIndicator` (primary) |
| Skeleton | `shimmer` paketi (kart placeholder) |

**🚫 YASAK:**
- Lottie animasyonları (gereksiz karmaşıklık)
- Hero animasyonları (göz yanıltıcı)
- Bounce / elastic curve
- 300ms+ süren geçişler

### Erişilebilirlik Kontrol Listesi (Her ekran için)

- [ ] Tüm metinler min 16sp
- [ ] Kontrast oranı ≥ 4.5:1 (WCAG AA)
- [ ] Tüm butonlar min 48dp yükseklik
- [ ] Her buton/ikonun `Semantics` label'ı
- [ ] `textScaleFactor` kısıtlanmıyor
- [ ] Hata mesajları Türkçe + anlaşılır
- [ ] Geri dönülemez işlemler onay dialog'u
- [ ] Her tab'da ikon + yazı birlikte

---

## 🌐 11. WEB (LANDING PAGE)

### Amaç
Sadece tanıtım + uygulama indirmeye yönlendirme. SaaS panel YOK.

### İçerik (Statik)
1. **Hero:** App adı + tagline + App Store + Google Play butonları
2. **Özellikler:** 3-4 madde
3. **Ekran görüntüleri:** Mockup
4. **Fiyatlandırma:** Aylık/yıllık
5. **SSS**
6. **İletişim / Destek emaili**
7. **Gizlilik politikası + KVKK** (yasal zorunluluk)

### Teknoloji
- Saf HTML + CSS + minimal JS
- Framework YOK (gereksiz karmaşıklık)

### Deployment
- CloudPanel üzerinden `aidatpanel.com` domain'i
- Cloudflare CDN (DNS + SSL)

---

## 🚀 12. DEPLOYMENT

### Backend (PM2 ecosystem)
```javascript
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
| `aidatpanel.com` | Landing page (statik) |
| `api.aidatpanel.com` | Node.js backend (port 4200, CloudPanel proxy) |

### Veritabanı Kurulum
```bash
createuser aidatpanel --pwprompt
createdb aidatpanel --owner=aidatpanel
npx prisma migrate deploy
```

### OkulOptik Paylaşım Kuralı
- ✅ Aynı PostgreSQL instance paylaşılabilir
- ✅ Ayrı veritabanı zorunlu (`aidatpanel`)
- ⚠️ Port kontrolü: 4200 dolu ise 4201 kullan

---

## 📊 13. MVP GELİŞTİRME ÖNCELİĞİ

### Faz 1 — Çekirdek (8 madde)
Auth + Bina/Daire CRUD + Davet kodu + Aidat (toplu + durum) + Sakin aidat görüntüleme + FCM altyapı + RevenueCat + Landing page

### Faz 2 — Tamamlama (6 madde)
Gider + Ticket + Yönetici bildirim + WhatsApp hatırlatma + PDF rapor + i18n

### Faz 3 — Büyüme (4 madde)
Online ödeme (İyzico/PayTR) + Çoklu yönetici + İstatistik dashboard + Belge paylaşımı

---

## ⚙️ 14. TEKNİK KARAR GEREKÇELERİ

| Karar | Seçim | Gerekçe |
|-------|-------|---------|
| State management | Riverpod | OkulOptik'te biliniyor (learning curve yok) |
| Navigation | GoRouter | Deep link, Flutter best practice |
| ORM | Prisma | Type-safe + kolay migration |
| Abonelik | RevenueCat | iOS + Android tek entegrasyon |
| Push | Firebase FCM | Cross-platform standart |
| WhatsApp | Twilio | Sandbox test, Türkiye desteği |
| i18n | Flutter ARB | Native çözüm |

---

## 📝 15. GELİŞTİRİCİ NOTLARI

- ✅ OkulOptik ile ortak PostgreSQL, ayrı DB (`aidatpanel`)
- ✅ Port çakışması: 4200 dolu ise 4201
- ✅ Tüm route'lar `/api/v1/` prefix (gelecek versiyonlama)
- ✅ **KVKK zorunluluğu:** `DELETE /api/me` endpoint Faz 1'de yazılmalı (kullanıcı verisi silme hakkı)
- ✅ Apple App Store kategori: **Finance** ("Kids Category" seçilmez)

---

## 📊 BELGE KALİTE DEĞERLENDİRMESİ

| Kriter | Skor | Açıklama |
|--------|------|----------|
| Kapsam | 10/10 | Stack → UI → deployment hepsi var |
| Netlik | 9/10 | Türkçe, açık, örneklerle zengin |
| Kod örnekleri | 9/10 | Gerçek Dart/SQL/JS kodu |
| Tutarlılık | 8/10 | `intl` versiyonu kaynakla kod farklı (0.19 vs 0.20.2) |
| Güncellenebilirlik | 6/10 | Versiyon tag'i yok, revizyon geçmişi yok |
| Testing stratejisi | 2/10 | Hiç yok |
| API doc (Swagger) | 1/10 | Yok |
| Monitoring/observability | 2/10 | Yok |
| Caching stratejisi | 2/10 | Redis/memory yok |
| Rate limiting | 1/10 | Yok |
| Backup stratejisi | 1/10 | Yok |
| **Ortalama** | **5.5/10** | **İyi — ama 6 kritik alan eksik** |

---

## ⚠️ BELGENİN KRİTİK EKSİKLERİ

| # | Alan | Risk | Öneri |
|---|------|------|-------|
| 1 | **API Dokümantasyonu** | Orta | Swagger / OpenAPI spec |
| 2 | **Rate Limiting** | Yüksek | express-rate-limit middleware |
| 3 | **Caching Stratejisi** | Orta | Redis / memory cache |
| 4 | **Testing Planı** | Yüksek | Unit/integration/e2e planı |
| 5 | **Monitoring** | Orta | Sentry + health check endpoint |
| 6 | **Backup Politikası** | Yüksek | PostgreSQL günlük backup + restore drill |
| 7 | **Security Headers** | Orta | Helmet.js, CORS whitelist |
| 8 | **API Response Standardı** | Orta | Success/error shape tutarlılığı |
| 9 | **Pagination Stratejisi** | Düşük | Cursor vs offset |
| 10 | **Observability/logs** | Orta | Structured logging (pino) |

---

## 🔍 KAYNAK vs KOD GAP ANALİZİ (ÖZET)

Mevcut kod (v0.0.8) ile bu referans belge arasında tespit edilen **15 kritik fark** `HATA_ANALIZ_RAPORU.md`'de detaylandırılmıştır. Özet:

| Seviye | Sayı | Ana Konular |
|--------|------|-------------|
| 🔴 Kritik | 4 | HTTP→HTTPS, Token expiry, DioClient refresh, ListView perf |
| 🟡 Yüksek | 4 | Dummy data, Due modülü eksik, RevenueCat kurulu değil, API constants hatalı |
| 🟡 Orta | 4 | FCM handler yok, versiyon formatı (+1), intl uyumsuzluk, getStoredUser eksik |
| 🟢 Düşük | 3 | Obfuscation, Cert pinning, Test coverage |

**Detay:** `AIDATPANEL_GAP_ANALIZI.md` (bu klasörde)

---

## 🎯 KRİTİK BAŞARI FAKTÖRLERİ

1. **50+ Yaş Uyumu** — UI her kararda bu gerçeği gözetmeli
2. **Offline-First Düşünce** — Bağlantı kopukluğu toleransı (cache)
3. **Türkçe Öncelik** — i18n var, primary TR
4. **Abonelik Kilit Mekanizması** — Faz 1 RevenueCat
5. **Davet Kodu Akışı** — Onboarding kritik
6. **PDF Rapor** — Yöneticiler için vazgeçilmez
7. **Finansal Hassasiyet** — Decimal kullanımı, yuvarlama yasak

---

## 🔄 BAKIM PROTOKOLÜ

### Revizyon Tetikleyicileri
- Stack değişikliği (paket/servis ekleme/çıkarma)
- API endpoint ekleme/silme
- DB şeması değişikliği (Prisma migration)
- Yeni role/izin eklenmesi
- Yeni 50+ yaş UI kuralı
- Deployment topology değişikliği

### Versiyonlama
- **Major (x.0):** Mimari değişiklik (örn: Microservices geçişi)
- **Minor (1.x):** Yeni bölüm, yeni endpoint grubu
- **Patch (1.0.x):** Metin düzeltme, tarih güncelleme

---

## 📁 KLASÖR İÇERİĞİ

| Dosya | Amaç | Versiyon |
|-------|------|----------|
| `ANALIZ_RAPORU.md` | Detaylı master reference analizi (bu dosya) | v1.0 |
| `RAPOR_OZETI.md` | Executive summary | v1.0 |
| `AIDATPANEL_GAP_ANALIZI.md` | Referans vs kod gap analizi + somut yapılacaklar | v1.0 |

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-03 | Sıfırdan temiz yapım: 995 satırlık master reference'in tüm 18+ bölümü analiz edildi; gap analizi üretildi |

---

**Analiz Tamamlandı:** 2026-05-03  
**Klasör:** `analiz_raporlari/4-aidatpanel_analizi/`  
**Sonraki Adım:** Gap analizindeki Aşama A (kritik güvenlik düzeltmeleri) başlatılabilir.
