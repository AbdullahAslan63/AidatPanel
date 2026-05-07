# Mobil App - Backend Entegrasyon Analizi
**Tarih:** 2026-05-03  
**Branch:** `mobile/flutter-app`  
**Hedef:** `backend/endpoints`

---

## Mevcut Mimari Durum

### ✅ Tamamlanan ve Backend-Compatible Sistemler

| Modül | Durum | Açıklama |
|-------|-------|----------|
| **Auth** | ✅ Tamamlandı | RemoteDatasource + Repository + API çağrıları hazır |
| **DioClient** | ✅ Tamamlandı | Token refresh, interceptor, error handling çalışıyor |
| **SecureStorage** | ✅ Tamamlandı | Token, refreshToken, user, expiry saklama tamam |
| **API Constants** | ✅ Tanımlı | Tüm backend endpoint'leri tanımlı (bazıları kullanılmıyor) |

### 🔄 Local-Only (Backend'e Bağlanmalı)

| Modül | Mevcut Durum | Backend Endpoint | Eşleşme |
|-------|--------------|------------------|---------|
| **Buildings** | `BuildingsStore` - In-memory state | `GET/POST/PUT/DELETE /api/v1/buildings` | ⚠️ Entity field'ları farklı |
| **Apartments** | `ApartmentsStore` - In-memory state | `GET/POST/PUT/DELETE /api/v1/buildings/:id/apartments` | ⚠️ Backend'de `floor` var, mobile'da `residentName` var |

### ❌ Boş Modüller (Backend'de var, Mobile'da yok)

| Modül | Backend Schema | Mobile Durum |
|-------|----------------|--------------|
| **Due** (Aidat) | ✅ `Due` modeli var | ❌ `features/dues/` - Boş klasör |
| **Expense** (Gider) | ✅ `Expense` modeli var | ❌ `features/expenses/` - Boş klasör |
| **Ticket** (Talep) | ✅ `Ticket` + `TicketUpdate` var | ❌ `features/tickets/` - Boş klasör |
| **Notification** | ✅ `Notification` modeli var | ❌ `features/notifications/` - Boş klasör |
| **Subscription** | ✅ `Subscription` modeli var | ❌ `features/subscription/` - Boş klasör |

---

## Kritik Uyumsuzluklar (Düzeltilmeli)

### 1. Building Entity Uyumsuzluğu

| Field | Mobile Entity | Backend Model | Durum |
|-------|---------------|---------------|-------|
| `id` | ✅ String | ✅ String @id @uuid | Eşleşiyor |
| `name` | ✅ String | ✅ String | Eşleşiyor |
| `address` | ✅ String | ✅ String | Eşleşiyor |
| `city` | ❌ **YOK** | ✅ String | **Mobile'a eklenmeli** |
| `managerId` | ❌ **YOK** | ✅ String | JWT'den geliyor |
| `totalApartments` | ✅ int | ❌ **Hesaplanan** | Backend'de apartments[].count |
| `occupiedApartments` | ✅ int | ❌ **Hesaplanan** | Backend'de residents count |
| `totalMonthlyDues` | ✅ double | ❌ **Hesaplanan** | Backend'de sum(Due.amount) |
| `collectedDues` | ✅ double | ❌ **Hesaplanan** | Backend'de sum(Paid Due.amount) |

**Öneri:** Mobile entity'ye `city` eklenmeli, diğer calculated field'lar backend'den gelmeli veya ayrı API çağrısıyla alınmalı.

### 2. Apartment Entity Uyumsuzluğu

| Field | Mobile Entity | Backend Model | Durum |
|-------|---------------|---------------|-------|
| `id` | ✅ String | ✅ String @id @uuid | Eşleşiyor |
| `buildingId` | ✅ String | ✅ String | Eşleşiyor |
| `number` | ✅ String (apartmentNumber) | ✅ String | Eşleşiyor |
| `floor` | ❌ **YOK** | ✅ Int? | **Mobile'a eklenmeli** |
| `residentName` | ✅ String | ❌ **YOK - User modelinde** | **Backend'den User.name alınmalı** |
| `phone` | ✅ String? | ❌ **YOK - User modelinde** | **Backend'den User.phone alınmalı** |
| `monthlyDues` | ✅ double | ❌ **YOK - Due modelinde** | **Ayrı API ile alınmalı** |
| `paymentStatus` | ✅ Enum | ❌ **YOK - Due modelinde** | **Ayrı API ile alınmalı** |
| `balance` | ✅ double | ❌ **YOK - Hesaplanan** | **Ayrı API ile alınmalı** |

