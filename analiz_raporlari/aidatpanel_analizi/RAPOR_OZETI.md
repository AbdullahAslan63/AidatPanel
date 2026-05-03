# AIDATPANEL ANALİZ ÖZETİ

**Tarih:** 2026-05-03  
**Kaynak:** planning/AIDATPANEL.md  
**Durum:** ✅ Analiz Tamamlandı

---

## 🎯 ÖZET

AidatPanel, **Türk apartman yöneticileri** için geliştirilmiş **Flutter + Node.js** mobil aidat yönetim platformu.

---

## ✅ PROJE ÖZETİ

| Özellik | Değer |
|---------|-------|
| **Platform** | iOS + Android (Flutter) |
| **Backend** | Node.js + Express + Prisma + PostgreSQL |
| **Domain** | aidatpanel.com |
| **API** | api.aidatpanel.com:4200 |
| **Hedef** | 50+ yaş kullanıcılar |

---

## 🏗️ TEKNİK STACK

### Backend
- **Runtime:** Node.js 20+
- **Framework:** Express.js
- **ORM:** Prisma
- **Database:** PostgreSQL
- **Auth:** JWT (15dk access, 30 gün refresh)
- **Push:** Firebase FCM
- **SMS/WhatsApp:** Twilio
- **Payments:** RevenueCat

### Flutter
- **State:** Riverpod ^2.5.0
- **Navigation:** GoRouter ^13.0.0
- **Network:** Dio ^5.4.0
- **Storage:** flutter_secure_storage ^9.0.0
- **IAP:** purchases_flutter ^7.0.0

---

## 🗄️ VERİTABANI ŞEMASI

### Ana Modeller
| Model | Amaç |
|-------|------|
| **User** | Yönetici ve sakinler (MANAGER/RESIDENT) |
| **Building** | Apartman bilgisi |
| **Apartment** | Daire bilgisi |
| **Due** | Aidat kaydı (PENDING/PAID/OVERDUE) |
| **InviteCode** | Davet kodu (7 gün geçerli, tek kullanımlık) |
| **Ticket** | Arıza/talep |
| **Subscription** | Abonelik (ACTIVE/EXPIRED/CANCELLED) |

---

## 🔌 API YAPISI (40+ Endpoint)

### Kategoriler
- **Auth:** 6 endpoint (register, login, join, refresh, logout, forgot-password)
- **Buildings:** 5 endpoint (Yönetici CRUD)
- **Apartments:** 4 endpoint (Yönetici CRUD)
- **Dues:** 4 endpoint (bulk create, status update)
- **Tickets:** 5 endpoint (Sakin/Yönetici)
- **Notifications:** 4 endpoint
- **Reports:** 2 endpoint (PDF)
- **Subscription:** 2 endpoint (RevenueCat webhook)

---

## 👥 KULLANICI ROLLERİ

### MANAGER (Yönetici)
**Abonelik Aktifken:**
- Çoklu apartman yönetimi
- Daire CRUD + davet kodu
- Toplu aidat oluşturma
- Aidat durum güncelleme
- Gider kaydı (9 kategori)
- PDF rapor
- Arıza/talep takibi
- Push bildirimi

**Abonelik Dolduğunda:** Kilitlenir

### RESIDENT (Sakin)
**Abonelikten Bağımsız:**
- Kendi aidat durumu ve geçmişi
- Arıza/talep oluşturma
- Bildirimleri görme

---

## 🎨 TASARIM SİSTEMİ (50+ Yaş)

### Temel İlke
**Sade, güvenilir, net. Şov değil, işlevsellik.**

### Renkler
- **primary:** #1B3A6B (Koyu lacivert)
- **accent:** #F59E0B (Amber)
- **success:** #16A34A
- **error:** #DC2626

### Boyutlar (Kritik!)
- Font: **minimum 16sp** (asla altına inme)
- Buton: **56dp** yükseklik
- Dokunma: **48x48dp**
- `textScaleFactor` **kısıtlanmamalı**

### Navigasyon
**BottomNavigationBar zorunlu - Hamburger menü YASAK!**

### UI Metinleri
```
✅ "Aidat Ekle"      ❌ "Add Due"
✅ "Ödendi İşaretle" ❌ "Mark as Paid"
```

---

## 💳 ABONELİK SİSTEMİ (RevenueCat)

| Plan | ID | Fiyat |
|------|-------|-------|
| Aylık | `aidatpanel_monthly` | ₺99/ay |
| Yıllık | `aidatpanel_annual` | ₺799/yıl |

**Webhook Olayları:** INITIAL_PURCHASE, RENEWAL, CANCELLATION, EXPIRATION, BILLING_ISSUE

---

## 🚀 MVP FAZLARI

### Faz 1 — Çekirdek
- Auth (register, login, JWT, davet kodu)
- Bina/daire CRUD
- Aidat sistemi
- FCM push
- RevenueCat abonelik
- Landing page

### Faz 2 — Tamamlama
- Gider kaydı
- Ticket sistemi
- WhatsApp hatırlatma
- PDF rapor
- i18n (TR/EN)

### Faz 3 — Büyüme
- Online ödeme (İyzico/PayTR)
- Çoklu yönetici
- İstatistik dashboard
- Belge paylaşımı

---

## ⚠️ EKSİK ALANLAR

| Alan | Öneri |
|------|-------|
| API Dokümantasyonu | Swagger/OpenAPI ekle |
| Rate Limiting | Express rate limit |
| Caching | Redis değerlendir |
| Testing | Unit/integration test |
| Monitoring | Health check + metrics |
| Backup | PostgreSQL backup planı |

---

## 🎯 KRİTİK BAŞARI FAKTÖRLERİ

1. **50+ Yaş Uyumu** - UI her kararda bu gerçeği gözetmeli
2. **Offline-First** - Cache stratejisi kritik
3. **Türkçe Öncelik** - i18n var, primary TR
4. **Abonelik Kilidi** - RevenueCat entegrasyonu kritik
5. **Davet Kodu** - Onboarding kritik noktası
6. **PDF Rapor** - Yöneticiler için olmazsa olmaz

---

## 📁 SONRAKİ ADIM

1. API Dokümantasyonu (Swagger)
2. Rate Limiting
3. Testing stratejisi
4. Monitoring

---

**Hazır:** Evet, eksik alanlar planlanabilir
