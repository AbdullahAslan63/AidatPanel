# AIDATPANEL - HATA ve EKSİKLİK ANALİZ RAPORU

**Tarih:** 2026-05-04  
**Versiyon:** 0.0.8  
**Analiz Eden:** AI Co-Founder (Furkan profili ile)  
**Durum:** 🔴 Kritik Hatalar Mevcut - Düzeltme Gerekli

---

## 🚨 KRİTİK HATALAR (Hemen Çözülmeli)

### 1. 🔴 HTTP Protokolü Kullanımı (Güvenlik Riski)
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/core/constants/api_constants.dart:2` |
| **Mevcut** | `static const String baseUrl = 'http://api.aidatpanel.com:4200';` |
| **Sorun** | HTTP yerine HTTPS kullanılmalı. Production'da HTTP ile API çağrısı güvenlik riski. |
| **Risk** | **Kritik** - Veri sızıntısı, MITM saldırıları |
| **Çözüm** | ```dart\nstatic const String baseUrl = 'https://api.aidatpanel.com:4200';\n// Cloudflare SSL sertifikası yapılandırılmalı``` |
| **Commit** | 23e458b |

---

### 2. 🔴 Token Expiry Süresi Uyuşmazlığı (Auth Sorunu)
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/features/auth/data/repositories/auth_repository_impl.dart:47-48, 79-80, 111-112` |
| **Mevcut** | `DateTime.now().add(const Duration(days: 30))` |
| **Sorun** | Access token 30 gün set ediliyor ama backend'de 15 dakika olmalı. Bu auth hatasına yol açar. |
| **Risk** | **Kritik** - Token süresi dolduktan sonra bile client token geçerli sanıyor |
| **Çözüm** | ```dart\n// Access token: 15 dakika\nawait _secureStorage.saveTokenExpiry(\n  DateTime.now().add(const Duration(minutes: 15)),\n);\n// Refresh token: 30 gün (ayrı saklanmalı)``` |
| **Commit** | 23e458b |

---

### 3. 🔴 DioClient Refresh Token Mantığında Risk
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/core/network/dio_client.dart:74-76` |
| **Mevcut** | `_dio.post(ApiConstants.refresh, data: {'refreshToken': refreshToken})` |
| **Sorun** | Refresh request'i kendi interceptor'ını atlıyor. Dio retry'da problem olabilir. |
| **Risk** | **Yüksek** - Refresh request'i timeout/401 alırsa sonsuz döngü riski |
| **Çözüm** | ```dart\n// Ayrı bir Dio instance kullan (interceptor olmadan)\nfinal refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));\nfinal response = await refreshDio.post(...);``` |
| **Commit** | 23e458b |

---

### 4. 🔴 ListView Performans Sorunu (Büyük Listelerde)
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/features/buildings/presentation/screens/invite_code_screen.dart` (2 yer) |
| **Dosya** | `mobile/lib/features/buildings/presentation/screens/add_building_screen.dart` (1 yer) |
| **Dosya** | `mobile/lib/features/buildings/presentation/widgets/invite_code_result_view.dart` (1 yer) |
| **Mevcut** | `ListView(children: [...])` - Tüm çocuklar aynı anda oluşturuluyor |
| **Sorun** | 50+ daire olan binalarda scroll lag ve memory spike |
| **Risk** | **Yüksek** - 50+ yaş kullanıcılar için performans problemi (50+ daireli binalar yaygın) |
| **Çözüm** | ```dart\n// ListView.builder kullan\nListView.builder(\n  itemCount: apartments.length,\n  itemBuilder: (context, index) => ApartmentItem(\n    apartment: apartments[index],\n  ),\n)``` |
| **Commit** | - |

---

## ⚠️ YÜKSEK ÖNCELİKLİ EKSİKLİKLER

### 5. 🟡 Dummy Data Hala Mevcut (Backend Entegrasyonu Eksik)
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/features/buildings/data/buildings_store.dart:11-41` |
| **Dosya** | `mobile/lib/features/apartments/data/apartments_store.dart:13-109` |
| **Mevcut** | Hardcoded bina ve daire verileri ("Güneş Apartmanı", "Mavi Gözler Sitesi", vb.) |
| **Sorun** | Backend API hazır ama hala dummy data kullanılıyor. Gerçek veri çekilmiyor. |
| **Risk** | **Yüksek** - Faz 2'de gerçek backend entegrasyonu yok |
| **Çözüm** | ```dart\n// BuildingsRemoteDatasource oluştur\nclass BuildingsRemoteDatasource {\n  Future<List<BuildingModel>> getBuildings() async {\n    final response = await _dioClient.get(ApiConstants.buildings);\n    return (response.data as List)\n      .map((json) => BuildingModel.fromJson(json))\n      .toList();\n  }\n}``` |
| **Not** | Backend API endpoint'leri hazır (`GET /api/buildings`) |

