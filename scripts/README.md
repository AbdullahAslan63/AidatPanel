# AidatPanel Analiz Rapor Güncelleme Sistemi

Backend kodunu otomatik analiz ederek analiz raporlarındaki ilerleme durumunu günceller.

## Özellikler

- **Otomatik Endpoint Tespiti:** Controller ve route dosyalarını tarar
- **Faz İlerleme Takibi:** Faz 1/2/3 tamamlanma yüzdelerini hesaplar
- **Durum Belirleme:** Her özelliği `completed` / `in-progress` / `not-started` olarak sınıflandırır
- **Rapor Güncelleme:** Tüm analiz raporlarını otomatik günceller
- **Dry-run Modu:** Değişiklikleri önce önizleme imkanı

## Kullanım

### Dry-run (Önizleme)
Değişiklikleri önce kontrol edin:
```bash
cd backend
npm run update-reports
```

### Gerçek Güncelleme
Raporları güncelleyin:
```bash
cd backend
npm run update-reports -- --write
```

### Sadece Durum Göster
Sadece mevcut durumu görüntüleyin, raporları değiştirmeden:
```bash
cd backend
npm run update-reports -- --status
```

## Çalışma Prensibi

1. **Backend Analizi**
   - `src/controllers/` dizinindeki dosyaları analiz eder
   - Export edilen fonksiyonları tespit eder
   - Yorumda olan fonksiyonları (`/* ... */`) belirler

2. **Durum Hesaplama**
   - Tüm endpoint'ler var → `completed`
   - Bazı endpoint'ler var/yorumda → `in-progress`
   - Hiç endpoint yok → `not-started`

3. **Rapor Güncelleme**
   - `1-master_prompt_analizi/1-ANALIZ_RAPORU.md`
   - `3-gorevdagilimi_analizi/1-ANALIZ_RAPORU.md`
   - `4-aidatpanel_analizi/1-ANALIZ_RAPORU.md`

## Örnek Çıktı

```
════════════════════════════════════════════════════════════
  AidatPanel - Analiz Rapor Güncelleme
════════════════════════════════════════════════════════════

▸ Backend Kod Analizi
--------------------------------------------------
Controller Dosyaları: 4
Route Dosyaları: 4

Tamamlanan Özellikler:
  ✅ Bina Yönetimi
  ✅ Daire Yönetimi

Devam Eden Özellikler:
  🔄 Kimlik Doğrulama Sistemi (4/4)
     └─ Yorumda: join
  🔄 Davet Kodu Sistemi (1/2)
     └─ Yorumda: validateInviteCode

Başlanmamış Özellikler:
  ⏳ Aidat Sistemi
  ⏳ Gider Sistemi
  ⏳ Arıza/Talep Sistemi

▸ Faz İlerleme Durumu
--------------------------------------------------
Faz 1 (Temel Altyapı)  [████████████████░░░░] 83%
Faz 2 (Aidat/Onboard)  [█████░░░░░░░░░░░░░░░] 25%
Faz 3 (Gider/Rapor)    [░░░░░░░░░░░░░░░░░░░░] 0%

▸ Rapor Güncellemeleri
--------------------------------------------------
Güncelleniyor: Master Prompt Analizi... Güncellendi ✓
Güncelleniyor: Görev Dağılımı... Güncellendi ✓
Güncelleniyor: AidatPanel Master... Güncellendi ✓
```

## Dosya Yapısı

```
scripts/
├── update-reports.js           # Ana script
├── README.md                   # Bu dosya
└── analyzers/
    ├── backend-analyzer.js     # Backend kod analizi
    └── report-writer.js        # Markdown güncelleme
```

## Özellik Eşleştirme

| Özellik | Controller | Route |
|---------|-----------|-------|
| Auth | authControllers.js | authRoutes.js |
| Bina Yönetimi | buildingController.js | buildingRoutes.js |
| Daire Yönetimi | apartmentController.js | apartmentRoutes.js |
| Davet Kodu | inviteCodeController.js | inviteCodeRoutes.js |
| Aidat | dueController.js | dueRoutes.js |
| Gider | expenseController.js | expenseRoutes.js |
| Arıza/Talep | ticketController.js | ticketRoutes.js |

## Notlar

- Yorumda olan fonksiyonlar (`/* funcName = async ... */`) devam ediyor kabul edilir
- Faz 1 için auth sistemi: register, login, refresh, logout tamamlandığında `completed` sayılır (join Faz 2'ye ait)
- Her yeni endpoint eklediğinizde otomatik olarak raporlar güncellenir
