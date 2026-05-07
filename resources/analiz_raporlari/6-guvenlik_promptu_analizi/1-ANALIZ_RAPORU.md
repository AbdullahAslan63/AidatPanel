# 1️⃣ ANALIZ_RAPORU.md (v2.0)

## GUVENLIK PROMPTU - DETAYLI ANALİZ RAPORU v2.0

**Versiyon:** 2.0  
**Tarih:** 2026-05-04  
**Kaynak:** `resources/planning/GUVENLIK_PROMPTU.md` v2.0  
**Puan:** 6.3 → 9.3/10 (+3.0)

---

## 🎯 KISA ÖZET

GUVENLIK_PROMPTU.md, Senior Security Researcher rolünde **adversarial mindset** ile git diff üzerinden güvenlik zafiyetleri tespiti için talimatlar sunan bir meta-prompt'tur. v1.0 (36 satır) 5 risk kategorisi, output format, constraints tanımlanmış ama operasyonel detaylar (KVKK/GDPR compliance, threat modeling, OWASP MASVS, secrets management, incident response) eksikti. v2.0'da KVKK/GDPR compliance checklist, STRIDE threat modeling, OWASP MASVS Level 1-2, secrets management policy, incident response plan eklenerek operasyonel detaylar tamamlandı. Artık ekip tarafından kullanılabilir, compliance-aware, threat-aware, incident-ready bir meta-prompt'tur.

---

## ✅ GÜÇLÜ YÖNLER

- **Adversarial Mindset:** "Saldırgan gibi düşün" prensibi net, zero trust enforced
- **5 Risk Kategorisi:** Injection, Access Control, Data Exposure, Misconfiguration, Code Quality tanımlanmış ve kapsamlı
- **Output Format:** Direktness, density, secrets detection tanımlanmış, actionable
- **Constraints:** Zero trust, context awareness, directness, density, secrets detection enforced
- **Uygulanabilirlik:** SECURITY_AUDIT.md başarıyla üretilmiş, 11 zafiyet tespit edilmiş

---

## ❌ ZAYIF YÖNLER / GAP'LER (v1.0'da)

- **KVKK/GDPR Compliance Eksik:** Veri saklama, gizlilik, kullanıcı hakları, denetim tanımlanmamış
- **Threat Modeling Eksik:** STRIDE/PASTA, threat tree, risk scoring tanımlanmamış
- **OWASP MASVS Eksik:** Mobile security checklist, Level 1-2 tanımlanmamış
- **Secrets Management Eksik:** Storage, rotation policy, audit tanımlanmamış
- **Incident Response Eksik:** Severity levels, response timeline, checklist, communication tanımlanmamış
- **Security Audit Checklist Eksik:** Pre/during/post-audit steps tanımlanmamış

---

## ⚠️ RİSK ANALİZİ

| Risk | Olasılık | Etki | Azaltma |
|------|----------|------|---------|
| Compliance violations (KVKK/GDPR) | Orta | 🔴 Kritik | Compliance checklist eklendi |
| Unidentified threats (threat modeling yok) | Yüksek | 🟡 Yüksek | STRIDE threat modeling eklendi |
| Mobile security gaps (MASVS yok) | Orta | 🟡 Yüksek | OWASP MASVS eklendi |
| Secrets exposure (hardcoded credentials) | Orta | 🔴 Kritik | Secrets management policy eklendi |
| Incident response delays (plan yok) | Orta | 🟡 Yüksek | Incident response plan eklendi |

---

## 🔍 BULGU DETAYLARI (v2.0 İyileştirmeleri)

### Bulgu 1: KVKK/GDPR Compliance Checklist Eklendi
- **Kategori:** Compliance / Legal
- **Severity:** Critical
- **v1.0'da:** Compliance tanımlanmamış, KVKK/GDPR violations riski
- **v2.0'da:** 4 kategorili compliance checklist (veri saklama, gizlilik, kullanıcı hakları, denetim) tanımlandı, 16 madde
- **Impact:** Compliance violations azalır, legal risk düşer
- **Evidence:** GUVENLIK_PROMPTU.md v2.0, "## 6. KVKK/GDPR COMPLIANCE CHECKLIST (v2.0 YENİ)" bölümü
- **Why Needed:** Compliance yok → legal risk. Checklist → compliance assurance

### Bulgu 2: STRIDE Threat Modeling Eklendi
- **Kategori:** Threat Modeling / Risk Assessment
- **Severity:** High
- **v1.0'da:** Threat modeling tanımlanmamış, unidentified threats riski
- **v2.0'da:** STRIDE kategorileri (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege), threat tree, risk scoring tanımlandı
- **Impact:** Threats görülür, mitigation stratejileri uygulanır
- **Evidence:** GUVENLIK_PROMPTU.md v2.0, "## 7. THREAT MODELING (STRIDE/PASTA) (v2.0 YENİ)" bölümü
- **Why Needed:** Modeling yok → unidentified threats. Modeling → threat visibility

