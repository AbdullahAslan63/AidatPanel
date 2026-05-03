# AGENTS PROMPTU - DETAYLI ANALİZ RAPORU

**Kaynak Dosya:** `planning/AGENTS_PROMPTU.md`  
**Analiz Tarihi:** 2026-05-03  
**Versiyon:** 1.0  
**Analiz Tipi:** Meta-Prompt + AidatPanel için AGENTS.md Üretimi  
**Durum:** ✅ Analiz tamam + AGENTS.md üretildi

---

## 📋 KAYNAK PROMPT ÖZETİ

**Tür:** Meta-prompt (AGENTS.md üreten talimat seti)  
**Uzunluk:** 72 satır (orijinal İngilizce)  
**Hedef Kitle:** AI coding agent'lar  
**Çekirdek Felsefe:** **Signal Density** (Sinyal Yoğunluğu)

### Temel Direktifler
| # | Direktif | Detay |
|---|----------|-------|
| 1 | **Ana Hedef** | Completeness değil, **SIGNAL DENSITY** |
| 2 | **4 Kriter** | Project-specific + Non-obvious + Action-guiding + Mistake-preventing |
| 3 | **Format** | Hard constraints (must/must not), bullet ağırlıklı, kısa Markdown |
| 4 | **Yasak İçerik** | Generic best practices, README tekrarı, tooling ile zaten yakalananlar |
| 5 | **Output Kuralı** | Sadece AGENTS.md içeriği - yorum, analiz, preface YASAK |
| 6 | **Rewrite Modu** | Eski içeriği agresif şekilde temizle + kısalt |

---

## 🎯 META-PROMPT DEĞERLENDİRMESİ

### ✅ Güçlü Yönler

#### 1. Signal Density Felsefesi
> "Your primary goal is NOT completeness. Your primary goal is SIGNAL DENSITY."

- Geleneksel "ne kadar çok bilgi o kadar iyi" yaklaşımına karşı
- Her kelime = maliyet (token + okuma süresi + dikkat)
- Minimal ama kritik yapıyı dayatıyor

#### 2. 4'lü Filtre Sistemi
Her madde 4 kriterden **en az birini** geçmeli:
1. **Project-specific:** AidatPanel'e özgü mü? (Generic → çıkar)
2. **Non-obvious:** Kod/README'den hemen anlaşılır mı? (Obvious → çıkar)
3. **Action-guiding:** Eylem yönlendirici mi? (Vague → çıkar)
4. **Mistake-preventing:** Gerçek bir hatayı önlüyor mu? (Nice-to-know → çıkar)

#### 3. Hard Constraints Vurgusu
> "Prefer 'must / must not' rules over vague recommendations"

- Belirsizliğe yer yok
- "Şunu yapmayı düşün" değil, "Şunu yapma"

#### 4. Deduplication Disiplini
- README/onboarding/style guide TEKRARI YOK
- Tooling (linter/formatter/CI) zaten yakalıyorsa YOK
- Generic tavsiyeler (clean code, error handling) YOK

#### 5. Quality Bar Self-Check
Çıktıdan önce 5 kontrol:
- Her bullet proje-özel veya gerçek hata önleyici mi?
- Generic kalmadı mı?
- Tekrar var mı?
- Operasyonel checklist gibi mi okunuyor?
- Anında uygulanabilir mi?

#### 6. Aggressive Rewrite Modu
Mevcut AGENTS.md varsa:
- Düşük değerli/generic içeriği agresif şekilde sil
- Vague dili eylem kuralına çevir
- Aman vermeden kısalt

---

### ⚠️ Belirsiz / Eksik Alanlar

| # | Alan | Durum | Risk |
|---|------|-------|------|
| 1 | **Proje context girdi yöntemi** | Belirsiz | AI projeyi nasıl analiz edecek? Önce keşif lazım |
| 2 | **"Real mistake" tanımı** | Subjektif | Hangi hatalar dokümante edilecek? |
| 3 | **Maksimum uzunluk** | Belirtilmemiş | "Shortest possible" göreceli |
| 4 | **Versiyon yönetimi** | Eksik | AGENTS.md güncellendiğinde nasıl track? |
| 5 | **Onay süreci** | Tanımsız | Üretilen içerik kim onaylayacak? |
| 6 | **Proje seviyesi farkları** | Yok | Solo dev vs ekip projesi farkı yok |

---

## 🛠️ AIDATPANEL İÇİN UYGULAMA STRATEJİSİ

### Adım 1: Proje Context Toplama (Tamamlandı)
AidatPanel'e özgü bilgiler 7 ana kaynaktan toplandı:

| Kaynak | Çıkarılan Bilgi |
|--------|-----------------|
| `analiz_raporlari/4-aidatpanel_analizi/` | Stack, mimari, design system, API endpoint'leri |
| `analiz_raporlari/3-gorevdagilimi_analizi/` | Ekip rolleri, branch naming, MR review kuralı |
| `HATA_ANALIZ_RAPORU.md` | 15 kritik hata + Kotlin daemon, intl uyumsuzluğu |
| Memory: Furkan kullanım stili | Versiyon onayı, checkpoint'li ilerleme |
| Memory: AidatPanel teknik mimari | 50+ yaş UI kısıtları, Türkçe UI politikası |
| Memory: Optimizasyon prensipleri | ListView.builder zorunluluğu, performance budget |
| Memory: Güvenlik audit | HTTPS zorunluluğu, token expiry mismatch |

### Adım 2: Signal Density Filtreleme