**Öneri:** Mobile'daki `ApartmentEntity` çok farklı. Backend'den gelen `Apartment` modeli ile `User` ve `Due` ilişkisini birleştirerek mobile entity oluşturulmalı.

### 3. User Entity Eşleşmesi

| Field | Mobile Entity | Backend Model | Durum |
|-------|---------------|---------------|-------|
| `id` | ✅ String | ✅ String | Eşleşiyor |
| `email` | ✅ String | ✅ String | Eşleşiyor |
| `name` | ✅ String | ✅ String | Eşleşiyor |
| `phone` | ✅ String? | ✅ String? | Eşleşiyor |
| `role` | ✅ Enum (manager/resident) | ✅ Enum (MANAGER/RESIDENT) | Eşleşiyor |
| `language` | ✅ String | ✅ String | Eşleşiyor |
| `fcmToken` | ✅ String? | ✅ String? | Eşleşiyor |

**Sonuç:** User entity tamamen eşleşiyor ✅

---

## Entegrasyon Planı

### Faz 1: Mevcut Sistemi Backend'e Bağlama (Öncelik: Yüksek)

#### 1.1 Buildings Modülü
```
yapılacaklar:
- [ ] BuildingRemoteDataSource oluştur
  - [ ] getBuildings() → GET /api/v1/buildings
  - [ ] createBuilding() → POST /api/v1/buildings
  - [ ] updateBuilding() → PUT /api/v1/buildings/:id
  - [ ] deleteBuilding() → DELETE /api/v1/buildings/:id
  
- [ ] BuildingRepository oluştur
  - [ ] Abstract + Implementation
  
- [ ] BuildingModel oluştur (JSON ↔ Entity dönüşümü)
  - [ ] city field'i ekle
  
- [ ] BuildingsStore'u güncelle
  - [ ] API'den veri çek
  - [ ] Cache mekanizması (opsiyonel)
```

#### 1.2 Apartments Modülü
```
yapılacaklar:
- [ ] ApartmentRemoteDataSource oluştur
  - [ ] getApartments(buildingId) → GET /api/v1/buildings/:id/apartments
  - [ ] createApartment() → POST /api/v1/buildings/:id/apartments
  - [ ] updateApartment() → PUT /api/v1/buildings/:id/apartments/:aptId
  - [ ] deleteApartment() → DELETE /api/v1/buildings/:id/apartments/:aptId
  
- [ ] ApartmentRepository oluştur
  - [ ] Abstract + Implementation
  
- [ ] ApartmentModel oluştur
  - [ ] floor field'i ekle
  - [ ] residentName → Backend User ilişkisinden al
  
- [ ] ApartmentsStore'u güncelle
  - [ ] API'den veri çek
```

### Faz 2: Eksik Modülleri Implemente Etme (Öncelik: Orta)

#### 2.1 Due (Aidat) Modülü
```
backend endpoint'leri:
- GET /api/v1/buildings/:id/dues
- POST /api/v1/buildings/:id/dues (bulk oluşturma)
- PUT /api/v1/dues/:id (ödeme durumu güncelle)

yapılacaklar:
- [ ] DueEntity oluştur
- [ ] DueRemoteDataSource oluştur
- [ ] DueRepository oluştur
- [ ] DueStore/DueNotifier oluştur
- [ ] UI screens (Aidat listesi, ödeme ekranı)
```

#### 2.2 Expense (Gider) Modülü
```
backend endpoint'leri:
- GET/POST /api/v1/buildings/:id/expenses
- DELETE /api/v1/expenses/:id

yapılacaklar:
- [ ] ExpenseEntity oluştur
- [ ] ExpenseRemoteDataSource oluştur
- [ ] ExpenseRepository oluştur
- [ ] UI screens (Gider listesi, ekleme ekranı)
```

#### 2.3 Ticket (Talep) Modülü
```
backend endpoint'leri:
- GET/POST /api/v1/buildings/:id/tickets
- GET /api/v1/tickets/:id/updates
- POST /api/v1/tickets/:id/updates

yapılacaklar:
- [ ] TicketEntity + TicketUpdateEntity oluştur
- [ ] TicketRemoteDataSource oluştur
- [ ] TicketRepository oluştur
- [ ] UI screens (Talep listesi, detay, yanıt)
```

