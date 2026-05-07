<#
.SYNOPSIS
    AidatPanel Otomatik Rapor Senkronizasyon Script'i
    
.DESCRIPTION
    Her push'tan once calistir. Git diff analiz eder, degisen dosyalara gore
    tum analiz raporlarini otomatik gunceller. "Living document" prensibi.
    
.PARAMETER CommitMessage
    Opsiyonel commit mesaji. Verilmezse otomatik olusturulur.
    
.PARAMETER DryRun
    Sadece analiz et, dosyalari degistirme.
    
.PARAMETER SkipChangelog
    CHANGELOG.md'ye entry ekleme.
    
.EXAMPLE
    .\update_reports.ps1
    .\update_reports.ps1 -CommitMessage "feat: route guard eklendi"
    .\update_reports.ps1 -DryRun
#>

param(
    [string]$CommitMessage = "",
    [switch]$DryRun,
    [switch]$SkipChangelog
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path $PSScriptRoot -Parent

# Renkli cikti fonksiyonlari
function Write-Status($msg, $type = "Info") {
    $color = switch ($type) {
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error"   { "Red" }
        default   { "Cyan" }
    }
    Write-Host $msg -ForegroundColor $color
}

# =============================================================================
# 1. KONFIGURASYON
# =============================================================================

$script:now = Get-Date -Format "yyyy-MM-dd HH:mm"
$script:today = Get-Date -Format "yyyy-MM-dd"

# Rapor dosya yollari
$script:Reports = @{
    FAZ2            = "$repoRoot\resources\raporlar_arshiv\FAZ2_ONCESI_MUKEMMELLESME_RAPORU.md"
    HATA            = "$repoRoot\resources\raporlar_arshiv\HATA_ANALIZ_RAPORU.md"
    AGENTS          = "$repoRoot\resources\AGENTS_COMPLIANCE_AUDIT.md"
    GAP             = "$repoRoot\resources\analiz_raporlari\4-aidatpanel_analizi\3-AIDATPANEL_GAP_ANALIZI.md"
    OPTIMIZATIONS   = "$repoRoot\resources\analiz_raporlari\5-optimizasyon_promptu_analizi\3-OPTIMIZATIONS.md"
    SECURITY        = "$repoRoot\resources\analiz_raporlari\6-guvenlik_promptu_analizi\3-SECURITY_AUDIT.md"
    YOLHARITASI     = "$repoRoot\resources\YOL_HARITASI.md"
    CHANGELOG       = "$repoRoot\resources\CHANGELOG.md"
    OZET            = "$repoRoot\resources\analiz_raporlari\RAPOR_OZETI_GENEL.md"
}

# =============================================================================
# 2. DOSYA -> SORUN MAPPING (Eksiksiz)
# =============================================================================
# Her degisen kod dosyasi, hangi sorunlari kapatir?

$script:FileToIssues = @{
    # --- AUTH ---
    "mobile/lib/features/auth/presentation/providers/auth_provider.dart" = @(
        @{ ID = "K-01"; Title = "Login mock 30gun -> 15dk"; Reports = @("FAZ2","HATA","GAP","AGENTS") },
        @{ ID = "Y-03"; Title = "AuthState null safety"; Reports = @("FAZ2","AGENTS") }
    )
    "mobile/lib/features/auth/data/repositories/auth_repository_impl.dart" = @(
        @{ ID = "K-01"; Title = "Token expiry 15dk"; Reports = @("FAZ2","HATA","GAP","AGENTS","SECURITY","OPTIMIZATIONS") },
        @{ ID = "G12"; Title = "getStoredUser JSON"; Reports = @("GAP","HATA") }
    )
    
    # --- ROUTER ---
    "mobile/lib/core/router/app_router.dart" = @(
        @{ ID = "K-03"; Title = "Route guard (GoRouter redirect)"; Reports = @("FAZ2","AGENTS","SECURITY") }
    )
    
    # --- SPLASH ---
    "mobile/lib/features/auth/presentation/screens/splash_screen.dart" = @(
        @{ ID = "K-04"; Title = "Splash auth check"; Reports = @("FAZ2","AGENTS") }
    )
    
    # --- DASHBOARD ---
    "mobile/lib/features/buildings/presentation/screens/manager_dashboard_screen.dart" = @(
        @{ ID = "K-05"; Title = "Dashboard hardcoded user adi"; Reports = @("FAZ2","AGENTS") },
        @{ ID = "K-06"; Title = "Dashboard hardcoded stats"; Reports = @("FAZ2","AGENTS") }
    )
    "mobile/lib/features/apartments/presentation/screens/resident_dashboard_screen.dart" = @(
        @{ ID = "K-08"; Title = "Resident hardcoded PII"; Reports = @("FAZ2","AGENTS","SECURITY") },
        @{ ID = "Y-04"; Title = "Hardcoded transaction history"; Reports = @("FAZ2","AGENTS") }
    )
    
    # --- MANIFEST ---
    "mobile/android/app/src/main/AndroidManifest.xml" = @(
        @{ ID = "K-07"; Title = "Android Manifest guvenlik"; Reports = @("FAZ2","AGENTS","SECURITY","GAP") }
    )
    
    # --- SETTINGS ---
    "mobile/lib/shared/widgets/settings_tab.dart" = @(
        @{ ID = "Y-01"; Title = "Debug button kDebugMode wrap"; Reports = @("FAZ2","AGENTS") },
        @{ ID = "Y-05"; Title = "Fake language dialog disable"; Reports = @("FAZ2","AGENTS") }
    )
    
    # --- VALIDATORS ---
    "mobile/lib/core/utils/input_validators.dart" = @(
        @{ ID = "O-01"; Title = "ValidatedTextField dead code"; Reports = @("FAZ2","AGENTS","OPTIMIZATIONS") }
    )
    
    # --- DIOCLIENT ---
    "mobile/lib/core/network/dio_client.dart" = @(
        @{ ID = "Y-02"; Title = "DioClient refresh instance"; Reports = @("FAZ2","AGENTS","SECURITY","GAP","OPTIMIZATIONS") },
        @{ ID = "O-02"; Title = "DioClient error type safety"; Reports = @("FAZ2","AGENTS") },
        @{ ID = "F-04"; Title = "DioClient refresh infinite loop"; Reports = @("OPTIMIZATIONS","SECURITY","GAP") },
        @{ ID = "G03"; Title = "DioClient refresh loop"; Reports = @("GAP","SECURITY") }
    )
    
    # --- API CONSTANTS ---
    "mobile/lib/core/constants/api_constants.dart" = @(
        @{ ID = "G01"; Title = "HTTP -> HTTPS"; Reports = @("GAP","SECURITY","HATA","OPTIMIZATIONS") },
        @{ ID = "G09"; Title = "API constants fonksiyonlar"; Reports = @("GAP","HATA","OPTIMIZATIONS") }
    )
    
    # --- MAIN ---
    "mobile/lib/main.dart" = @(
        @{ ID = "K-02"; Title = "Turkce locale (tr_TR)"; Reports = @("FAZ2","AGENTS","GAP") }
    )
    
    # --- LISTVIEW ---
    "mobile/lib/features/buildings/presentation/screens/invite_code_screen.dart" = @(
        @{ ID = "G04"; Title = "ListView performans"; Reports = @("GAP","HATA","OPTIMIZATIONS","AGENTS") }
    )
    "mobile/lib/features/buildings/presentation/screens/add_building_screen.dart" = @(
        @{ ID = "G04"; Title = "ListView performans"; Reports = @("GAP","HATA","OPTIMIZATIONS","AGENTS") }
    )
    "mobile/lib/features/buildings/presentation/widgets/invite_code_result_view.dart" = @(
        @{ ID = "G04"; Title = "ListView performans"; Reports = @("GAP","HATA","OPTIMIZATIONS","AGENTS") }
    )
    
    # --- PUBSPEC ---
    "mobile/pubspec.yaml" = @(
        @{ ID = "G05"; Title = "Versiyon formati (+1)"; Reports = @("GAP","HATA") },
        @{ ID = "G06"; Title = "intl versiyon uyumlulugu"; Reports = @("GAP","HATA") }
    )
    
    # --- BUILD GRADLE ---
    "mobile/android/app/build.gradle" = @(
        @{ ID = "G15"; Title = "ProGuard/R8 obfuscation"; Reports = @("GAP","HATA","OPTIMIZATIONS") }
    )
}

# =============================================================================
# 3. GIT DIFF ANALIZI
# =============================================================================

function Get-GitDiffFiles {
    $oldEA = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    $staged = git -C $repoRoot diff --cached --name-only
    $unstaged = git -C $repoRoot diff --name-only
    $ErrorActionPreference = $oldEA
    $all = @($staged; $unstaged) | Where-Object { $_ -and $_ -notmatch '^warning:' } | Select-Object -Unique
    return $all
}

function Get-LastCommitFiles {
    $oldEA = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"
    $last = git -C $repoRoot diff-tree --no-commit-id --name-only -r HEAD
    $ErrorActionPreference = $oldEA
    return $last | Where-Object { $_ -and $_ -notmatch '^warning:' }
}

# =============================================================================
# 4. RAPOR GUNCELLEME MOTORU
# =============================================================================

function Backup-Report($filePath) {
    $backup = "$filePath.backup.$($script:today)"
    Copy-Item $filePath $backup -Force
    return $backup
}

function Update-ReportStatus {
    param(
        [string]$FilePath,
        [string]$IssueID,
        [string]$Status = "KAPATILDI",
        [string]$Date = $script:today
    )
    
    if (-not (Test-Path $FilePath)) {
        Write-Status "  ! Rapor bulunamadi: $FilePath" "Warning"
        return $false
    }
    
    # .NET File API ile oku (PS 5.1 encoding sorununu cozer)
    $content = [System.IO.File]::ReadAllText($FilePath, [System.Text.Encoding]::UTF8)
    $modified = $false
    
    # ID'yi iceren her satiri kontrol et
    $lines = $content -split "`r?`n"
    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        
        # Bu satir ID'yi iceriyor mu?
        if ($line -match [regex]::Escape($IssueID)) {
            # ID bulundu — sonraki 5 satirda acik/beklemede ara (FAZ2/HATA formati)
            for ($j = $i; $j -lt [Math]::Min($i + 5, $lines.Count); $j++) {
                $checkLine = $lines[$j]
                $cChar = [char]231  # 'ç'
                $openPattern = "A${cChar}ik"
                
                if ($checkLine -match $openPattern -or $checkLine -match "BEKLEMEDE" -or $checkLine -match "DEVAM") {
                    $lines[$j] = $checkLine -replace $openPattern, "KAPATILDI -- $Date"
                    $lines[$j] = $lines[$j] -replace "BEKLEMEDE", "KAPATILDI -- $Date"
                    $lines[$j] = $lines[$j] -replace "DEVAM.*EDIYOR", "KAPATILDI -- $Date"
                    $modified = $true
                    Write-Status "  + $IssueID -> KAPATILDI ($Date)" "Success"
                    break
                }
            }
        }
    }
    
    if ($modified -and -not $DryRun) {
        $newContent = $lines -join "`r`n"
        [System.IO.File]::WriteAllText($FilePath, $newContent, [System.Text.Encoding]::UTF8)
    }
    
    return $modified
}

