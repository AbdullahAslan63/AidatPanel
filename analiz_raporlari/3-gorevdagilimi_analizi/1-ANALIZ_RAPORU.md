# GorevDagilimi.md - Analiz Raporu

## Analiz Tarihi
2026-05-05

## Analiz Edilen Kaynak
**Dosya:** `planning/GOREVDAGILIMI.md`  
**Tür:** Proje Yol Haritası ve Görev Dağılımı  
**Hedef Kitle:** AidatPanel geliştirme ekibi

---

## Proje Ekibi ve Hiyerarşi

| Öğrenci | Rol | Odak Noktası | Yetenek Seviyesi |
|---------|-----|--------------|------------------|
| **Abdullah** | Lead Developer | Backend Mimari, DevOps, Entegrasyonlar | En Deneyimli |
| **Furkan** | Senior Mobile | Flutter Core, Kritik Yönetici Modülleri | İkinci |
| **Yusuf** | Junior Full-Stack | API Geliştirme, Sakin Dashboard | Üçüncü |
| **Seyit** | Junior UI/UX | Tasarım Sistemi, Landing Page, Bildirimler | Dördüncü |

**Hiyerarşi:** Abdullah > Furkan > Yusuf > Seyit

---

## Faz Bazlı Görev Dağılımı

### 🚀 Faz 1: Temel Altyapı ve Kimlik Doğrulama (MVP-1)
**Hedef:** Veritabanının kurulması ve güvenli giriş/kayıt sisteminin tamamlanması

#### Abdullah (Backend Lead)
- ✅ PostgreSQL veritabanı kurulumu ve Prisma şeması tasarımı
- ✅ JWT tabanlı Auth sistemi (Access/Refresh token) ve şifreleme
- ✅ API mimarisinin kurulması (`/api/v1` prefix)

#### Furkan (Mobile Core)
- Flutter projesinin temiz mimari (Clean Architecture) ile başlatılması
- Riverpod state management ve GoRouter navigasyon altyapısı
- Login ve Register ekranlarının backend entegrasyonu

#### Yusuf (Building API)
- Bina ve Daire CRUD (Ekle/Sil/Listele) endpoint'lerinin yazılması
- Yönetici bazlı veri filtreleme mantığının kurulması

#### Seyit (UI & Web)
- `AppColors`, `AppTypography` ve ortak widget'ların oluşturulması
- HTML/CSS ile statik Landing Page hazırlanması

---

### 🚀 Faz 2: Aidat Sistemi ve Onboarding (MVP-2)
**Hedef:** Aidat döngüsünün başlatılması ve sakinlerin davet koduyla katılımı

#### Abdullah (Logic & Payment)
- Davet kodu (Invite Code) üretim ve doğrulama algoritması
- Toplu aidat oluşturma (Bulk creation) arka plan işleri
- RevenueCat abonelik kontrol middleware'i

#### Furkan (Manager Hub)
- Yönetici ekranı: Daire listesi, davet kodu yönetimi (Pop-up)
- Aidat ödeme durumlarını (Ödendi/Bekliyor) manuel değiştirme arayüzü

#### Yusuf (Resident Hub)
- Sakin ekranı: "Davet Koduyla Katıl" akışı
- Kendi aidat geçmişini görüntüleme ve filtreleme ekranı

#### Seyit (Notify & i18n)
- Firebase FCM (Push Notification) entegrasyonu
- Uygulama içi yerelleştirme (TR/EN) için ARB dosyalarının yönetimi

---

### 🚀 Faz 3: Giderler, Destek ve Raporlama (Final)
**Hedef:** Finansal raporlama ve kullanıcı destek sisteminin eklenmesi

#### Abdullah (Reporting)
- PDF Rapor oluşturma servisi (Aylık bina özeti)
- Twilio WhatsApp/SMS hatırlatıcı servisinin API entegrasyonu

#### Furkan (Ticket System)
- Arıza/Talep (Ticket) sistemi mobil arayüzü
- Sakin hata bildirimi ve yönetici yanıt akışının kurulması

#### Yusuf (Finance)
- Gider kayıt sistemi (Gider ekleme, kategori seçimi)
- Bina bazlı aylık gider özeti API'ları

