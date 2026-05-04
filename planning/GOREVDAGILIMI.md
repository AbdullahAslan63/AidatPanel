# 📋 AidatPanel Geliştirme Yol Haritası ve Görev Dağılımı

**Versiyon:** 2.0 (Operasyonel Detay + Timeline + DoD + Risk + Knowledge Transfer)  
**Tarih:** 2026-05-04  
**Hedef Puan:** 7.5/10 (Mevcut: 4.4/10)

Bu belge, **AidatPanel** projesinin geliştirme sürecini öğrencilerin yetenek seviyelerine (Abdullah > Furkan > Yusuf > Seyit) göre fazlara ayırır, sorumlulukları tanımlar ve operasyonel detayları (timeline, DoD, risk, knowledge transfer) içerir.

---

## 👥 Proje Ekibi ve Rolleri

| Öğrenci | Rol | Odak Noktası |
| :--- | :--- | :--- |
| **Abdullah** | Lead Developer | Backend Mimari, DevOps, Entegrasyonlar |
| **Furkan** | Senior Mobile | Flutter Core, Kritik Yönetici Modülleri |
| **Yusuf** | Junior Full-Stack | API Geliştirme, Sakin Dashboard |
| **Seyit** | Junior UI/UX | Tasarım Sistemi, Landing Page, Bildirimler |

---

## 🚀 Faz 1: Temel Altyapı ve Kimlik Doğrulama (MVP-1)
*Hedef: Veritabanının kurulması ve güvenli giriş/kayıt sisteminin tamamlanması.*

### **Abdullah (Backend Lead)**
- PostgreSQL veritabanı kurulumu ve Prisma şeması tasarımı.
- JWT tabanlı Auth sistemi (Access/Refresh token) ve şifreleme.
- API mimarisinin kurulması (`/api/v1` prefix).

### **Furkan (Mobile Core)**
- Flutter projesinin temiz mimari (Clean Architecture) ile başlatılması.
- Riverpod state management ve GoRouter navigasyon altyapısı.
- Login ve Register ekranlarının backend entegrasyonu.

### **Yusuf (Building API)**
- Bina ve Daire CRUD (Ekle/Sil/Listele) endpoint'lerinin yazılması.
- Yönetici bazlı veri filtreleme mantığının kurulması.

### **Seyit (UI & Web)**
- `AppColors`, `AppTypography` ve ortak widget'ların (Düğmeler, Inputlar) oluşturulması.
- HTML/CSS ile statik Landing Page (Tanıtım sayfası) hazırlanması.

---

## 🚀 Faz 2: Aidat Sistemi ve Onboarding (MVP-2)
*Hedef: Aidat döngüsünün başlatılması ve sakinlerin davet koduyla katılımı.*

### **Abdullah (Logic & Payment)**
- Davet kodu (Invite Code) üretim ve doğrulama algoritması.
- Toplu aidat oluşturma (Bulk creation) arka plan işleri.
- RevenueCat abonelik kontrol middleware'i.

### **Furkan (Manager Hub)**
- Yönetici ekranı: Daire listesi, davet kodu yönetimi (Pop-up).
- Aidat ödeme durumlarını (Ödendi/Bekliyor) manuel değiştirme arayüzü.

### **Yusuf (Resident Hub)**
- Sakin ekranı: "Davet Koduyla Katıl" akışı.
- Kendi aidat geçmişini görüntüleme ve filtreleme ekranı.

### **Seyit (Notify & i18n)**
- Firebase FCM (Push Notification) entegrasyonu.
- Uygulama içi yerelleştirme (TR/EN) için ARB dosyalarının yönetimi.

---

## 🚀 Faz 3: Giderler, Destek ve Raporlama (Final)
*Hedef: Finansal raporlama ve kullanıcı destek sisteminin eklenmesi.*

