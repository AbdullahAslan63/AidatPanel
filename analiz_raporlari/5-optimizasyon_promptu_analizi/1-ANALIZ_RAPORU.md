# Optimizasyon Promptu - Analiz Raporu

## Analiz Tarihi
2026-05-05

## Analiz Edilen Kaynak
**Dosya:** `planning/OPTİMİZASYON PROMPTU.md`  
**Tür:** Yazılım Optimizasyon Denetim Promptu  
**Hedef:** Kod, sorgu, servis ve mimari optimizasyon analizi

---

## Prompt'un Amacı

Bu prompt, bir **uzman yazılım optimizasyon denetçisi** rolünde çalışarak kodun performans, ölçeklenebilirlik, verimlilik, güvenilirlik, sürdürülebilirlik ve maliyet açısından analiz edilmesini sağlar.

### İşletim Modu (Operating Mode)
- **Rol:** Senior optimization engineer
- **Yaklaşım:** Kesin, şüpheci, pratik
- **Hedef:** Vague tavsiyelerden kaçınmak

---

## Gerekli Çıktı Formatı

### 1) Optimization Summary
- Mevcut optimizasyon sağlığının kısa özeti
- En yüksek etkili 3 iyileştirme
- Değişiklik yapılmazsa en büyük risk

### 2) Findings (Önceliklendirilmiş)
Her bulgu için format:
- **Title**
- **Category:** CPU / Memory / I/O / Network / DB / Algorithm / Concurrency / Build / Frontend / Caching / Reliability / Cost
- **Severity:** Critical / High / Medium / Low
- **Impact:** latency, throughput, memory, cost, vb.
- **Evidence:** Spesifik kod yolu, pattern, sorgu
- **Why it's inefficient:** Neden verimsiz
- **Recommended fix:** Önerilen çözüm
- **Tradeoffs / Risks:** Riskler
- **Expected impact estimate:** Tahmini etki (%)
- **Removal Safety:** Safe / Likely Safe / Needs Verification
- **Reuse Scope:** local / module / service-wide

### 3) Quick Wins (Önce Yapılacaklar)
- En hızlı yüksek değerli değişiklikler

### 4) Deeper Optimizations (Sonra Yapılacaklar)
- Mimari veya daha büyük refactor'lar

### 5) Validation Plan
- İyileştirmeleri doğrulama yöntemi
- Benchmark'lar, profiling stratejisi, metrikler

### 6) Optimized Code / Patch (Mümkünse)
- Revize edilmiş kod snippet'leri
- Query rewrites, config değişiklikleri

---

## Optimizasyon Checklist

### Algoritmalar ve Veri Yapıları
- [ ] Gereğinden kötü zaman karmaşıklığı
- [ ] Tekrarlanan taramalar / nested loops / N+1 davranışı
- [ ] Kötü veri yapısı seçimleri
- [ ] Gereksiz sıralama/filtreleme/transformasyon
- [ ] Gereksiz kopyalama / serializasyon / parsing

### Bellek
- [ ] Sıcak yollarda büyük allocation'lar
- [ ] Kaçınılabilir nesne oluşturma
- [ ] Bellek sızıntıları / retained referanslar
- [ ] Sınırsız cache büyümesi
- [ ] Full dataset loading yerine streaming/pagination

### I/O ve Ağ
- [ ] Aşırı disk okuma/yazma
- [ ] Gereksiz ağ/API çağrıları
- [ ] Eksik batching, compression, keep-alive, pooling
- [ ] Hassas yollarda blocking I/O
- [ ] Aynı veri için tekrarlanan istekler (cache adayları)

### Database / Query Performansı
- [ ] N+1 sorgular
- [ ] Eksik indeksler
- [ ] SELECT * gereksiz kullanım
- [ ] Sınırsız taramalar
- [ ] Kötü join / filter / sort pattern'leri
- [ ] Eksik pagination / limits
- [ ] Cache olmadan tekrarlanan aynı sorgular

### Concurrency / Async
- [ ] Seri async işler paralel yapılabilir
- [ ] Aşırı paralelleştirme contention yaratıyor
- [ ] Lock contention / race conditions / deadlocks
- [ ] Async kodda thread blocking
- [ ] Kötü queue/backpressure yönetimi

### Caching
- [ ] Cache olmayan bariz yerler
- [ ] Yanlış cache granularity
- [ ] Eski invalidasyon stratejisi
- [ ] Düşük hit-rate pattern'leri
- [ ] Cache stampede riski

### Frontend / UI (Varsa)
- [ ] Gereksiz rerender'lar
- [ ] Büyük bundle'lar / code splitting yok
- [ ] Render yollarında pahalı hesaplamalar
- [ ] Asset loading verimsizlikleri
- [ ] Layout thrashing / aşırı DOM işi

