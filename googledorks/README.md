# Google Dorking Commands

Google Dorking is a technique used to find information on the web using advanced Google search operators. Below are some useful Google Dork commands:

## 1. Finding Specific File Types
- **`filetype:pdf site:example.com`**  
  Find all PDF files on `example.com`.

- **`filetype:docx confidential`**  
  Find Word documents containing the word "confidential".

## 2. Searching for Specific Text in URLs
- **`inurl:login`**  
  Find URLs containing the word "login".

- **`inurl:admin`**  
  Find admin login pages.

## 3. Finding Specific Information on Websites
- **`site:example.com "password"`**  
  Search for the word "password" on `example.com`.

- **`intitle:"index of" "backup"`**  
  Find directories with the title "Index of" containing backups.

## 4. Finding Exposed Databases
- **`intitle:"index of" "mysql.conf"`**  
  Look for exposed MySQL configuration files.

- **`filetype:sql "password"`**  
  Find SQL files that may contain passwords.

## 5. Finding Vulnerable Websites
- **`inurl:"php?id="`**  
  Identify URLs that might be vulnerable to SQL injection.

- **`"Powered by WordPress" inurl:wp-content`**  
  Find websites powered by WordPress, which may have exploitable vulnerabilities if not updated.

## 6. Looking for Email Addresses
- **`site:example.com "@example.com"`**  
  Find email addresses associated with `example.com`.

- **`"@gmail.com" filetype:xls`**  
  Find Excel files containing Gmail addresses.

## 7. Discovering Sensitive Directories
- **`intitle:"index of" "admin"`**  
  Search for directories that may contain admin panels.

- **`intitle:"index of" "ftp"`**  
  Look for exposed FTP directories.

## 8. Finding Cameras and Other IoT Devices
- **`inurl:"/view.shtml"`**  
  Find publicly accessible IP cameras.

- **`inurl:"axis-cgi/mjpg"`**  
  Search for unsecured Axis cameras.

## 9. Uncovering Error Messages
- **`"Warning: mysql_connect()"`**  
  Find sites with MySQL connection errors that could reveal database details.

- **`"intitle:"phpmyadmin" "Error"`**  
  Look for errors related to phpMyAdmin.

## 10. Discovering Login Portals
- **`intitle:"admin login"`**  
  Find admin login pages.

- **`intitle:"secure login"`**  
  Search for secure login portals.

## 11. Exposing Unsecured Files
- **`filetype:log`**  
  Find log files that might contain sensitive information.

- **`filetype:cfg`**  
  Look for configuration files that could expose system settings.

## 12. Finding Vulnerable Devices
- **`intitle:"index of /" inurl:admin`**  
  Search for directories with administrative access.

- **`intitle:"WebcamXP 5"`**  
  Look for unsecured WebcamXP 5 feeds.

## 13. Looking for Passwords
- **`"your password is" filetype:txt`**  
  Search for text files containing passwords.

- **`inurl:wp-config.php`**  
  Look for WordPress configuration files that may contain database credentials.

## 14. Finding Unprotected APIs
- **`inurl:"/api/" "token"`**  
  Search for API endpoints that may expose tokens.

- **`"api_key" filetype:env`**  
  Look for `.env` files that may contain API keys.

## 15. Finding Directories
- **`intitle:"index of" /admin`**  
  Find directories named "admin".

- **`intitle:"index of" /passwords`**  
  Search for directories containing password files.

## 16. Finding WordPress Plugins and Themes
- **`inurl:wp-content/plugins`**  
  Identify WordPress plugins, potentially revealing vulnerabilities.

- **`inurl:wp-content/themes`**  
  Discover WordPress themes, possibly leading to security insights.

## 17. Discovering Backup Files
- **`filetype:bak inurl:"backup"`**  
  Find backup files that may contain sensitive information.

- **`filetype:sql inurl:"backup"`**  
  Look for SQL backup files that could be exploited.

## example for finding admin wordpress
```
site:domain.tld intitle: Log In inurl:wp-login.php
```

```
site:domain.tld inurl:wp-admin
```

