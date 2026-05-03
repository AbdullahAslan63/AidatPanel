# AIDATPANEL - KAPSAMLI PROJE ANALIZI ve YOL HARITASI

**Tarih:** 2026-05-03  
**Versiyon:** 0.0.8+1  
**Branch:** mobile/flutter-app  
**Analiz Eden:** AI Co-Founder (Furkan profili ile)  
**Durum:** 🟡 Faz 1 Tamamlandı, Faz 2 Devam Ediyor

---

## 📊 GENEL DURUM ÖZETİ

### Proje Sağlık Durumu
| Metrik | Durum | Not |
|--------|-------|-----|
| **Kod Kalitesi** | 🟡 Orta | Clean Architecture yapısı var, bazı eksiklikler var |
| **Faz Tamamlama** | 🟡 %65 | Faz 1 temel olarak tamam, Faz 2 kritik modüllerde eksik |
| **Güvenlik** | 🟡 Orta | Temel auth var, hardening eksiklikleri var |
| **Optimizasyon** | 🟡 Orta | Debug modda çalışıyor, production optimizasyonları bekliyor |
| **Test Coverage** | 🔴 Düşük | Unit/widget test yok, manuel test odaklı |
| **Dokümantasyon** | 🟢 İyi | planning/ klasörü kapsamlı, analiz raporları tamamlandı |

### Ekip Durumu
| Üye | Rol | Mevcut Durum | Kritiklik |
|-----|-----|--------------|-----------|
| **Abdullah** | Lead Developer | Backend hazır (Node.js + Prisma) | 🔴 Kritik - Tüm MR'ları onaylıyor |
| **Furkan** | Senior Mobile | Flutter Core aktif çalışıyor | 🔴 **En Kritik** - Faz 2 modüllerinin tek sorumlusu |
| **Yusuf** | Junior Full-Stack | Backend API geliştirme desteği | 🟡 Orta - Faz 2'de daha aktif olacak |
| **Seyit** | Junior UI/UX | UI kit temelleri hazır | 🟡 Orta - Faz 2 bildirim/i18n görevleri bekliyor |

---

## 🏗️ MEVCUT MİMARİ ANALİZİ

### Flutter Uygulaması (mobile/)

#### ✅ Tamamlanan Bileşenler (Faz 1)
```
mobile/lib/
├── main.dart                    ✅ Entry point, Firebase init
├── core/
│   ├── constants/
│   │   ├── api_constants.dart   ✅ Base URL tanımlı
│   │   └── app_constants.dart   ✅ Sürüm bilgisi
│   ├── theme/
│   │   ├── app_theme.dart       ✅ ThemeData yapılandırması
│   │   ├── app_colors.dart      ✅ Renk paleti (50+ yaş uyumlu)
│   │   └── app_typography.dart  ✅ Nunito font, 16sp minimum
│   ├── router/
│   │   └── app_router.dart      ✅ GoRouter yapılandırması
│   ├── network/
│   │   ├── dio_client.dart      ✅ Dio + interceptor'lar
│   │   └── api_exception.dart   ✅ Exception handling
│   ├── storage/
│   │   └── secure_storage.dart  ✅ JWT token saklama
│   └── utils/
│       ├── date_utils.dart      ✅ Tarih formatlama
│       └── currency_utils.dart  ✅ Para birimi formatlama
├── features/
│   ├── auth/                    ✅ Login, Register, Join (temel UI + mock)
│   ├── dashboard/               ✅ Manager/Resident dashboard (temel yapı)
│   ├── buildings/               ✅ Bina CRUD (temel UI)
│   ├── apartments/              ✅ Daire CRUD (temel UI)
│   └── ... (diğer modüller placeholder)
└── shared/
    ├── widgets/                 ✅ Loading, Error, Empty state widget'ları
    └── models/                  ✅ Base entity modelleri
```