### Güvenilirlik / Maliyet
- [ ] Sonsuz retries / retry jitter yok
- [ ] Timeout'lar çok yüksek/düşük
- [ ] Polling yerine event-driven yaklaşım yok
- [ ] Gereksiz pahalı API/model çağrıları
- [ ] Rate limiting yok / abuse amplification

### Kod Yeniden Kullanımı ve Ölü Kod
- [ ] Extract edilmeli/tekilleştirilmeli tekrarlanan mantık
- [ ] Modüller arası tekrarlanan utility kodu
- [ ] Benzer sorgular/fonksiyonlar (küçük parametre farklılıkları)
- [ ] Copy-paste implementasyonlar (drift riski)
- [ ] Kullanılmayan fonksiyonlar, sınıflar, export'lar, değişkenler
- [ ] Ölü dallar (her zaman true/false koşullar)
- [ ] Return/throw sonrası unreachable kod
- [ ] Değer katmayan stale abstraction'lar

---

## AidatPanel'de Uygulanan Optimizasyonlar

### Mevcut Uygulananlar (Aşama 0)

| # | Bulgu | Aksiyon | Durum |
|---|-------|---------|-------|
| 1 | Auth middleware DB lookup her istekte | JWT payload'a `role` ekle, DB lookup kaldır | ✅ Applied |
| 2 | No pagination | `take`/`skip` building + apartment servislerine | ✅ Applied |
| 3 | Missing Prisma indexes | `@@index` foreign key'lere ekle | ✅ Applied |
| 4 | No response compression | `compression` middleware ekle | ✅ Applied |
| 5 | CORS null-origin bypass | `!origin` check kaldır | ✅ Applied |
| 6 | Prisma query log development'ta | `PRISMA_QUERY_LOG` env var ile kontrol | ✅ Applied |
| 7 | Rate limiter MemoryStore | Yorum ekle (Faz 3 reminder) | ✅ Applied |

### Uygulanmamışlar (Faz 2+)
- Redis rate limiter
- Pagination tüm list endpoint'lerine
- Cursor-based pagination (büyük dataset)
- Cache layer (Redis)
- DB connection pooling tuning
- Online payment integration (İyzico/PayTR)

---

## Kurallar

- **Premature optimizasyon önerme** - Açıkça gerekçelendirilmedikçe
- **Yüksek-ROI değişiklikler** - Akıllıca değişiklikler üzerine odaklan
- **Varsayımları belirt** - Bilgi eksikse best-effort analiz
- **"Likely" etiketle** - Koddan alone kanıtlanamazsa
- **Doğruluğu feda etme** - Hız için doğruluğu bozma (explicit tradeoff belirt)
- **Gerçekçi öneriler** - Üretim ekipleri için uygulanabilir
- **OPTIMIZATIONS.md'e yaz** - Kodu fixleme (fix yapılmadan analiz yapılır)

---

## AidatPanel Backend İçin Önerilen Optimizasyon Analizi

### Yapılacak Analizler

1. **Auth Middleware Performansı**
   - DB lookup kaldırıldı mı?
   - JWT decode + verify süresi

2. **Prisma Query Optimizasyonu**
   - SELECT * kullanımı
   - Gereksiz include'lar
   - N+1 sorgular (var mı?)

3. **Building/Apartment Endpoint'leri**
   - Pagination implementasyonu
   - Offset-based vs cursor-based

4. **Zod Validasyon Overhead**
   - Schema complexity analizi
   - Validasyon süresi

5. **Error Handling**
   - Error stack trace'ler
   - Günlük log seviyesi

6. **Response Boyutu**
   - JSON payload boyutu
   - Compression etkin mi?

7. **Test Suite Performansı**
   - Test çalışma süresi
   - Paralel test imkanı

---

## Analiz Sonucu

Bu prompt, **kapsamlı bir optimizasyon denetimi** için mükemmel bir çerçeve sunar. AidatPanel projesinde kullanıldığında:

**Avantajları:**
- Yüksek etkili iyileştirmeleri önceliklendirir
- ROI bazlı karar vermeyi teşvik eder
- Doğrulama planı ile etkiyi ölçülebilir kılar
- Kod değişimi öncesi analizi zorunlu kılar

**Kullanım Alanları:**
- Aşama 0 (Aşama 0) optimizasyon workflow'u
- Her major feature öncesi performans analizi
- Bottleneck tespiti ve çözümü

---

**Analiz Raporu ID:** 1-OPTIMIZASYON-PROMPTU-ANALIZ  
**Son Güncelleme:** 2026-05-05
