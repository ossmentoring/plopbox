from urllib.request import urlopen, Request
import json
import http.client


with open("/run/secrets/user") as f:
    user = f.read().strip()

with open("/run/secrets/passwd") as f:
    passwd = f.read().strip()


def keycloak_token():
    req = Request(
        f"http://keycloak:8080/auth/realms/master/protocol/openid-connect/token",
        data=f"username={user}&password={passwd}&client_id=admin-cli&grant_type=password".encode("utf-8"),
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        method="POST")
    return json.loads(urlopen(req).read().decode('utf-8'))["access_token"]


def keycloak_clients():
    req = Request(
        "http://keycloak:8080/auth/admin/realms/master/clients/",
        headers={"Authorization": f"Bearer {keycloak_token()}"},
        method="GET")
    return json.loads(urlopen(req).read().decode('utf-8'))

def mod_account_client():
    for client in keycloak_clients():
        if client["clientId"] == "account":
            account = client
            break

    _id = account["id"]
    account["implicitFlowEnabled"] = True
    req = Request(
        f"http://keycloak:8080/auth/admin/realms/master/clients/{_id}",
        data=json.dumps(account).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {keycloak_token()}",
            "Content-Type": "application/json"},
        method="PUT")
    return urlopen(req).status

print(mod_account_client())
