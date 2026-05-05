# AidatPanel Master Reference - Rapor Özeti

## 🎯 Proje Özeti
**AidatPanel:** Türk apartman yöneticileri için mobil aidat yönetim platformu  
**Platform:** iOS + Android (Flutter) + Node.js Backend

## 🏗️ Teknik Stack

| Katman | Teknoloji |
|--------|-----------|
| **Backend** | Node.js 20+, Express, Prisma |
| **Database** | PostgreSQL |
| **Mobile** | Flutter + Riverpod + GoRouter |
| **Auth** | JWT (15dk access / 30gün refresh) |
| **Notifications** | Firebase FCM + Twilio WhatsApp |
| **Payments** | RevenueCat (iOS/Android IAP) |
| **Deployment** | PM2 + Contabo VPS |

## 📊 MVP İlerleme Durumu

### Faz 1 (Çekirdek) - %75 Tamamlandı ✅
| Modül | Durum |
|-------|-------|
| Auth sistemi | ✅ Tamamlandı |
| Bina/Daire CRUD | ✅ Tamamlandı |
| Davet kodu sistemi | 🔄 Başlanacak |
| Aidat yönetimi | ⏳ Planlandı |
| FCM Bildirimler | ⏳ Planlandı |
| RevenueCat | ⏳ Planlandı |

### Faz 2 (Tamamlama) - %0 Başlanmadı ⏳
- Gider kaydı, Ticket sistemi, WhatsApp, PDF rapor, i18n

### Faz 3 (Büyüme) - %0 Başlanmadı ⏳
- Online ödeme, Çoklu yönetici, Dashboard grafikleri

## 👥 Kullanıcı Rolleri

### MANAGER (Yönetici)
- Bina/daire yönetimi ✅
- Davet kodu üretimi 🔄
- Aidat oluşturma/güncelleme ⏳
- Gider kaydı ⏳
- PDF rapor ⏳

### RESIDENT (Sakin)
- Kendi aidat durumunu görme ⏳
- Arıza/talep oluşturma ⏳
- Bildirimleri görme ⏳

## 🔐 Sakin Onboarding (Davet Kodu)

```
Yönetici → "Davet Kodu Üret" (12 karakter, 7 gün geçerli, tek kullanımlık)
    ↓
Sakine iletilir (WhatsApp/kağıt/sözlü)
    ↓
Sakin uygulamaya katılır → Kayıt → Dashboard
```

## 🎨 Tasarım Kısıtları (50+ Yaş)

| Kural | Değer |
|-------|-------|
| Minimum font | **16sp** |
| Minimum dokunma | **48dp** |
| Navigasyon | **Bottom Navigation** (hamburger yasak) |
| Buton yüksekliği | **56dp** |
| Font ailesi | **Nunito** |

## ⚠️ Erişilebilirlik Checklist
- [ ] Tüm metinler ≥16sp
- [ ] Kontrast oranı 4.5:1+
- [ ] Tüm butonlar ≥48dp
- [ ] Semantics label'lar tanımlı
- [ ] textScaleFactor kısıtlaması yok
- [ ] Hata mesajları Türkçe

## 💰 Abonelik Planları

| Plan | Fiyat |
|------|-------|
| Aylık | ₺99/ay |
| Yıllık | ₺799/yıl |

---

**Rapor Özeti ID:** 2-AIDATPANEL-OZET
