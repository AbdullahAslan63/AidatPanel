# AidatPanel

Türk apartman ve site yöneticileri için geliştirilmiş mobil aidat yönetim platformu.

## 📱 Proje Yapısı

```
aidatpanel/
├── backend/          # Node.js + Express API (Abdullah)
│   ├── src/         # API kodları
│   ├── prisma/      # Veritabanı şeması
│   └── README.md    # Backend dokümantasyonu
├── mobile/           # Flutter uygulaması (Furkan)
└── web/              # Landing page (Seyyid)
```

## 👥 Ekip

| İsim | Rol | Görev |
|------|-----|-------|
| **Abdullah** | Backend Lead | API, Veritabanı, DevOps |
| **Furkan** | Mobile Developer | Flutter uygulaması |
| **Yusuf** | Full-Stack | API geliştirme, Dashboard |
| **Seyyid** | UI/UX | Tasarım, Landing Page |

## 📚 Dokümantasyon

- [Furkan için Flutter Rehberi](backend/FURKAN_ICIN_DOKUMANTASYON.md) - JWT entegrasyonu ve API kullanımı
- [Yusuf için API Rehberi](backend/YUSUF_ICIN_DOKUMANTASYON.md) - Backend API geliştirme
- [Backend API](backend/README.md) - API endpoint listesi ve kullanımı
- [Proje Detayları](AIDATPANEL.md) - Master reference dokümanı
- [Görev Dağılımı](GOREVDAGILIMI.md) - Fazlar ve sorumluluklar

## 🚀 Başlangıç

Her klasörün kendi README.md'sine bakın:
- `backend/README.md` - Backend kurulumu ve çalıştırma
- `mobile/` - Flutter projesi (henüz oluşturulmadı)
- `web/` - Landing page (Seyyid)

## 🛠️ Teknoloji Stack

- **Backend:** Node.js, Express, Prisma, PostgreSQL
- **Mobile:** Flutter, Riverpod, GoRouter
- **Auth:** JWT (Access + Refresh Token)

## 📝 Not

Bu repo 4 kişilik ekip çalışması için hazırlanmıştır. Her geliştirici kendi branch'inde çalışır.