#### ⚠️ Eksik/Bekleyen Bileşenler (Faz 2-3)
```
mobile/lib/features/
├── dues/                        ⚠️ Aidat sistemi (kritik eksik)
│   ├── data/                    ❌ Repository, datasource
│   ├── domain/                  ❌ Entity, use case
│   └── presentation/            ⚠️ Placeholder UI var, logic eksik
├── expenses/                    ❌ Gider kaydı (Faz 3)
├── tickets/                   ❌ Arıza/talep sistemi (Faz 3)
├── notifications/             ⚠️ FCM entegrasyonu bekliyor (Faz 2)
├── reports/                   ❌ PDF rapor (Faz 2)
└── subscription/              ⚠️ RevenueCat entegrasyonu placeholder
```

### Backend (backend/)

#### ✅ Tamamlanan (Abdullah tarafından)
- ✅ PostgreSQL + Prisma schema
- ✅ JWT auth (Access 15dk, Refresh 30 gün)
- ✅ API endpoint'leri (40+ endpoint tanımlı)
- ✅ Building/Apartment CRUD
- ✅ Invite code sistemi (7 gün geçerli, tek kullanımlık)
- ✅ Due (aidat) CRUD
- ✅ Expense (gider) CRUD
- ✅ Ticket sistemi
- ✅ RevenueCat webhook hazırlığı

### Veritabanı Şeması (Prisma)

#### ✅ Tamamlanan Modeller
| Model | Durum | Kullanım |
|-------|-------|----------|
| User | ✅ | Auth, role (MANAGER/RESIDENT) |
| Building | ✅ | Apartman yönetimi |
| Apartment | ✅ | Daire yönetimi |
| Due | ✅ | Aidat kayıtları |
| InviteCode | ✅ | Davet kodu sistemi |
| Expense | ✅ | Gider kayıtları |
| Ticket | ✅ | Arıza/talep sistemi |
| TicketUpdate | ✅ | Ticket güncellemeleri |
| Subscription | ✅ | RevenueCat entegrasyonu |
| Notification | ✅ | FCM bildirimleri |

---

## 🎯 KRİTİK EKSİKLİKLER ve RİSKLER

### 🔴 Kritik Eksiklikler (Hemen Çözülmeli)

#### 1. **Faz 2 - Aidat Sistemi (Furkan)**
| Bileşen | Durum | Risk | Öncelik |
|---------|-------|------|---------|
| **Due Repository** | ❌ Yok | Backend API var ama Flutter'da data layer yok | 🔴 **Kritik** |
| **Due Provider** | ❌ Yok | State management eksik | 🔴 **Kritik** |
| **Manager - Aidat Listesi** | ⚠️ Placeholder | "Aidatlar Sekmesi" yazısı var, gerçek UI yok | 🔴 **Kritik** |
| **Manager - Ödendi İşaretle** | ❌ Yok | Manuel durum değiştirme UI + logic yok | 🔴 **Kritik** |
| **Resident - Aidatlarım** | ⚠️ Placeholder | Sakin dashboard'unda placeholder | 🔴 **Kritik** |

#### 2. **Backend Entegrasyonu (Furkan + Abdullah)**
| Bileşen | Durum | Risk | Öncelik |
|---------|-------|------|---------|
| **API Service Layer** | ⚠️ Partial | Dio client var ama endpoint-specific servisler eksik | 🟡 **Yüksek** |
| **Error Handling** | ⚠️ Basic | Global error handling var ama feature-specific yok | 🟡 **Yüksek** |
| **Loading States** | ⚠️ Basic | Genel loading var ama skeleton/ shimmer eksik | 🟡 **Orta** |

#### 3. **Güvenlik Hardening (Tüm Ekip)**
| Bileşen | Durum | Risk | Öncelik |
|---------|-------|------|---------|
| **Input Validation** | ⚠️ Basic | Form validation var ama API input sanitization eksik | 🟡 **Yüksek** |
| **Security Headers** | ❌ Yok | Helmet.js backend'de eksik | 🟡 **Yüksek** |
| **Rate Limiting** | ❌ Yok | express-rate-limit yok | 🟡 **Orta** |
| **Certificate Pinning** | ❌ Yok | SSL pinning Flutter'da yok | 🟡 **Orta** |

