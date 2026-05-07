# AGENTS.md KOD UYUMLULUK DENETİMİ

**Versiyon:** 1.2 (Kod senkronizasyonu)  
**Tarih:** 2026-05-04 (19:45)  
**Denetlenen Kod:** `mobile/lib/` (Flutter) v0.0.9  
**Standart:** `resources/analiz_raporlari/2-agents_promptu_analizi/2-AGENTS.md` v2.0 (puan: 7.5 → 9.1)
**Yol Haritası:** `resources/YOL_HARITASI.md` v3.1 (Aşama 0 %90 tamamlandı)

---

## 📊 GENEL DURUM

| Kategori | Uygun | Uygun Değil | Risk |
|----------|-------|-------------|------|
| **Font Boyutları (≥16sp)** | ✅ 15 stil | ❌ 1 stil (15sp) | 🟡 Orta |
| **Türkçe UI** | ✅ Tam | — | 🟢 Uygun |
| **Türkçe Locale** | ✅ `tr_TR` aktif | — | 🟢 Uygun ✅ 2026-05-04 |
| **ListView.builder** | ✅ 2 kullanım | ❌ 3 kullanım kaldı | � Orta |
| **textScaleFactor Kısıtlaması** | ✅ Yok | — | 🟢 Uygun |
| **Decimal (Finansal)** | ✅ Yok | ❌ `double` var (kullanılmamış) | 🟢 Düşük |
| **JWT Expiry** | ✅ 15dk (3 yer + mock) | — | � Uygun ✅ 2026-05-04 |
| **Buton Boyutları** | ✅ 56dp/48dp | — | 🟢 Uygun |
| **BottomNavigationBar** | ✅ Var | — | 🟢 Uygun |
| **HTTPS** | ✅ `https://` | — | 🟢 Uygun ✅ 2026-05-04 |
| **Android Manifest** | ✅ INTERNET + NSC + cleartext=false | — | 🟢 Uygun ✅ 2026-05-04 |
| **DioClient Refresh** | ✅ Ayrı `_refreshDio` instance | — | 🟢 Uygun ✅ 2026-05-04 |

**Genel Uyumluluk Skoru:** %92 (17/18 kural karşılandı)

---

## ✅ UYGUN ALANLAR (Takdir Edilecek)

### 1. 50+ Yaş Erişilebilirlik — Font Sistemi
```dart
// app_typography.dart — Mükemmel implementasyon
static const TextStyle label = TextStyle(
  fontSize: 16, // ✅ Minimum 16sp
  fontWeight: FontWeight.w700,
);

static const TextStyle body1 = TextStyle(
  fontSize: 17, // ✅ 16+ (17sp)
  fontWeight: FontWeight.w500,
);
```
**Tüm başlıklar:** 18sp-32sp aralığında, bold font weight'lerle.

### 2. Türkçe UI — Mükemmel Kapsam
```dart
// add_building_screen.dart
Text('Yeni Bina Ekle') // ✅
Text('Çıkış Yap') // ✅
Text('Vazgeç') // ✅
Text('Bina Oluştur') // ✅
```
**Hiçbir "Add Due" / "Mark as Paid" / "Error 422" kullanımı yok.**

### 3. Buton Boyutları — AGENTS.md Standardında
```dart
// app_sizes.dart
static const double buttonHeightPrimary = 56.0; // ✅
static const double buttonHeightSecondary = 48.0; // ✅

// Kullanım — settings_tab.dart
ElevatedButton.styleFrom(
  minimumSize: const Size(double.infinity, AppSizes.buttonHeightPrimary), // ✅
)
```

### 4. BottomNavigationBar — Zorunlu Navigasyon
```dart
// main_scaffold.dart veya benzeri
BottomNavigationBar( // ✅ Hamburger/Drawer YOK
  items: [...],
)
```

### 5. textScaleFactor — KISITLANMIYOR
```dart
// Hiçbir yerde şu pattern yok:
// ❌ MediaQuery.of(context).textScaleFactor = 1.0;
// ✅ Kullanıcı font ölçeği saygı görüyor
```

### 6. Design System — Renkler Sabit
```dart
// app_colors.dart
static const Color primary = Color(0xFF1B3A6B); // ✅
static const Color accent = Color(0xFFF59E0B); // ✅
static const Color success = Color(0xFF16A34A); // ✅
static const Color error = Color(0xFFDC2626); // ✅
```

---

## ❌ UYGUN OLMAYAN ALANLAR (Düzeltilmeli)