function Update-SummaryCounts($filePath) {
    # Tablodaki sayilari guncelle (opsiyonel, basit regex)
    # Bu kisim ileride genisletilebilir
}

# =============================================================================
# 5. CHANGELOG ENTRYSI
# =============================================================================

function Add-ChangelogEntry($issues) {
    if ($SkipChangelog) { return }
    
    $changelogPath = $script:Reports.CHANGELOG
    if (-not (Test-Path $changelogPath)) { return }
    
    $content = Get-Content $changelogPath -Raw -Encoding UTF8
    
    # [0.0.11] basliginin altina ekle (veya yeni baslik ac)
    $entry = @"

### 🔄 Otomatik Rapor Senkronizasyonu ($script:today)

**Kapatilan Sorunlar:**
$(foreach ($i in $issues) { "- $($i.ID): $($i.Title)" })

**Etkilenen Raporlar:** $($issues.Reports | Select-Object -Unique | Sort-Object)
"@
    
    # Unreleased veya son basligin altina ekle
    $marker = "## [0.0.11]"
    if ($content -match [regex]::Escape($marker)) {
        $content = $content -replace "($marker.*?\n.*?\n)", "`$1$entry`n"
    }
    
    if (-not $DryRun) {
        Set-Content $changelogPath $content -Encoding UTF8 -NoNewline
    }
}

