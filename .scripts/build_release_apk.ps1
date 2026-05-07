# AidatPanel Release APK Build Script
# Calistir: Right-click - Run with PowerShell

Write-Host '=== AidatPanel Release APK Build ===' -ForegroundColor Cyan

# Proje dizinine git
Set-Location -Path 'C:\AidatPanel\mobile'

# pubspec.yaml'dan versiyonu oku (X.Y.Z+N formati)
$pubspecContent = Get-Content 'pubspec.yaml' -Raw
if ($pubspecContent -match 'version:\s*([0-9.]+)\+(\d+)') {
    $baseVersion = $matches[1]
    $oldBuildNumber = [int]$matches[2]
    $newBuildNumber = $oldBuildNumber + 1
    $version = $baseVersion + '+' + $newBuildNumber
    $versionFolder = 'v' + $baseVersion
    
    Write-Host ('Mevcut: ' + $baseVersion + '+' + $oldBuildNumber) -ForegroundColor Gray
    Write-Host ('Yeni build number: ' + $newBuildNumber) -ForegroundColor Yellow
    
    # pubspec.yaml'i guncelle (build number +1)
    $newContent = $pubspecContent -replace ('version:\s*' + $baseVersion + '\+' + $oldBuildNumber), ('version: ' + $version)
    Set-Content -Path 'pubspec.yaml' -Value $newContent -NoNewline
    Write-Host ('pubspec.yaml guncellendi: ' + $version) -ForegroundColor Green
} elseif ($pubspecContent -match 'version:\s*([0-9.]+)') {
    # Build number yoksa +1 ekle
    $baseVersion = $matches[1]
    $version = $baseVersion + '+1'
    $versionFolder = 'v' + $baseVersion
    
    Write-Host ('Build number yok, +1 ekleniyor...') -ForegroundColor Yellow
    $newContent = $pubspecContent -replace ('version:\s*' + $baseVersion), ('version: ' + $version)
    Set-Content -Path 'pubspec.yaml' -Value $newContent -NoNewline
    Write-Host ('pubspec.yaml guncellendi: ' + $version) -ForegroundColor Green
} else {
    Write-Host 'Versiyon okunamadi! pubspec.yaml kontrol et' -ForegroundColor Red
    pause
    exit 1
}

Write-Host ''
Write-Host '[1/5] Flutter clean...' -ForegroundColor Yellow
flutter clean

Write-Host ''
Write-Host '[2/5] Dependencies yukleniyor...' -ForegroundColor Yellow
flutter pub get

Write-Host ''
Write-Host '[3/5] Release APK build...' -ForegroundColor Yellow
flutter build apk --release

if ($LASTEXITCODE -eq 0) {
    Write-Host ''
    Write-Host 'Build basarili!' -ForegroundColor Green
    
    # Kaynak APK
    $source = 'C:\AidatPanel\mobile\build\app\outputs\flutter-apk\app-release.apk'
    
    # Hedef klasor yapisi
    $baseDir = 'C:\AidatPanel APK'
    $versionDir = $baseDir + '\' + $versionFolder
    $destFile = $versionDir + '\aidatpanel-' + $versionFolder + '.apk'
    
    # Ana klasor yoksa olustur
    if (!(Test-Path $baseDir)) {
        New-Item -ItemType Directory -Path $baseDir -Force
        Write-Host ('Ana dizin olusturuldu: ' + $baseDir) -ForegroundColor Gray
    }
    
    # Versiyon klasoru kontrol et
    if (Test-Path $versionDir) {
        Write-Host ('Versiyon klasoru bulundu: ' + $versionFolder) -ForegroundColor Yellow
        Write-Host '  Mevcut icerik temizleniyor...' -ForegroundColor Gray
        
        # Klasorun icini temizle
        Get-ChildItem -Path $versionDir -Recurse | Remove-Item -Force -Recurse
        Write-Host '  Icerik temizlendi' -ForegroundColor Green
    } else {
        Write-Host ('Versiyon klasoru olusturuluyor: ' + $versionFolder) -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $versionDir -Force
        Write-Host '  Klasor olusturuldu' -ForegroundColor Green
    }
    
    # APK'yi kopyala
    Copy-Item -Path $source -Destination $destFile -Force
    
    Write-Host ''
    Write-Host 'APK kaydedildi:' -ForegroundColor Green
    Write-Host ('  Konum: ' + $destFile) -ForegroundColor White
    
    Write-Host ''
    Write-Host 'Telefona yuklemek icin:' -ForegroundColor Cyan
    Write-Host '  1. USB ile telefona kopyala' -ForegroundColor White
    Write-Host '  2. Telefonda dosyaya dokunarak yukle' -ForegroundColor White
    Write-Host '  3. Bilinmeyen kaynak uyarisi verirse IZIN VER' -ForegroundColor White
    
    # APK boyutunu goster
    $size = (Get-Item $destFile).Length / 1MB
    Write-Host ''
    Write-Host ('Boyut: ' + [math]::Round($size, 2) + ' MB') -ForegroundColor Gray
    Write-Host ('Klasor: C:\AidatPanel APK\' + $versionFolder + '\') -ForegroundColor Gray
    
} else {
    Write-Host ''
    Write-Host 'Build basarisiz!' -ForegroundColor Red
    Write-Host 'Hata mesajini kontrol et' -ForegroundColor Yellow
}

Write-Host ''
Write-Host '=== Tamamlandi ===' -ForegroundColor Cyan
pause