### 🟡 Önemli Eksiklikler (Faz 2-3'te Çözülmeli)

#### 4. **Abonelik Sistemi (Furkan)**
- RevenueCat Flutter SDK kurulu ama entegrasyon tamamlanmamış
- Paywall ekranı placeholder
- Subscription status kontrolü yok

#### 5. **Bildirim Sistemi (Seyit + Abdullah)**
- FCM entegrasyonu backend'de hazır ama Flutter'da tamamlanmamış
- Push notification handler yok
- Local notifications yok

#### 6. **i18n (Seyit)**
- ARB dosyaları yapısı var ama TR/EN içerikleri eksik
- Dil değiştirme UI var ama persistence yok

---

## 🚀 DETAYLI YOL HARITASI

### 🎯 **AŞAMA 1: FAZ 2 TEMEL - Aidat Sistemi (1-2 Hafta)**
**Sorumlu:** Furkan (Primary), Abdullah (API Review)  
**Hedef:** Aidat sistemi tam çalışır durumda (Manager + Resident)

#### 1.1 Data Layer (3-4 gün)
```
dues/
├── data/
│   ├── models/
│   │   ├── due_model.dart          # JSON serialization
│   │   └── due_dto.dart            # API request/response
│   ├── datasources/
│   │   ├── due_remote_datasource.dart  # Dio HTTP calls
│   │   └── due_local_datasource.dart   # Cache (Hive?)
│   └── repositories/
│       └── due_repository_impl.dart    # Repository pattern
```

**Görevler:**
- [ ] DueModel, DueDTO oluştur (freezed + json_serializable)
- [ ] DueRemoteDatasource oluştur (CRUD operations)
- [ ] DueRepositoryImpl oluştur (error handling, caching)
- [ ] Unit test yaz (repository tests)

#### 1.2 Domain Layer (1-2 gün)
```
dues/
├── domain/
│   ├── entities/
│   │   └── due_entity.dart         # Business logic entity
│   ├── repositories/
│   │   └── due_repository.dart     # Abstract interface
│   └── usecases/
│       ├── get_dues_by_building.dart
│       ├── get_dues_by_apartment.dart
│       ├── update_due_status.dart
│       └── create_bulk_dues.dart
```

**Görevler:**
- [ ] DueEntity tanımla (domain logic)
- [ ] Repository interface tanımla
- [ ] Use case'leri oluştur (single responsibility)

#### 1.3 Presentation Layer (4-5 gün)
```
dues/
└── presentation/
    ├── providers/
    │   ├── dues_provider.dart       # Riverpod state management
    │   └── due_form_provider.dart   # Form state
    ├── screens/
    │   ├── manager_dues_screen.dart    # Yönetici: Tüm aidatlar
    │   ├── apartment_dues_screen.dart  # Yönetici: Daire aidatları
    │   └── resident_dues_screen.dart   # Sakin: Benim aidatlarım
    └── widgets/
        ├── due_list_item.dart       # Aidat kartı
        ├── due_status_badge.dart    # Ödendi/Bekliyor/Gecikmiş
        ├── due_filter_chip.dart     # Filtreleme
        └── mark_paid_dialog.dart    # Ödendi işaretleme dialog
```

**Görevler:**
- [ ] ManagerDuesScreen: Bina bazlı aidat listesi
- [ ] ApartmentDuesScreen: Daire bazlı aidat görünümü
- [ ] ResidentDuesScreen: Sakin kendi aidatları
- [ ] MarkPaidDialog: Ödendi/Ödenmedi toggle'ı + confirmation
- [ ] DueStatusBadge: Renkli durum göstergeleri
- [ ] DuesProvider: Riverpod ile state management
- [ ] Pull-to-refresh + Pagination

