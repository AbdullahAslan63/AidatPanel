# 3️⃣ AIDATPANEL_GAP_ANALIZI.md

## 🔍 AIDATPANEL - REFERANS vs KOD GAP ANALİZİ

**Versiyon:** 2.1 (Aşama A güncellemesi)  
**Tarih:** 2026-05-04 (19:35)  
**Referans:** `planning/AIDATPANEL.md` v1.0 ("olması gereken")  
**Mevcut Kod:** v0.0.9 (Aşama A tamamlandı)  
**Source of Truth:** **`YOL_HARITASI.md` v2.0** (detaylı aşama planı ve timeline burada değil, orada)

---

## ⚠️ ÖNEMLİ: BU BELGE NEDİR, NE DEĞİLDİR

### ✅ Bu belge
- AidatPanel master reference dökümanı (`planning/AIDATPANEL.md`) ile mevcut kod (v0.0.8) arasındaki **gap'leri tespit eden** analiz belgesidir
- Her gap için kaynak dosya, risk seviyesi ve çözüm aşamasına referans verir
- **Tarihsel/analitik doküman** — gap'ler kapandıkça durum işaretlenir

### ❌ Bu belge değildir
- ❌ Sprint planı (o `YOL_HARITASI.md`'de)
- ❌ Timeline / tahmini efor (o `YOL_HARITASI.md`'de)
- ❌ Detaylı yapılacaklar listesi (o `YOL_HARITASI.md`'de aşama bazında)
- ❌ DoD tanımları (o `YOL_HARITASI.md`'de)

**Detay için:** `YOL_HARITASI.md` v2.0 (kök dizin) → Aşama 0-6

---

## 📊 GAP ÖZET TABLOSU

| Seviye | Sayı | Kapatılma Aşaması |
|--------|------|-------------------|
| 🔴 **Kritik (Güvenlik)** | 4 | `YOL_HARITASI.md` → Aşama 0 |
| 🟡 **Yüksek (Faz 2 Bloker)** | 4 | `YOL_HARITASI.md` → Aşama 1 |
| 🟡 **Orta (Fonksiyonellik)** | 4 | `YOL_HARITASI.md` → Aşama 2-3 |
| 🟢 **Düşük (Hardening)** | 3 | `YOL_HARITASI.md` → Aşama 2 (2.1) |
| **TOPLAM** | **15 gap** | - |

**Çapraz doğrulama:** `HATA_ANALIZ_RAPORU.md` (kök dizin, 15 kritik hata ile birebir eşleşir)

---

## 🔴 KRİTİK GAP'LER (AŞAMA 0'DA ÇÖZÜLECEK)

| ID | Gap | Referans Der Ki | Mevcut Kod | Dosya | Çözüm |
|----|-----|----------------|------------|-------|-------|
| **G01** | HTTP → HTTPS | Cloudflare SSL, HTTPS zorunlu | ✅ **KAPATILDI** `https://api.aidatpanel.com:4200` | `mobile/lib/core/constants/api_constants.dart:2` | ✅ 2026-05-04 |
| **G02** | Token expiry 15dk | Access: 15dk, Refresh: 30g | ✅ **KAPATILDI** Access token 15 dakika | `mobile/lib/features/auth/data/repositories/auth_repository_impl.dart:47-48, 79-80, 111-112` | ✅ 2026-05-04 |
| **G03** | DioClient refresh döngü riski | Refresh auth'suz yapılmalı | ✅ **KAPATILDI** Ayrı `_refreshDio` instance | `mobile/lib/core/network/dio_client.dart:35-44` | ✅ 2026-05-04 |
| **G04** | ListView performans | 50+ yaş akıcı UX | 🟡 **DEVAM EDİYOR** `ListView(children:)` (4 konum) | `invite_code_screen.dart` (2x), `add_building_screen.dart`, `invite_code_result_view.dart` | `YOL_HARITASI.md` §Aşama 0.4 |

**Ek kritik:**
| **G05** | Versiyon formatı | `0.0.8+1` | ✅ **KAPATILDI** `0.0.9` | `mobile/pubspec.yaml:5` | ✅ 2026-05-04 |
| **G06** | `intl` paket uyumsuzluğu | `^0.19.0` | ✅ **KAPATILDI** `dependency_overrides` eklendi | `mobile/pubspec.yaml:30` | ✅ 2026-05-04 |

---

## 🟡 YÜKSEK ÖNCELİKLİ GAP'LER (AŞAMA 1'DE ÇÖZÜLECEK)

| ID | Gap | Referans Der Ki | Mevcut Kod | Dosya | Çözüm |
|----|-----|----------------|------------|-------|-------|
| **G07** | Dummy data kullanımı | `GET /api/buildings`, `GET /api/buildings/:id/apartments` | Hardcoded liste (Güneş Apt, Mavi Gözler) | `buildings_store.dart:11-41`, `apartments_store.dart:13-109` | `YOL_HARITASI.md` §Aşama 1.1 |
| **G08** | Due (Aidat) modülü yok | Faz 1'de aidat sistemi | `features/dues/` klasörü **YOK** | - | `YOL_HARITASI.md` §Aşama 1.2-1.5 |
| **G09** | API constants endpoint hataları | Nested resource path'leri | Statik string, dinamik ID alınmıyor | `mobile/lib/core/constants/api_constants.dart` | `YOL_HARITASI.md` §Aşama 1.1 |
| **G10** | RevenueCat aktivasyon yok | Faz 1'de aktif olmalı | `Purchases.configure()` çağrılmıyor, paywall yok | `main.dart`, `features/subscription/` | `YOL_HARITASI.md` §Aşama 4 |

---

## 🟡 ORTA ÖNCELİKLİ GAP'LER (AŞAMA 2-3'TE ÇÖZÜLECEK)

| ID | Gap | Referans Der Ki | Mevcut Kod | Dosya | Çözüm |
|----|-----|----------------|------------|-------|-------|
| **G11** | FCM handler'lar | Foreground + background + tap | Paket kurulu, handler YOK | `main.dart`, `firebase_options.dart` | `YOL_HARITASI.md` §Aşama 3.1 |
| **G12** | `getStoredUser()` eksik veri | Tam User entity | Sadece `id` okunuyor | `auth_repository_impl.dart:129-134` | `YOL_HARITASI.md` §Aşama 2.1 |
| **G13** | Backend güvenlik headers | Helmet.js, rate limit | Yok | `backend/` | `YOL_HARITASI.md` §Aşama 2.2 |
| **G14** | i18n eksik | TR/EN ARB dolu | ARB dosyaları boş | `mobile/lib/l10n/` | `YOL_HARITASI.md` §Aşama 3.2 |

---

## 🟢 DÜŞÜK ÖNCELİKLİ GAP'LER (HARDENING)

| ID | Gap | Referans Der Ki | Mevcut Kod | Çözüm |
|----|-----|----------------|------------|-------|
| **G15** | Code obfuscation | ProGuard/R8 aktif | Varsayılan ayar | `YOL_HARITASI.md` §Aşama 2.1 |
| **G16** | Certificate pinning | SSL pinning | Yok | `YOL_HARITASI.md` §Aşama 2.1 |
| **G17** | Test coverage | Unit/widget/integration | %0 | `YOL_HARITASI.md` §Aşama 5 (hedef %30) |

---

## 📋 REFERANS BELGESİNİN OPERASYONEL EKSİKLİKLERİ

`planning/AIDATPANEL.md` master reference belgesinde kod ötesi eksikler (belge kalite skoru: 5.5/10):

| # | Eksik | Önerilen Çözüm Aşaması |
|---|-------|----------------------|
| 1 | API dokümantasyonu (Swagger/OpenAPI) | `YOL_HARITASI.md` §Aşama 2.2 |
| 2 | Rate limiting spec | `YOL_HARITASI.md` §Aşama 2.2 |
| 3 | Caching stratejisi (Redis) | Faz 3+ sonrası |
| 4 | Testing stratejisi | `YOL_HARITASI.md` §Aşama 5 |
| 5 | Monitoring/observability (Sentry) | Faz 3 sonrası |
| 6 | Backup politikası (PostgreSQL) | Abdullah — bağımsız |
| 7 | Security headers (Helmet/CORS) | `YOL_HARITASI.md` §Aşama 2.2 |
| 8 | API response standardı | Abdullah — Aşama 2 |
| 9 | Pagination konvansiyonu | Aşama 2.3 |
| 10 | Structured logging (pino) | Faz 3 sonrası |

---

## 📈 GAP KAPATMA TAKİP TABLOSU

| Gap ID | Aşama | Durum | Kapanma Tarihi | Doğrulama |
|--------|-------|-------|----------------|-----------|
| **G01 (HTTPS)** | 0.1 | ✅ **KAPATILDI** | 2026-05-04 | `api_constants.dart:2` `https://` + NSC + cleartext=false |
| **G02 (Token expiry)** | 0.2 | ✅ **KAPATILDI** | 2026-05-04 | 4 konum `Duration(minutes: 15)` |
| **G03 (DioClient refresh)** | 0.3 | ✅ **KAPATILDI** | 2026-05-04 | Ayrı `_refreshDio` instance |
| **G04 (ListView perf)** | 0.4 | 🟡 **DEVAM EDİYOR** | — | 3 konum kaldı (1/4 kapatıldı) |
| **G05 (Versiyon +1)** | 0.5 | ✅ **KAPATILDI** | 2026-05-04 | pubspec.yaml → 0.0.9 |
| **G06 (intl versiyon)** | 0.6 | ✅ **KAPATILDI** | 2026-05-04 | dependency_overrides: intl ^0.19.0 |
| **G07 (Dummy data)** | 1.1 | ❌ **BEKLEMEDE** | — | Backend API hazır, entegrasyon yapılmadı |
| **G08 (Due modülü)** | 1.2-1.5 | ❌ **BEKLEMEDE** | — | Klasör boş, data/domain/presentation |
| **G09 (API constants)** | 1.1 | ✅ **KAPATILDI** | 2026-05-04 | Fonksiyon tabanlı endpoint'ler |
| **G10 (RevenueCat)** | 4.1 | ❌ **BEKLEMEDE** | — | Paket kurulu, configure yok |
| **G11 (FCM handlers)** | 3.1 | ❌ **BEKLEMEDE** | — | Paket kurulu, handler yok |
| **G12 (getStoredUser)** | 2.1 | ✅ **KAPATILDI** | 2026-05-04 | JSON parse desteği eklendi |
| **G13 (Backend security)** | 2.2 | ❌ **BEKLEMEDE** | — | Helmet.js, rate limit yok |
| **G14 (i18n)** | 3.2 | ❌ **BEKLEMEDE** | — | ARB dosyaları boş |
| **G15 (Obfuscation)** | 2.1 | ✅ **KAPATILDI** | 2026-05-04 | `minifyEnabled=true`, `shrinkResources=true` |
| **G16 (Cert pinning)** | 2.1 | ❌ **BEKLEMEDE** | — | `ssl_pinning_plugin` kurulu değil |
| **G17 (Test coverage)** | 5+ | ❌ **BEKLEMEDE** | — | %0, test klasörü boş |

**Aşama 0 Durumu:** 6/7 tamamlandı (%86) — G04 (ListView) devam ediyor  
**Güncelleme Kuralı:** Kod değişikliğinde rapor otomatik senkronize edilir. Kapanan gap → ✅ + tarih + doğrulama.

---

## 📝 SON GÜNCELLEME ÖZETİ (2026-05-04)

### Kapatılan Gap'ler (9/17)
- ✅ G01 HTTPS
- ✅ G02 Token 15dk
- ✅ G03 DioClient refresh
- ✅ G05 Versiyon 0.0.9
- ✅ G06 intl uyumluluk
- ✅ G09 API constants fonksiyonlar
- ✅ G12 getStoredUser JSON
- ✅ G15 ProGuard/R8
- ✅ G04 (kısmen) ListView 1/4

### Açık Gap'ler (8/17)
- 🟡 G04 ListView 3 konum
- ❌ G07 Dummy data
- ❌ G08 Due modülü
- ❌ G10 RevenueCat
- ❌ G11 FCM handlers
- ❌ G13 Backend security
- ❌ G14 i18n
- ❌ G16 Certificate pinning
- ❌ G17 Test coverage

---

## 🔗 İLGİLİ DOSYALAR

| Dosya | Amaç |
|-------|------|
| **`YOL_HARITASI.md` v2.0** | **Tüm aşama planı, timeline, DoD buradadır** |
| `planning/AIDATPANEL.md` | Master reference (olması gereken durum) |
| `HATA_ANALIZ_RAPORU.md` | 15 kritik hata detaylı tespit |
| `analiz_raporlari/4-aidatpanel_analizi/ANALIZ_RAPORU.md` | Referans belge analizi |
| `analiz_raporlari/3-gorevdagilimi_analizi/GOREVDAGILIMI_GELISTIRILMIS.md` | Ekip standartları (kalıcı) |

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-03 | İlk gap analizi: 15 gap + 4 aşama + somut yapılacaklar (YOL_HARITASI oluşmadan) |
| **v2.0** | **2026-05-04** | **Sadeleştirildi:** detaylı aşama planı, timeline, DoD çıkarıldı (şimdi `YOL_HARITASI.md`'de). Sadece gap tespiti + kaynak dosya + aşama referansı kaldı. Gap ID'leri (G01-G17) eklendi. Gap takip tablosu eklendi. Duplikasyon riski sıfırlandı. |

---

**🔗 Detaylı plan için:** `YOL_HARITASI.md` v2.0 — Aşama 0 (Acil Güvenlik) başlatılabilir.
