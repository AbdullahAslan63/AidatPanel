# 🤖 AGENTS PROMPTU - AGENTS.md Oluşturma Rehberi

**Versiyon:** 2.0 (Operasyonel Detay + Context Toplama + Doğrulama + Versiyon Yönetimi)  
**Tarih:** 2026-05-04  
**Hedef Puan:** 8.5/10 (Mevcut: 7.5/10)

---

## 📋 GÖREV

Yazılım projeleri için **AGENTS.md** oluşturmak veya yeniden yazmak. Amaç: **SIGNAL DENSITY** (yüksek sinyal yoğunluğu).

**Çıktı:** Minimal, project-specific, action-guiding, hata önleyici AGENTS.md (1-2 sayfa).

AGENTS.md should be a minimal, high-value instruction file for coding agents working in the repo. It must only include information that is:
1) project-specific,
2) non-obvious,
3) action-guiding,
4) likely to prevent costly mistakes.

## Core Principles (must follow)
- Be minimal. Shorter is better if it preserves critical constraints.
- Include only information an agent cannot quickly infer from the codebase, standard tooling, or README.
- Prefer hard constraints over general advice.
- Prefer "must / must not" rules over vague recommendations.
- Do not duplicate docs, onboarding guides, or style guides.
- Do not include generic best practices (e.g., "write clean code", "add comments", "handle errors").
- Do not include rules already enforced by tooling (linters, formatters, CI) unless there is a known exception or trap.
- Optimize for task success, not human-facing prose quality.

## What AGENTS.md SHOULD contain (if applicable)
- Critical repo-specific safety constraints (e.g., migrations, API contracts, secrets, compatibility requirements)
- Required validation commands before finishing (test/lint/typecheck/build) only if they are actually used
- Non-obvious workflow constraints (e.g., pnpm-only, codegen order, required service startup dependencies)
- Unusual repository conventions that agents routinely miss
- Important file locations only when not obvious
- Change-safety expectations (e.g., preserve backward compatibility unless explicitly requested)
- Known gotchas that have caused repeated mistakes

## What AGENTS.md MUST NOT contain
- README replacement content
- Architecture deep-dives unless absolutely required to avoid breakage
- Generic coding philosophy
- Long examples unless the example captures a critical non-obvious pattern
- Repeated/duplicated rules
- Aspirational rules not enforced by the team
- Anything stale, uncertain, or "nice to know"

## Output Requirements
- Output ONLY the final AGENTS.md content (no commentary, no analysis, no preface).
- Use concise Markdown.
- Keep sections tight and skimmable.
- Prefer bullets over paragraphs.
- If information is missing or uncertain, omit it rather than invent.
- If a section has no high-signal content, omit the section entirely.
- Aim for the shortest document that still prevents major mistakes.

## Preferred Structure (adapt as needed)
- # AGENTS.md
- ## Must-follow constraints
- ## Validation before finishing
- ## Repo-specific conventions
- ## Important locations (only non-obvious)
- ## Change safety rules
- ## Known gotchas (optional)

## Rewrite Mode Behavior (important)
When given an existing AGENTS.md:
- Aggressively remove low-value or generic content
- Deduplicate overlapping rules
- Rewrite vague language into explicit action rules
- Preserve truly critical project-specific constraints
- Shorten relentlessly without losing important meaning

## Quality Bar (self-check before finalizing)
Before producing output, ensure:
- Every bullet is project-specific OR prevents a real mistake
- No generic advice remains
- No duplicated information remains
- The file reads like an operational checklist, not documentation
- A coding agent could use it immediately during implementation

---

## 📊 CONTEXT TOPLAMA YÖNTEMİ (v2.0 YENİ)

AGENTS.md oluşturmadan önce şu kaynaklardan context topla:

### 1. Proje Yapısı (5-10 dk)
- [ ] `README.md` oku (stack, setup, conventions)
- [ ] `package.json` / `pubspec.yaml` / `go.mod` oku (dependencies, scripts)
- [ ] Mevcut `AGENTS.md` varsa oku (ne var, ne eksik?)
- [ ] `.github/workflows/` oku (CI/CD, validation commands)
- [ ] `tsconfig.json` / `eslint.config.js` / `dart_defines` oku (tooling)

### 2. Kod Analizi (10-15 dk)
- [ ] Proje kökü: Dosya yapısını tara (`src/`, `lib/`, `app/`, vb.)
- [ ] Kritik dosyalar: `main.ts`, `main.dart`, `app.ts`, `index.js` oku
- [ ] API/Backend: Endpoint tanımları, auth middleware, validation
- [ ] Frontend: State management, routing, component structure
- [ ] Database: Schema, migrations, constraints
- [ ] Secrets/Config: `.env.example`, environment variables

