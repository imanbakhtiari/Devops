import requests

# Define the domain here
domain = "example.com"  # Replace with the domain you want to query

def get_subdomains(domain):
    """
    Fetch all subdomains for a given domain from crt.sh.
    """
    url = f"https://crt.sh/?q=%25.{domain}&output=json"
    try:
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            # Parse JSON response for subdomains
            certificates = response.json()
            subdomains = set()
            for cert in certificates:
                if 'name_value' in cert:
                    entries = cert['name_value'].split('\n')
                    for entry in entries:
                        if entry.endswith(domain):
                            subdomains.add(entry.strip())
            return sorted(subdomains)
        else:
            print(f"Failed to fetch subdomains. HTTP {response.status_code}")
            return []
    except Exception as e:
        print(f"Error occurred: {e}")
        return []

def main():
    subdomains = get_subdomains(domain)

    if subdomains:
        print(f"\nSubdomains found for {domain}:")
        for subdomain in subdomains:
            print(subdomain)
    else:
        print(f"No subdomains found for {domain}.")

if __name__ == "__main__":
    main()

