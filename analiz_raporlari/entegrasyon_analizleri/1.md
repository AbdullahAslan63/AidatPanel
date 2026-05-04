# Furkan Flutter Entegrasyon Rehberi

> Backend: `backend/endpoints` branch  
> Mobile: `mobile/flutter-app` branch  
> Tarih: 2026-05-03  
> Uyumsuzluk: KRİTİK - Aşağıda detaylı açıklandı

---

## 🚨 KRİTİK UYARI: Veri Modeli Uyumsuzluğu

### Furkan'ın Beklediği (Mock) vs Backend'in Döndürdüğü

| Veri | Furkan'ın Mock'u | Backend (Faz 1) | Durum |
|---|---|---|---|
| **Building.totalApartments** | ✅ Var | ✅ Hesaplanabilir | OK |
| **Building.occupiedApartments** | ✅ Var | ⚠️ User'lı daireler sayılır | Kısmen OK |
| **Building.totalMonthlyDues** | ✅ Var | ❌ **YOK** - Due tablosu Faz 2 | **EKSİK** |
| **Building.collectedDues** | ✅ Var | ❌ **YOK** - Due tablosu Faz 2 | **EKSİK** |
| **Apartment.residentName** | ✅ Var | ❌ **YOK** - User tablosunda | **EKSİK** |
| **Apartment.phone** | ✅ Var | ❌ **YOK** - User tablosunda | **EKSİK** |
| **Apartment.monthlyDues** | ✅ Var | ❌ **YOK** - Due tablosu Faz 2 | **EKSİK** |
| **Apartment.paymentStatus** | ✅ Var | ❌ **YOK** - Due tablosu Faz 2 | **EKSİK** |
| **Apartment.balance** | ✅ Var | ❌ **YOK** - Due'dan hesaplanır | **EKSİK** |

### Sonuç
**Faz 1 backend'i, Furkan'ın UI tasarımındaki tüm verileri sağlayamaz.**
- Sakin bilgileri (isim, telefon) `User` tablosunda, `Apartment`'ta değil
- Aidat bilgileri (monthlyDues, paymentStatus, balance) `Due` tablosu Faz 2'de
- Prisma şemasına müdahale edilmeyecek (AGENTS.md kuralı)

### Geçici Çözüm (Faz 1)
Backend'den gelen verilerle sınırlı UI gösterimi:
- Building: sadece id, name, address
- Apartment: sadece id, number, floor
- Diğer alanlar: "Yakında" veya "-" göster

---

## 📋 Mevcut Backend Endpoint'leri (Faz 1)

### 1. Auth - Login
**Endpoint:** `POST /api/v1/auth/login`

**Furkan'ın Kodu:** `mobile/lib/features/auth/data/datasources/auth_remote_datasource.dart:22-28`
```dart
@override
Future<LoginResponse> login(LoginRequest request) async {
  final response = await _dioClient.post(
    ApiConstants.login,
    data: request.toJson(),
  );
  return LoginResponse.fromJson(response.data);
}
```

**Request (LoginRequest.toJson()):**
```json
{
  "identifier": "ahmet@example.com",
  "password": "123456"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Giriş başarılı.",
  "data": {
    "accessToken": "eyJ...",
    "refreshToken": "eyJ...",
    "user": {
      "id": "uuid",
      "email": "ahmet@example.com",
      "name": "Ahmet Yılmaz",
      "role": "MANAGER"
    }
  }
}
```

**⚠️ Uyarı:** Backend `phone` alanı dönmüyor, ama `UserData` modelinde var. Null gelir.

---

### 2. Buildings - Listeleme
**Endpoint:** `GET /api/v1/buildings`

**Furkan'ın Beklediği Veri:** `BuildingEntity` - 6 alan
```dart
BuildingEntity(
  id: '1',
  name: 'Güneş Apartmanı',
  address: 'Atatürk Cad. No: 45',
  totalApartments: 12,        // ❌ Backend'de YOK
  occupiedApartments: 11,     // ❌ Backend'de YOK
  totalMonthlyDues: 12000,    // ❌ Backend'de YOK (Faz 2)
  collectedDues: 10500,       // ❌ Backend'de YOK (Faz 2)
)
```

