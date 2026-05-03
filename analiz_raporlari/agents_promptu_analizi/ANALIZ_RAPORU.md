# AGENTS PROMPTU ANALİZ RAPORU

**Kaynak Dosya:** `planning/AGENTS_PROMPTU.md`  
**Analiz Tarihi:** 2026-05-03  
**Durum:** ✅ Tamamlandı  
**Analiz Tipi:** Meta-Prompt Değerlendirmesi - AGENTS.md Oluşturma Talimatları

---

## 📋 META-PROMPT YAPISI ANALİZİ

### Amaç ve Kapsam
| Öğe | Değerlendirme |
|-----|---------------|
| **Amaç** | AGENTS.md dosyası oluşturmak veya yeniden yazmak için talimatlar |
| **Hedef Kullanıcı** | AI coding agent'lar (senin gibi ben) |
| **Yöntem** | Signal Density (Sinyal Yoğunluğu) odaklı |
| **Çıktı** | Minimal, high-value, proje-özel kurallar dosyası |
| **Dil** | İngilizce (orijinal) |

---

## ✅ GÜÇLÜ YÖNLER

### 1. Minimalizm Prensibi
```
"Shorter is better if it preserves critical constraints"
```
- Gereksiz bilgiyi eleme odaklı
- Her kelime değerli olmalı
- Kısa = Güçlü

### 2. Signal Density Felsefesi
**4 Kriter:**
1. ✅ Project-specific (proje-özel)
2. ✅ Non-obvious (açık olmayan)
3. ✅ Action-guiding (eylem yönlendirici)
4. ✅ Mistake-preventing (hata önleyici)

### 3. Hard Constraints Vurgusu
- "Prefer 'must / must not' rules over vague recommendations"
- Net kurallar > Tavsiyeler
- Belirsizlik yok

### 4. Deduplication Stratejisi
- README, onboarding, style guide tekrarı yok
- Tooling (linter, CI) kuralları yok (exception varsa hariç)
- Generic best practices yok

### 5. Output Odaklılık
```
"Output ONLY the final AGENTS.md content (no commentary, no analysis, no preface)"
```
- Sadece çıktı, analiz yok
- Kısa Markdown
- Checklist formatı

---

## ⚠️ EKSİK VE BELİRSİZ ALANLAR

| Alan | Durum | Eksiklik | Öneri |
|------|-------|----------|-------|
| **Proje-spesifik Context** | Eksik | AidatPanel özel bilgileri yok | Proje analizi yapılmalı |
| **Mevcut AGENTS.md Değerlendirmesi** | Yok | Eski dosya nasıl yorumlanacak? | Rewrite mode detayları var ama referans yok |
| **Quality Bar Metrikleri** | Tanımsız | "Real mistake" nasıl tanımlanacak? | Proje-özel örnekler gerekli |
| **Validation Komutları** | Örnek Yok | `flutter test` gibi spesifik komutlar? | AidatPanel'e göre doldurulmalı |
| **Known Gotchas Listesi** | Boş | Geçmiş hatalar dokümante edilmemiş | Ekip geçmişi analizi gerekli |

---

## 🎯 ÖNERİLEN AGENTS.md YAPISI (AidatPanel için)

```markdown
# AGENTS.md - AidatPanel Flutter

## Must-follow Constraints
- [Kritik kural 1]
- [Kritik kural 2]

## Validation Before Finishing
- `flutter analyze`
- `flutter test`
- Emulator'da test (emulator-5554)

## Repo-specific Conventions
- Dummy data koru (backend hazır değil)
- Türkçe UI metinleri (16sp min)
- BottomNavigationBar zorunlu

## Important Locations
- `mobile/lib/` - Ana kod
- `mobile/pubspec.yaml` - Versiyon

## Change Safety Rules
- Versiyon değişikliği SADECE kullanıcı onayıyla
- Backend entegrasyonu izinli

## Known Gotchas
- Kotlin daemon çökmeleri
- Windows path sorunları
```

---

## 📊 KALİTE KONTROL LİSTESİ (AGENTS.md için)

Her maddeyi yazmadan önce kontrol:
- [ ] Bu bilgi proje-özel mi? (Generic değil mi?)
- [ ] Açık olmayan bir şey mi? (Obvious değil mi?)
- [ ] Eylem yönlendirici mi? (Vague değil mi?)
- [ ] Hata önleyici mi? (Nice-to-know değil mi?)
- [ ] "Must/must not" formatında mı?
- [ ] Kısa ve öz mü?

---

## 🚀 UYGULAMA ADIMLARI

### Adım 1: Proje Analizi
AidatPanel özel bilgileri topla:
- Flutter stack (Riverpod, GoRouter, Dio)
- Kritik workflow'lar (versiyon, backend, dummy data)
- Bilinen sorunlar (Kotlin daemon, Windows path)
- Ekip kuralları (Furkan'ın onay gerektiren işlemleri)

### Adım 2: AGENTS.md Taslağı
Yukarıdaki yapıya göre doldur:
- Must-follow constraints (5-10 madde)
- Validation komutları (3-5 komut)
- Repo conventions (5-7 madde)
- Gotchas (3-5 bilinen sorun)

### Adım 3: Kalite Kontrol
Signal Density kriterlerine göre gözden geçir:
- Her madde 4 kriterden en az 2'sine uymalı
- Generic içerikleri çıkar
- Tekrarları birleştir

### Adım 4: Output
Sadece AGENTS.md içeriği, yorum yok.

---

## 💡 KRİTİK BAŞARI FAKTÖRLERİ

1. **Minimalizm** - Kısa ama kritik
2. **Proje-özel** - AidatPanel'e has
3. **Eylem odaklı** - "Must/must not"
4. **Hatadan öğrenme** - Gotchas'lar gerçek hatalardan
5. **Güncellenebilir** - Sürekli revizyon

---

## 📁 SONRAKİ ADIMLAR

1. AidatPanel proje analizi yap
2. Signal Density kriterlerine göre AGENTS.md oluştur
3. Kalite kontrolünden geçir
4. `analiz_raporlari/agents_promptu_analizi/` içine kaydet
5. Furkan onayı al

---

**Analiz Tamamlandı:** 2026-05-03  
**Klasör:** `analiz_raporlari/agents_promptu_analizi/`  
**Sonraki Adım:** AidatPanel için AGENTS.md oluştur
