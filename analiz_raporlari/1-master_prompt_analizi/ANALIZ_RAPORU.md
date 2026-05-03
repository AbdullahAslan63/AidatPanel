# MASTER PROMPTU - DETAYLI ANALİZ RAPORU

**Kaynak Dosya:** `planning/MASTER_PROMPTU.md`  
**Analiz Tarihi:** 2026-05-03  
**Versiyon:** 1.0  
**Analiz Eden:** AI Co-Founder  
**Durum:** ✅ Analiz Tamamlandı + Furkan Profili Üretildi

---

## 📋 KAYNAK PROMPT ÖZETİ

**Tür:** Meta-prompt (prompt üreten prompt)  
**Uzunluk:** 12 satır  
**Amaç:** Kişiselleştirilmiş "AI Co-Founder" sistem promptu üretmek için kullanıcıyı Reverse Engineering yöntemiyle analiz etmek.

### Prompt'un Temel Direktifleri
| # | Direktif | Detay |
|---|----------|-------|
| 1 | **Görev Tanımı** | Hayatın her alanında destek olacak, derinlemesine anlayan, stratejik AI Co-Founder sistem promptu tasarla |
| 2 | **Yöntem** | Reverse Engineering (Tersine Mühendislik) |
| 3 | **Soru Kuralı** | Tek seferde max 2 soru (uzun liste yasak) |
| 4 | **Süreç** | Sor → Cevap al → Kullanıcı modelini güncelle → Tekrar |
| 5 | **Bitiş** | "Yeterince veri" toplanınca nihai copy-paste prompt üret |

---

## 🎯 META-PROMPT DEĞERLENDİRMESİ

### ✅ Güçlü Yönler

#### 1. İteratif Bilgi Toplama Stratejisi
```
Soru (max 2) → Cevap → Model güncelle → Tekrar
```
- **Bilişsel yük dağıtımı:** Tek seferde 20 soru yerine 2'şerli gruplar
- **Derin cevaplar:** Az soru = fazla düşünme alanı
- **Adaptif akış:** Her cevap bir sonraki soruyu şekillendirir

