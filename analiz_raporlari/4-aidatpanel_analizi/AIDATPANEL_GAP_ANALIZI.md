# 🔍 AIDATPANEL - REFERANS vs KOD GAP ANALİZİ

**Versiyon:** 2.0 (Sadeleştirilmiş — `YOL_HARITASI.md` ile hizalanmış)  
**Tarih:** 2026-05-04  
**Referans:** `planning/AIDATPANEL.md` v1.0 ("olması gereken")  
**Mevcut Kod:** v0.0.8  
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
| **G01** | HTTP → HTTPS | Cloudflare SSL, HTTPS zorunlu | `http://api.aidatpanel.com:4200` | `mobile/lib/core/constants/api_constants.dart:2` | `YOL_HARITASI.md` §Aşama 0.1 |
| **G02** | Token expiry 15dk | Access: 15dk, Refresh: 30g | Access token 30 gün set ediliyor | `mobile/lib/features/auth/data/repositories/auth_repository_impl.dart:47-48, 79-80, 111-112` | `YOL_HARITASI.md` §Aşama 0.2 |
| **G03** | DioClient refresh döngü riski | Refresh auth'suz yapılmalı | Refresh kendi interceptor'ını çağırıyor | `mobile/lib/core/network/dio_client.dart:74-76` | `YOL_HARITASI.md` §Aşama 0.3 |
| **G04** | ListView performans | 50+ yaş akıcı UX | `ListView(children:)` (4 konum) | `invite_code_screen.dart` (2x), `add_building_screen.dart`, `invite_code_result_view.dart` | `YOL_HARITASI.md` §Aşama 0.4 |

**Ek kritik:**
| **G05** | Versiyon formatı | `0.0.8+1` | `0.0.8` (+1 yok) | `mobile/pubspec.yaml:5` | `YOL_HARITASI.md` §Aşama 0.5 |
| **G06** | `intl` paket uyumsuzluğu | `^0.19.0` | `^0.20.2` | `mobile/pubspec.yaml:30` | `YOL_HARITASI.md` §Aşama 0.6 |

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

| Gap ID | Aşama | Durum | Kapanma Tarihi |
|--------|-------|-------|----------------|
| G01 (HTTPS) | 0.1 | ⏳ Bekliyor | - |
| G02 (Token expiry) | 0.2 | ⏳ Bekliyor | - |
| G03 (DioClient refresh) | 0.3 | ⏳ Bekliyor | - |
| G04 (ListView perf) | 0.4 | ⏳ Bekliyor | - |
| G05 (Versiyon +1) | 0.5 | ⏳ Bekliyor | - |
| G06 (intl versiyon) | 0.6 | ⏳ Bekliyor | - |
| G07 (Dummy data) | 1.1 | ⏳ Bekliyor | - |
| G08 (Due modülü) | 1.2-1.5 | ⏳ Bekliyor | - |
| G09 (API constants) | 1.1 | ⏳ Bekliyor | - |
| G10 (RevenueCat) | 4.1 | ⏳ Bekliyor | - |
| G11 (FCM handlers) | 3.1 | ⏳ Bekliyor | - |
| G12 (getStoredUser) | 2.1 | ⏳ Bekliyor | - |
| G13 (Backend security) | 2.2 | ⏳ Bekliyor | - |
| G14 (i18n) | 3.2 | ⏳ Bekliyor | - |
| G15 (Obfuscation) | 2.1 | ⏳ Bekliyor | - |
| G16 (Cert pinning) | 2.1 | ⏳ Bekliyor | - |
| G17 (Test coverage) | 5+ | ⏳ Bekliyor | - |

**Güncelleme kuralı:** Her aşama bitişinde (git tag açıldığında) tablo güncellenir. Kapanan gap → ✅ + tarih.

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
