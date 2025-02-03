# website_level_firewall
Scripts for creating a sandboxed environment with controlled access to a specific website. It scans the site to identify dependent domains for artifacts, JavaScript libraries, and other resources. A domain-level firewall is then used to restrict the host’s internet access, allowing connections only to the required domains.

# Steps

## Generate HAR (HTTP Archive) file
1. Open up Google Chrome or Firefox.
2. Hit `F12` to bring up Developer Tools.
3. Click on the `Network` tab.
4. Make sure recording is on (the red circle should be on).
5. Do your thing on the site you want to check out.
6. When you're done, right-click on any entry in the `Network` tab and choose `Save all as HAR with content`.
7. Save the HAR file.

