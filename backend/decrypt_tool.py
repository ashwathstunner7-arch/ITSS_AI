import sys
import os

# Adjust path to import app modules
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from app.core.security import decrypt_password

def main():
    print("=== Password Decryption Tool (Local Testing Only) ===")
    if len(sys.argv) > 1:
        encrypted_text = sys.argv[1]
    else:
        encrypted_text = input("Paste the encrypted password string from the DB: ")
    
    plain_text = decrypt_password(encrypted_text)
    print(f"\nDecrypted Password: {plain_text}")

if __name__ == "__main__":
    main()
