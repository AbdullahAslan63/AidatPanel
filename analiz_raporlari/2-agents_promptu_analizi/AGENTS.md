# 3️⃣ AGENTS.md

## AGENTS.md

AidatPanel — Flutter mobile + Node.js backend (apartman aidat yönetimi, hedef kitle 50+ yaş).

## Must-follow constraints

- **UI dili Türkçe**, teknik jargon yasak: "Aidat Ekle" ✅, "Add Due" / "Mark as Paid" / "Error 422" ❌. Hata mesajları kullanıcıya Türkçe + insanca.
- **50+ yaş erişilebilirlik kısıtları (DÜŞÜRÜLEMEZ):** font min `16sp`, primary buton `56dp`, secondary buton `48dp`, dokunma alanı min `48x48dp`, ikon `24dp`. `MediaQuery.textScaleFactor` kısıtlanmaz.
- **Navigasyon:** `BottomNavigationBar` zorunlu. Hamburger / Drawer menü YASAK.
- **Renkler sabit:** primary `#1B3A6B`, accent `#F59E0B`, success `#16A34A`, error `#DC2626`. Yeni renk eklemeden önce design system'e ekle.
- **Versiyon değişikliği SADECE Furkan onayıyla.** `pubspec.yaml`'daki `version` alanına otomatik dokunma.
- **Hard delete operasyonları onay dialog'u ZORUNLU** (sakin, daire, bina, aidat silme). Soft delete kullanılmıyor.
- **Decimal finansal alanlar:** Aidat/gider tutarları `Decimal(10,2)`, `double`/`float` kullanma (yuvarlama hatası).
- **JWT süresi:** access token `15 dakika`, refresh token `30 gün`. Mobile'da bu süreleri override etme — backend ile uyumlu kalmalı.

## Validation before finishing

- `flutter analyze` (mobile/) — 0 issue olmalı
- `flutter test` (mobile/) — testler eklendikçe çalıştır
- Yeni screen/feature ekledikten sonra emulator-5554'te smoke test (login → ekran → çıkış)
- Backend endpoint değişikliğinde Postman/curl ile manuel test
- `flutter pub get` çalıştır, `pubspec.lock` farklarını gözden geçirip commit et

## Repo-specific conventions

- **Branch naming:** `feature/{name}-{task}` (örn: `feature/furkan-tickets`). Diğer formatlar reddedilir.
- **MR review:** Tüm pull request'leri **Abdullah** onaylar — bypass yok.
- **Mimari:** Feature-based Clean Architecture — `mobile/lib/features/{feature}/{data,domain,presentation}/`. Yeni dosyaları core/ veya shared/ altına atmadan önce gerçekten reusable olduğundan emin ol.
- **State management:** Riverpod (`flutter_riverpod ^2.5.0`). Provider/BLoC karıştırma. `StatefulWidget` yerine `ConsumerStatefulWidget`.
- **Navigation:** GoRouter (`^13.0.0`). `Navigator.push` direkt kullanma, route'u router config'e ekle.
- **HTTP:** Dio + interceptors. Yeni HTTP client başlatma — `DioClient` provider'ını kullan.
- **Secure storage:** Token/PII için `flutter_secure_storage`. `SharedPreferences`'a token YAZMA.
- **Code generation:** `freezed` + `json_serializable`. Manuel `fromJson`/`toJson` yazma.
- **API base:** `https://api.aidatpanel.com:4200` — `http://` ile başlayan URL commit etme (production trap).
- **Versiyonlama:** `pubspec.yaml` formatı `0.0.8+1` (build number zorunlu). Sadece `0.0.8` reddedilir.
- **Liste render:** 10+ item potansiyeli olan `ListView`'larda **`ListView.builder` zorunlu**. `ListView(children: [...])` 50+ dairelik binalarda lag yapar.
- **Dokümantasyon:** Major analiz/karar `analiz_raporlari/` altına tarihli + başlıklı + versiyon numaralı kaydet.