#### 2. Reverse Engineering Yaklaşımı
- Kullanıcıya "sen nasılsın?" sormak yerine davranış desenlerinden çıkarım yapıyor
- Veri odaklı kişiselleştirme (yüzeysel değil derin profil)
- Kör nokta keşfi (kullanıcının farkında olmadığı pattern'ler)

#### 3. Stratejik Derinlik Vurgusu
- "Hayatın her alanı" ifadesi → holistik yaklaşım (sadece iş değil)
- "Sürdürülebilir ve stratejik düşünen" → kısa vadeli değil, uzun vadeli
- "Üst düzey AI Co-Founder" → asistan değil, stratejik ortak

#### 4. Copy-Paste Hazır Çıktı
- "Copy-paste yapabileceğim" ifadesi → direkt kullanılabilir format
- Başka AI sistemlerine (Claude/GPT/Gemini) transfer edilebilir
- Taşınabilirlik sağlanmış

---

### ⚠️ Belirsiz / Eksik Alanlar

| # | Alan | Durum | Risk |
|---|------|-------|------|
| 1 | **Kullanıcı modeli yapısı** | Belirsiz | Hangi boyutlar kapsanmalı? Tutarsız profil üretilebilir |
| 2 | **Soru kategorileri** | Tanımsız | Hangi alanlarda derinleşilmeli? |
| 3 | **Yeterlilik kriteri** | Subjektif ("yeterince veri") | Ne zaman bitmeli? Erken/geç bitme riski |
| 4 | **Çıktı format şablonu** | Belirtilmemiş | AI'ya göre farklı yapılar üretilebilir |
| 5 | **Güncelleme mekanizması** | Eksik | Prompt statik mi, yaşayan belge mi? |
| 6 | **Hata yönetimi** | Eksik | Kullanıcı cevap vermezse/belirsiz cevap verirse ne olur? |
| 7 | **Doğrulama** | Eksik | Üretilen prompt kullanıcıya sunulup onay alınıyor mu? |

---

## 🧠 ÖNERİLEN 6 BOYUTLU KULLANICI MODELİ

Meta-prompt'ta yapı belirtilmediği için şu çerçeve önerildi ve Furkan için uygulandı:

```yaml
KullaniciModeli:
  1_ZamanEnerji:
    tercih: [sabah/gece/esnek]
    seansUzunlugu: [uzun/kısa/değişken]
    flowYonetimi: [kesintisiz/checkpoint'li]
    resetMekanizmasi: [açıklama]

  2_ProblemCozme:
    yaklasim: [analiz/deneme/hibrit]
    riskAlgisi: [düşük/orta/yüksek]
    kalıteStandarti: [yeterli/mükemmeliyetçi]
    kararKaynagi: [iç ses/danışma/hibrit]

  3_OgrenmeBilgi:
    girisYontemi: [video/yazı/deneme]
    basariKriteri: [demo/production-ready/anlatma]
    organizasyon: [notlar/raporlar/mental]
    tracking: [yok/az/orta/yoğun]

  4_EkipIletisim:
    rol: [lider/takipçi/eşit]
    feedbackReaksiyonu: [savunma/anlama/düzeltme]
    mentorluk: [detaylı/overview/yok]
    iletisimTercihi: [doğrudan/dolaylı/karma]

  5_VizyonMotivasyon:
    projeAnlami: [para/başarı/öğrenme/vizyon]
    yeterlilikAlgisi: [yeterli/daha iyi]
    uzunVadeHedef: [tanımlı/esnek]
    basariTanimi: [metrik/his/karma]

  6_TeknikTercihler:
    stack: []        # Dil/framework/kütüphane
    araclar: []      # IDE, CI/CD, debugging
    ortam: []        # OS, shell, hardware
    kisitlamalar: [] # Bilinen sorunlar, uyumsuzluklar
```

---

## 📋 ÖNERİLEN RÖPORTAJ PROTOKOLÜ

### Soru Kategorileri (5 Ana Başlık)
| # | Kategori | Örnek Sorular |
|---|----------|---------------|
| 1 | **Çalışma Ritmi** | En verimli saatler? Flow state yönetimi? Yorgunluk sinyalleri? |
| 2 | **Problem Çözme** | Analiz mi deneme mi? Risk toleransın? Kalite standardın? |
| 3 | **Öğrenme** | Yeni konuya nasıl girişirsin? Bir şeyi "öğrendim" ne zaman dersin? |
| 4 | **Ekip Dinamiği** | Lider mi takipçi mi? Feedback nasıl alırsın? Mentorluğu nasıl yaparsın? |
| 5 | **Vizyon** | Projelerinin anlamı? 5 yıllık hedef? Başarıyı nasıl tanımlarsın? |

### Yeterlilik Kriterleri
- ✅ 6 boyutun her birinde **en az 1-2 güçlü sinyal** toplandı
- ✅ Çelişen cevaplar birleştirildi/netleştirildi
- ✅ Kullanıcı kendi profilini "bu benim" olarak onayladı
- ✅ Tekrar eden pattern'ler tespit edildi (sadece anlık cevap değil)

### Süreç (Tahmini)
| Döngü | Soru | Süre | Çıktı |
|-------|------|------|-------|
| 1 | 2 | 5-10 dk | İlk taslak model |
| 2 | 2 | 5-10 dk | Boyut doldurma |
| 3 | 2 | 5-10 dk | Derinleştirme |
| 4-6 | 2'şer | 15-30 dk | Rafinaj + doğrulama |
| **Toplam** | **8-12** | **30-60 dk** | **Nihai Master Prompt** |

---

## 📄 ÇIKTI PROMPT ŞABLONU

Meta-prompt'ta format verilmediği için şu şablon kullanıldı:

```markdown
# [KULLANICI_ADI]'NIN AI CO-FOUNDER - MASTER SYSTEM PROMPT

## 🎯 Kimlik ve Rol
## 👤 Kullanıcı Modeli (6 boyut)
## 💬 İletişim Protokolü
## 🎛️ Çalışma Modları
## 🚫 Hard Constraints (ASLA/HER ZAMAN)
## 🧩 Özel Senaryolar
## 📁 Bellek Yönetimi
## 🎯 Başarı Kriterleri
## 🔄 Geri Bildirim Döngüsü
## 📝 Revizyon Geçmişi
```

---

## ✅ FURKAN İÇİN UYGULAMA SONUCU

### Röportaj Metrikleri
| Metrik | Değer |
|--------|-------|
| **Tarih** | 2026-05-03 |
| **Kullanıcı** | Furkan (AidatPanel - Senior Mobile Developer) |
| **Soru Sayısı** | 6 |
| **Tamamlanan Boyut** | 6/6 (tamamı) |
| **Çıktı** | `FURKAN_AI_COFUNDER_MASTER_PROMPT.md` v1.0 |

### Üretilen Profil Özeti (6 Boyut)
| Boyut | Furkan'ın Değerleri |
|-------|---------------------|
| **Zaman/Enerji** | Gece owl, uzun seans, checkpoint'li ilerleme, Genshin/Valorant reset |
| **Problem Çözme** | Derin analiz, zero-tolerance hata, mükemmeliyetçi, iç ses odaklı |
| **Öğrenme** | Video→doküman sırası, production-ready kriteri, tarihli/başlıklı raporlar, CHANGELOG tracking |
| **Ekip/İletişim** | Lider rol, anlama+çözüm reaksiyonu, step-by-step mentorluk, test ile doğrulama |
| **Vizyon** | Başarı+para ikili motivasyon, "daha iyi olabilir" filtresi, 5 yıl → Teknik Lider |
| **Teknik Tercihler** | Flutter/Riverpod/Node.js/Prisma, Windows+Windsurf+emulator-5554, Clean Architecture, 50+ yaş UI kısıtları |

### Değer Katkıları (Meta-Prompt Ötesi)
Meta-prompt'ta talep edilmeyen ancak eklenen iyileştirmeler:
- ✅ **4 Çalışma Modu:** Teknik Danışman / PM / Analiz / Stratejik
- ✅ **Hard Constraints:** ASLA/HER ZAMAN listeleri
- ✅ **4 Özel Senaryo:** Detaylı implementasyon / Tıkanma / Junior mentorluk / Liderlik
- ✅ **Bellek Yönetimi:** Working + Long-term context stratejisi
- ✅ **Hazır Referans Cümleler:** Reset/checkpoint/mükemmeliyetçi hatırlatmaları

---

## 💡 KRİTİK BAŞARI FAKTÖRLERİ

| # | Faktör | Uygulama Notu |
|---|--------|---------------|
| 1 | **Sınırlı soru prensibi** | ✅ Uygulandı (6 soru, 2'şerli gruplar halinde) |
| 2 | **Şeffaf model** | ✅ Kullanıcı modeli tablolarla gösterildi |
| 3 | **Stratejik derinlik** | ✅ Yüzeysel cevaplar değil, davranış desenleri (reset mekanizması, checkpoint mantığı vb.) |
| 4 | **Esneklik** | ✅ Şablon Furkan için özelleştirildi, katı değil |
| 5 | **Copy-paste hazır** | ✅ Başka AI sistemlerine transfer edilebilir |
| 6 | **Güncellenebilirlik** | ✅ Revizyon geçmişi tutuluyor, tetikleyiciler tanımlı |

---

## 🔄 BAKIM VE REVİZYON PROTOKOLÜ

### Revizyon Tetikleyicileri
- Yeni öğrenme yöntemi keşfi
- Ekip dinamiklerinde değişiklik
- Yeni vizyon/hedef tanımı
- Teknoloji stack güncellemesi
- Ayda bir genel review

### Versiyonlama Kuralı
- **Major (x.0.0):** Boyut ekleme/çıkarma, yapısal değişiklik
- **Minor (1.x.0):** Mevcut boyuta yeni alan, mod/senaryo ekleme
- **Patch (1.0.x):** Metin düzeltme, tutarlılık

---

## 📊 META-PROMPT KALİTE SKORU

| Kriter | Skor | Açıklama |
|--------|------|----------|
| Netlik | 7/10 | Amaç net ama detay eksik |
| Yöntem Tanımı | 8/10 | Reverse engineering + 2 soru kuralı güçlü |
| Yapı Tanımı | 3/10 | Kullanıcı modeli yapısı belirsiz |
| Çıktı Tanımı | 5/10 | "Copy-paste hazır" denilmiş ama format yok |
| Güncelleme | 2/10 | Bakım mekanizması tanımsız |
| Doğrulama | 3/10 | Kalite kontrol adımı yok |
| **Ortalama** | **4.7/10** | **Orta - eksikler AI tarafından doldurulmalı** |

---

## 📁 KLASÖR İÇERİĞİ

| Dosya | Amaç | Versiyon |
|-------|------|----------|
| `ANALIZ_RAPORU.md` | Detaylı meta-prompt analizi (bu dosya) | v1.0 |
| `RAPOR_OZETI.md` | Executive summary | v1.0 |
| `FURKAN_AI_COFUNDER_MASTER_PROMPT.md` | Furkan için üretilmiş nihai sistem promptu | v1.0 |

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-03 | Sıfırdan temiz analiz, meta-prompt değerlendirmesi + Furkan profili üretimi tek raporda |

---

**Analiz Tamamlandı:** 2026-05-03  
**Klasör:** `analiz_raporlari/1-master_prompt_analizi/`  
**Durum:** ✅ Nihai prompt üretildi, kullanıma hazır. Aylık review tetikleyicisi kuruldu.
