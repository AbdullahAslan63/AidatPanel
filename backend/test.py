from ast import If
import requests

success = 0
failed = 0
url = "https://api.aidatpanel.com/api/v1"
name = "Test User"
email = "test@example.com"
password = "123456"

response = requests.post(f"{url}/auth/register", json={"name": name, "email": email, "password": password})
if response.json()["success"] == True:
    print("Register:")
    print(response.json())
    success += 1
else:
    print("Register failed:")
    print(response.json())
    failed += 1

login_response = requests.post(f"{url}/auth/login", json={"identifier": email, "password": password})
if login_response.json()["success"] == True:
    print("Login:")
    print(login_response.json())
    success += 1
else:
    print("Login failed:")
    print(login_response.json())
    failed += 1
token = login_response.json()["data"]["accessToken"]

addBuilding_response = requests.post(f"{url}/buildings", headers={"Authorization": f"Bearer {token}"}, json={"name": "Test Building", "address": "Test Address", "city": "Test City"})
if addBuilding_response.json()["success"] == True:
    print("Add Building:")
    print(addBuilding_response.json())
    success += 1
else:
    print("Add Building failed:")
    print(addBuilding_response.json())
    failed += 1
buildingID = addBuilding_response.json()["data"]["id"]

updateBuilding_response = requests.put(f"{url}/buildings/{buildingID}", headers={"Authorization": f"Bearer {token}"}, json={"name": "Test Building Updated", "address": "Test Address Updated", "city": "Test City Updated"})
if updateBuilding_response.json()["success"] == True:
    print("Update Building:")
    print(updateBuilding_response.json())
    success += 1
else:
    print("Update Building failed:")
    print(updateBuilding_response.json())
    failed += 1

addApartment_response = requests.post(f"{url}/buildings/{buildingID}/apartments", headers={"Authorization": f"Bearer {token}"}, json={"buildingId": buildingID, "number": "101", "floor": 1, "rooms": 3, "bathrooms": 2, "area": 100})
if addApartment_response.json()["success"] == True:
    print("Add Apartment:")
    print(addApartment_response.json())
    success += 1
else:
    print("Add Apartment failed:")
    print(addApartment_response.json())
    failed += 1
apartmentID = addApartment_response.json()["data"]["id"]

updateApartment_response = requests.put(f"{url}/buildings/{buildingID}/apartments/{apartmentID}", headers={"Authorization": f"Bearer {token}"}, json={"buildingId": buildingID, "number": "101", "floor": 1, "rooms": 3, "bathrooms": 2, "area": 100})
if updateApartment_response.json()["success"] == True:
    print("Update Apartment:")
    print(updateApartment_response.json())
    success += 1
else:
    print("Update Apartment failed:")
    print(updateApartment_response.json())
    failed += 1

listApartments_response = requests.get(f"{url}/buildings/{buildingID}/apartments", headers={"Authorization": f"Bearer {token}"})
if listApartments_response.json()["success"] == True:
    print("List Apartments:")
    print(listApartments_response.json())
    success += 1
else:
    print("List Apartments failed:")
    print(listApartments_response.json())
    failed += 1

listBuildings_response = requests.get(f"{url}/buildings", headers={"Authorization": f"Bearer {token}"})
if listBuildings_response.json()["success"] == True:
    print("List Buildings:")
    print(listBuildings_response.json())
    success += 1
else:
    print("List Buildings failed:")
    print(listBuildings_response.json())
    failed += 1

deleteApartment_response = requests.delete(f"{url}/buildings/{buildingID}/apartments/{apartmentID}", headers={"Authorization": f"Bearer {token}"})
if deleteApartment_response.json()["success"] == True:
    print("Delete Apartment:")
    print(deleteApartment_response.json())
    success += 1
else:
    print("Delete Apartment failed:")
    print(deleteApartment_response.json())
    failed += 1

deleteBuilding_response = requests.delete(f"{url}/buildings/{buildingID}", headers={"Authorization": f"Bearer {token}"})
if deleteBuilding_response.json()["success"] == True:
    print("Delete Building:")
    print(deleteBuilding_response.json())
    success += 1
else:
    print("Delete Building failed:")
    print(deleteBuilding_response.json())
    failed += 1

refresh_token = login_response.json()["data"]["refreshToken"]
refresh_response = requests.post(f"{url}/auth/refresh", json={"refreshToken": refresh_token})
if refresh_response.json()["success"] == True:
    print("Refresh:")
    print(refresh_response.json())
    success += 1
else:
    print("Refresh failed:")
    print(refresh_response.json())
    failed += 1


logout_response = requests.post(f"{url}/auth/logout", headers={"Authorization": f"Bearer {token}"})
if logout_response.json()["success"] == True:
    print("Logout:")
    print(logout_response.json())
    success += 1
else:
    print("Logout failed:")
    print(logout_response.json())
    failed += 1