### Bulgu 3: OWASP MASVS Eklendi
- **Kategori:** Mobile Security / Standards
- **Severity:** High
- **v1.0'da:** Mobile security checklist tanımlanmamış, mobile gaps riski
- **v2.0'da:** MASVS Level 1-2 (storage, crypto, auth, network, code, vb.) tanımlandı, 13 madde
- **Impact:** Mobile security gaps kapatılır, MASVS compliance sağlanır
- **Evidence:** GUVENLIK_PROMPTU.md v2.0, "## 8. OWASP MASVS (Mobile Application Security Verification Standard) (v2.0 YENİ)" bölümü
- **Why Needed:** MASVS yok → mobile gaps. MASVS → mobile security assurance

### Bulgu 4: Secrets Management Policy Eklendi
- **Kategori:** Security / Secrets
- **Severity:** Critical
- **v1.0'da:** Secrets management tanımlanmamış, hardcoded credentials riski
- **v2.0'da:** Secrets tanımı, storage (env vars, Keychain, Vault), rotation policy (90-180-365 gün), audit tanımlandı
- **Impact:** Hardcoded credentials riski azalır, secrets secure kalır
- **Evidence:** GUVENLIK_PROMPTU.md v2.0, "## 9. SECRETS MANAGEMENT (v2.0 YENİ)" bölümü
- **Why Needed:** Policy yok → secrets exposure. Policy → secrets protection

### Bulgu 5: Incident Response Plan Eklendi
- **Kategori:** Incident Management / Response
- **Severity:** High
- **v1.0'da:** Incident response tanımlanmamış, slow response riski
- **v2.0'da:** Severity levels, response timeline (Critical <4 hours, High <24 hours, vb.), checklist, communication tanımlandı
- **Impact:** Incident response hızlı, damage azalır
- **Evidence:** GUVENLIK_PROMPTU.md v2.0, "## 10. INCIDENT RESPONSE PLAN (v2.0 YENİ)" bölümü
- **Why Needed:** Plan yok → slow response. Plan → fast, coordinated response

### Bulgu 6: Security Audit Checklist Eklendi
- **Kategori:** Audit / Quality Assurance
- **Severity:** High
- **v1.0'da:** Audit checklist tanımlanmamış, incomplete audits riski
- **v2.0'da:** Pre/during/post-audit steps (scope, threat model, static/dynamic analysis, dependency scanning, findings, risk scoring, remediation, follow-up) tanımlandı
- **Impact:** Audits complete, consistent, actionable
- **Evidence:** GUVENLIK_PROMPTU.md v2.0, "## 11. SECURITY AUDIT CHECKLIST (v2.0 YENİ)" bölümü
- **Why Needed:** Checklist yok → incomplete audits. Checklist → comprehensive audits

### Bulgu 7: Veri Saklama Politikası Tanımlandı
- **Kategori:** Compliance / Data Retention
- **Severity:** High
- **v1.0'da:** Veri saklama süresi tanımlanmamış
- **v2.0'da:** KVKK: 3 yıl, soft delete değil hard delete, backup cleanup, veri silme endpoint tanımlandı
- **Impact:** Compliance sağlanır, data retention clear
- **Evidence:** GUVENLIK_PROMPTU.md v2.0, "## 6. KVKK/GDPR COMPLIANCE CHECKLIST (v2.0 YENİ)" → "Veri Saklama (Data Retention)" bölümü
- **Why Needed:** Policy yok → compliance violations. Policy → compliance assurance

### Bulgu 8: Threat Tree Örneği Tanımlandı
- **Kategori:** Threat Modeling / Documentation
- **Severity:** Medium
- **v1.0'da:** Threat tree örneği yok
- **v2.0'da:** "Unauthorized Access to Dues" threat tree örneği tanımlandı, 4 attack path
- **Impact:** Threat modeling daha concrete, actionable
- **Evidence:** GUVENLIK_PROMPTU.md v2.0, "## 7. THREAT MODELING (STRIDE/PASTA) (v2.0 YENİ)" → "Threat Tree Örneği" bölümü
- **Why Needed:** Örnek yok → abstract modeling. Örnek → concrete, actionable

### Bulgu 9: Risk Scoring Metodolojisi Tanımlandı
- **Kategori:** Risk Assessment / Methodology
- **Severity:** Medium
- **v1.0'da:** Risk scoring tanımlanmamış
- **v2.0'da:** Likelihood × Impact = Risk Score, 1-3 (Low), 4-6 (Medium), 7-9 (Critical) tanımlandı
- **Impact:** Risk scoring consistent, comparable
- **Evidence:** GUVENLIK_PROMPTU.md v2.0, "## 7. THREAT MODELING (STRIDE/PASTA) (v2.0 YENİ)" → "Risk Scoring" bölümü
- **Why Needed:** Scoring yok → inconsistent risk assessment. Metodoloji → consistent scoring