---

### 6. 🟡 Due (Aidat) Modülü Tamamen Eksik
| Alan | Detay |
|------|-------|
| **Konum** | `mobile/lib/features/dues/` - Klasör yok |
| **Eksik Bileşenler** | Data Layer (Model, Datasource, Repository)<br>Domain Layer (Entity, UseCase)<br>Presentation Layer (Screen, Provider, Widgets) |
| **Sorun** | AidatPanel'in temel fonksiyonu (aidat yönetimi) Flutter'da implemente edilmemiş. |
| **Risk** | **Kritik** - Faz 2'nin ana modülü eksik. Manager "Aidatlar" sekmesinde sadece placeholder text var. |
| **Backend Durumu** | ✅ API hazır: `GET /api/buildings/:id/dues`, `POST /api/buildings/:id/dues/bulk`, `PATCH /api/dues/:id/status` |
| **Çözüm** | Aşama 1'de detaylandırıldı: DueModel, DueRemoteDatasource, DueRepository, UseCase'ler, Manager/Resident ekranları |

---

### 7. 🟡 Abonelik (RevenueCat) Entegrasyonu Eksik
| Alan | Detay |
|------|-------|
| **Paket** | `purchases_flutter: ^7.0.0` pubspec.yaml'de var |
| **Konfigürasyon** | `main.dart`'te Purchases.configure() çağrılmıyor |
| **Paywall** | `subscription/presentation/paywall_screen.dart` - dosya yok |
| **Sorun** | Abonelik sistemi kurulu ama aktif değil. Manager için kritik özellikler (yeni bina ekleme, yeni aidat oluşturma) kilitli değil. |
| **Risk** | **Yüksek** - İş modeli gereği abonelik şart |
| **Çözüm** | ```dart\n// main.dart\nawait Purchases.configure(\n  PurchasesConfiguration('rc_live_...'),\n);\n// Kilit mantığı için subscription status kontrolü``` |

---

### 8. 🟡 FCM (Push Notification) Tamamlanmamış
| Alan | Detay |
|------|-------|
| **Paket** | `firebase_messaging: ^15.0.0` pubspec.yaml'de var |
| **Konfigürasyon** | `firebase_options.dart` - dosya var ama içerik kontrol edilmeli |
| **Handler** | Background/foreground message handler yok |
| **Sorun** | Bildirim sistemi kurulumu yarım kalmış. Backend webhook hazır ama client handler yok. |
| **Risk** | **Orta** - Faz 2'de tamamlanması gerekiyor |
| **Çözüm** | `FirebaseMessaging.onMessage.listen(...)` ve `onBackgroundMessage` handler'ları ekle |

---

## ⚠️ ORTA ÖNCELİKLİ HATALAR

### 9. 🟡 Versiyon Formatı Eksik (+1 yok)
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/pubspec.yaml:5` |
| **Mevcut** | `version: 0.0.8` |
| **Sorun** | Flutter build number eksik (`+1`). Semantic versioning için build number şart. |
| **Doğrusu** | `version: 0.0.8+1` |
| **Risk** | **Düşük** - Play Store/App Store sürümlendirmede sorun olabilir |
| **Çözüm** | `version: 0.0.8+1` yap |

---

### 10. 🟡 intl Paket Versiyonu Uyumsuzluğu Riski
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/pubspec.yaml:30` |
| **Mevcut** | `intl: ^0.20.2` |
| **Sorun** | Flutter SDK 3.11.5 ile intl 0.20.2 uyumlu mu? flutter_localizations (SDK) ile conflict riski. |
| **Risk** | **Orta** - Derleme hatası veya runtime hatası |
| **Çözüm** | ```yaml\ndependency_overrides:\n  intl: ^0.19.0  # Flutter 3.11.5 ile test edilmiş versiyon``` |

---

### 11. 🟡 API Constants Endpoint Hataları
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/core/constants/api_constants.dart` |
| **Sorun** | Tüm endpoint'ler `$apiVersion/buildings` baz alınmış ama farklı base path'leri var:<br>- Apartments: `buildings/:id/apartments`<br>- Dues: `buildings/:id/dues`<br>- Expenses: `buildings/:id/expenses` |
| **Mevcut** | Hepsi aynı base path'i kullanıyor, dinamik ID eklenmemiş |
| **Risk** | **Yüksek** - API çağrıları 404 dönecek |
| **Çözüm** | ```dart\nstatic String buildingApartments(String buildingId) =>\n  '$apiVersion/buildings/$buildingId/apartments';\n// Şeklinde fonksiyonlar kullan``` |

---

