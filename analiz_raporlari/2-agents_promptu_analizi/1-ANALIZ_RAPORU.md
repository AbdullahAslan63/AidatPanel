# AGENTS_PROMPTU.md - Prompt Analiz Raporu

## Analiz Tarihi
2026-05-05

## Prompt Kimliği
**Dosya:** `planning/AGENTS_PROMPTU.md`  
**Tür:** AI Agent İş Akışı Talimatı  
**Hedef:** AGENTS.md dosyasını yeniden yazma/yaratma

---

## Prompt'un Amacı

Bu prompt, yazılım projeleri için **AGENTS.md** dosyasının nasıl oluşturulacağını veya yeniden yazılacağını tanımlar. AI agent'lara yönelik minimal, yüksek sinyal yoğunluğunda bir talimat dosyası üretmeyi amaçlar.

### Temel İlkeler (Core Principles)

| İlke | Açıklama |
|------|----------|
| **Sinyal Yoğunluğu** | Tamamlama değil, yüksek değerli bilgi |
| **Minimalizm** | Kısa ve öz, kritik kısıtlamaları koru |
| **Proje-Spesifik** | Sadece codebase'den çıkarılamayan bilgiler |
| **Aksiyon-Odaklı** | "must/must not" kuralları |
| **Yinelenmeme** | README, onboarding, stil rehberleriyle tekrar etme |

---

## AGENTS.md İçeriği (Ne Olmalı)

### İçermesi Gerekenler ✅
1. **Kritik Güvenlik Kısıtlamaları** - Migration, API kontratları, sırlar
2. **Validasyon Komutları** - Test/lint/typecheck/build (gerçekten kullanılanlar)
3. **İş Akışı Kısıtlamaları** - pnpm-only, codegen sırası, bağımlılıklar
4. **Repo-Spesifik Konvansiyonlar** - Agent'ların kaçırdığı alışılmadık kurallar
5. **Önemli Dosya Konumları** - Belli olmayan kritik yerler
6. **Değişim Güvenliği** - Geriye uyumluluk beklentileri
7. **Bilinen Tuzaklar** - Tekrarlanan hatalar

### İçermemesi Gerekenler ❌
- README yerine geçen içerik
- Mimari derinlemesine incelemeler
- Genel kodlama felsefesi
- Uzun örnekler (kritik olmayan)
- Yinelenen kurallar
- Uygulanmayan kurallar
- Eski/belirsiz bilgiler

---

## AGENTS.md Yapısı

```markdown
# AGENTS.md

## Must-follow constraints
- Phase-locked: Never implement outside current Faz
- Zod first: All POST/PUT routes must use validateMiddleware
- Transactions: Multi-step DB ops must use Prisma $transaction
- JWT payload only: req.user = { id, role } from token only

## Validation before finishing
- [ ] All new POST/PUT routes wrapped with Zod validation
- [ ] Multi-step DB ops use $transaction
- [ ] npm test passes
- [ ] No console.log in production code

## Repo-specific conventions
- Service pattern: Controller calls Service. Service calls Prisma.
- Error handling: All errors flow through errorHandler middleware
- Route prefix: All routes mounted at /api/v1/*
- File naming: Singular controllers, plural routes

## Important locations
- backend/src/middlewares/validateMiddleware.js
- backend/src/validators/ - Zod schemas
- backend/src/services/ - All DB logic isolated here

## Change safety rules
- Preserve backward compatibility on existing endpoints
- New fields: optional by default
- Never drop tables/columns without explicit approval

## Known gotchas
- authMiddleware has commented-out DB lookup. Do not uncomment.
- join controller is commented out. Needs $transaction when re-enabled.
- Rate limiter uses MemoryStore - fine for Faz 1.
- mobile/ folder was deleted. Do not recreate.
```

---

## Prompt'un Çıktı Formatı

### Rewrite Mod Davranışı
Mevcut AGENTS.md varsa:
1. Düşük değerli/generic içeriği agresifçe kaldır
2. Örtüşen kuralları tekilleştir
3. Belirsiz dili açık kurallara dönüştür
4. Kritik proje-spesifik kısıtlamaları koru
5. Anlam kaybetmeden sürekli kısalt

### Kalite Kontrolü (Self-check)
- Her madde proje-spesifik VEYA gerçek hata önleyici mi?
- Generic tavsiye kaldı mı?
- Yinelenen bilgi var mı?
- Operasyonel checklist gibi mi okunuyor?
- Kodlama agent'ı hemen kullanabilir mi?

---

## AidatPanel'de Uygulanmış AGENTS.md Analizi

Mevcut `backend/src/AGENTS.md` (veya prompt_data/AGENTS.md) şunları içeriyor:

### ✅ Doğru Uygulananlar
- Phase-locked development kuralı
- Zod validation zorunluluğu
- Transaction kullanımı kuralı
- JWT payload yapısı (id, role)
- Service pattern konvansiyonu
- Error handling middleware akışı
- Route prefix standartı (/api/v1/*)

### ⚠️ Dikkat Edilmesi Gerekenler
- Faz 1 sınırlandırması (Faz 2'ye geçiş planı netleşmeli)
- Rate limiter MemoryStore kullanımı (Faz 3 Redis geçişi)
- Commented-out kodlar (join controller, authMiddleware DB lookup)

---

## Analiz Sonucu

Bu prompt, **yüksek sinyal yoğunluğunda** AI agent rehberliği için mükemmel bir çerçeve sunar. AidatPanel projesinde uygulandığında:

**Avantajları:**
- Tekrarlanan hataları önler
- Kod tutarlılığını sağlar
- Faz kilitleme disiplinini korur
- Onboarding süresini kısaltır

**Kullanım Alanları:**
- Yeni agent onboarding'i
- Mevcut AGENTS.md revizyonu
- Proje kurallarının standardizasyonu
- Kod review öncesi checklist

---

**Analiz Raporu ID:** 1-AGENTS-PROMPTU-ANALIZ  
**Son Güncelleme:** 2026-05-05