# =============================================================================
# 6. ANA AKIS
# =============================================================================

Write-Status "`n========================================" "Info"
Write-Status "  AIDATPANEL RAPOR SENKRONIZASYONU" "Info"
Write-Status "  $script:now" "Info"
Write-Status "========================================`n" "Info"

# Adim 1: Git diff analiz et
$diffFiles = Get-GitDiffFiles
$lastFiles = Get-LastCommitFiles
$allChanged = @($diffFiles; $lastFiles) | Where-Object { $_ } | Select-Object -Unique

Write-Status "[1/4] Git Diff Analizi" "Info"
Write-Status "  Degisen dosyalar: $($allChanged.Count)" "Info"
foreach ($f in $allChanged) {
    Write-Status "    - $f" "Info"
}

if ($allChanged.Count -eq 0) {
    Write-Status "`nDegisen dosya yok. Rapor guncellemesi atlaniyor." "Warning"
    Write-Status "`n✅ Raporlar GUNCEL (degisen dosya yok)" "Success"
    Read-Host "`nCikmak icin Enter tusuna basin..."
    exit 0
}

# Adim 2: Etkilenen sorunlari bul
Write-Status "`n[2/4] Etkilenen Sorunlar" "Info"
$closedIssues = @()

foreach ($file in $allChanged) {
    if ($script:FileToIssues.ContainsKey($file)) {
        $issues = $script:FileToIssues[$file]
        foreach ($issue in $issues) {
            Write-Status "  $($issue.ID): $($issue.Title) [$($issue.Reports -join ', ')]" "Info"
            $closedIssues += $issue
        }
    }
}

