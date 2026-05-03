# GOREVDAGILIMI - DETAYLI ANALİZ RAPORU

**Kaynak Dosya:** `planning/GOREVDAGILIMI.md`  
**Analiz Tarihi:** 2026-05-03  
**Versiyon:** 1.0  
**Analiz Tipi:** Proje Yol Haritası + Ekip Yapısı + Risk Değerlendirmesi  
**Durum:** ✅ Analiz tamam + İyileştirilmiş yol haritası üretildi

---

## 📋 KAYNAK BELGE ÖZETİ

**Tür:** Proje yol haritası (planning document)  
**Uzunluk:** 96 satır  
**Kapsam:** 3 fazlı MVP geliştirme planı + 4 kişilik ekip + teknik standartlar  
**Mevcut Durum:** "Beklemede 🟡" (v1.0.0)

### Belge Yapısı
| Bölüm | İçerik |
|-------|--------|
| **Ekip ve Roller** | Abdullah (Lead) > Furkan (Senior) > Yusuf (Junior) > Seyit (Junior) |
| **Faz 1 (MVP-1)** | Temel Altyapı + Auth |
| **Faz 2 (MVP-2)** | Aidat Sistemi + Onboarding |
| **Faz 3 (Final)** | Giderler, Destek, Raporlama |
| **Teknik Standartlar** | Code review, Git, 50+ yaş UI, Türkçe hata mesajları |

---

## 🎯 BELGE DEĞERLENDİRMESİ

### ✅ Güçlü Yönler

#### 1. Net Rol Tanımları
- Her ekip üyesinin odak noktası tek satırla belirtilmiş
- Hiyerarşi açık: Abdullah > Furkan > Yusuf > Seyit
- Lead → Senior → Junior gradasyonu