### Faz 3: İleri Seviye Özellikler (Öncelik: Düşük)

#### 3.1 Notification Modülü
```
backend endpoint'leri:
- GET /api/v1/notifications
- PATCH /api/v1/notifications/:id/read

yapılacaklar:
- [ ] FCM entegrasyonu
- [ ] NotificationEntity oluştur
- [ ] Bildirim listesi ekranı
```

#### 3.2 Subscription Modülü
```
backend endpoint'leri:
- GET /api/v1/me/subscription
- RevenueCat webhook entegrasyonu

yapılacaklar:
- [ ] RevenueCat SDK entegrasyonu
- [ ] SubscriptionEntity oluştur
- [ ] Abonelik ekranı
```

---

## Backend Hatalarının Mobil Etkisi

| Backend Hatası | Mobil Etki | Öncelik |
|----------------|------------|---------|
| Prisma URL eksik | API çağrıları 500 hatası verir | 🔴 Kritik |
| cookie-parser eksik | `req.cookies` çalışmaz (mobil etkilenmez çünkü header kullanıyor) | 🟡 Orta |
| /join endpoint kapalı | Davet kodu ile kayıt çalışmaz | 🔴 Kritik ( Resident kaydı gerekli ) |
| Rate limiting agresif | Mobile'da çok hızlı işlem yapılamaz | 🟡 Orta |
| Token blacklist yok | Güvenlik açığı (çalınan token kullanılabilir) | 🟡 Orta |

---

## API Çağrı Akış Şeması (Başarılı Senaryo)

```
1. Kullanıcı Login/Register
   Mobile: POST /api/v1/auth/login
   Backend: ✅ Hazır
   Mobile: Token sakla (SecureStorage)
   
2. Bina Listesi
   Mobile: GET /api/v1/buildings (Header: Bearer token)
   Backend: ✅ Hazır
   Mobile: BuildingEntity listesi göster
   
3. Daire Listesi
   Mobile: GET /api/v1/buildings/:id/apartments
   Backend: ✅ Hazır
   Mobile: ApartmentEntity listesi göster
   
4. Yeni Bina Ekle
   Mobile: POST /api/v1/buildings {name, address, city}
   Backend: ✅ Hazır
   Mobile: Listeyi yenile
   
5. Yeni Daire Ekle
   Mobile: POST /api/v1/buildings/:id/apartments {number, floor}
   Backend: ✅ Hazır
   Mobile: Listeyi yenile
```

---

## Özet ve Öneriler

### Risk Değerlendirmesi

| Kategori | Seviye | Açıklama |
|----------|--------|----------|
| **Mimari Uyumluluk** | 🟡 Orta | Clean Architecture var ama sadece Auth'da tam uygulanmış |
| **Data Model Uyumu** | 🔴 Yüksek | Building ve Apartment entity'leri backend'den farklı |
| **Eksik Modüller** | 🔴 Yüksek | Due, Expense, Ticket gibi kritik modüller boş |
| **API Altyapısı** | 🟢 Düşük | DioClient ve interceptor'lar hazır |

### Hemen Yapılması Gerekenler

1. **BuildingEntity'ye `city` field'i ekle** - Backend uyumluluğu için
2. **ApartmentEntity'ye `floor` field'i ekle** - Backend uyumluluğu için
3. **BuildingRemoteDataSource oluştur** - 4 API endpoint'i implemente et
4. **ApartmentRemoteDataSource oluştur** - 4 API endpoint'i implemente et
5. **BuildingsStore ve ApartmentsStore'u API'den veri çekecek şekilde güncelle**

### Tahmini Efor

| Faz | Modül | Süre |
|-----|-------|------|
| Faz 1 | Buildings bağlantısı | 4-6 saat |
| Faz 1 | Apartments bağlantısı | 4-6 saat |
| Faz 2 | Due modülü | 6-8 saat |
| Faz 2 | Expense modülü | 4-6 saat |
| Faz 2 | Ticket modülü | 6-8 saat |
| Faz 3 | Notification | 4-6 saat |
| **Toplam** | | **28-40 saat** |

---

*Rapor: Cascade AI | Analiz tarihi: 2026-05-03*