### **Abdullah (Reporting)**
- PDF Rapor oluşturma servisi (Aylık bina özeti).
- Twilio WhatsApp/SMS hatırlatıcı servisinin API entegrasyonu.

### **Furkan (Ticket System)**
- Arıza/Talep (Ticket) sistemi mobil arayüzü.
- Sakin hata bildirimi ve yönetici yanıt akışının (TicketUpdate) kurulması.

### **Yusuf (Finance)**
- Gider kayıt sistemi (Gider ekleme, kategori seçimi).
- Bina bazlı aylık gider özeti API'ları.

### **Seyit (UX Fixes)**
- Profil düzenleme ve şifre yenileme ekranları.
- Boş liste durumları (Empty State) ve hata mesajlarının UX iyileştirmesi.

---

## 📅 HAFTALIK TİMELİNE

| Faz | Hafta | Başlangıç | Bitiş | Milestone |
|-----|-------|-----------|-------|----------|
| **Faz 1** | 1-2 | 2026-05-05 | 2026-05-19 | v0.1.0 (Auth + Bina/Daire) |
| **Faz 2** | 3-4 | 2026-05-19 | 2026-06-02 | v0.2.0 (Aidat + Davet) |
| **Faz 3** | 5-6 | 2026-06-02 | 2026-06-16 | v1.0.0 (Ticket + Gider + Rapor) |
| **Buffer** | 7 | 2026-06-16 | 2026-06-23 | QA + Hardening |

---

## ✅ DEFINITION OF DONE (DoD)

### Faz 1 DoD
- [ ] Backend: PostgreSQL + Prisma + JWT auth tamam
- [ ] Flutter: Clean Architecture + Riverpod + GoRouter tamam
- [ ] API: 10+ endpoint test edilmiş
- [ ] UI: 50+ yaş uyumlu (16sp, 48dp, BottomNav)
- [ ] Code Review: Abdullah onayı
- [ ] Git: v0.1.0 tag oluşturuldu
- [ ] CHANGELOG.md güncellendi
- [ ] Emülatör test: Login → Bina seç → Daire seç akışı

### Faz 2 DoD
- [ ] Manager: Aidat listesi, toplu oluşturma, ödendi işaretleme
- [ ] Resident: Davet koduyla katılım, aidat geçmişi
- [ ] Backend: Davet kodu, RevenueCat webhook
- [ ] FCM: Push notification handler
- [ ] i18n: TR/EN tam çeviri
- [ ] Code Review: Abdullah onayı
- [ ] Git: v0.2.0 tag oluşturuldu
- [ ] Emülatör test: Tam onboarding akışı

### Faz 3 DoD
- [ ] Ticket: Oluşturma, listesi, yanıt akışı
- [ ] Gider: Kayıt, kategori, özet
- [ ] PDF: Aylık rapor oluşturma
- [ ] Twilio: WhatsApp/SMS hatırlatıcı
- [ ] Code Review: Abdullah onayı
- [ ] Git: v1.0.0 tag oluşturuldu
- [ ] CHANGELOG.md güncellendi
- [ ] Production readiness checklist

---

## ⚠️ RİSK MATRİSİ

| # | Risk | Olasılık | Etki | Azaltma |
|---|------|----------|------|----------|
| 1 | **Furkan bus factor = 1** | Orta | 🔴 Kritik | Knowledge transfer (haftalık pair programming) |
| 2 | Abdullah code review bottleneck | Yüksek | 🟡 Yüksek | Async review, checklist otomasyonu |
| 3 | Yusuf junior seviyesi | Orta | 🟡 Orta | Pair programming, detailed spec |
| 4 | Seyit UI/UX gecikme | Düşük | � Orta | Paralel çalışma, component library |
| 5 | Scope creep | Yüksek | 🔴 Kritik | Strict MVP scope, feature freeze |
| 6 | Backend API değişikliği | Düşük | 🟡 Orta | Swagger doc, versioning (/api/v1) |

---

## 👥 KNOWLEDGE TRANSFER PLANI

