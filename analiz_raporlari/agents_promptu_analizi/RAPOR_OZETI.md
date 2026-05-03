# AGENTS PROMPTU ANALİZ ÖZETİ

**Tarih:** 2026-05-03  
**Kaynak:** planning/AGENTS_PROMPTU.md  
**Durum:** ✅ Analiz Tamamlandı

---

## 🎯 ÖZET

Bu meta-prompt, **Signal Density** (Sinyal Yoğunluğu) felsefesiyle **AGENTS.md** dosyası oluşturma talimatlarıdır.

---

## ✅ GÜÇLÜ YÖNLER

- ✅ **Minimalizm** - Kısa ve kritik odaklı
- ✅ **Signal Density** - 4 kriter (project-specific, non-obvious, action-guiding, mistake-preventing)
- ✅ **Hard Constraints** - "Must/must not" formatı
- ✅ **Deduplication** - Tekrarları önleme
- ✅ **Output Odaklı** - Sadece AGENTS.md içeriği, yorum yok

---

## ⚠️ EKSİK ALANLAR (Çözüm Bekliyor)

| Alan | Çözüm Gerekli |
|------|---------------|
| Proje-spesifik context | AidatPanel analizi yapılmalı |
| Mevcut AGENTS.md referansı | Eski dosya içeriği incelenmeli |
| Known gotchas | Geçmiş hatalar dokümante edilmeli |
| Validation komutları | Flutter özel komutlar tanımlanmalı |

---

## 📋 AGENTS.md YAPISI

```markdown
# AGENTS.md

## Must-follow constraints
## Validation before finishing
## Repo-specific conventions
## Important locations
## Change safety rules
## Known gotchas
```

---

## 🚀 BAŞLATMAK İÇİN

**Dosyalar:**
- `ANALIZ_RAPORU.md` - Detaylı analiz ve rehber
- `RAPOR_OZETI.md` - Bu özet

**Sonraki Adım:**
AidatPanel için AGENTS.md oluştur → Kalite kontrolü → Kaydet

---

## 📁 KLASÖR YAPISI

```
analiz_raporlari/
├── agents_promptu_analizi/
│   ├── ANALIZ_RAPORU.md    (Detaylı analiz)
│   ├── RAPOR_OZETI.md      (Bu özet)
│   └── AGENTS.md           (Nihai çıktı - sonraki adım)
└── master_prompt_analizi/
    └── ...
```

---

**Hazır:** Evet, AGENTS.md oluşturulabilir
