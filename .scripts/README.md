# .scripts — AidatPanel Script'leri

Bu klasör, **AidatPanel projesine özel otomasyon script'leri** içerir.

---

## 📁 Dosyalar

| Dosya | Amaç |
|-------|------|
| `update_reports.ps1` | Her push'tan önce çalışır. Git diff analiz eder, değişen dosyalara göre **9 analiz raporunu** otomatik senkronize eder. |
| `auto_l10n.py` | Yeni eklenen Dart dosyalarındaki hardcoded Türkçe string'lerini extract eder, İngilizce'ye çevirir ve JSON dosyalarına ekler. |
| `build_release_apk.ps1` | Release APK build script'i. |

---

## 🚀 Kullanım

### update_reports.ps1

**Terminal'den çalıştır:**
```powershell
# 1. Terminal'i aç
# 2. .scripts klasörüne git

cd .scripts
.\update_reports.ps1

# Veya parametrelerle:
.\update_reports.ps1 -CommitMessage "fix: route guard eklendi"
.\update_reports.ps1 -DryRun              # Sadece analiz et, değiştirme
.\update_reports.ps1 -SkipChangelog       # CHANGELOG'u atla
```

**Furkan'ın Özel Komutları ile:**
Windsurf chat panelinde:
```
push et
```
> AI otomatik olarak `update_reports.ps1` çalıştırır, raporları günceller, commit eder, push eder.

### auto_l10n.py

**Kullanım:**
```bash
cd mobile
python ../.scripts/auto_l10n.py
```

**Özellikler:**
- Hardcoded string extract (regex ile)
- Key generate (camelCase, Türkçe karakter çevirisi)
- JSON'a ekle (common namespace altına)
- Kod değişikliği (context.t ile değiştir, import ekle)
- Slang çalıştır

**Sınırlamalar:**
- Manuel çeviri gerekli (placeholder kullanıyor)
- Test için tek dosya yöntemi

### build_release_apk.ps1

**Kullanım:**
```bash
cd mobile
powershell ../.scripts/build_release_apk.ps1
```

---

## 🔧 update_reports.ps1 Nasıl Çalışır?

### Adım 1: Git Diff Analizi
Script, son commit ile şimdiki durum arasındaki farkı alır:
```powershell
git diff --cached --name-only   # Staged dosyalar
git diff --name-only            # Unstaged dosyalar
git diff-tree --name-only HEAD  # Son commit'teki dosyalar
```

### Adım 2: Dosya → Sorun Eşleştirmesi

Değişen her kod dosyası, **önceden tanımlı mapping tablosu** ile hangi sorunları kapatacağını bilir.

| Değişen Dosya | Kapatılan Sorun(lar) | Rapor(lar) |
|---------------|---------------------|------------|
| `auth_provider.dart` | K-01, Y-03 | FAZ2, HATA, GAP, AGENTS |
| `dio_client.dart` | Y-02, O-02, F-04, G03 | FAZ2, GAP, SECURITY, OPTIMIZATIONS |
| `api_constants.dart` | G01, G09 | GAP, SECURITY, HATA |
| `app_router.dart` | K-03 | FAZ2, AGENTS, SECURITY |
| `resident_dashboard_screen.dart` | K-08, Y-04 | FAZ2, AGENTS |
| ... | ... | ... |

**Toplam 17 kod dosyası** ve **20+ sorun mapping'i** tanımlı.

### Adım 3: Rapor Güncelleme

Her eşleşen sorun için:
1. Rapor dosyasını aç
2. Sorun ID'sini ara (örn: `K-01`, `G04`, `F-04`)
3. Durumunu bul: `❌ Açık` veya `🟡 Devam Ediyor`
4. Değiştir: `✅ KAPATILDI — 2026-05-04 20:45`
5. Dosyayı kaydet

### Adım 4: CHANGELOG Entry (Opsiyonel)

`CHANGELOG.md`'ye otomatik entry ekler:
```markdown
### 🔄 Otomatik Rapor Senkronizasyonu (2026-05-04)
**Kapatılan Sorunlar:**
- K-03: Route guard (GoRouter redirect)
- K-08: Resident hardcoded PII
```

---

## 📊 Kapsanan Raporlar (9)

1. `FAZ2_ONCESI_MUKEMMELLESME_RAPORU.md`
2. `HATA_ANALIZ_RAPORU.md`
3. `AGENTS_COMPLIANCE_AUDIT.md`
4. `AIDATPANEL_GAP_ANALIZI.md`
5. `OPTIMIZATIONS.md`
6. `SECURITY_AUDIT.md`
7. `YOL_HARITASI.md`
8. `CHANGELOG.md`
9. `RAPOR_OZETI_GENEL.md`

---

## ⚙️ update_reports.ps1 Parametreleri

| Parametre | Tip | Açıklama |
|-----------|-----|----------|
| `-CommitMessage` | string | Commit mesajı (opsiyonel) |
| `-DryRun` | switch | Sadece analiz et, dosyaları değiştirme |
| `-SkipChangelog` | switch | CHANGELOG.md'yi güncelleme |

---

## 🛡️ Güvenlik

- **update_reports.ps1** sadece markdown dosyalarını değiştirir (`*.md`)
- Kod dosyalarına (`*.dart`) dokunmaz
- Her çalıştırmada backup alınmaz (gerekirse eklenir)
- Dry-run modu ile önce test edin

---

## 📝 Script Geliştirme

Yeni script eklerken:
1. Bu README.md'yi güncelle
2. Script'i bu klasöre taşı
3. Kullanım talimatlarını ekle
4. Sınırlamaları belirt

Yeni bir mapping eklemek istersen (update_reports.ps1 için):

```powershell
# update_reports.ps1 icinde $FileToIssues hashtable'ina ekle:
"mobile/lib/yeni_dosya.dart" = @(
    @{ ID = "Y-99"; Title = "Yeni sorun"; Reports = @("FAZ2","HATA") }
)
```

---

## Script'leri Çalıştırma Öncesi

Her script'i çalıştırmadan önce:
- Git commit yap (değişiklikleri kaydet)
- Script'in ne yaptığını kontrol et
- Backup al

---

**Son güncelleme:** 2026-05-06  
**Versiyon:** 3.0 (Birleştirilmiş README - Script'ler + Rapor Güncelleme)