#### 2. Faz Bazlı İlerleme
- 3 fazlı incremental delivery (MVP-1, MVP-2, Final)
- Her fazın hedefi tek cümlede özetlenmiş
- Risk yönetimi açısından doğru yaklaşım (büyük riski 3'e böl)

#### 3. Yetenek Bazlı Görev Dağılımı
- Junior'lara senior dependency ile kritik olmayan modüller
- Senior'a (Furkan) Flutter core'da otonom modüller
- Lead'e (Abdullah) backend mimari ve entegrasyonlar

#### 4. 50+ Yaş Tasarım Kısıtları
- Min 16sp font, 48dp dokunma alanı, BottomNav zorunluluğu
- Hedef kitle perspektifi açık şekilde belirtilmiş

#### 5. Türkçe Hata Yönetimi Kuralı
- "Teknik jargondan arındırılmış" ifadesi → kullanıcı odaklılık

---

### ⚠️ Belge Eksiklikleri

| # | Alan | Risk Seviyesi | Etki |
|---|------|---------------|------|
| 1 | **Zaman çizelgesi yok** | 🔴 Yüksek | Faz tamamlanma tahmini imkansız, deadline yönetimi zor |
| 2 | **Definition of Done yok** | 🔴 Yüksek | "Tamamlandı" subjektif, faz geçişi belirsiz |
| 3 | **Risk matrisi yok** | 🔴 Yüksek | Furkan bus factor riski açık ama dokümante değil |
| 4 | **Sync meeting protokolü yok** | 🟡 Orta | İletişim freq./format belirsiz, blocker'lar geç fark edilir |
| 5 | **Knowledge transfer planı yok** | 🟡 Orta | Junior'lar Senior bilgisinden yararlanamayabilir |
| 6 | **Branch naming detayı eksik** | 🟡 Orta | Örnek var (`feature/furkan-tickets`) ama kural yok |
| 7 | **Merge stratejisi tanımsız** | 🟢 Düşük | Rebase vs merge commit netleşmemiş |
| 8 | **Teknik borç takibi yok** | 🟢 Düşük | Faz sonu cleanup planı belirsiz |
| 9 | **Bağımlılık haritası yok** | 🟡 Orta | Faz1→Faz2 bağımlılıkları implicit |
| 10 | **Onboarding planı yok** | 🟢 Düşük | Yeni üye gelirse nasıl başlayacak? |

---

## 🚨 KRİTİK RİSK: FURKAN'IN YÜKÜ

### Workload Tahmini (Belgede Yok, Görev İçeriklerinden Hesaplandı)

| Faz | Abdullah | **Furkan** | Yusuf | Seyit |
|-----|----------|-----------|-------|-------|
| Faz 1 | %30 | %35 | %20 | %15 |
| Faz 2 | %25 | **%40** | %20 | %15 |
| Faz 3 | %25 | **%35** | %25 | %15 |

### Risk Tespiti
- ⚠️ **Furkan Faz 2'de en yüksek workload (%40)**
- ⚠️ **Yönetici (Manager) odaklı tüm modüller Furkan'da** → bus factor 1
- ⚠️ **Junior'lar (Yusuf/Seyit) Flutter deneyimi sınırlı** → Furkan unavailable olursa Manager Hub bloklanır
- ⚠️ **Abdullah backend odaklı** → Flutter'da yedek değil

### Bus Factor Analizi
| Modül | Sorumlu | Yedek? | Risk |
|-------|---------|--------|------|
| Auth UI | Furkan | Yusuf (kısmen) | Düşük |
| Manager Hub | Furkan | YOK | **Çok Yüksek** |
| Davet kodu UI | Furkan | YOK | **Çok Yüksek** |
| Aidat durum UI | Furkan | YOK | **Çok Yüksek** |
| Ticket sistemi | Furkan | YOK | **Yüksek** |

---

## 📊 EKİP YETENEK MATRİSİ

| Üye | Backend | Flutter | UI/UX | DevOps | Toplam |
|-----|---------|---------|-------|--------|--------|
| Abdullah (Lead) | ⭐⭐⭐ | ⭐ | ⭐ | ⭐⭐⭐ | 8 |
| **Furkan (Senior)** | ⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐ | 7 |
| Yusuf (Junior) | ⭐⭐ | ⭐ | ⭐ | ⭐ | 5 |
| Seyit (Junior) | ⭐ | ⭐ | ⭐⭐⭐ | ⭐ | 6 |

### Yetenek Boşlukları
- 🔴 **Flutter Senior:** Sadece Furkan (yedek yok)
- 🟡 **Backend Lead:** Sadece Abdullah (Yusuf yarı-yedek)
- 🟢 **UI/UX:** Seyit + Furkan'ın yardımı (sağlıklı)
- 🔴 **DevOps:** Sadece Abdullah (yedek yok)

---

## 🛠️ TEKNİK STANDART ANALİZİ

### Code Review Kuralı: "Abdullah tüm MR'ları onaylar"
- ✅ **Avantaj:** Lead seviyesi kalite kontrolü
- ⚠️ **Risk:** Abdullah bottleneck (özellikle vacation/hastalık dönemlerinde)
- ⚠️ **Yetki Mismatch:** Furkan Senior ama MR onay yetkisi yok
- 💡 **Öneri:** Senior çapraz review (Furkan ↔ Abdullah)

### Git Workflow: "Herkes kendi branch'inde"
- ✅ Feature branch yaklaşımı sağlıklı
- ❌ **Eksik:** Branch naming kuralı resmi değil (sadece örnek)
- ❌ **Eksik:** Merge stratejisi (rebase vs merge commit) belirsiz
- ❌ **Eksik:** Direct push to main politikası belirtilmemiş
- 💡 **Öneri:** `feature/{name}-{task}` zorunluluğu + main protected

### 50+ Yaş Tasarım Kısıtı
| Kural | Değer | Uygulama |
|-------|-------|----------|
| Min font | 16sp | ✅ Kabul edilebilir |
| Min touch | 48dp | ✅ Material Design uyumlu |
| Navigation | BottomNav zorunlu | ✅ Hamburger zihinsel yük olabilir 50+ için |

**Eksik:** Erişilebilirlik düzeyleri (WCAG AA mı AAA mı?), kontrast oranı, dyslexia-friendly font?

### Hata Mesajları: "Türkçe + jargon yok"
- ✅ Doğru hedef
- ❌ **Eksik:** Hata mesajı şablonu/örnekleri yok
- 💡 **Öneri:** "✅ Aidat Ekle" / "❌ Add Due" gibi örnek seti

---

## 🔗 FAZLAR ARASI BAĞIMLILIKLAR (Belgede Yok, Çıkarıldı)

```
Faz 1 → Faz 2: Auth + Building API (Furkan, Yusuf için zorunlu)
Faz 1 → Faz 2: UI Kit (Seyit'ten Furkan/Yusuf'a)
Faz 2 → Faz 3: Aidat sistemi (Yusuf gider raporlaması için)
Faz 2 → Faz 3: Manager Hub (Furkan ticket UI için)
```

### Paralelleşme Fırsatları
| Paralel Çift | Mümkün mü? | Açıklama |
|--------------|------------|----------|
| Seyit UI Kit + Furkan Mobile | ✅ Evet | UI kit hazırlanırken mobile başlayabilir |
| Yusuf API + Abdullah Backend | ✅ Evet | Endpoint'ler bağımsız geliştirilebilir |
| Furkan Faz 1 + Abdullah Faz 2 prep | ⚠️ Kısmen | Faz 1 son haftalarında Faz 2 prep |

---

## 📈 BELGE KALİTE SKORU

| Kriter | Skor | Açıklama |
|--------|------|----------|
| Rol Netliği | 9/10 | Net hiyerarşi + odak noktaları |
| Faz Yapısı | 8/10 | 3 fazlı incremental yaklaşım |
| Görev Dağılımı | 8/10 | Yetenek-uyumlu, ama workload yok |
| Zaman Yönetimi | 2/10 | Timeline yok, deadline yok |
| Risk Yönetimi | 1/10 | Tamamen yok |
| İletişim Protokolü | 3/10 | Sync meeting tanımsız |
| Definition of Done | 2/10 | Belirsiz |
| Teknik Standartlar | 7/10 | Var ama detay eksik |
| Knowledge Transfer | 0/10 | Hiç yok |
| **Ortalama** | **4.4/10** | **Orta - güçlü yapı, kritik eksikler kapatılmalı** |

---

## 💡 İYİLEŞTİRME UYGULAMASI

`GOREVDAGILIMI_GELISTIRILMIS.md` dosyasında şu eklemeler yapıldı:

| # | Eklenen | Çözdüğü Sorun |
|---|---------|----------------|
| 1 | **Detaylı timeline** (faz başına hafta) | Zaman çizelgesi eksikliği |
| 2 | **Definition of Done** (her faz için) | "Tamamlandı" subjektifliği |
| 3 | **Risk matrisi + mitigation** | Bus factor + Furkan riski |
| 4 | **Knowledge transfer planı** | Junior'lara mentorluk eksikliği |
| 5 | **Sync meeting protokolü** | İletişim freq./format |
| 6 | **Branch naming + merge stratejisi** | Git workflow detayı |
| 7 | **Teknik borç takibi** | Faz sonu cleanup |
| 8 | **Bağımlılık haritası** | Implicit bağımlılıklar |
| 9 | **Hata mesajı örnekleri** | Türkçe UI standardı |
| 10 | **Onboarding planı** | Yeni üye senaryosu |

---

## 🎯 KRİTİK BAŞARI FAKTÖRLERİ

| # | Faktör | Uygulama |
|---|--------|----------|
| 1 | **Bus factor azaltma** | ✅ Knowledge transfer planı eklendi |
| 2 | **Zaman yönetimi** | ✅ Faz başına haftalık plan eklendi |
| 3 | **DoD netliği** | ✅ Her faz için checklist eklendi |
| 4 | **Risk görünürlüğü** | ✅ Risk matrisi + mitigation eklendi |
| 5 | **Junior gelişimi** | ✅ Her faz için pairing planı |
| 6 | **Furkan yükü** | ✅ Yedekleme + dokümantasyon zorunluluğu |

---

## 🔄 BAKIM PROTOKOLÜ

### Revizyon Tetikleyicileri
- Faz tamamlanması (lessons learned eklemek)
- Ekip değişikliği (yeni üye/ayrılan)
- Major teknik karar değişikliği (stack güncellemesi vb.)
- Risk gerçekleşmesi (bus factor olayı vs.)
- Aylık genel review

### Versiyonlama
- **Major (x.0):** Faz yapısı değişikliği, ekip değişikliği
- **Minor (1.x):** Yeni standart, yeni risk eklenmesi
- **Patch (1.0.x):** Metin düzeltme, tarih güncelleme

---

## 📁 KLASÖR İÇERİĞİ

| Dosya | Amaç | Versiyon |
|-------|------|----------|
| `ANALIZ_RAPORU.md` | Detaylı analiz + risk değerlendirmesi (bu dosya) | v1.0 |
| `RAPOR_OZETI.md` | Executive summary | v1.0 |
| `GOREVDAGILIMI_GELISTIRILMIS.md` | İyileştirilmiş yol haritası (kullanıma hazır) | v2.0 |

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-03 | Sıfırdan temiz yapım: belge analizi + risk değerlendirmesi + iyileştirilmiş yol haritası üretimi |

---

**Analiz Tamamlandı:** 2026-05-03  
**Klasör:** `analiz_raporlari/3-gorevdagilimi_analizi/`  
**Durum:** ✅ İyileştirilmiş yol haritası üretildi, ekip kullanımına hazır.