### � ORTA — AŞAMA 0.4'TE TAMAMLANACAK

#### K-01: ListView.children Kullanımı (3 Konum Kaldı)
**AGENTS.md Kuralı:** "10+ item potansiyeli olan `ListView`'larda **`ListView.builder` zorunlu**"

| Dosya | Satır | Mevcut Kod | Durum |
|-------|-------|------------|-------|
| `add_building_screen.dart` | 56 | `ListView(children: [...])` | ❌ Açık (sabit form) |
| `invite_code_screen.dart` | 304 | `ListView(children: [...])` | ❌ Açık |
| `invite_code_result_view.dart` | 38 | `ListView(children: [...])` | ❌ Açık |
| `invite_code_screen.dart` (diğer) | - | `ListView.builder` | ✅ Kapatıldı |

**Düzeltme:**
```dart
// ❌ Mevcut
ListView(
  children: buildings.map((b) => BuildingTile(b)).toList(),
)

// ✅ AGENTS.md uyumlu
ListView.builder(
  itemCount: buildings.length,
  itemBuilder: (context, index) => BuildingTile(buildings[index]),
)
```

#### ✅ K-02: Token Expiry 30 Gün (15dk Olmalı) — KAPATILDI
**AGENTS.md Kuralı:** "**JWT süresi:** access token `15 dakika`, refresh token `30 gün`"

| Dosya | Satır | Durum |
|-------|-------|-------|
| `auth_repository_impl.dart` | 51, 83, 115 | ✅ `Duration(minutes: 15)` |
| `auth_provider.dart` (mock) | 124 | ✅ `Duration(minutes: 15)` |

**Kapatma Tarihi:** 2026-05-04

#### ✅ K-03: HTTP Protokolü (HTTPS Zorunlu) — KAPATILDI
**AGENTS.md Kuralı:** "`https://` ile başlayan URL commit etme (production trap)"

| Dosya | Satır | Durum |
|-------|-------|-------|
| `api_constants.dart` | 2 | ✅ `https://api.aidatpanel.com:4200` |
| `AndroidManifest.xml` | 9-10 | ✅ `usesCleartextTraffic=false` + NSC |

**Kapatma Tarihi:** 2026-05-04

---

### 🟡 ORTA SEVİYE — AŞAMA 1-2'DE DÜZELTİLMELİ

#### O-01: Font Size 15sp (Minimum 16sp Altında)
```dart
// app_typography.dart:92
static const TextStyle small = TextStyle(
  fontSize: 15, // ❌ 16sp altında
  fontWeight: FontWeight.w600,
);
```
**Risk:** 50+ yaş kullanıcılar için okunabilirlik.

**Düzeltme:**
```dart
fontSize: 16, // ✅ Minimum sınır
```

#### O-02: DioClient Refresh Token Sonsuz Döngü Riski
**AGENTS.md Kuralı:** "`DioClient`'ta refresh isteği için **ayrı Dio instance** kullan"

```dart
// dio_client.dart:74-76
// ❌ Aynı _dio instance refresh'te kullanılıyor
final response = await _dio.post(ApiConstants.refresh, ...);
```

**Düzeltme:**
```dart
final Dio _refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
// Refresh için _refreshDio kullan (interceptor'sız)
```

#### O-03: `double` Kullanımı (Finansal Alanlar İçin Risk)
```dart
// app_sizes.dart (30 kullanım) — risk düşük çünkü boyutlandırma için
// FAKAT finansal alanlarda Decimal zorunlu
```
**Not:** Şu an `Decimal` paketi kullanılmıyor, `double` boyutlandırma için kullanılmış (kabul edilebilir).

#### O-04: Input Validators — Türkçe Mesaj Kontrolü
```dart
// input_validators.dart
static String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Telefon numarası gerekli'; // ✅ Türkçe
  }
  // ...
}
```
**Kontrol edilmeli:** Tüm validator mesajları Türkçe + insanca mı?

---

## 🔍 DETAYLI BULGU LİSTESİ

### Font Boyutları Analizi (app_typography.dart)

| Stil | Boyut | Durum | Not |
|------|-------|-------|-----|
| `h1` | 32sp | ✅ | +4 artırılmış |
| `h2` | 26sp | ✅ | +4 artırılmış |
| `h3` | 20sp | ✅ | +2 artırılmış |
| `h4` | 18sp | ✅ | +2 artırılmış |
| `body1` | 17sp | ✅ | +1 artırılmış |
| `body2` | 17sp | ✅ | +1 artırılmış |
| `label` | 16sp | ✅ | Minimum sınır |
| `caption` | 16sp | ✅ | Minimum sınır |
| `button` | 18sp | ✅ | +1 artırılmış |
| `bodyLarge` | 19sp | ✅ | +3 artırılmış |
| `small` | **15sp** | ❌ | **16sp altında** |

