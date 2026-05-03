#!/usr/bin/env python3
"""
AidatPanel Backend API Test Suite
Test edilecek endpoint'ler: Auth, Buildings, Apartments
"""

import requests
import json
import uuid
import sys
from datetime import datetime

# Konfigürasyon
BASE_URL = "http://localhost:3000/api/v1"
TEST_EMAIL = f"test_{uuid.uuid4().hex[:8]}@example.com"
TEST_PASSWORD = "Test123456"
TEST_NAME = "Test User"

# Global değişkenler
tokens = {}
test_building_id = None
test_apartment_id = None


def log_test(name, success, message="", data=None):
    """Test sonucunu formatlı yazdır"""
    status = "✅ PASS" if success else "❌ FAIL"
    print(f"\n{status} | {name}")
    if message:
        print(f"   └─ {message}")
    if data and not success:
        print(f"   └─ Response: {json.dumps(data, indent=2, ensure_ascii=False)[:200]}")
    return success


def test_register():
    """POST /auth/register - Yeni kullanıcı kaydı"""
    url = f"{BASE_URL}/auth/register"
    payload = {
        "name": TEST_NAME,
        "email": TEST_EMAIL,
        "password": TEST_PASSWORD
    }
    
    try:
        response = requests.post(url, json=payload, timeout=10)
        data = response.json()
        
        if response.status_code == 201 and data.get("success"):
            return log_test("Register", True, f"User created: {TEST_EMAIL}")
        elif response.status_code == 409:
            return log_test("Register", False, "Email already exists")
        else:
            return log_test("Register", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Register", False, str(e))


def test_register_validation():
    """POST /auth/register - Validasyon hatası testi"""
    url = f"{BASE_URL}/auth/register"
    payload = {
        "name": "A",  # Çok kısa
        "email": "invalid-email",
        "password": "123"  # Çok kısa
    }
    
    try:
        response = requests.post(url, json=payload, timeout=10)
        data = response.json()
        
        if response.status_code == 400 and not data.get("success"):
            return log_test("Register Validation", True, "Correctly rejected invalid data")
        else:
            return log_test("Register Validation", False, f"Expected 400, got {response.status_code}")
    except Exception as e:
        return log_test("Register Validation", False, str(e))


def test_login():
    """POST /auth/login - Giriş yap"""
    global tokens
    url = f"{BASE_URL}/auth/login"
    payload = {
        "identifier": TEST_EMAIL,
        "password": TEST_PASSWORD
    }
    
    try:
        response = requests.post(url, json=payload, timeout=10)
        data = response.json()
        
        if response.status_code == 200 and data.get("success"):
            tokens["access"] = data["data"]["accessToken"]
            tokens["refresh"] = data["data"]["refreshToken"]
            user_role = data["data"]["user"]["role"]
            return log_test("Login", True, f"Success, role: {user_role}")
        else:
            return log_test("Login", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Login", False, str(e))


def test_login_invalid():
    """POST /auth/login - Yanlış şifre"""
    url = f"{BASE_URL}/auth/login"
    payload = {
        "identifier": TEST_EMAIL,
        "password": "wrongpassword"
    }
    
    try:
        response = requests.post(url, json=payload, timeout=10)
        data = response.json()
        
        if response.status_code == 401 and not data.get("success"):
            return log_test("Login Invalid", True, "Correctly rejected wrong password")
        else:
            return log_test("Login Invalid", False, f"Expected 401, got {response.status_code}")
    except Exception as e:
        return log_test("Login Invalid", False, str(e))


def test_refresh():
    """POST /auth/refresh - Token yenile"""
    url = f"{BASE_URL}/auth/refresh"
    payload = {"refreshToken": tokens.get("refresh", "")}
    
    try:
        response = requests.post(url, json=payload, timeout=10)
        data = response.json()
        
        if response.status_code == 200 and data.get("success"):
            tokens["access"] = data["data"]["accessToken"]
            return log_test("Refresh Token", True, "New access token received")
        else:
            return log_test("Refresh Token", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Refresh Token", False, str(e))


def test_refresh_invalid():
    """POST /auth/refresh - Geçersiz refresh token"""
    url = f"{BASE_URL}/auth/refresh"
    payload = {"refreshToken": "invalid.token.here"}
    
    try:
        response = requests.post(url, json=payload, timeout=10)
        
        if response.status_code in [401, 403]:
            return log_test("Refresh Invalid", True, "Correctly rejected invalid token")
        else:
            return log_test("Refresh Invalid", False, f"Expected 401/403, got {response.status_code}")
    except Exception as e:
        return log_test("Refresh Invalid", False, str(e))


def get_auth_headers():
    """Auth header'ı oluştur"""
    return {"Authorization": f"Bearer {tokens.get('access', '')}"}


def test_create_building():
    """POST /buildings - Bina oluştur"""
    global test_building_id
    url = f"{BASE_URL}/buildings"
    payload = {
        "name": f"Test Building {uuid.uuid4().hex[:6]}",
        "address": "Test Address 123",
        "city": "İstanbul"
    }
    
    try:
        response = requests.post(url, json=payload, headers=get_auth_headers(), timeout=10)
        data = response.json()
        
        if response.status_code == 201 and data.get("success"):
            test_building_id = data["data"]["id"]
            return log_test("Create Building", True, f"Building ID: {test_building_id}")
        else:
            return log_test("Create Building", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Create Building", False, str(e))


def test_create_building_validation():
    """POST /buildings - Validasyon hatası"""
    url = f"{BASE_URL}/buildings"
    payload = {
        "name": "A",  # Çok kısa
        "address": "Short",
        "city": "X"
    }
    
    try:
        response = requests.post(url, json=payload, headers=get_auth_headers(), timeout=10)
        
        if response.status_code == 400:
            return log_test("Create Building Validation", True, "Correctly rejected invalid data")
        else:
            return log_test("Create Building Validation", False, f"Expected 400, got {response.status_code}")
    except Exception as e:
        return log_test("Create Building Validation", False, str(e))


def test_get_buildings():
    """GET /buildings - Binaları listele"""
    url = f"{BASE_URL}/buildings"
    
    try:
        response = requests.get(url, headers=get_auth_headers(), timeout=10)
        data = response.json()
        
        if response.status_code == 200 and data.get("success"):
            count = len(data.get("data", []))
            return log_test("Get Buildings", True, f"Found {count} buildings")
        else:
            return log_test("Get Buildings", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Get Buildings", False, str(e))


def test_get_building_by_id():
    """GET /buildings/:id - Bina detayı"""
    if not test_building_id:
        return log_test("Get Building By ID", False, "No building ID available")
    
    url = f"{BASE_URL}/buildings/{test_building_id}"
    
    try:
        response = requests.get(url, headers=get_auth_headers(), timeout=10)
        data = response.json()
        
        if response.status_code == 200 and data.get("success"):
            return log_test("Get Building By ID", True, f"Building: {data['data'].get('name')}")
        else:
            return log_test("Get Building By ID", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Get Building By ID", False, str(e))


def test_update_building():
    """PUT /buildings/:id - Bina güncelle"""
    if not test_building_id:
        return log_test("Update Building", False, "No building ID available")
    
    url = f"{BASE_URL}/buildings/{test_building_id}"
    payload = {
        "name": f"Updated Building {uuid.uuid4().hex[:6]}",
        "city": "Ankara"
    }
    
    try:
        response = requests.put(url, json=payload, headers=get_auth_headers(), timeout=10)
        data = response.json()
        
        if response.status_code == 200 and data.get("success"):
            return log_test("Update Building", True, "Building updated successfully")
        else:
            return log_test("Update Building", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Update Building", False, str(e))


def test_create_apartment():
    """POST /buildings/:id/apartments - Daire oluştur"""
    global test_apartment_id
    if not test_building_id:
        return log_test("Create Apartment", False, "No building ID available")
    
    url = f"{BASE_URL}/buildings/{test_building_id}/apartments"
    payload = {
        "number": f"{uuid.uuid4().hex[:4].upper()}",
        "floor": 1
    }
    
    try:
        response = requests.post(url, json=payload, headers=get_auth_headers(), timeout=10)
        data = response.json()
        
        if response.status_code == 201 and data.get("success"):
            test_apartment_id = data["data"]["id"]
            return log_test("Create Apartment", True, f"Apartment ID: {test_apartment_id}")
        else:
            return log_test("Create Apartment", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Create Apartment", False, str(e))


def test_get_apartments():
    """GET /buildings/:id/apartments - Daireleri listele"""
    if not test_building_id:
        return log_test("Get Apartments", False, "No building ID available")
    
    url = f"{BASE_URL}/buildings/{test_building_id}/apartments"
    
    try:
        response = requests.get(url, headers=get_auth_headers(), timeout=10)
        data = response.json()
        
        if response.status_code == 200 and data.get("success"):
            count = len(data.get("data", []))
            return log_test("Get Apartments", True, f"Found {count} apartments")
        else:
            return log_test("Get Apartments", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Get Apartments", False, str(e))


def test_update_apartment():
    """PUT /buildings/:id/apartments/:id - Daire güncelle"""
    if not test_building_id or not test_apartment_id:
        return log_test("Update Apartment", False, "Missing building or apartment ID")
    
    url = f"{BASE_URL}/buildings/{test_building_id}/apartments/{test_apartment_id}"
    payload = {
        "number": "UPDATED-1A",
        "floor": 2
    }
    
    try:
        response = requests.put(url, json=payload, headers=get_auth_headers(), timeout=10)
        data = response.json()
        
        if response.status_code == 200 and data.get("success"):
            return log_test("Update Apartment", True, "Apartment updated successfully")
        else:
            return log_test("Update Apartment", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Update Apartment", False, str(e))


def test_delete_apartment():
    """DELETE /buildings/:id/apartments/:id - Daire sil"""
    if not test_building_id or not test_apartment_id:
        return log_test("Delete Apartment", False, "Missing building or apartment ID")
    
    url = f"{BASE_URL}/buildings/{test_building_id}/apartments/{test_apartment_id}"
    
    try:
        response = requests.delete(url, headers=get_auth_headers(), timeout=10)
        data = response.json()
        
        if response.status_code == 200 and data.get("success"):
            return log_test("Delete Apartment", True, "Apartment deleted successfully")
        else:
            return log_test("Delete Apartment", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Delete Apartment", False, str(e))


def test_delete_building():
    """DELETE /buildings/:id - Bina sil"""
    if not test_building_id:
        return log_test("Delete Building", False, "No building ID available")
    
    url = f"{BASE_URL}/buildings/{test_building_id}"
    
    try:
        response = requests.delete(url, headers=get_auth_headers(), timeout=10)
        data = response.json()
        
        if response.status_code == 200 and data.get("success"):
            return log_test("Delete Building", True, "Building deleted successfully")
        else:
            return log_test("Delete Building", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Delete Building", False, str(e))


def test_logout():
    """POST /auth/logout - Çıkış yap"""
    url = f"{BASE_URL}/auth/logout"
    
    try:
        response = requests.post(url, headers=get_auth_headers(), timeout=10)
        data = response.json()
        
        if response.status_code == 200 and data.get("success"):
            return log_test("Logout", True, "Logout successful")
        else:
            return log_test("Logout", False, f"Status: {response.status_code}", data)
    except Exception as e:
        return log_test("Logout", False, str(e))


def test_unauthorized_access():
    """Yetkisiz erişim testi"""
    url = f"{BASE_URL}/buildings"
    
    try:
        response = requests.get(url, timeout=10)
        
        if response.status_code == 401:
            return log_test("Unauthorized Access", True, "Correctly rejected without token")
        else:
            return log_test("Unauthorized Access", False, f"Expected 401, got {response.status_code}")
    except Exception as e:
        return log_test("Unauthorized Access", False, str(e))


def run_all_tests():
    """Tüm testleri çalıştır"""
    print("=" * 60)
    print("AidatPanel Backend API Test Suite")
    print("=" * 60)
    print(f"Base URL: {BASE_URL}")
    print(f"Test Email: {TEST_EMAIL}")
    print(f"Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    results = []
    
    # Auth Tests
    print("\n" + "=" * 60)
    print("🔐 AUTH TESTS")
    print("=" * 60)
    results.append(("Register", test_register()))
    results.append(("Register Validation", test_register_validation()))
    results.append(("Login", test_login()))
    results.append(("Login Invalid", test_login_invalid()))
    results.append(("Refresh Token", test_refresh()))
    results.append(("Refresh Invalid", test_refresh_invalid()))
    results.append(("Unauthorized", test_unauthorized_access()))
    
    # Building Tests
    print("\n" + "=" * 60)
    print("🏢 BUILDING TESTS")
    print("=" * 60)
    results.append(("Create Building", test_create_building()))
    results.append(("Create Building Validation", test_create_building_validation()))
    results.append(("Get Buildings", test_get_buildings()))
    results.append(("Get Building By ID", test_get_building_by_id()))
    results.append(("Update Building", test_update_building()))
    
    # Apartment Tests
    print("\n" + "=" * 60)
    print("🏠 APARTMENT TESTS")
    print("=" * 60)
    results.append(("Create Apartment", test_create_apartment()))
    results.append(("Get Apartments", test_get_apartments()))
    results.append(("Update Apartment", test_update_apartment()))
    results.append(("Delete Apartment", test_delete_apartment()))
    
    # Cleanup
    print("\n" + "=" * 60)
    print("🧹 CLEANUP")
    print("=" * 60)
    results.append(("Delete Building", test_delete_building()))
    results.append(("Logout", test_logout()))
    
    # Summary
    print("\n" + "=" * 60)
    print("📊 TEST SUMMARY")
    print("=" * 60)
    
    passed = sum(1 for _, result in results if result)
    failed = sum(1 for _, result in results if not result)
    total = len(results)
    
    print(f"Total: {total} tests")
    print(f"Passed: {passed} ✅")
    print(f"Failed: {failed} ❌")
    print(f"Success Rate: {(passed/total)*100:.1f}%")
    
    if failed > 0:
        print("\nFailed Tests:")
        for name, result in results:
            if not result:
                print(f"  ❌ {name}")
    
    print("=" * 60)
    
    return failed == 0


if __name__ == "__main__":
    try:
        success = run_all_tests()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\n⚠️ Tests interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n\n💥 Fatal error: {e}")
        sys.exit(1)
