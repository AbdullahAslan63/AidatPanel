# GOREVDAGILIMI ANALİZ ÖZETİ

**Tarih:** 2026-05-03  
**Kaynak:** planning/GOREVDAGILIMI.md  
**Durum:** ✅ Analiz Tamamlandı

---

## 🎯 ÖZET

AidatPanel projesi için **3 fazlı MVP** yapısı ve **4 kişilik ekip** görev dağılımı.

---

## ✅ GÜÇLÜ YÖNLER

- ✅ **Net rol tanımları:** Abdullah (Lead), Furkan (Senior), Yusuf/Seyit (Junior)
- ✅ **Faz bazlı ilerleme:** MVP-1 → MVP-2 → Final
- ✅ **Yetenek hiyerarşisi:** Görevler yetenek seviyesine uygun
- ✅ **Teknik standartlar:** Code review, Git workflow, 50+ yaş kısıtları

---

## ⚠️ KRİTİK RİSK: Furkan'ın Yükü

| Faz | Furkan'ın Görevi | İş Yükü |
|-----|------------------|---------|
| Faz 1 | Flutter projesi, Auth | %35 |
| Faz 2 | Manager Hub | **%40** |
| Faz 3 | Ticket sistemi | **%35** |

**Risk:** Furkan Faz 2-3'te en yüksek workload sahibi ve kritik modüllerin tek sorumlusu.

**Öneri:** Knowledge transfer planı, bus factor azaltma.

---

## 📊 EKİP YAPISI

| Üye | Rol | Odak | Seviye |
|-----|-----|------|--------|
| Abdullah | Lead Developer | Backend, DevOps | ⭐⭐⭐ |
| **Furkan** | Senior Mobile | Flutter Core | ⭐⭐⭐ |
| Yusuf | Junior Full-Stack | API, Dashboard | ⭐⭐ |
| Seyit | Junior UI/UX | Tasarım, Web | ⭐⭐ |

---

## 🚀 FAZLAR ÖZETİ

### Faz 1 (MVP-1): Temel Altyapı
- Backend: PostgreSQL, Prisma, JWT (Abdullah)
- Mobile: Flutter projesi, Riverpod, GoRouter, Auth (Furkan)
- API: Bina/Daire CRUD (Yusuf)
- UI: Design system, Landing Page (Seyit)

### Faz 2 (MVP-2): Aidat Sistemi
- Backend: Davet kodu, Aidat bulk, RevenueCat (Abdullah)
- Mobile: Manager Hub, Aidat durum (Furkan)
- Mobile: Resident Hub, Davet kodu katılım (Yusuf)
- UI: Push notification, i18n (Seyit)

### Faz 3 (Final): Giderler ve Destek
- Backend: PDF rapor, WhatsApp/SMS (Abdullah)
- Mobile: Ticket sistemi (Furkan)
- API: Gider kayıt, özet (Yusuf)
- UI: Profil, UX polish (Seyit)

---

## 📋 TEKNİK STANDARTLAR

| Standart | Kural |
|----------|-------|
| Code Review | Abdullah tüm MR'ları onaylar |
| Git Workflow | Herkes kendi branch'inde: `feature/{name}-{task}` |
| 50+ Yaş | 16sp font, 48dp touch, BottomNav zorunlu |
| Hata Mesajları | Teknik jargon yok, Türkçe, anlaşılır |

---

## ⚠️ EKSİK ALANLAR

| Alan | Öneri |
|------|-------|
| Zaman çizelgesi | Faz 1 için gün/hafta planı ekle |
| Risk yönetimi | Furkan unavailable senaryosu planla |
| Definition of Done | Her faz için "tamamlandı" kriteri |
| Sync meeting | Günlük/haftalık toplantı rutini |

---

## 🎯 SONRAKİ ADIM

1. **Furkan Risk Planı:** Knowledge transfer ve yedekleme
2. **Timeline:** Faz 1 için detaylı zaman planı
3. **DoD:** Her faz için başarı kriterleri

---

**Hazır:** Evet, risk planı ve timeline eklenebilir