### Bulgu 10: Secrets Rotation Policy Tanımlandı
- **Kategori:** Security / Secrets Management
- **Severity:** High
- **v1.0'da:** Rotation policy tanımlanmamış
- **v2.0'da:** API keys 90 gün, DB passwords 180 gün, JWT secrets 1 yıl, certificates 1 yıl tanımlandı
- **Impact:** Secrets compromise riski azalır, security posture güçlenir
- **Evidence:** GUVENLIK_PROMPTU.md v2.0, "## 9. SECRETS MANAGEMENT (v2.0 YENİ)" → "Rotation Policy" bölümü
- **Why Needed:** Policy yok → stale secrets. Policy → regular rotation

### Bulgu 11: Incident Severity Levels Tanımlandı
- **Kategori:** Incident Management / Classification
- **Severity:** Medium
- **v1.0'da:** Severity levels tanımlanmamış
- **v2.0'da:** Critical (data breach, service down, exploit), High (unauthorized access, malware, DDoS), Medium (vulnerability, misconfiguration), Low (information disclosure, minor bug) tanımlandı
- **Impact:** Incident classification clear, response prioritized
- **Evidence:** GUVENLIK_PROMPTU.md v2.0, "## 10. INCIDENT RESPONSE PLAN (v2.0 YENİ)" → "Incident Severity Levels" bölümü
- **Why Needed:** Levels yok → unclear prioritization. Levels → clear prioritization

---

## 💡 İYİLEŞTİRME ÖNERİLERİ

1. **Threat Modeling Workshop:** STRIDE threat modeling workshop yapıl, team training. Efor: 4-5 saat, Etki: Yüksek (team awareness)

2. **Security Scanning Integration:** Snyk, Dependabot, npm audit CI/CD'ye entegre et. Efor: 2-3 saat, Etki: Yüksek (automated scanning)

3. **Secrets Vault Setup:** HashiCorp Vault veya AWS Secrets Manager setup. Efor: 3-4 saat, Etki: Yüksek (secrets protection)

4. **Incident Response Runbook:** Detailed runbook oluştur, team training. Efor: 3-4 saat, Etki: Yüksek (incident readiness)

5. **Security Audit Automation:** OWASP ZAP, Burp Suite automation setup. Efor: 4-5 saat, Etki: Orta (audit efficiency)

---

## 📊 KALİTE SKORU

### v1.0 (Başlangıç: 6.3/10)
| Kriter | Skor |
|--------|------|
| Adversarial mindset | 10/10 |
| Zero trust prensibi | 10/10 |
| 5 risk kategorisi | 10/10 |
| Çıktı formatı | 9/10 |
| Signal-to-noise | 10/10 |
| Compliance (KVKK/GDPR) | 2/10 |
| Threat modeling | 3/10 |
| Mobile security (MASVS) | 4/10 |
| Secrets management | 2/10 |
| Incident response | 2/10 |
| **Ortalama** | **6.3/10** |

### v2.0 (Final: 9.3/10) ✅
| Kriter | Skor |
|--------|------|
| Adversarial mindset | 10/10 |
| Zero trust prensibi | 10/10 |
| 5 risk kategorisi | 10/10 |
| Çıktı formatı | 9/10 |
| Signal-to-noise | 10/10 |
| Compliance (KVKK/GDPR) | 9/10 |
| Threat modeling (STRIDE) | 9/10 |
| Mobile security (MASVS) | 9/10 |
| Secrets management | 9/10 |
| Incident response plan | 9/10 |
| **Ortalama** | **9.3/10** |

**Yorum:** v2.0 ile compliance, threat modeling, MASVS, secrets management, incident response eklendi. Hedef 7.5 aşıldı (+1.8 puan). Meta-prompt artık production-ready, compliance-aware, threat-aware, incident-ready.

---

## 📝 REVİZYON GEÇMİŞİ

| Versiyon | Tarih | Değişiklik |
|----------|-------|-----------|
| v1.0 | 2026-05-03 | İlk versiyon (5 risk kategorisi, output format, constraints) |
| v2.0 | 2026-05-04 | Operasyonel detay: KVKK/GDPR compliance, threat modeling (STRIDE), OWASP MASVS, secrets management, incident response. Puan: 6.3 → 9.3/10 |

---

## 🚀 SONRAKI ADIMLAR

- [ ] STRIDE threat modeling workshop yapıl
- [ ] Snyk, Dependabot, npm audit CI/CD'ye entegre et
- [ ] HashiCorp Vault veya AWS Secrets Manager setup
- [ ] Incident response runbook oluştur
- [ ] OWASP ZAP, Burp Suite automation setup
- [ ] Security audit schedule kur (quarterly)
- [ ] Team security training planla