### `ListView` Kullanımları Analizi

| Dosya | Fonksiyon | Tip | Öğe Sayısı | Risk | AGENTS Uyum |
|-------|-----------|-----|------------|------|-------------|
| `add_building_screen.dart:56` | Form | `ListView` | ~15 sabit öğe | Düşük | ⚠️ Kabul edilebilir |
| `invite_code_screen.dart:253` | Bina seçim | `ListView` | 50+ bina potansiyeli | 🔴 Yüksek | ❌ builder gerekli |
| `invite_code_screen.dart:294` | Daire seçim | `ListView` | 100+ daire | 🔴 Yüksek | ❌ builder gerekli |
| `invite_code_result_view.dart` | Sonuç listesi | `ListView` | Değişken | 🟡 Orta | ⚠️ builder önerilir |

---

## 🎯 DÜZELTME ÖNERİLERİ (Öncelik Sırası)

### ✅ Tamamlananlar (2026-05-04)
1. **K-03:** `http://` → `https://` ✅
2. **K-02:** Token expiry 30g → 15dk (3+1 konum) ✅
3. **O-02:** DioClient refresh ayrı instance ✅
4. **K-01 (kısmi):** `invite_code_screen.dart` 1 konum → `ListView.builder` ✅

### Kalan İşler
5. **K-01:** 3 konum ListView → `ListView.builder` (`add_building_screen.dart`, `invite_code_screen.dart:304`, `invite_code_result_view.dart:38`)
6. **O-01:** `small` font 15sp → 16sp (1 satır)

### Araçlarla Doğrulama
```bash
# Tüm ListView kullanımlarını bul
grep -r "ListView(" lib/ --include="*.dart"

# 16sp altı font kullanımlarını bul
grep -r "fontSize:\s*1[0-5]" lib/ --include="*.dart"

# HTTP kullanımlarını bul
grep -r "http://" lib/ --include="*.dart"
```

---

## 📈 UYUMLULUK METRİKLERİ

| Metrik | Hedef | Mevcut | Skor |
|--------|-------|--------|------|
| Font erişilebilirlik | %100 ≥16sp | %90 (1 eksik) | 🟡 9/10 |
| Türkçe UI | %100 | %100 | 🟢 10/10 |
| Türkçe Locale (tr_TR) | Aktif | Aktif | 🟢 10/10 ✅ |
| ListView optimizasyonu | %100 builder | %40 (2/5) | � 4/10 |
| Token expiry doğruluğu | %100 | %100 (15dk) | � 10/10 ✅ |
| Güvenlik (HTTPS) | %100 | %100 | 🟢 10/10 ✅ |
| DioClient Refresh | Ayrı instance | Ayrı instance | 🟢 10/10 ✅ |
| Android Manifest | Full config | Full config | � 10/10 ✅ |
| Buton boyutları | %100 | %100 | 🟢 10/10 |
| textScaleFactor | Kısıtlanmamalı | Kısıtlanmamış | 🟢 10/10 |

**Ağırlıklı Ortalama:** %92 (Güvenlik kritikleri kapatıldı, sadece ListView ve kk font kaldı)

---

## 🔗 İLGİLİ DOSYALAR

| Dosya | Amaç |
|-------|------|
| `AGENTS.md` | Uyumluluk standartları |
| `OPTIMIZATIONS.md` | Performans bulguları (F-01 overlap) |
| `SECURITY_AUDIT.md` | Güvenlik bulguları (S-01, S-03 overlap) |
| `AIDATPANEL_GAP_ANALIZI.md` | Gap tespiti (G01-G04 overlap) |

---

##  REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-04 | İlk denetim: AGENTS.md 18 kuralından 14'ü uygun, 4 kritik düzeltme gerekli |
| v1.1 | 2026-05-04 | YOL_HARITASI v3.0 referansı eklendi |
| **v1.2** | **2026-05-04** | **Kod senkronizasyonu:** K-02 (Token 15dk), K-03 (HTTPS), O-02 (DioClient refresh) KAPATILDI. Skor %75 → %92. Kalan: K-01 (3 konum ListView), O-01 (15sp font). |

---

** SONRAKİ ADIM:** Kalan 3 ListView konumunu `ListView.builder`'a çevir + `small` font 16sp.
