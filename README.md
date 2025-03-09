# Setting Up a Domain with Namecheap, Cloudflare, and Nginx Reverse Proxy

## 1. Register and Configure Domain in Namecheap
### Step 1: Register a Domain
- Purchase a domain from [Namecheap](https://www.namecheap.com/).

### Step 2: Change DNS to Cloudflare
1. Log in to **Namecheap**.
2. Go to **Domain List** > Select your domain.
3. Under **Nameservers**, choose `Custom DNS` and enter Cloudflare’s nameservers.
4. Save changes.

## 2. Configure Cloudflare for Your Domain
### Step 1: Add Your Domain to Cloudflare
1. Sign up at [Cloudflare](https://dash.cloudflare.com/).
2. Click **Add Site** and enter your domain.
3. Choose the **Free Plan** and continue.
4. Cloudflare will scan your current DNS records.

### Step 2: Update DNS Records in Cloudflare
1. In Cloudflare’s dashboard, go to **DNS**.
2. Add an **A Record**:
    - Name: `@` (root domain)
    - IPv4 Address: Your server's public IP
    - Proxy Status: **Proxied** (Orange Cloud ✅)
3. Add a **CNAME Record**:
    - Name: `www`
    - Target: `yourdomain.com`
    - Proxy Status: **Proxied** ✅
4. Save the records.

### Step 3: Enable SSL/TLS in Cloudflare
1. Go to **SSL/TLS** > **Overview**.
2. Select **Full (Strict)** mode.

## 3. Set Up Nginx Reverse Proxy
### Step 1: Install Nginx on Ubuntu Server
```sh
sudo apt update
sudo apt install nginx -y
```

### Step 2: Configure Nginx for Reverse Proxy
1. Open the Nginx configuration file:
   ```sh
   sudo vim /etc/nginx/sites-available/default
   ```
2. Modify the file with the following configuration:
   ```nginx
   server {
       listen 80;
       server_name yourdomain.com www.yourdomain.com;

       location / {
           proxy_pass http://localhost:8080; # Change to your application port
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
       }
   }
   ```
3. Save and exit Vim (`ESC + :wq`).

### Step 3: Enable Nginx Configuration
```sh
sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
sudo nginx -t # Check for syntax errors
sudo systemctl restart nginx
```

## 4. Allow Firewall Rules
```sh
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

## 5. Obtain and Apply SSL Certificate (Let's Encrypt)
1. Install Certbot:
   ```sh
   sudo apt install certbot python3-certbot-nginx -y
   ```
2. Run Certbot for SSL:
   ```sh
   sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com
   ```
3. Automatic renewal:
   ```sh
   sudo systemctl enable certbot.timer
   ```
```
    Note if are trying to install your own ssl with key you might wanna create a group and add that group to your user like
    Try adding postgres user to the group ssl-cert
    *StackOverFlow fix* :(
    sudo grouadd ssl-cert 
    sudo gpasswd -a ubuntu ssl-cert
    Then fix ownership and mode
    
    sudo chown root:ssl-cert  /etc/ssl/private/ssl-cert-snakeoil.key
    sudo chmod 740 /etc/ssl/private/ssl-cert-snakeoil.key

```
## 6. Verify Setup
1. Run:
   ```sh
   curl -I https://yourdomain.com
   ```
2. Check if Cloudflare is handling SSL correctly.

Your domain is now successfully set up with **Namecheap, Cloudflare, and Nginx as a reverse proxy**! 🎉