**Backend'in Döndüğü:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "name": "Güneş Apartmanı",
      "address": "Atatürk Cad. No: 45",
      "city": "İstanbul",
      "managerId": "uuid",
      "createdAt": "2026-05-01T10:00:00Z",
      "updatedAt": "2026-05-01T10:00:00Z"
    }
  ]
}
```

**Entegrasyon:** `buildings_store.dart:12-40`
```dart
// Mevcut: Mock veriler
// Değişecek:
final response = await dioClient.get(ApiConstants.buildings);
final buildings = (response.data['data'] as List)
  .map((json) => BuildingEntity(
    id: json['id'],
    name: json['name'],
    address: json['address'],
    totalApartments: 0,       // ⚠️ Backend'de yok, 0 göster
    occupiedApartments: 0,    // ⚠️ Backend'de yok, 0 göster
    totalMonthlyDues: 0,      // ⚠️ Backend'de yok, 0 göster
    collectedDues: 0,         // ⚠️ Backend'de yok, 0 göster
  ))
  .toList();
```

---

### 3. Apartments - Listeleme (Bina Altında)
**Endpoint:** `GET /api/v1/buildings/{buildingId}/apartments`

**Furkan'ın Beklediği Veri:** `ApartmentEntity` - 8 alan
```dart
ApartmentEntity(
  id: '1-1',
  buildingId: '1',
  apartmentNumber: '1A',
  residentName: 'Ahmet Yılmaz',  // ❌ Backend'de YOK (User tablosunda)
  phone: '+905551112233',         // ❌ Backend'de YOK (User tablosunda)
  monthlyDues: 1000,              // ❌ Backend'de YOK (Due tablosu Faz 2)
  paymentStatus: PaymentStatus.paid,  // ❌ Backend'de YOK
  balance: 0,                     // ❌ Backend'de YOK
)
```

**Backend'in Döndüğü:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "number": "1A",
      "floor": 1,
      "buildingId": "uuid",
      "createdAt": "2026-05-01T10:00:00Z"
    }
  ]
}
```

**Entegrasyon:** `apartments_store.dart:13-109`
```dart
// apartmentsFor metodu değişecek
Future<List<ApartmentEntity>> fetchApartments(String buildingId) async {
  final response = await dioClient.get(
    '${ApiConstants.buildings}/$buildingId/apartments'
  );
  
  return (response.data['data'] as List).map((json) {
    return ApartmentEntity(
      id: json['id'],
      buildingId: buildingId,
      apartmentNumber: json['number'],  // ✅ Backend'de var
      residentName: 'Bilinmiyor',       // ⚠️ Backend'de YOK
      phone: null,                       // ⚠️ Backend'de YOK
      monthlyDues: 0,                  // ⚠️ Backend'de YOK
      paymentStatus: PaymentStatus.pending, // ⚠️ Backend'de YOK
      balance: 0,                      // ⚠️ Backend'de YOK
    );
  }).toList();
}
```

---

## ⚠️ Furkan İçin Değiştirilecek Dosyalar

### 1. `mobile/lib/features/buildings/data/buildings_store.dart`
**Değişecek:** `getBuildings()` metodu

**Mevcut:** Mock veriler `_initialBuildings()`

**Yeni:** API'den çek
```dart
Future<void> loadBuildings() async {
  final response = await dioClient.get(ApiConstants.buildings);
  final data = response.data['data'] as List;
  
  state = data.map((json) => BuildingEntity(
    id: json['id'],
    name: json['name'],
    address: json['address'],
    totalApartments: 0,      // FIXME: Backend Faz 2'de eklenecek
    occupiedApartments: 0,   // FIXME: Backend Faz 2'de eklenecek
    totalMonthlyDues: 0,     // FIXME: Backend Faz 2'de eklenecek
    collectedDues: 0,        // FIXME: Backend Faz 2'de eklenecek
  )).toList();
}
```

