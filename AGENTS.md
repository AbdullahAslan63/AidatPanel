# AGENTS.md - AidatPanel

## Must-follow Constraints

- **Faz 1 Only**: Sadece Faz 1 backend özellikleri implemente edilebilir (Auth, Building, Apartment). Faz 2+ kodları reddet.
- **Backend Only**: Şu an sadece backend API geliştiriliyor. Frontend/mobile kodu yazma.
- **No Edge Runtime**: Prisma edge runtime kullanma (Prisma Accelerate yok).
- **Rate Limiter**: `MemoryStore` kullan (Redis yok). Her deploy'da sıfırlanması kabul edilebilir.
- **No Expo**: Expo CLI veya Expo Go kullanımı yasak.
- **Pagination**: `skip/take` kullan (cursor pagination değil).
- **UUID Strings**: Tüm ID'ler string UUID olarak saklanır (Int değil).

## Validation Before Finishing

```bash
cd backend

# Test et (varsa)
npm test

# Lint kontrolü (varsa)
npm run lint

# Type kontrolü (varsa)
npm run typecheck

# Analiz raporlarını güncelle
npm run update-reports -- --write
```

## Repo-specific Conventions

### Rapor Güncelleme Prosedürü
Her backend değişikliği sonrası analiz raporları otomatik güncellenmelidir:

```bash
cd backend

# Önce durumu kontrol et (dry-run)
npm run update-reports

# Onaylandıktan sonra yaz
npm run update-reports -- --write
```

**Bu prosedür zorunludur çünkü:**
- Analiz raporları planlama için tek kaynak
- Manuel güncelleme unutuluyor
- Ekip ilerlemesini görmek için kritik

### Git Hook (Opsiyonel)
Otomatik güncelleme için pre-commit hook eklenebilir:
```bash
echo '#!/bin/sh
cd backend && npm run update-reports -- --write' > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## Important Locations

- **Backend**: `backend/src/`
- **Controllers**: `backend/src/controllers/`
- **Routes**: `backend/src/routes/`
- **Scripts**: `scripts/` (rapor güncelleme)
- **Analiz Raporları**: `analiz_raporlari/`
- **Prisma Schema**: `backend/prisma/schema.prisma`

## Change Safety Rules

- **Backward Compatibility**: Mevcut endpoint'leri değiştirmeden yeni ekle.
- **Model Changes**: Prisma schema değişikliği yapmadan önce mevcut veriyi dikkate al.
- **API Contract**: `success`, `message`, `data` response formatını koru.

## Known Gotchas

1. **join fonksiyonu**: Auth controller'da yorumda (`/* ... */`). Bu Faz 2'ye aittir, Faz 1'de implemente edilmez.
2. **inviteCode validate**: Henüz implemente edilmedi (sadece generate var).
3. **TODO Comments**: Kodda `TODO` veya `FIXME` yorumları varsa bunlar raporlara yansır.
