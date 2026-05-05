# AidatPanel Changelog

> Tüm önemli değişiklikler bu dosyada kaydedilir.
> Format: [TİP] Açıklama - #commit_id @tarih_saat

---

## 🏷️ v0.0.1-dev - 2026-05-06 @00:50:00

### 🚀 Yeni Özellikler
- `[FEAT]` **Davet Kodu Sistemi tamamlandı** - Faz 1 %100 ✅
  - `POST /api/v1/auth/join` - Davet koduyla sakin kaydı
  - `POST /api/v1/apartments/:id/invite-code` - Davet kodu üretme
  - `validateInviteCode` fonksiyonu aktifleştirildi
  - Kod formatı: `APXXX-XXX-XXX` (7 gün geçerli, tek kullanımlık)

### 📊 Rapor Güncellemeleri
- `[REPORT]` Analiz raporları güncellendi - **Faz 1: %100** tamamlandı 🎉
- `[REPORT]` Davet Kodu Sistemi: 2/2 endpoint tamamlandı

### 📝 Teknik Detaylar
- **Commit:** Beklemede
- **Branch:** backend/yedek
- **Değişiklikler:**
  - `backend/src/controllers/inviteCodeController.js` - validateInviteCode aktifleştirildi
  - `backend/src/controllers/authControllers.js` - join fonksiyonu eklendi
  - `backend/src/routes/authRoutes.js` - /join route'u aktifleştirildi
  - `backend/index.js` - inviteCodeRoutes eklendi
  - `ENDPOINTS_LISTESİ.md` - Yeni endpoint'ler dokumente edildi

**Tagler:** `#backend` `#davet_kodu` `#faz1` `#tamamlandı` `#join` `#sakin`

---

## 🏷️ v0.0.1-dev - 2026-05-06 @00:11:00

### 🚀 Yeni Özellikler
- `[FEAT]` ENDPOINTS_LISTESİ.md oluşturuldu - Tüm aktif endpoint'ler ve req.body parametreleri dokumente edildi - @2026-05-06

### 📊 Rapor Güncellemeleri
- `[REPORT]` Analiz raporları otomatik güncellendi - Faz 1: %83 tamamlandı - @2026-05-06

### 📝 Teknik Detaylar
- **Commit:** `7ece11727b39d96ba5558d62d54e59a6bf1ac346`
- **Branch:** backend/yedek
- **Değişiklikler:**
  - `CHANGELOG.md` - Yeni eklendi
  - `ENDPOINTS_LISTESİ.md` - Yeni eklendi
  - `analiz_raporlari/*` - Raporlar senkronize edildi

**Tagler:** `#backend` `#endpoints` `#dokumentasyon` `#faz1`

---

## 🏷️ v0.0.1-dev - 2026-05-06 @00:16:00

### 📊 Rapor Güncellemeleri
- `[REPORT]` Otomatik rapor kontrolü - Tüm raporlar güncel, değişiklik yok - Faz 1: %83

### 🔧 Altyapı
- `[INFRA]` Git remote URL güncellendi: `mahmutoktay/AidatPanel`

### 📝 Teknik Detaylar
- **Commit:** `7ece11727b39d96ba5558d62d54e59a6bf1ac346` (önceki)
- **Branch:** backend/yedek
- **Komut:** `raporla ve push et` - Raporlar zaten güncel

**Tagler:** `#raporlama` `#kontrol` `#faz1` `#git`

---

## 🏷️ v0.0.1-dev - 2026-05-05 @17:18:33

### 🚀 Yeni Özellikler
- `[FEAT]` Otomatik rapor güncelleme sistemi kuruldu
- `[FEAT]` AGENTS.md oluşturuldu - AI agent talimatları
- `[FEAT]` Davet kodu controller ve route dosyaları eklendi

### 📊 Rapor Güncellemeleri
- `[REPORT]` Tüm analiz raporları güncellendi - Faz 1: %83 tamamlandı

### 📚 Dokümantasyon
- `[DOCS]` scripts/README.md - Otomatik sistem kullanım kılavuzu
- `[DOCS]` backend/README.md - Rapor güncelleme komutları eklendi

### 📝 Teknik Detaylar
- **Commit:** `9ad71a5e28e35492c69da7b838f9999603ad2f8f`
- **Branch:** backend/yedek
- **Dosyalar:** 12 değişiklik, 1194 ekleme(+), 10 silme(-)

**Tagler:** `#backend` `#raporlama` `#otomasyon` `#agents_md` `#faz1` `#davet_kodu`

---

## 🏷️ v0.0.1-dev - Önceki

### 🚀 Başlangıç
- `[INIT]` Proje altyapısı kuruldu
- `[INIT]` PostgreSQL + Prisma entegrasyonu
- `[INIT]` JWT auth sistemi (register, login, refresh, logout)
- `[INIT]` Building CRUD (5 endpoint)
- `[INIT]` Apartment CRUD (4 endpoint)

**Tagler:** `#init` `#backend` `#auth` `#building` `#apartment`

---

## 📋 Etiket Açıklamaları

| Etiket | Anlamı |
|--------|--------|
| `FEAT` | Yeni özellik |
| `FIX` | Bug fix |
| `DOCS` | Dokümantasyon |
| `REFACTOR` | Kod refactor |
| `PERF` | Performans iyileştirmesi |
| `REPORT` | Rapor güncellemesi |
| `TEST` | Test ekleme/güncelleme |

## 🎯 Faz Durumları

| Faz | Durum | Yüzde |
|-----|-------|-------|
| Faz 1 (Temel Altyapı) | **Tamamlandı** ✅ | **%100** |
| Faz 2 (Aidat/Onboard) | Devam ediyor | %50 |
| Faz 3 (Gider/Rapor) | Başlanacak | %0 |
