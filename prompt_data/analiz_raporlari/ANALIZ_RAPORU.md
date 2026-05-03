# MASTER PROMPTU ANALİZ RAPORU

**Kaynak Dosya:** `planning/MASTER_PROMPTU.md`  
**Analiz Tarihi:** 2026-05-03  
**Durum:** ✅ Tamamlandı

---

## 📋 META-PROMPT YAPISI ANALİZİ

### Amaç ve Kapsam
| Öğe | Değerlendirme |
|-----|---------------|
| **Amaç** | Kişiselleştirilmiş AI Co-Founder sistem promptu oluşturma |
| **Yöntem** | Reverse Engineering (Tersine Mühendislik) |
| **Derinlik** | Hayatın her alanı, iş, projeler - holistik yaklaşım |
| **Hedef Kullanıcı** | Kendini derinlemesine anlamak isteyen, stratejik düşünen birey |
| **Çıktı** | Copy-paste yapılabilir Master System Prompt |

---

## ✅ GÜÇLÜ YÖNLER

### 1. İteratif Bilgi Toplama Stratejisi
```
Soru (max 2) → Cevap → Kullanıcı Modeli Güncelle → Tekrar
```
- Bilişsel yükü dağıtır
- Derinlemesine cevaplar almayı sağlar
- Adım adım güven inşası

### 2. Sınırlı Soru Prensibi
- **"Tek seferde uzun bir liste sorma"**
- Max 2 soru kuralı
- Kalite > Kuantite

### 3. Reverse Engineering Yaklaşımı
- Mevcut davranışlardan çıkarım
- Tersine mühendislikle model oluşturma
- Veri odaklı kişiselleştirme

### 4. Esnek Yeterlilik Kriteri
- "Yeterince veriye ulaştığında" - subjektif ama adaptif
- Kullanıcı kontrolünde bitiş noktası

---

## ⚠️ EKSİK VE BELİRSİZ ALANLAR

| Alan | Durum | Eksiklik | Öneri |
|------|-------|----------|-------|
| **Kullanıcı Modeli Yapısı** | Belirsiz | Hangi boyutları içermeli? | 6 boyutlu çerçeve önerisi (aşağıda) |
| **Soru Kategorileri** | Tanımsız | Hangi alanlarda sorular? | 5 kategori önerisi (aşağıda) |
| **Yeterlilik Kriteri** | Subjektif | Ne zaman "yeterli veri"? | 12-15 cevap veya 5-6 döngü önerisi |
| **Prompt Format Şablonu** | Belirsiz | Nasıl bir yapıda olmalı? | Hazır şablon önerisi (aşağıda) |
| **Bakım/Güncelleme** | Eksik | Sürekli öğrenme mekanizması? | Güncelleme protokolü önerisi |
| **Hata Yönetimi** | Eksik | Kullanıcı cevap vermezse? | Timeout/exit stratejisi |

---

## 🎯 ÖNERİLEN SORU KATEGORİLERİ (5 Ana Başlık)

### 1. Çalışma Ritmi ve Enerji Yönetimi
- Sabah/gece tercihi
- Uzun seans vs kısa aralıklar
- Flow state yönetimi
- Mental yorgunluk sinyalleri

### 2. Problem Çözme ve Karar Verme
- Analiz vs deneme yaklaşımı
- Risk algısı ve teknik borç toleransı
- Karar kaynağı (iç ses/dış danışma)
- Mükemmeliyetçilik seviyesi

### 3. Öğrenme ve Bilgi İşleme
- Giriş yöntemi (video/yazı/deneme)
- Başarı kriteri (demo/production)
- Bilgi organizasyon sistemi
- Tracking ve not tutma alışkanlıkları

### 4. Ekip ve İletişim Dinamikleri
- Liderlik vs takipçi rolü
- Feedback alma reaksiyonu
- Mentorluk yaklaşımı
- Conflict resolution stili

### 5. Vizyon, Motivasyon ve Uzun Vade
- Proje/hedef anlamı
- "Yeterli" vs "daha iyi" algısı
- 5 yıllık vizyon
- Başarı tanımı

---

## 🧠 ÖNERİLEN KULLANICI MODELİ YAPISI (6 Boyut)

