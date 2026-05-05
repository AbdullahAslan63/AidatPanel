# AGENTS_PROMPTU - Rapor Özeti

## 🎯 Prompt Amacı
**AGENTS.md** dosyası yaratma/rewrite için AI agent talimatı  
**Odak:** Sinyal yoğunluğu > Tamamlama

## 📋 Temel İlkeler
| İlke | Özet |
|------|------|
| **Minimal** | Kısa ama kritik kısıtlamalar korunur |
| **Proje-Spesifik** | Codebase'den çıkarılamayan bilgiler |
| **Aksiyon-Odaklı** | "must/must not" kuralları |
| **Yinelenmeme** | README/stil rehberleriyle tekrar etme |

## ✅ AGENTS.md İçermeli
- Kritik güvenlik kısıtlamaları
- Validasyon komutları (test/lint/build)
- İş akışı kısıtlamaları
- Repo-spesifik konvansiyonlar
- Bilinen tuzaklar

## ❌ AGENTS.md İçermemeli
- README yerine geçen içerik
- Mimari derinlemesine incelemeler
- Genel kodlama felsefesi
- Uzun örnekler
- Uygulanmayan kurallar

## 🏗️ Yapı
```
AGENTS.md
├── Must-follow constraints
├── Validation before finishing
├── Repo-specific conventions
├── Important locations
├── Change safety rules
└── Known gotchas
```

## 🔍 AidatPanel Uygulaması
**Durum:** ✅ Aktif kullanımda  
**Lokasyon:** `prompt_data/AGENTS.md`  
**Etki:** Faz kilitleme, Zod validasyon, Service pattern kuralları aktif

## ⚠️ Kritik Kurallar (AidatPanel)
1. **Phase-locked:** Faz 1 dışı implementasyon yasak
2. **Zod first:** Tüm POST/PUT route'ları validateMiddleware ile
3. **Transactions:** Multi-step DB ops $transaction zorunlu
4. **JWT payload:** req.user = { id, role } token'dan direkt

---

**Rapor Özeti ID:** 2-AGENTS-PROMPTU-OZET
