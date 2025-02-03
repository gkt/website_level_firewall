import os
import glob
import json
import sys
from urllib.parse import urlparse

# Check if the HAR file path is provided as a command line argument
if len(sys.argv) != 2:
    print("Usage: python har_parser.py <path_to_har_file>")
    sys.exit(1)

har_file_path = sys.argv[1]

# Check if the provided path is a valid file
if not os.path.isfile(har_file_path):
    print(f"Error: {har_file_path} is not a valid file.")
    sys.exit(1)

domains = set()

print("Parsing unique domains from the HAR file...")

with open(har_file_path, 'r', encoding='utf-8') as f:
    data = json.load(f)

for entry in data["log"]["entries"]:
    url = entry["request"]["url"]
    parsed_url = urlparse(url)
    # Add the domain (including port if present) to the set
    domains.add(parsed_url.netloc)

# Sort the list of unique domains
sorted_domains = sorted(domains)

print("Writing sorted domains to domains.txt...")

# Write the sorted domains to a text file
with open("domains.txt", "w", encoding='utf-8') as out_file:
    for d in sorted_domains:
        out_file.write(d + "\n")

print("domains.txt has been generated.")