#### Seyit (UX Fixes)
- Profil düzenleme ve şifre yenileme ekranları
- Boş liste durumları (Empty State) ve hata mesajlarının UX iyileştirmesi

---

## Teknik Standartlar ve Kurallar

### 1. Kod İncelemesi (Code Review)
- **Abdullah** tüm Merge Request'leri (MR) inceleyerek onay verir

### 2. Git Akışı
- Herkes kendi branch'inde çalışır (örn: `feature/furkan-tickets`)

### 3. Tasarım Kısıtları (50+ Yaş Kullanıcılar İçin)
- Minimum font boyutu: **16sp**
- Minimum dokunma alanı: **48dp**
- Hamburger menü yerine **Bottom Navigation** kullanımı zorunlu

### 4. Hata Yönetimi
- Tüm hatalar kullanıcıya teknik terimlerden arındırılmış, anlaşılır Türkçe ile sunulacak

---

## Mevcut Durum Analizi (2026-05-05)

### Abdullah'nın İlerlemesi
**Faz 1 Status:** %75 Tamamlandı ✅
- ✅ Veritabanı + Prisma
- ✅ JWT Auth sistemi
- ✅ Bina/Daire CRUD
- 🔄 Davet kodu (başlanacak)

### Furkan'ın İlerlemesi
**Faz 1 Status:** %50 Tamamlandı 🔄
- ✅ Flutter proje yapısı
- ✅ Riverpod + GoRouter
- 🔄 Login/Register entegrasyonu

### Yusuf'un İlerlemesi
**Faz 1 Status:** %35 Tamamlandı 🔄
- ✅ Backend API kullanımı öğrenildi
- 🔄 Building API endpoint'leri

### Seyit'in İlerlemesi
**Faz 1 Status:** %25 Tamamlandı 🔄
- ✅ Tasarım sistemi başlangıcı
- 🔄 Landing Page

---

## Kritik Bağımlılıklar (Blockers)

### Faz 2 Başlangıcı İçin Gerekenler
1. **Abdullah:** Davet kodu algoritması tamamlanmalı
2. **Furkan:** Login entegrasyonu çalışır olmalı
3. **Yusuf:** Building API tamamlanmalı

### Faz 3 Başlangıcı İçin Gerekenler
1. **Abdullah:** Aidat sistemi tamamlanmalı
2. **Furkan:** Manager Hub ekranları hazır olmalı
3. **Seyit:** FCM entegrasyonu çalışır olmalı

---

## Risk Analizi

### Yüksek Risk 🔴
- **Abdullah:** Tek kişi tüm MR'ları onaylıyor (bottleneck riski)
- **Faz Sızıntısı:** AGENTS.md kuralına rağmen Faz 2 özelliklerine erken geçiş

### Orta Risk 🟡
- **Furkan ↔ Abdullah:** Backend API değişikliklerinde senkronizasyon
- **Yusuf:** Junior yetkinlik, kod review sürecinde daha fazla iterasyon

### Düşük Risk 🟢
- **Seyit:** UI/UX bağımsız çalışabilir, diğerlerine bağımlılık az

---

## Öneriler

### Abdullah İçin
1. **Delegasyon:** Yusuf'un yetkinliği arttıkça MR review'u kısmen devret
2. **Dokümantasyon:** API değişikliklerini hemen FURKAN_ICIN_DOKUMANTASYON.md'ye yaz
3. **Faz Disiplini:** Faz 1 bitmeden Faz 2'ye geçme, AGENTS.md kuralını koru

### Ekip İçin
1. **Sync Meetings:** Haftalık Furkan-Abdullah backend sync meeting'i
2. **API Contract:** Swagger/OpenAPI dokümantasyonu oluştur
3. **Test Coverage:** Her endpoint için test.py'ye senaryo ekleme zorunluluğu

---

## Sonuç

GorevDagilimi.md, AidatPanel projesinin **faz bazlı, yetenek seviyesine göre dağıtılmış** bir yol haritasıdır. Abdullah'ın liderliğinde, her fazda net sorumluluklar ve başarı kriterleri tanımlanmıştır.

**Anahtar Başarı Faktörü:** Faz disiplini ve Abdullah-Furkan senkronizasyonu.

---

**Analiz Raporu ID:** 1-GOREVDAGILIMI-ANALIZ  
**Son Güncelleme:** 2026-05-05
