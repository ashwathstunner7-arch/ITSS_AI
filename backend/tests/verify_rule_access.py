import requests

BASE_URL = "http://localhost:8000"

def test_access(token, description):
    headers = {"Authorization": f"Bearer {token}"}
    print(f"\n--- Testing: {description} ---")
    
    # Try to create a prompt
    payload = {"title": "Test Prompt", "content": "Test Content"}
    response = requests.post(f"{BASE_URL}/prompts/my", json=payload, headers=headers)
    print(f"Create Prompt Status: {response.status_code}")
    if response.status_code != 200:
        print(f"Detail: {response.json().get('detail')}")

if __name__ == "__main__":
    print("Ensure the backend is running before executing this test.")
    # In a real scenario, we would login to get tokens for different users
    # For now, this serves as a blueprint for verification.
    print("Manually verify by logging in as 'User' vs 'Admin' in the UI/API.")