### 3. Hata Geçmişi (5-10 dk)
- [ ] Git log'u tara: Sık tekrarlanan hatalar, revert'ler
- [ ] Issue tracker: "bug" label'lı issue'lar
- [ ] Code review comments: Neden reject edilen PR'lar?
- [ ] Slack/Discord: Tekrarlanan sorular, gotcha'lar

### 4. Team Knowledge (5 dk)
- [ ] Ekip ile konuş: "Yeni bir agent ne yapması gerekir?"
- [ ] "Hangi hataları sık yapıyor?"
- [ ] "Hangi kuralları sık unutuyor?"

### 5. Standart Checklist (2-3 dk)
- [ ] Backward compatibility gerekli mi?
- [ ] Breaking changes nasıl handle ediliyor?
- [ ] Migration stratejisi nedir?
- [ ] Secrets nasıl yönetiliyor?
- [ ] API versioning var mı?

---

## ✅ DOĞRULAMA ADIMI (v2.0 YENİ)

AGENTS.md oluşturduktan sonra şu kontrol listesini geç:

### Kalite Kontrol
- [ ] **Signal Density:** Her satır project-specific veya hata önleyici mi?
- [ ] **Minimal:** Gereksiz satır var mı? Kaldır.
- [ ] **Actionable:** "Yapılacak" şeyler açık mı? (must/must not formatında)
- [ ] **Doğru:** Kod ile eşleşiyor mu? (stale rule yok mu?)
- [ ] **Kısa:** 1-2 sayfa mı? (3+ sayfaysa çok fazla)
- [ ] **Skimmable:** Hızlı okuma mı? (bullets, bold, clear headings)

### Doğrulama Komutları
- [ ] Tüm validation commands test edildi mi?
- [ ] Komutlar gerçekten kullanılıyor mu? (CI/CD'de çalışıyor mu?)
- [ ] Komut çıktıları anlaşılır mı?

### Proje-Spesifik Kurallar
- [ ] Repo-specific constraints var mı? (migrations, API contracts, secrets)
- [ ] Non-obvious workflows var mı? (codegen order, service dependencies)
- [ ] Unusual conventions var mı? (naming, file locations)
- [ ] Known gotcha'lar var mı? (repeated mistakes)

### Duplikasyon
- [ ] README'de var olan kurallar tekrarlanmış mı? (kaldır)
- [ ] Tooling tarafından enforce edilen kurallar var mı? (kaldır)
- [ ] Aynı kural 2+ kez yazılmış mı? (birleştir)

---

## 🔄 VERSIYON YÖNETİMİ (v2.0 YENİ)

### Versiyon Numaralandırması
- **Patch (v1.0.1):** Yazım hatası, minor clarification
- **Minor (v1.1.0):** Yeni rule eklendi, existing rule revize edildi
- **Major (v2.0.0):** Komple rewrite, 3+ rule değişti

### Güncelleme Tetikleyicileri
- [ ] Yeni stack component eklendi (dependency)
- [ ] Yeni validation tool eklendi (linter, formatter, test framework)
- [ ] Repeated mistake tespit edildi (code review'de)
- [ ] API contract değişti (breaking change)
- [ ] Migration stratejisi değişti
- [ ] Secrets management yöntemi değişti

### Güncelleme Süreci
1. Tetikleyici olay oluştu
2. Context topla (yeni kurallar neler?)
3. AGENTS.md'yi revize et
4. Doğrulama checklist'i geç
5. Versiyon numarasını artır
6. Revizyon geçmişine ekle

### Revizyon Geçmişi Formatı
```markdown
## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-03 | İlk versiyon (signal density prensibi) |
| v1.1 | 2026-05-04 | Flutter-specific rules eklendi |
| v2.0 | 2026-05-05 | Context toplama, doğrulama, versiyon yönetimi eklendi |
```

---

## 🎯 KALITE KONTROL CHECKLIST

Üretilen AGENTS.md şu kriterleri karşılamalı:

- [ ] **Signal Density:** Yüksek (her satır değerli)
- [ ] **Minimal:** 1-2 sayfa (3+ sayfa = çok fazla)
- [ ] **Project-Specific:** Generic advice yok
- [ ] **Actionable:** "Yapılacak" şeyler açık (must/must not)
- [ ] **Doğru:** Kod ile eşleşiyor (stale rule yok)
- [ ] **Skimmable:** Hızlı okuma (bullets, bold, headings)
- [ ] **Duplikasyon yok:** README/tooling ile overlap yok
- [ ] **Gotcha'lar:** Known mistakes capture edildi
- [ ] **Validation:** Commands test edildi
- [ ] **Versiyon:** Revizyon geçmişi var

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-03 | İlk versiyon (signal density prensibi, core principles, output requirements) |
| v2.0 | 2026-05-04 | Operasyonel detay: Context toplama yöntemi (5 kaynak), doğrulama checklist, versiyon yönetimi, kalite kontrol. Puan: 7.5 → 8.5/10 |
