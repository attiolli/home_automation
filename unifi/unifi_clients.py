import requests
import urllib3

# Disable warnings about insecure requests
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# UniFi Controller Configuration
# Unifi contacted via nginx proxy on this example (Hence the url not having 8443 port)
controller_url = "https://your.unificontroller.url"
username = "your-username"
password = "your-password"
site_id = "default"

# API Endpoints
login_url = f"{controller_url}/api/auth/login"
# Clients url maby different if not using a http proxy in front of unifi
clients_url = f"{controller_url}/api/s/{site_id}/stat/sta"

# Create a session to manage cookies
session = requests.Session()

def login():
    # Login payload
    payload = {"username": username, "password": password, "remember": True}
    # Log in to the UniFi Controller
    response = session.post(login_url, json=payload, verify=False)
    response.raise_for_status()
    print("Login successful!")

def get_wifi_clients():
    # Fetch Wi-Fi clients
    headers = {
        "Content-Type": "application/json",
        "Referer": f"{controller_url}/manage/site/{site_id}/dashboard",
        "X-Requested-With": "XMLHttpRequest"
    }
    response = session.get(clients_url, headers=headers, verify=False)
    response.raise_for_status()
    clients = response.json()["data"]
    return clients

def main():
    try:
        login()
        clients = get_wifi_clients()
        print("Connected Wi-Fi Clients:")
        for client in clients:
            print(f"MAC: {client['mac']}, IP: {client.get('ip', 'Unknown')}, Hostname: {client.get('hostname', 'Unknown')}, Signal: {client.get('signal', 'Unknown')}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