### 12. 🟡 AuthRepositoryImpl.getStoredUser() Eksik Veri
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/features/auth/data/repositories/auth_repository_impl.dart:129-134` |
| **Mevcut** | ```dart\nreturn userId != null\n  ? UserEntity(id: userId, email: '', name: '', role: UserRole.resident)\n  : null;``` |
| **Sorun** | Stored user'dan sadece ID okunuyor, email/name/role eksik. Splash'dan sonra kullanıcı adı/email gösterilemiyor. |
| **Risk** | **Orta** - UI'da kullanıcı bilgileri eksik görünebilir |
| **Çözüm** | SecureStorage'da kullanıcı detaylarını JSON olarak sakla ve parse et |

---

## 📋 DÜŞÜK ÖNCELİKLİ (Hardening)

### 13. 🟢 Code Obfuscation Eksik
| Alan | Detay |
|------|-------|
| **Konfigürasyon** | `android/app/build.gradle`'de proguard/r8 ayarları varsayılan |
| **Sorun** | APK decompile edilebilir, API key'ler görülebilir |
| **Risk** | **Düşük** - Security through obscurity ama önemli |
| **Çözüm** | ```gradle\nandroid {\n  buildTypes {\n    release {\n      minifyEnabled true\n      shrinkResources true\n      proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'\n    }\n  }\n}``` |

---

### 14. 🟢 Certificate Pinning Eksik
| Alan | Detay |
|------|-------|
| **Paket** | `ssl_pinning_plugin` ekli değil |
| **Sorun** | SSL sertifikası değişirse veya MITM saldırısı olursa koruma yok |
| **Risk** | **Düşük** - HTTPS var ama pinning ekstra güvenlik |
| **Çözüm** | `ssl_pinning_plugin` ekle ve sertifika public key'i pinle |

---

### 15. 🟢 Test Coverage Sıfır
| Alan | Detay |
|------|-------|
| **Durum** | `mobile/test/` klasörü boş veya yok |
| **Unit Test** | Repository test'leri yok |
| **Widget Test** | UI test'leri yok |
| **Integration Test** | API entegrasyon test'leri yok |
| **Risk** | **Orta** - Regression riski yüksek |
| **Çözüm** | En azından Repository test'leri yaz (`auth_repository_test.dart`) |

---

## 📊 ÖZET TABLO

| Seviye | Sayı | Başlıca Sorunlar |
|--------|------|-------------------|
| 🔴 **Kritik** | 4 | HTTP protokolü, Token expiry, DioClient refresh, ListView performans |
| 🟡 **Yüksek** | 4 | Dummy data, Due modülü eksik, RevenueCat eksik, API constants hatalı |
| 🟡 **Orta** | 4 | FCM eksik, Versiyon formatı, intl uyumsuzluğu, getStoredUser eksik |
| 🟢 **Düşük** | 3 | Obfuscation, Certificate pinning, Test coverage |
| **Toplam** | **15** | |

---

## 🎯 ÖNERİLEN DÜZELTME SIRASI

### Aşama A: Acil Güvenlik (Bugün)
1. 🔴 HTTP → HTTPS değiştir
2. 🔴 Token expiry süresini düzelt (15 dk)
3. 🔴 DioClient refresh token mantığını düzelt

### Aşama B: Faz 2 Bloklayıcı (Bu hafta)
4. 🟡 Dummy data'yı backend API ile değiştir
5. 🟡 Due modülü data layer'ını oluştur
6. 🟡 API constants endpoint'lerini düzelt

### Aşama C: İş Fonksiyonelliği (Gelecek hafta)
7. 🟡 RevenueCat entegrasyonu
8. 🟡 FCM bildirim handler'ları
9. 🟡 Due presentation layer (UI)

### Aşama D: Hardening (Sonra)
10. 🟢 ProGuard/R8 obfuscation
11. 🟢 Certificate pinning
12. 🟢 Unit test'ler

---

## ⚠️ RİSK ANALİZİ

### Şu Anki Risk Seviyesi: 🔴 **YÜKSEK**

**Neden:**
1. HTTP protokolü - Veri sızıntısı riski
2. Token expiry yanlış - Auth bypass riski
3. Due modülü eksik - Faz 2'nin ana modülü yok
4. Dummy data - Gerçek backend entegrasyonu yok

### Dönüm Noktası Önerisi:
```
🔴 KRİTİK: "dönüm noktası al" önerilir.

Mevcut Faz 1 durumu (çalışan auth + bina yönetimi) kaydedilmeli.
Aşama A (güvenlik düzeltmeleri) sonrası yeni dönüm noktası önerilir.
```

---

**Hazır mısın Furkan? Hangi hatayla başlamak istersin?**

Önerim: **Aşama A** ile başla (HTTP → HTTPS, Token expiry düzeltmesi)
Risk seviyesi: 🔴 **Kritik** - Bu güvenlik hataları production'a çıkmadan çözülmeli.
