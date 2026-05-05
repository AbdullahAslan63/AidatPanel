# Optimizasyon Promptu - Rapor Özeti

## 🎯 Prompt Amacı
**Yazılım optimizasyon denetimi** için AI agent talimatı  
**Odak:** Performans, ölçeklenebilirlik, verimlilik, maliyet

## 📋 Analiz Alanları

| Alan | İçerik |
|------|--------|
| **Algorithms** | Zaman karmaşıklığı, N+1 davranışı |
| **Memory** | Allocation'lar, sızıntılar, cache |
| **I/O & Network** | Batching, compression, pooling |
| **Database** | N+1 sorgular, indeksler, pagination |
| **Concurrency** | Paralelleştirme, lock contention |
| **Caching** | Hit-rate, invalidasyon |
| **Frontend** | Rerender'lar, bundle boyutu |
| **Reliability** | Timeouts, retries, rate limiting |

## 🏗️ Çıktı Formatı

```
1. Optimization Summary
2. Findings (Önceliklendirilmiş)
3. Quick Wins
4. Deeper Optimizations
5. Validation Plan
6. Optimized Code (mümkünse)
```

## 📊 AidatPanel Uygulananlar (Aşama 0)

| # | Optimizasyon | Durum |
|---|--------------|-------|
| 1 | Auth middleware DB lookup kaldırma | ✅ |
| 2 | Pagination (take/skip) | ✅ |
| 3 | Prisma @@index foreign key'ler | ✅ |
| 4 | Response compression | ✅ |
| 5 | CORS null-origin fix | ✅ |
| 6 | Prisma query log env kontrolü | ✅ |

## ⏳ Faz 2+ Planlananlar
- Redis rate limiter
- Cursor-based pagination
- Cache layer (Redis)
- Connection pooling tuning

## ⚠️ Kritik Kural
**"Premature optimizasyon önerme"** - Açık gerekçe olmadan

## ✅ Checklist Özeti
- [ ] Algoritma verimliliği
- [ ] Bellek yönetimi
- [ ] I/O optimizasyonu
- [ ] DB query optimizasyonu
- [ ] Concurrency
- [ ] Caching stratejisi
- [ ] Ölü kod temizliği

---

**Rapor Özeti ID:** 2-OPTIMIZASYON-PROMPTU-OZET
