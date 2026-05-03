# 📋 AidatPanel - Ekip Standartları ve Çalışma Protokolü

**Versiyon:** 3.0 (Sadeleştirilmiş — `YOL_HARITASI.md` ile hizalanmış)  
**Son Güncelleme:** 2026-05-04  
**Source of Truth (timeline + aşama planı):** **`YOL_HARITASI.md` v2.0**

---

## ⚠️ ÖNEMLİ: BU BELGE NEDİR, NE DEĞİLDİR

### ✅ Bu belge (kalıcı standartlar)
- Ekip rolleri, bus factor analizi
- Git akışı, PR kuralları, code review süreci
- Sync meeting protokolü (günlük standup, haftalık review, faz sonu review)
- Knowledge transfer planı (junior yetiştirme)
- Teknik standartlar (50+ yaş UI, hata mesajları, Türkçe dil kuralları)
- DoD şablonu (her aşama için kullanılacak)
- Onboarding planı (yeni üye senaryosu)
- Başarı metrikleri
- Teknik borç takip kuralları

### ❌ Bu belge değildir
- ❌ Aşama planı / timeline (`YOL_HARITASI.md`'de)
- ❌ Somut sprint görev listesi (`YOL_HARITASI.md`'de)
- ❌ Gap tespiti (`AIDATPANEL_GAP_ANALIZI.md`'de)

**Detay plan için:** `YOL_HARITASI.md` v2.0 → Aşama 0-6

---

## 👥 1. EKİP YAPISI VE ROLLER

### Üye Matrisi

| Üye | Rol | Ana Sorumluluk | Bus Factor Riski |
|-----|-----|----------------|------------------|
| **Abdullah** | Lead Developer / CTO | Backend (Node.js/Prisma), mimari kararlar, PR onayı | 🟢 Düşük (dokümante ediyor) |
| **Furkan** | Senior Mobile | Flutter Core, tüm feature modülleri, release | 🔴 **YÜKSEK** (tek sorumlu) |
| **Yusuf** | Junior Full-Stack | Backend API desteği, basit endpoint'ler | 🟡 Orta (eğitiliyor) |
| **Seyit** | Junior UI/UX | UI kit, bildirim ekranları, i18n | 🟡 Orta (eğitiliyor) |

### Sorumluluk Dağılımı

#### Abdullah (Lead)
- Backend tüm sorumluluk: Prisma migration, endpoint, webhook, deployment
- Tüm PR'ların 1. review'u
- Mimari kararlar (yeni paket ekleme, şema değişikliği)
- Release/tag onayı

#### Furkan (Senior Mobile)
- Flutter tüm feature modülleri (auth, buildings, dues, tickets, vb.)
- 50+ yaş UI kurallarının uygulanması
- RevenueCat, FCM entegrasyonu
- Junior'lara pair programming (knowledge transfer)

#### Yusuf (Junior Full-Stack)
- Backend: basit endpoint'ler, input validation, Joi/Zod schema
- Furkan'dan Flutter pair programming (haftalık)
- Unit test yazımı (Aşama 5+)

#### Seyit (Junior UI/UX)
- UI kit bileşenleri (button, card, badge, dialog)
- i18n (TR/EN ARB)
- Notification UI ekranları
- Shimmer skeleton loading'ler

---

## 🔴 2. BUS FACTOR RİSK ANALİZİ

### Risk: Furkan = Tek Flutter Sorumlusu

**Olasılık:** Orta | **Etki:** 🔴 Kritik

**Azaltma Stratejileri:**
1. **Haftalık pair programming** (her Salı 14:00–16:00)
   - Furkan bir feature'ı junior'la birlikte kodlar
   - Junior sürücü, Furkan yönlendirici
2. **Kritik bilgi dokümantasyonu**
   - `docs/ARCHITECTURE.md` — Clean Architecture uygulama detayları
   - `docs/DEPLOYMENT.md` — Release süreci
   - `docs/PACKAGE_RATIONALES.md` — Paket seçim gerekçeleri
3. **PR üzerinden knowledge share**
   - Her PR'a "Reviewer Notes" bölümü (öğrenilenler)
4. **Furkan devamsızlık planı**
   - 1-3 gün: Yusuf/Seyit küçük bug fix'ler
   - 1+ hafta: Abdullah Flutter'a geçici destek
5. **Rotasyonlu feature ownership** (Faz 3'ten itibaren)
   - Bir modül tamamen Yusuf'a verilsin (örnek: Expenses)

---

## 🔄 3. GIT AKIŞI VE BRANCH STRATEJİSİ

### Branch Yapısı
- **`main`** — production, protected, sadece squash merge
- **`develop`** — entegrasyon branch'i, feature'lar buradan alınır
- **`feature/{isim}-{gorev}`** — zorunlu format
  - Örnek: `feature/furkan-dues-data-layer`, `feature/yusuf-expenses-api`
- **`hotfix/{description}`** — acil production düzeltmesi

### Merge Stratejisi
- **Squash and merge** zorunlu (clean history)
- Merge commit message: `feat(module): kısa açıklama (#PR-no)`
- Branch merge sonrası otomatik silinir

### PR Kuralları
| Kural | Değer |
|-------|-------|
| PR boyutu | **<500 satır** değişiklik (büyükse parçala) |
| PR açıklaması | Zorunlu: ne, neden, nasıl test edildi |
| Ekran görüntüsü | UI değişikliği varsa zorunlu |
| CI kontrolü | `flutter analyze` 0 issue + `flutter test` yeşil |
| Review süresi | Abdullah **24 saat içinde** review |

### PR Şablonu
```markdown
## 🎯 Ne Yapıldı?
[Özet]

## 🔍 Neden?
[Problem / gereksinim]

## 🧪 Nasıl Test Edildi?
- [ ] Manuel emülatör testi (emulator-5554)
- [ ] `flutter analyze`
- [ ] `flutter test` (eğer test yazıldıysa)
- [ ] Edge case'ler: [liste]

## 📸 Ekran Görüntüsü
[Varsa]

## 🔗 İlgili
- Gap ID: [GXX] (eğer `AIDATPANEL_GAP_ANALIZI.md`'de varsa)
- Aşama: [YOL_HARITASI.md §X.Y]
```

### Code Review Süreci
1. PR aç → CI yeşil olmalı (`flutter analyze`, `flutter test`, lint)
2. **1. review:** Abdullah (tüm PR'lar)
3. **2. review:** Furkan (Flutter PR'ları için 2. göz, ≥200 satır ise)
4. Onay sonrası squash merge
5. Branch sil

---

## 🗓️ 4. SYNC MEETING PROTOKOLÜ

### Günlük Standup (Async, Discord #standup kanalı)
- **Zaman:** 09:00'a kadar mesaj atılmış olmalı
- **Format:**
  ```
  📆 [Tarih]
  ✅ Dün: [ne bitirildi]
  🎯 Bugün: [ne yapılacak]
  🚧 Blocker: [varsa]
  ```

### Haftalık Review (Cuma 17:00, 60 dk)
- **Kanal:** Discord voice veya Google Meet
- **Format:**
  - Hafta hedefleri retrospect (15 dk)
  - Demo (yeni özellikler, 20 dk)
  - Sonraki hafta planlaması (15 dk)
  - Açık tartışma / risk review (10 dk)

### Aşama Sonu Review (Her git tag sonrası, 90 dk)
- **Format:**
  - DoD checklist kontrol (30 dk)
  - Lessons learned (20 dk)
  - Sonraki aşama timeline ayarlaması (20 dk)
  - Risk matrisi güncelleme (20 dk)
- **Sorumlu:** Abdullah facilitator

### Async İletişim Kanalları
| Kanal | Amaç |
|-------|------|
| Discord #standup | Günlük durum |
| Discord #general | Hızlı sorular, blocker |
| Discord #random | Mola sohbetleri (Genshin/Valorant) |
| GitHub Issues | Bug raporu, feature talebi |
| PR Comments | Code-related tartışma |

---

## 🎓 5. KNOWLEDGE TRANSFER PLANI

### Haftalık Pair Programming (Salı 14:00–16:00)

| Hafta | Oturum | Mentor | Öğrenci |
|-------|--------|--------|---------|
| 1 | Clean Architecture (data layer) | Furkan | Yusuf |
| 2 | Riverpod state management | Furkan | Yusuf |
| 3 | UI kit + widget composition | Furkan | Seyit |
| 4 | GoRouter + deep links | Furkan | Seyit |
| 5 | Dio interceptors + error handling | Furkan | Yusuf |
| 6 | Form validation + UX patterns | Furkan | Seyit |
| 7+ | Rotasyon (ihtiyaca göre) | - | - |

### Furkan → Junior Aktarım Süreci
1. **Canlı ders** (1 saat) — konsept + whiteboard
2. **Pair coding** (1 saat) — junior sürücü, Furkan gözlemci
3. **Solo task** — junior haftaya kendi başına benzer görev
4. **Code review** — Furkan detaylı yorumla geri dönüş

### Dokümantasyon Beklentisi
Her junior, öğrendiği konuyu **`docs/learning-notes/`** altına kısa not olarak yazar. Bir hafta içinde merge edilir.

---

## 📐 6. TEKNİK STANDARTLAR

### 6.1 50+ Yaş UI Kuralları (Sıkı)

| Kural | Değer | Test |
|-------|-------|------|
| Min font | 16sp | `grep -r "fontSize: [0-9]" lib/` tarama |
| Primary buton | 56dp | `minimumSize: Size(.., 56)` |
| Dokunma alanı | 48x48dp min | Semantics + Size check |
| Kontrast | WCAG AA ≥ 4.5:1 | Figma kontrast tool |
| Font | Nunito zorunlu | `pubspec.yaml` |
| `textScaleFactor` | ASLA kısıtlanmayacak | `MediaQuery.of(context).textScaleFactor` override yok |
| Navigation | BottomNav zorunlu | `Drawer`/`Scaffold.drawer` YASAK |
| Tab | İkon + yazı birlikte | `BottomNavigationBarItem(label:)` dolu |
| Animasyon | Max 200ms | Lottie/Hero/bounce YASAK |

### 6.2 Türkçe UI Dil Kuralları

**✅ Doğru:**
- "Aidat Ekle", "Ödendi İşaretle", "Geri Dön"
- "Telefon numarası hatalı", "Emin misiniz?"

**❌ Yasak:**
- "Add Due", "Mark as Paid" (İngilizce)
- "Error 422: Validation failed" (teknik)
- "dashboard", "sync", "toggle", "payload", "cache" (teknik jargon UI'da)

### 6.3 Hata Mesajı Şablonu

**Format:**
- ✅ Başarı: "Aidat başarıyla oluşturuldu."
- ❌ Hata: "Bir hata oluştu. [Kullanıcı eylemi]" (örn: "Bir hata oluştu. Lütfen tekrar deneyin.")
- ⚠️ Uyarı: "Bu işlemi geri alamazsınız."

**Yasak:**
- ❌ "Error 500", "Internal server error"
- ❌ "Null pointer exception"
- ❌ İngilizce teknik mesajlar

### 6.4 Onay Dialog (Geri Dönülemez İşlemler)

Her silme, ödendi işaretleme, toplu işlemde **zorunlu**:
- Başlık: "Emin misiniz?"
- İçerik: Sonucu net açıkla (örn: "Bu daireyi silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.")
- Butonlar: "İptal" (secondary) + "Sil/Onayla" (error rengi)

---

## ✅ 7. DEFINITION OF DONE ŞABLONU

Her aşama için `YOL_HARITASI.md`'deki DoD listesi uygulanır. Ek olarak **tüm aşamalar için ortak kriterler**:

### Ortak DoD (Her Aşama İçin)
- [ ] `flutter analyze` 0 issue
- [ ] Manuel test yapıldı (emulator-5554)
- [ ] `flutter analyze` 0 issue
- [ ] PR açıldı → Abdullah review → merge (squash)
- [ ] `CHANGELOG.md` güncellendi
- [ ] Git tag açıldı (vX.Y.Z) — ilgili aşamanın `YOL_HARITASI.md`'deki hedef versiyonu
- [ ] `AIDATPANEL_GAP_ANALIZI.md`'de ilgili gap → ✅ işaretlendi
- [ ] Aşama sonu review yapıldı (90 dk)

### Feature-Specific DoD
`YOL_HARITASI.md` → Her aşamanın kendi "Definition of Done" bölümüne bak.

---

## 📈 8. PERFORMANCE BUDGET (Her PR'da Kontrol)

### Mobile
| Metrik | Hedef | Nasıl Ölçülür |
|--------|-------|---------------|
| Cold start | <3 saniye | Stopwatch |
| Frame rate | 60 FPS stabil | Flutter DevTools Performance |
| APK boyutu | <30 MB | `flutter build apk --release` |
| İlk ekran render | <1 saniye | Performance overlay |

### Backend
| Metrik | Hedef | Nasıl Ölçülür |
|--------|-------|---------------|
| Ortalama yanıt | <200ms | pm2 logs + Postman |
| P95 yanıt | <500ms | Load test |
| Memory | <512MB | PM2 monitor |

---

## 📥 9. ONBOARDING PLANI (Yeni Üye)

### Hafta 1: Tanışma ve Setup
- [ ] Repo clone + branch (`git clone` + `git checkout develop`)
- [ ] Dependencies kurulumu (`flutter pub get`, `npm install`)
- [ ] Firebase config (emülatör çalıştırma)
- [ ] Backend local setup (PostgreSQL + `.env`)
- [ ] İlk PR: küçük tipoja/log düzeltmesi (süreç pratiği)

### Hafta 2: Dokümantasyon Turu
- [ ] `planning/AIDATPANEL.md` (master reference) oku
- [ ] `YOL_HARITASI.md` (sprint planı) oku
- [ ] `AIDATPANEL_GAP_ANALIZI.md` (gap'ler) oku
- [ ] `HATA_ANALIZ_RAPORU.md` (bilinen sorunlar) oku
- [ ] Bu dosya (ekip standartları) oku

### Hafta 3: Küçük Feature
- [ ] Bir bug fix veya küçük UI iyileştirmesi
- [ ] Pair programming Furkan ile
- [ ] Review sürecini tam yaşa

### Hafta 4: Bağımsız Feature
- [ ] Bir aşama alt-görevi sahiplen
- [ ] Solo geliştirme + PR
- [ ] Review + merge

---

## 📊 10. BAŞARI METRİKLERİ

### Teknik
- ✅ `flutter analyze` 0 issue (her PR'da)
- ✅ Test coverage Aşama 5 sonu **≥ %30**
- ✅ Cold start < 3s
- ✅ API P95 < 500ms

### Süreç
- ✅ PR review süresi **≤ 24 saat** (Abdullah)
- ✅ PR boyutu **< 500 satır**
- ✅ Aşama DoD %100 (git tag şartı)
- ✅ Her 2 haftada bir junior'a pair programming

### İş
- ✅ Faz 2 (v0.4.0) — 2026-06-09'a kadar
- ✅ Faz 3 (v1.0.0-rc1) — 2026-07-07'ye kadar
- ✅ v1.0.0 release — 2026-07-14'e kadar

---

## 🏗️ 11. TEKNİK BORÇ TAKİBİ

### Bilinen Teknik Borçlar (Aşama 0 öncesi)
Tüm borçlar `HATA_ANALIZ_RAPORU.md` + `AIDATPANEL_GAP_ANALIZI.md`'de listelenmiş (G01-G17).

### Teknik Borç Ekleme Kuralı
Bir geliştirici hızlı çözüm için shortcut alırsa **ZORUNLU**:
1. `// TODO(tech-debt): [açıklama] — YOL_HARITASI.md Aşama X'te düzeltilecek`
2. `AIDATPANEL_GAP_ANALIZI.md`'ye yeni gap olarak ekle (yeni ID: G18+)
3. PR description'da belirt

### Teknik Borç Review
Her haftalık review'da açık TODO'lar taranır, "bu hafta kapanacak mı?" kararı verilir.

---

## 🔗 12. İLGİLİ DOSYALAR

| Dosya | Amaç |
|-------|------|
| **`YOL_HARITASI.md` v2.0** | **Aşama planı, timeline, feature DoD** |
| `AIDATPANEL_GAP_ANALIZI.md` | Gap tespiti ve takip |
| `planning/AIDATPANEL.md` | Master reference |
| `HATA_ANALIZ_RAPORU.md` | Detaylı hata tespiti |
| `planning/MASTER_PROMPTU.md` | AI Co-Founder kişilik prompt'u |
| `analiz_raporlari/2-agents_promptu_analizi/AGENTS.md` | AI agent rehberi |
| `analiz_raporlari/1-master_prompt_analizi/FURKAN_AI_COFUNDER_MASTER_PROMPT.md` | Furkan profil prompt'u |

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | (kaynak) | `planning/GOREVDAGILIMI.md` — 96 satırlık ilk yol haritası |
| v2.0 | 2026-05-03 | Geliştirilmiş versiyon: timeline + DoD + risk matrisi + knowledge transfer + sync protokolü + Git akışı + onboarding + başarı metrikleri (437 satır) |
| **v3.0** | **2026-05-04** | **Sadeleştirildi:** aşama planı ve timeline çıkarıldı (şimdi `YOL_HARITASI.md`'de). Sadece kalıcı standartlar kaldı: ekip yapısı, Git akışı, sync protokol, knowledge transfer, teknik standartlar, DoD şablonu, onboarding, başarı metrikleri, teknik borç takibi. Duplikasyon riski sıfırlandı. |

---

**🔗 Detaylı aşama planı için:** `YOL_HARITASI.md` v2.0 — Aşama 0 (Acil Güvenlik) başlatılabilir.