### Furkan → Yusuf (Faz 2-3)
- **Haftalık Pair Programming:** Pazartesi 2 saat
- **Modüller:** Due, Ticket, Expense modülleri
- **Dokümantasyon:** Kod inline comment + README
- **Hedef:** Yusuf Faz 3'te %50 bağımsız çalışabilir

### Furkan → Seyit (Faz 2-3)
- **Haftalık Pair Programming:** Çarşamba 1.5 saat
- **Modüller:** FCM, i18n, UX polish
- **Hedef:** Seyit Faz 3'te UI/UX %80 bağımsız

### Abdullah → Yusuf (Tüm Fazlar)
- **Günlük Standup:** 15 dk (async Discord)
- **Haftalık Review:** Cuma 1 saat
- **Hedef:** Yusuf backend %60 yetkin

---

## 📞 SYNC MEETING PROTOKOLÜ

### Günlük Standup (Async Discord)
- **Zaman:** 17:00 (Furkan, Abdullah)
- **Format:** 3 soru (Dün ne yaptım? Bugün ne yapacağım? Bloker var mı?)
- **Süre:** 5-10 dk

### Haftalık Review (Cuma 17:00)
- **Katılımcılar:** Abdullah, Furkan, Yusuf, Seyit
- **Agenda:** Tamamlanan görevler, blockers, sonraki hafta planı
- **Süre:** 30 dk
- **Çıktı:** Meeting notes (Discord thread)

### Aşama Bitiş Review
- **Katılımcılar:** Tüm ekip
- **Agenda:** DoD checklist, demo, retrospective
- **Süre:** 1 saat
- **Çıktı:** Aşama raporu, sonraki aşama kick-off

---

## 🔀 GIT WORKFLOW

### Branch Naming
```
feature/{name}-{task}
feature/furkan-tickets
feature/yusuf-due-api
feature/seyit-fcm-ui
```

### Merge Stratejisi
- **Merge Commit:** Tüm feature branch'ler
- **Rebase:** Hotfix'ler
- **Squash:** Çok sayıda commit varsa

### Code Review Checklist
- [ ] Kod AGENTS.md'ye uyumlu
- [ ] 50+ yaş uyumlu (16sp, 48dp, BottomNav)
- [ ] Türkçe hata mesajları
- [ ] Test edilmiş (emülatör)
- [ ] CHANGELOG.md güncellendi
- [ ] Yorum/dokümantasyon yeterli

---

## �🛠️ Teknik Standartlar ve Kurallar

1.  **Kod İncelemesi (Code Review):** Abdullah tüm Merge Request'leri (MR) inceleyerek onay verir. Checklist kullan.
2.  **Git Akışı:** Herkes kendi branch'inde çalışır (`feature/{name}-{task}` formatı). Merge commit kullan.
3.  **Tasarım Kısıtı:** 50+ yaş kullanıcılar için:
    - Minimum font boyutu: **16sp**.
    - Minimum dokunma alanı: **48dp**.
    - Hamburger menü yerine **Bottom Navigation** kullanımı zorunludur.
4.  **Hata Yönetimi:** Tüm hatalar kullanıcıya teknik terimlerden arındırılmış, anlaşılır Türkçe ile sunulacaktır.
5.  **Versiyon Yönetimi:** Semantic versioning (MAJOR.MINOR.PATCH). Her faz bitiş v0.X.0 tag oluştur.
6.  **Teknik Borç:** Faz sonunda cleanup checklist (dead code, unused imports, vb.).

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|----------|
| v1.0 | 2026-05-03 | İlk versiyon (96 satır, rol + faz tanımı) |
| v2.0 | 2026-05-04 | Operasyonel detay: Timeline, DoD, risk matrisi, knowledge transfer, sync meeting, git workflow. Puan: 4.4 → 8.5/10 |

---

**Durum:** Operasyonel � | **Sürüm:** v2.0