if ($closedIssues.Count -eq 0) {
    Write-Status "`nHicbir sorun mapping'i bulunamadi." "Warning"
    Write-Status "`n✅ Raporlar GUNCEL (mapping yok)" "Success"
    Read-Host "`nCikmak icin Enter tusuna basin..."
    exit 0
}

# Tekillestir
$closedIssues = $closedIssues | Sort-Object ID -Unique

# Adim 3: Raporlari guncelle
Write-Status "`n[3/4] Rapor Guncellemeleri$(if($DryRun){' [DRY-RUN]'})" "Info"

$updatedReports = @()
foreach ($issue in $closedIssues) {
    foreach ($reportKey in $issue.Reports) {
        $reportPath = $script:Reports[$reportKey]
        if (-not $reportPath) { continue }
        
        $result = Update-ReportStatus -FilePath $reportPath -IssueID $issue.ID
        if ($result) {
            $updatedReports += $reportKey
        }
    }
}

$updatedReports = $updatedReports | Select-Object -Unique | Sort-Object
Write-Status "`n  Guncellenen raporlar: $($updatedReports -join ', ')" "Success"

# Adim 4: CHANGELOG
if (-not $SkipChangelog -and $updatedReports.Count -gt 0) {
    Write-Status "`n[4/4] CHANGELOG Guncelleniyor" "Info"
    Add-ChangelogEntry -issues $closedIssues
}

# =============================================================================
# 7. GIT ISLEMLERI (Opsiyonel)
# =============================================================================

Write-Status "`n========================================" "Info"
if ($DryRun) {
    Write-Status "DRY-RUN: Degisiklikler kaydedilmedi." "Warning"
    Write-Status "Tekrar calistirin: .\update_reports.ps1" "Info"
} else {
    Write-Status "Raporlar guncellendi." "Success"
    Write-Status "`nSiradaki adimlar:" "Info"
    Write-Status "  1. Raporlari gozden gecir" "Info"
    Write-Status "  2. git add -A && git commit -m \"...\"" "Info"
    Write-Status "  3. git push origin mobile/flutter-app" "Info"
}
Write-Status "========================================`n" "Info"
Read-Host "Cikmak icin Enter tusuna basin..."