## Important locations

- `planning/` — Kaynak prompt dosyaları (MASTER, AGENTS, GOREVDAGILIMI, AIDATPANEL, OPTIMIZASYON, GUVENLIK)
- `analiz_raporlari/` — Her promptun analizi ayrı klasörde (1-master..., 2-agents..., vb.)
- `analiz_raporlari/4-aidatpanel_analizi/ANALIZ_RAPORU.md` — Stack, API, design system referans
- `HATA_ANALIZ_RAPORU.md` — Bilinen 15 kritik hata + düzeltme sırası
- `mobile/lib/core/constants/api_constants.dart` — API endpoint'leri tek kaynak
- `mobile/lib/core/network/dio_client.dart` — HTTP interceptor + refresh token mantığı
- `mobile/lib/features/{feature}/data/repositories/` — Repository implementasyonları (auth_repository_impl.dart vs.)

## Change safety rules

- **API kontratı değişikliği** = backend + mobile aynı PR'da güncellenir. Sadece bir tarafta değiştirme.
- **Database migration** Prisma üzerinden. `npx prisma migrate dev --name <açıklama>` — manuel SQL yazma.
- **Yeni paket eklemeden önce** `pubspec.lock`'ta benzer işi yapan paket var mı kontrol et (Furkan duplicate paketten hoşlanmaz).
- **Dummy data temizliği:** `mobile/lib/features/buildings/data/buildings_store.dart` ve `apartments_store.dart` hardcoded data içeriyor. Backend entegrasyonunda bunları silip API'ye bağla — yarım bırakma.
- **Token expiry mismatch:** `auth_repository_impl.dart`'da access token 30 gün set edilmiş (yanlış). Backend 15dk veriyor — düzeltirken refresh token'ı ayrı sakla.
- **Refresh token interceptor sonsuz döngü riski:** `DioClient`'ta refresh isteği için **ayrı Dio instance** kullan (interceptor'sız), aynı client'la deneme.

## Known gotchas

- **Kotlin daemon çökmesi (Windows):** `flutter run` build sırasında "Kotlin daemon" hatası verirse: `cd android && .\gradlew --stop` sonra build cache temizle. Sık tekrarlıyor.
- **Windows path uzunluğu:** Build path'leri 260 karakteri aşabilir. Proje köküne yakın bir path'te (örn `C:\AidatPanel`) tut.
- **`intl` versiyon uyumsuzluğu:** `intl: ^0.20.2` Flutter SDK 3.11.5 ile çakışabilir. `dependency_overrides: intl: ^0.19.0` gerekirse.
- **`run_command` PowerShell trap:** Cascade/agent komut çalıştırırken `cd <dir> && <cmd>` YERİNE `Cwd` parametresi kullan. PowerShell'de `&&` farklı davranabilir.
- **Emulator-5554 dependency:** Test/screenshot görevleri bu emulator'ı varsayar. Farklı emulator açıksa belirt.
- **`flutter clean` sonrası ilk build yavaş:** ~5-10 dk normal. Timeout ayarlamadan agent komut çalıştırma.
- **Cached_network_image cache temizliği:** Resim güncellemesi görünmüyorsa `CachedNetworkImage.evictFromCache()` veya manuel cache reset.
- **RevenueCat configure çağrısı eksik:** `purchases_flutter` paketi `pubspec.yaml`'da var ama `Purchases.configure()` `main.dart`'ta çağrılmıyor — abonelik testi için manual ekle.
- **FCM handler yok:** `firebase_messaging` paketi yüklü ama `onMessage.listen` ve `onBackgroundMessage` handler'ları yazılmamış. Push notification entegrasyonunda eklenmeli.

---

**Versiyon:** 1.0  
**Son Güncelleme:** 2026-05-03  
**Sonraki Review:** Aylık veya stack değişikliğinde