**Checkpoint:**
- ✅ Manager ekranından aidat görme, filtreleme, ödendi işaretleme çalışıyor
- ✅ Resident ekranından kendi aidatlarını görüyor
- ✅ Backend API ile tam entegrasyon
- ✅ Error handling ve loading states tamam

---

### 🎯 **AŞAMA 2: GÜVENLİK ve OPTİMIZASYON (1 Hafta)**
**Sorumlu:** Furkan (Flutter), Abdullah (Backend), Yusuf (Destek)  
**Hedef:** Production-ready güvenlik ve temel optimizasyon

#### 2.1 Flutter Güvenlik (2-3 gün)
- [ ] Input validation (form'lar için regex pattern'ler)
- [ ] Debug log'ları kaldır (`kDebugMode` check)
- [ ] ProGuard/R8 obfuscation yapılandırması
- [ ] Certificate pinning değerlendir (ssl_pinning_plugin)

#### 2.2 Backend Güvenlik (Abdullah) (2-3 gün)
- [ ] Helmet.js entegrasyonu (security headers)
- [ ] express-rate-limit yapılandırması
- [ ] Input sanitization middleware
- [ ] CORS whitelist yapılandırması

#### 2.3 Optimizasyon (2 gün)
- [ ] `ListView.builder` kullanımı (büyük listelerde)
- [ ] Image caching stratejisi (shimmer + cached_network_image)
- [ ] API pagination (default limit 50)
- [ ] Prisma query optimization (N+1 detection)

**Checkpoint:**
- ✅ Security audit yapıldı, kritik zafiyetler kapandı
- ✅ API response <200ms (ortalama)
- ✅ Flutter 60 FPS stabil

---

### 🎯 **AŞAMA 3: FAZ 2 TAMAMLAMA - Bildirim ve i18n (1 Hafta)**
**Sorumlu:** Seyit (Primary), Abdullah (FCM Backend), Furkan (Flutter entegrasyon)

#### 3.1 FCM Bildirim Sistemi (3-4 gün)
- [ ] Firebase Cloud Messaging entegrasyonu (Flutter)
- [ ] Push notification handler (background + foreground)
- [ ] Local notifications (Flutter Local Notifications)
- [ ] Notification listesi ekranı (Seyit)

#### 3.2 i18n Tamamlama (2-3 gün)
- [ ] ARB dosyalarını doldur (TR/EN)
- [ ] Dil değiştirme persistence (SharedPreferences)
- [ ] Tüm UI metinlerini ARB'den çek

**Checkpoint:**
- ✅ Push notification çalışıyor (test mesajı)
- ✅ TR/EN dil desteği tamam
- ✅ UI'da teknik jargon yok, anlaşılır metinler

---

### 🎯 **AŞAMA 4: FAZ 2 BİTİŞ - RevenueCat Abonelik (1 Hafta)**
**Sorumlu:** Furkan (Flutter), Abdullah (Backend Webhook)  
**Hedef:** Abonelik sistemi tam çalışır

