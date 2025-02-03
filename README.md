# website_level_firewall
Scripts for creating a sandboxed environment with controlled access to a specific website. It scans the site to identify dependent domains for artifacts, JavaScript libraries, and other resources. A ip-level firewall, ufw, is then used to restrict the host’s internet access, allowing connections only to the required domains.

# Steps

## Generate HAR (HTTP Archive) file
1. Open up Google Chrome or Firefox.
2. Hit `F12` to bring up Developer Tools.
3. Click on the `Network` tab.
4. Make sure recording is on (the red circle should be on).
5. Do your thing on the site you want to check out.
6. When you're done, right-click on any entry in the `Network` tab and choose `Save all as HAR with content`.
7. Save the HAR file.

## Parse HAR file

`python har_parser.py <path_to_har_file>`

This will generate domains.txt

## Setup ufw rules

`setup_fileswall.sh`


## Validate the setup

Open your browser and verify that you can access the target website but not other sites. these steps are one time no neet ro rerun them upon reboot.


# Gotchas and TODOs

1. ufw is based on iptables which uses IP to filter connections. IPs can change with changes to DNS records or when switching VPN or proxy, so if things stop running, rerun the steps. An ideal solution to this would be to use an application-level firewall like Squid, but that's a TODO.
2. Manual steps to download HAR file can be automated by using a tool like tcpdump.
3. A more versatile setup can be achieved by using network namespaces to isolate the process and restrict access to the network.