### 2. `mobile/lib/features/apartments/data/apartments_store.dart`
**Değişecek:** `apartmentsFor()` ve provider'lar

**Mevcut:** Mock veriler `_initialApartments()`

**Yeni:** API'den çek
```dart
Future<void> loadApartments(String buildingId) async {
  final response = await dioClient.get(
    '${ApiConstants.buildings}/$buildingId/apartments'
  );
  final data = response.data['data'] as List;
  
  final apartments = data.map((json) => ApartmentEntity(
    id: json['id'],
    buildingId: buildingId,
    apartmentNumber: json['number'],
    residentName: 'Bilinmiyor',      // FIXME: User ilişkisi Faz 2'de
    phone: null,                       // FIXME: User ilişkisi Faz 2'de
    monthlyDues: 0,                    // FIXME: Due tablosu Faz 2'de
    paymentStatus: PaymentStatus.pending, // FIXME: Due tablosu Faz 2'de
    balance: 0,                        // FIXME: Due'dan hesaplanacak
  )).toList();
  
  state = {...state, buildingId: apartments};
}
```

### 3. `mobile/lib/core/constants/api_constants.dart`
**Değişecek:** Base URL

**Mevcut:**
```dart
static const String baseUrl = 'http://api.aidatpanel.com:4200';
```

**Yeni:** (Development için)
```dart
static const String baseUrl = 'http://localhost:3000'; // Backend portuna göre
```

---

## 🔄 Backend'den Gelen Response Formatı (Tüm Endpointler)

Tüm API response'ları şu formatı kullanır:
```json
{
  "success": true|false,
  "data": {...}|[...]|null,
  "message": "string|null",
  "errors": [...]|null
}
```

**Başarılı:** `success: true`, `data` dolu  
**Hata:** `success: false`, `message` ve/veya `errors` dolu

---

## 📊 Faz 1 vs Faz 2 Veri Uyumsuzluğu Özeti

| UI'da Görünen | Veri Kaynağı | Faz 1 | Faz 2 |
|---|---|---|---|
| Bina adı | Backend | ✅ | ✅ |
| Bina adresi | Backend | ✅ | ✅ |
| Toplam daire sayısı | Backend (count) | ✅ | ✅ |
| Dolu daire sayısı | Backend (User join) | ⚠️ Manual | ✅ Auto |
| Aylık toplam aidat | Due tablosu | ❌ 0 göster | ✅ |
| Toplanan aidat | Due tablosu | ❌ 0 göster | ✅ |
| Tahsilat oranı | Hesaplanan | ❌ %0 göster | ✅ |
| Daire numarası | Backend | ✅ | ✅ |
| Sakin adı | User tablosu | ❌ "Bilinmiyor" | ✅ |
| Telefon | User tablosu | ❌ "-" | ✅ |
| Aidat durumu | Due tablosu | ❌ "Bekliyor" | ✅ |
| Bakiye | Due tablosu | ❌ 0 | ✅ |

---

## 🎯 Özet ve Öneriler

### Furkan İçin:
1. **Entegrasyona başlayabilir** - Auth ve temel CRUD çalışıyor
2. **UI'da eksik verileri** "Yakında", "-", "Bilinmiyor" olarak göster
3. **Faz 2'de** eksik alanlar otomatik dolacak (API değişmeyecek, sadece data dolu gelecek)

### Backend İçin (Senin Yapman Gereken):
- **Şu an için bir şey yok** - Faz 1 endpointleri çalışıyor
- **Faz 2'de:** Due tablosu ve User ilişkisi eklenecek

### Kritik Not:
**Prisma şemasına müdahale edilmeyecek** - Bu yüzden şu an Furkan'ın beklediği tüm verileri döndüremeyiz. Faz 2 planlamasına dahil edilecek.

---

**Hazır mısın?** Furkan bu rehberle entegrasyona başlayabilir. Eksik veriler için UI placeholder'ları kullanmalı.