#### 4.1 RevenueCat Entegrasyonu (3-4 gün)
- [ ] Purchases.configure() (main.dart)
- [ ] Paywall ekranı (subscription/presentation/)
- [ ] Subscription status kontrolü (dashboard'ta kilit mantığı)
- [ ] Backend webhook entegrasyonu (Abdullah)

#### 4.2 Abonelik Kilit Mantığı (2-3 gün)
- [ ] Manager için kilitlenecek özellikler (yeni bina, yeni aidat, PDF, toplu bildirim)
- [ ] Kilit UI ("Aboneliğinizi yenileyin" mesajı)
- [ ] Grace period handling

**Checkpoint:**
- ✅ Test abonelik alınıyor (sandbox)
- ✅ Abonelik dolunca kilitler aktif oluyor
- ✅ RevenueCat webhook çalışıyor

**🎉 FAZ 2 TAMAMLANMASI** - MVP-2 kullanılabilir durumda

---

### 🎯 **AŞAMA 5: FAZ 3 BAŞLANGIÇ - Ticket Sistemi (2 Hafta)**
**Sorumlu:** Furkan (Primary)

#### 5.1 Ticket Modülü (2 Hafta)
```
tickets/
├── data/
│   ├── models/
│   ├── datasources/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/
    └── screens/
        ├── resident_create_ticket_screen.dart
        ├── resident_ticket_list_screen.dart
        ├── manager_ticket_list_screen.dart
        └── manager_ticket_detail_screen.dart
```

- [ ] Ticket oluşturma (Sakin)
- [ ] Ticket listesi (Yönetici)
- [ ] Ticket detay + güncelleme (Yönetici)
- [ ] TicketUpdate chat-like UI

---

### 🎯 **AŞAMA 6: FAZ 3 TAMAMLAMA - Gider ve PDF (2 Hafta)**
**Sorumlu:** Yusuf (Gider API), Furkan (Flutter UI), Abdullah (PDF Backend)

#### 6.1 Gider Kaydı (1 Hafta)
- [ ] Expense modülü (Flutter)
- [ ] Gider kategorileri (UI)
- [ ] Aylık gider özeti

#### 6.2 PDF Rapor (1 Hafta)
- [ ] Backend PDF generation (Abdullah - puppeteer/pdfkit)
- [ ] Flutter'da PDF indirme/görüntüleme
- [ ] Aylık özet rapor UI

---

## 📅 TAHMİNİ TAKVİM (Toplam 8-10 Hafta)

| Aşama | Süre | Başlangıç | Bitiş | Sorumlu |
|-------|------|-----------|-------|---------|
| **Aşama 1** | 1-2 hafta | 2026-05-03 | 2026-05-17 | Furkan |
| **Aşama 2** | 1 hafta | 2026-05-17 | 2026-05-24 | Furkan + Abdullah |
| **Aşama 3** | 1 hafta | 2026-05-24 | 2026-05-31 | Seyit + Abdullah |
| **Aşama 4** | 1 hafta | 2026-05-31 | 2026-06-07 | Furkan + Abdullah |
| **FAZ 2 BİTİŞ** | | | **2026-06-07** | |
| **Aşama 5** | 2 hafta | 2026-06-07 | 2026-06-21 | Furkan |
| **Aşama 6** | 2 hafta | 2026-06-21 | 2026-07-05 | Yusuf + Furkan + Abdullah |
| **FAZ 3 BİTİŞ** | | | **2026-07-05** | |

**🎯 HEDEF:** 2026-07-05'te AidatPanel v1.0.0 (MVP Final) tamamlanmış olur.

---

## ⚠️ RİSKLER ve AZALTMA STRATEJİLERİ

| Risk | Olasılık | Etki | Azaltma Stratejisi |
|------|----------|------|-------------------|
| **Furkan tıkanma/uzaklaşma** | Orta | 🔴 Kritik | - Checkpoint'li ilerleme (sizin profilinize uygun)  <br> - Günlük sync'ler  <br> - Genshin/Valorant reset molaları planlı  <br> - Yusuf'a knowledge transfer |
| **Backend API değişiklikleri** | Düşük | 🟡 Yüksek | - API versioning (`/api/v1/`)  <br> - OpenAPI/Swagger dokümantasyonu  <br> - Eşzamanlı geliştirme koordinasyonu |
| **RevenueCat entegrasyonu karmaşası** | Orta | 🟡 Yüksek | - Sandbox testleri önceden planla  <br> - Backend webhook önce hazır olsun  <br> - Grace period testing |
| **50+ yaş kullanıcı UX sorunları** | Orta | 🟡 Orta | - Erken kullanıcı testleri (beta)  <br> - Furkan'ın babası veya tanıdıklar test etsin  <br> - Feedback döngüsü |
| **Test coverage eksikliği** | Yüksek | 🟡 Orta | - Her feature'de manuel test checklist  <br> - Integration test planı (sonra otomasyon) |

---

## 🎛️ CHECKPOINT ve KONTROL NOKTALARI

Her aşamada Furkan'ın "checkpoint'li ilerleme" stiline uygun kontrol noktaları:

### Aşama 1 Checkpoint'leri
1. ✅ **Data Layer Tamam** - Repository test'leri geçiyor
2. ✅ **Domain Layer Tamam** - Use case'ler çalışıyor
3. ✅ **Manager UI Tamam** - Aidat listeleme, filtreleme çalışıyor
4. ✅ **Ödendi İşaretleme Tamam** - Dialog + API entegrasyonu çalışıyor
5. ✅ **Resident UI Tamam** - Sakin kendi aidatlarını görüyor

### Her Checkpoint Sonrası
- [ ] **Kod Review:** Abdullah MR review yapıyor
- [ ] **Test:** Emülatörde (emulator-5554) manuel test
- [ ] **Commit:** CHANGELOG.md güncellemesi + versiyon (gerekirse)
- [ ] **Sync:** Ekip brief (15 dk - ne yapıldı, sıradaki ne)

---

## 📋 BAŞARILI TAMAMLAMA KRİTERLERİ (Definition of Done)

### Aşama 1 (Aidat Sistemi) DoD
- [ ] Manager: Tüm aidatları görme, filtreleme (bina/daire/durum)
- [ ] Manager: Aidat ödendi/ödenmedi işaretleme (onay dialog'lu)
- [ ] Resident: Kendi aidat geçmişini görme
- [ ] Backend API entegrasyonu tam (hata handling ile)
- [ ] Pull-to-refresh çalışıyor
- [ ] 50+ yaş uyumlu (16sp font, 48dp touch)

### Aşama 2 (Güvenlik/Optimizasyon) DoD
- [ ] Security audit yapıldı, Critical/High zafiyetler kapandı
- [ ] API response <200ms (ortalama)
- [ ] Flutter 60 FPS stabil
- [ ] Helmet.js + rate limiting aktif
- [ ] ProGuard/R8 obfuscation yapılandırıldı

### Aşama 3 (Bildirim/i18n) DoD
- [ ] FCM push notification çalışıyor (test mesajı)
- [ ] TR/EN dil desteği tamam
- [ ] UI metinleri teknik jargon içermiyor

### Aşama 4 (Abonelik) DoD
- [ ] Sandbox test aboneliği alınıyor
- [ ] Abonelik dolunca kilitler aktif
- [ ] RevenueCat webhook çalışıyor
- [ ] Grace period handling test edildi

---

## 🎯 SONUÇ ve ÖNERİLER

### Hemen Yapılacaklar (Bugün/ Yarın)
1. **Aşama 1'e Başla:** Due modülünün data layer'ını oluştur (DueModel, DueRemoteDatasource)
2. **Backend API Review:** Abdullah ile API endpoint'lerini gözden geçir (var mı, değişiklik var mı?)
3. **Versiyon 0.0.9 Hazırlığı:** Faz 2 başlangıcı için versiyon bump + CHANGELOG.md

### Kritik Başarı Faktörleri
1. **Furkan'ın Checkpoint'li İlerlemesi:** Her 2-3 saatte bir checkpoint, Genshin/Valorant reset molası
2. **Abdullah'ın Code Review Hızı:** MR'lar 24 saat içinde review edilmeli (bottleneck olmasın)
3. **Günlük Sync:** 15 dk daily standup (ne yapıldı, blockers, sıradaki)
4. **Test Kültürü:** Her feature manuel test + ekran kaydı (Abdullah için)

### Vizyon Hatırlatması
Bu proje başarıyla tamamlandığında:
- ✅ Türkiye'de binlerce apartman yöneticisi kullanıyor olacak
- ✅ Furkan Senior Mobile Developer olarak portföyünde güçlü bir ürün
- ✅ Teknik liderlik yolunda önemli bir adım
- ✅ Başarı + Para (ikisi de kritik) hedefine ulaşılmış olacak

---

**Hazır mısın Furkan? Aşama 1'e başlayalım mı?** 🚀

**Sonraki Adım:** Due modülü data layer'ını oluşturmaya başla mı?
