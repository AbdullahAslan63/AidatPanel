# AIDATPANEL - HATA ve EKSİKLİK ANALİZ RAPORU

**Tarih:** 2026-05-06
**Versiyon:** 0.1.0
**Analiz Eden:** AI Co-Founder (Furkan profili ile)
**Durum:** 🟡 Aşama A Tamamlandı - Aşama B Devam Ediyor

---

## 🚨 KRİTİK HATALAR (Hemen Çözülmeli)

### H-01: HTTP Protokolü Kullanımı (Güvenlik Riski) [STATUS: CLOSED - 2026-05-04] [PRIORITY: CRITICAL]
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/core/constants/api_constants.dart:2` |
| **Mevcut** | `static const String baseUrl = 'https://api.aidatpanel.com:4200';` |
| **Sorun** | ✅ **KAPATILDI** - HTTPS'e geçildi |
| **Risk** | ✅ **ÇÖZÜLDÜ** |
| **Çözüm** | ✅ Implementasyon tamamlandı |
| **Kapatılma Tarihi** | 2026-05-04 |

---

### H-02: Token Expiry Süresi Uyuşmazlığı (Auth Sorunu) [STATUS: CLOSED - 2026-05-04] [PRIORITY: CRITICAL]
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/features/auth/data/repositories/auth_repository_impl.dart:47-48, 79-80, 111-112` |
| **Mevcut** | `DateTime.now().add(const Duration(minutes: 15))` |
| **Sorun** | ✅ **KAPATILDI** - Access token 15 dakikaya düşürüldü |
| **Risk** | ✅ **ÇÖZÜLDÜ** |
| **Çözüm** | ✅ Implementasyon tamamlandı (3 lokasyonda) |
| **Kapatılma Tarihi** | 2026-05-04 |

---

### H-03: DioClient Refresh Token Mantığında Risk [STATUS: CLOSED - 2026-05-04] [PRIORITY: CRITICAL]
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/core/network/dio_client.dart:35-44` |
| **Mevcut** | Ayrı `_refreshDio` instance (interceptor'sız) |
| **Sorun** | ✅ **KAPATILDI** - Sonsuz döngü riski ortadan kaldırıldı |
| **Risk** | ✅ **ÇÖZÜLDÜ** |
| **Çözüm** | ✅ Implementasyon tamamlandı |
| **Kapatılma Tarihi** | 2026-05-04 |

---

### H-04: ListView Performans Sorunu (3 Konum Kaldı) [STATUS: OPEN] [PRIORITY: MEDIUM]
| Alan | Detay |
|------|-------|
| **Dosya** | `mobile/lib/features/buildings/presentation/screens/invite_code_screen.dart:304` |
| **Dosya** | `mobile/lib/features/buildings/presentation/screens/add_building_screen.dart:56` |
| **Dosya** | `mobile/lib/features/buildings/presentation/widgets/invite_code_result_view.dart:38` |
| **Mevcut** | `ListView(children: [...])` - Tüm çocuklar aynı anda oluşturuluyor |
| **Risk** | **Orta** - 3 konum kaldı, `add_building_screen` sabit form (kabul edilebilir) |
| **Çözüm** | `ListView.builder` kullan |
| **Kapatılan** | `invite_code_screen.dart` (1 konum) ✅ 2026-05-04 → `ListView.builder` |

---

## YÜKSEK ÖNCELİKLİ EKSİKLİKLER

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

## 📊 ÖZET TABLO (Güncel)

| Seviye | Sayı | Kapatıldı | Kalan | Başlıca Sorunlar |
|--------|------|-----------|-------|-------------------|
| 🔴 **Kritik** | 4 | 3 ✅ | 1 | ListView (3 konum kaldı) |
| 🟡 **Yüksek** | 4 | 0 | 4 | Dummy data, Due modülü, RevenueCat, API constants |
| 🟡 **Orta** | 4 | 2 ✅ | 2 | FCM eksik, getStoredUser eksik |
| 🟢 **Düşük** | 3 | 1 ✅ | 2 | Certificate pinning, Test coverage |
| **Toplam** | **15** | **6** | **9** | |

### Kapatılan Hatalar (6/15)
| # | Hata | Kapatılma | Rapor |
|---|------|-----------|-------|
| 1 | HTTP → HTTPS | ✅ 2026-05-04 | Aşama A |
| 2 | Token expiry 15dk | ✅ 2026-05-04 | Aşama A |
| 3 | DioClient refresh loop | ✅ 2026-05-04 | Aşama A |
| 9 | Versiyon formatı (+1) | ✅ 2026-05-04 | v0.0.9 |
| 10 | intl paket uyumsuzluğu | ✅ 2026-05-04 | dependency_overrides |
| 13 | ProGuard/R8 obfuscation | ✅ 2026-05-04 | build.gradle |

---

## 🎯 DÜZELTME DURUMU

### ✅ Aşama A: Acil Güvenlik — TAMAMLANDI (2026-05-04)
1. ✅ HTTP → HTTPS değiştirildi
2. ✅ Token expiry süresi düzeltildi (15 dk)
3. ✅ DioClient refresh token mantığı düzeltildi

### 🟡 Aşama B: Faz 2 Bloklayıcı — DEVAM EDİYOR
4. 🟡 Dummy data → Backend API (Aşama 1.1)
5. 🟡 Due modülü data layer (Aşama 1.2-1.5)
6. 🟡 API constants endpoint'leri (kısmen ✅)

### 🟡 Aşama C: İş Fonksiyonelliği — BEKLEMEDE
7. 🟡 RevenueCat entegrasyonu
8. 🟡 FCM bildirim handler'ları
9. 🟡 Due presentation layer (UI)

### ✅🟡 Aşama D: Hardening — KISMEN
10. ✅ ProGuard/R8 obfuscation (build.gradle)
11. 🟢 Certificate pinning (Sonra)
12. 🟢 Unit test'ler (Aşama 5)

---

## ⚠️ RİSK ANALİZİ (Güncel)

### Şu Anki Risk Seviyesi: � **ORTA**

**Neden:**
1. ✅ HTTP/HTTPS — KAPATILDI (2026-05-04)
2. ✅ Token expiry — KAPATILDI (2026-05-04)
3. 🟡 Due modülü eksik - Faz 2'nin ana modülü henüz başlamadı (Aşama 1)
4. 🟡 Dummy data - Backend API entegrasyonu Aşama 1'de yapılacak

### Aşama 0 Durumu: ✅ %90 Tamamlandı
| Madde | Durum |
|-------|-------|
| HTTP → HTTPS | ✅ KAPATILDI |
| Token 15dk | ✅ KAPATILDI |
| DioClient refresh | ✅ KAPATILDI |
| ListView builder | 🟡 3 konum kaldı |
| Versiyon +1 | ✅ KAPATILDI |
| intl uyumluluk | ✅ KAPATILDI |

---

**Hazır mısın Furkan? Hangi hatayla başlamak istersin?**

Önerim: **Aşama A** ile başla (HTTP → HTTPS, Token expiry düzeltmesi)
Risk seviyesi: 🔴 **Kritik** - Bu güvenlik hataları production'a çıkmadan çözülmeli.