#### ✅ AGENTS.md'ye GİREN (proje-özel + non-obvious)
- Türkçe UI politikası (jargon yasak)
- 50+ yaş tasarım kısıtları (16sp/48dp/56dp)
- BottomNav zorunlu / Hamburger YASAK
- pubspec.yaml versiyon formatı `0.0.8+1` (sıkça unutuluyor)
- Kotlin daemon çökmeleri (Windows-spesifik gotcha)
- intl 0.20.2 ↔ Flutter 3.11.5 uyumsuzluğu
- ListView.builder zorunluluğu (50+ liste için)
- HTTPS zorunluluğu (HTTP traplara karşı)
- Branch naming `feature/{name}-{task}`
- Versiyon değişikliği için Furkan onayı
- run_command'de Cwd parametresi (cd değil)

#### ❌ AGENTS.md'ye GİRMEYEN (generic/obvious)
- "Clean code yaz" (generic)
- "Test yaz" (generic)
- Riverpod kullan (pubspec.yaml'dan obvious)
- Flutter projesi (proje yapısından obvious)
- Linter kuralları (`flutter analyze` zaten yakalar)

### Adım 3: Quality Bar Kontrolü
Her bullet için son kontrol uygulandı:
- ✅ Generic içerik temizlendi
- ✅ Tekrar elimine edildi
- ✅ Vague dil eylem kuralına çevrildi
- ✅ "Must/must not" formatı uygulandı
- ✅ Operasyonel checklist hissi sağlandı

---

## 📊 META-PROMPT KALİTE SKORU

| Kriter | Skor | Açıklama |
|--------|------|----------|
| Felsefe netliği | 10/10 | Signal Density açıkça tanımlı |
| Filtre kriterleri | 9/10 | 4 kriter güçlü, ölçülebilir |
| Format zorlaması | 9/10 | Markdown + bullet + must/must not |
| Yasak içerik listesi | 9/10 | Net şekilde belirlenmiş |
| Output disiplini | 10/10 | "ONLY content, no preface" çok güçlü |
| Proje context yöntemi | 4/10 | AI proje analizini nasıl yapacak belirsiz |
| Doğrulama | 6/10 | Self-check var ama dış validasyon yok |
| Versiyon yönetimi | 3/10 | Tanımsız |
| **Ortalama** | **7.5/10** | **İyi - güçlü çekirdek, çevre eksikleri kapatılabilir** |

---

## 🎯 SIGNAL DENSITY UYGULAMA SONUÇLARI

### AidatPanel AGENTS.md Metrikleri
| Metrik | Değer |
|--------|-------|
| **Toplam Madde** | ~25 hard constraint |
| **Bölüm Sayısı** | 6 (preferred structure) |
| **Tahmini Token** | ~800-1000 |
| **Generic Madde** | 0 |
| **Project-specific Oran** | %100 |
| **Non-obvious Oran** | ~%90 |

### Ölçek Karşılaştırması
| Yaklaşım | Token | Etki |
|----------|-------|------|
| Generic AGENTS.md (200 madde) | ~5000 | Düşük (gürültü) |
| Yarı-jenerik (50 madde) | ~2000 | Orta |
| **Signal Density (~25 madde)** | **~1000** | **Yüksek (sinyal)** |

---

## 💡 KRİTİK BAŞARI FAKTÖRLERİ

| # | Faktör | Uygulama |
|---|--------|----------|
| 1 | **Minimalizm** | ✅ Sadece ~25 hard constraint |
| 2 | **Project-specific** | ✅ Her madde AidatPanel'e özgü |
| 3 | **Non-obvious** | ✅ Generic best practice yok |
| 4 | **Action-guiding** | ✅ Tüm maddeler "must/must not" |
| 5 | **Mistake-preventing** | ✅ HATA_ANALIZ'tan beslendi |
| 6 | **Maintainable** | ✅ Versiyon + revizyon geçmişi |

---

## 🔄 BAKIM PROTOKOLÜ

### Revizyon Tetikleyicileri
- Stack değişikliği (paket güncelleme, yeni servis)
- Yeni gotcha keşfi (yeni Windows/Flutter sorunu)
- Yeni bağımsız ekip kuralı (örn: yeni branch naming)
- HATA_ANALIZ'dan tekrarlayan hata pattern'i
- Yeni 50+ yaş UI kuralı

### Versiyonlama
- **Major (x.0):** Bölüm ekleme/çıkarma
- **Minor (1.x):** Yeni constraint ekleme
- **Patch (1.0.x):** Metin düzeltme

### Review Periyodu
- **Aylık:** Genel review
- **Her major release sonrası:** Stack değişikliği kontrolü
- **Her HATA_ANALIZ güncellemesi sonrası:** Yeni gotcha tarama

---

## 📁 KLASÖR İÇERİĞİ

| Dosya | Amaç | Versiyon |
|-------|------|----------|
| `ANALIZ_RAPORU.md` | Detaylı meta-prompt analizi (bu dosya) | v1.0 |
| `RAPOR_OZETI.md` | Executive summary | v1.0 |
| `AGENTS.md` | AidatPanel için üretilmiş nihai çıktı (kullanıma hazır) | v1.0 |

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-03 | Sıfırdan temiz yapım: meta-prompt analizi + AidatPanel için AGENTS.md üretimi |

---

**Analiz Tamamlandı:** 2026-05-03  
**Klasör:** `analiz_raporlari/2-agents_promptu_analizi/`  
**Durum:** ✅ AGENTS.md üretildi, kullanıma hazır. Aylık review tetikleyicisi kuruldu.