```yaml
KullaniciModeli:
  ZamanEnerji:
    tercih: [sabah/gece/esnek]
    seansUzunlugu: [uzun/kisa]
    flowYonetimi: [kesintisiz/checkpointli]
    resetMekanizmasi: [aktif/pasif]
    
  ProblemCozme:
    yaklasim: [analiz/deneme/karisik]
    riskAlgisi: [dusuk/orta/yuksek]
    kararKaynagi: [icSes/danisma/karisik]
    kaliteStandarti: [yeterli/mukemmeliyetci]
    
  OgrenmeBilgi:
    girisYontemi: [video/yazi/deneme]
    basariKriteri: [demo/production/anlatma]
    organizasyon: [notlar/raporlar/mental]
    tracking: [yok/az/orta/cok]
    
  EkipIletisim:
    rol: [lider/takipci/esit]
    feedbackReaksiyonu: [savunma/anlama/duzeltme]
    mentorluk: [detayli/overview/yok]
    iletisimTercihi: [dogrudan/dolayli/karisik]
    
  VizyonMotivasyon:
    projeAnlami: [para/basari/ogrenme/vizyon]
    yeterlilikAlgisi: [yeterli/dahaIyi]
    besYillikHedef: [teknikLider/girisimci/uzman]
    basariTanimi: [tanimli/esnek/gelisen]
    
  TeknikTercihler:
    stack: []
    araclar: []
    ortam: []
    kisitlamalar: []
```

---

## 📄 ÖNERİLEN MASTER PROMPT ŞABLONU

```markdown
# [KULLANICI_ADI]'NIN AI CO-FOUNDER - MASTER SYSTEM PROMPT

## 🎯 Kimlik ve Rol
Sen [Kullanıcı Adı]'nın AI Co-Founder'ı ve stratejik ortağısın...

## 👤 Kullanıcı Modeli
[6 boyutlu yapı burada doldurulacak]

## 💬 İletişim Protokolü
[Dil, ton, format kuralları]

## 🎛️ Çalışma Modları
[4 mod tanımı]

## 🚫 Kısıtlamalar
[Hard constraints]

## 🧩 Özel Senaryolar
[Senaryo başlıkları ve davranışlar]

## 📁 Bellek Yönetimi
[Working memory ve long-term memory yapısı]

## 🎯 Başarı Kriterleri
[Metrikler ve göstergeler]

## 🔄 Geri Bildirim Döngüsü
[Sürekli iyileştirme mekanizması]
```

---

## 📊 UYGULAMA REHBERİ

### Röportaj Süreci (Tahmini)
| Döngü | Sorular | Süre | Çıktı |
|-------|---------|------|-------|
| 1 | 2 | 5-10 dk | İlk model |
| 2 | 2 | 5-10 dk | Güncellenmiş model |
| 3 | 2 | 5-10 dk | Detaylanmış model |
| 4-6 | 2'şer | 15-30 dk | Nihai model |
| **Toplam** | **10-12** | **30-60 dk** | **Master Prompt** |

### Yeterlilik Kriterleri (Önerilen)
- ✅ En az 12-15 cevap toplanmış
- ✅ 5-6 döngü tamamlanmış  
- ✅ 6 boyutun tamamında veri var
- ✅ Kullanıcı "yeterli" hissediyor

### Başarı Metrikleri
| Metrik | Hedef |
|--------|-------|
| Öneri uygulanma oranı | >80% |
| Kullanıcı memnuniyeti | >4/5 |
| Tekrar düzeltme ihtiyacı | <20% |
| Stratejik uyum | Yüksek |

---

## 🚀 SONRAKİ ADIMLAR

### Hemen Yapılacaklar
1. Kullanıcıdan ilk 2 soru için hazır olması istenir
2. Soru seti 1 hazırlanır (Zaman/Enerji + Problem/Karar)
3. Röportaj başlatılır

### Süreç Sonunda
1. Kullanıcı Modeli oluşturulur
2. Master Prompt şablona göre doldurulur
3. prompt_data/master_promptu_analizi/ içine kaydedilir
4. Kullanıcı onaylar

### Bakım
- Her etkileşimde model güncellenir
- Aylık review önerilir
- Yeni pattern tespit edildiğinde revizyon

---

## 💡 KRİTİK BAŞARI FAKTÖRLERİ

1. **Sınırlı soru prensibine sadık kalma** - Kalite önemli
2. **Kullanıcı Modeli'ni görünür tutma** - Şeffaf güncelleme
3. **Stratejik derinlik** - Yüzeysel bilgi değil, davranış desenleri
4. **Esneklik** - Her kullanıcı farklı, şablon esnek kalmalı
5. **Uygulanabilirlik** - Copy-paste hazır, kullanıma hazır çıktı

---

**Analiz Tamamlandı:** 2026-05-03  
**Klasör:** `prompt_data/master_promptu_analizi/`  
**Sonraki Adım:** Kullanıcıdan röportaj için onay al
