⚡🧑‍💻 Friends, for more information, join the Telegram channel: [https://t.me/ayhandeveloper](https://t.me/ayhandeveloper?utm_source=gemini)

---

# 🚀 **3X-ui-Panel** | Cloud Deployment of 3X-UI on Railway with Nginx Reverse Proxy

---

### ✨ **Full Support for WebSocket, HTTP Upgrade, TCP Reality, and gRPC on a Single Cloud Port**

---

## 🌟 **Project Architecture**

In this project, all web traffic (panel management, subscription links, and HTTP/WS inbounds) is managed through an **Nginx Reverse Proxy** on standard public ports (80/443). For advanced protocols relying on a direct TCP/gRPC/Reality stream on port **8080**, the **Railway TCP Proxy** feature is utilized to establish a connection without disrupting the web layer.

> 💡 **Why is this structure better?** Cloud services like Railway typically only allocate ports 80/443 for Web Services. With this architecture, 50 HTTP/WS inbounds are routed behind Nginx, and direct traffic ports are connected to the core via the TCP Proxy.

---

## 🔥 **Key Features**

| Feature | Description |
| --- | --- |
| ⚡ **3X-UI v3.10.2** | Upgraded to the latest official 3X-UI version with higher performance |
| 🛡️ **Nginx Reverse Proxy** | Manages web routes and protocols behind a single port |
| 🔌 **Railway TCP Proxy** | Direct traffic routing of port `8080` for Reality / gRPC protocols |
| 🌐 **CF Real IP** | Real client IP detection behind the Cloudflare CDN network (Support is only available when using your own custom domain registered behind Cloudflare) |
| 🔀 **50 Dedicated Inbound Routes** | Default routing from `/in1` (internal port 8001) to `/in50` (internal port 8050) |
| 🔄 **WS & HTTP Upgrade Ready** | Full support for WS and HTTP Upgrade on internal ports 8001 to 8050 |
| ⚡ **TCP Reality & xHTTP** | Direct support for TCP Reality and xHTTP on port 8080 |
| 📑 **Direct Sub/Panel Support** | Transparent routing of the `/managepanel/` path to port 3000 and `/sub/` to port 2096 |

---

## 🛠️ **Internal Routing Map**

| URL Path / Port | Internal Destination Service | Connection Type / Use Case |
| --- | --- | --- |
| `/managepanel/` | `127.0.0.1:3000` | 3X-UI management dashboard |
| `/sub/` | `127.0.0.1:2096` | Retrieving client subscription links |
| `/in1` to `/in50` | `127.0.0.1:8001` to `8050` | Nginx traffic inbounds (WS / HTTP Upgrade) |
| **Port 8080** | `127.0.0.1:8080` | Direct inbound via Railway TCP Proxy (Reality / xHTTP / gRPC) |

---

## 🔒 **Comprehensive Inbound & Security Guide**

### 1️⃣ **Inbound Routes from `/in1` to `/in50` (WS / HTTP Upgrade)**

For the 50 inbounds connected to Nginx (internal ports `8001` to `8050`):

* **Usable Transports:** **`WebSocket (WS)`** or **`HTTP Upgrade`**
* **Security in Panel:** Must be set to **`none`** (because SSL/TLS is handled by the outer CDN/Railway layer).
* **Host Settings (in the Panel Host/Domain section using the Add Host button):**
* **Address / Host:** Main panel domain address (e.g., `your-app.up.railway.app`)
* **Port:** The number `443`
* **Security / TLS:** Enabled
* *And use your-app.up.railway.app as the sni*



---

### 2️⃣ **Port `8080` Inbound (Direct Connection to Railway TCP Proxy)**

Port `8080` is reserved for direct transport layer protocols. To use this inbound:

#### 🔹 **Step One: Enabling TCP Proxy in Railway**

1. In the Railway dashboard, go to your project and navigate to **Settings > Networking**.
2. Click on the **Add TCP Proxy** option.
3. Set the internal port to **`8080`**.
4. Copy the dedicated TCP Proxy domain (e.g., `domain.proxy.rlwy.net`) and the assigned port (e.g., `12345`).

#### 🔹 **Step Two: Configuring the Host Section in the 3X-UI Panel**

1. Enter the panel, edit the port `8080` inbound, and click on **Add Host**.
2. **Address / Host:** The TCP Proxy domain copied from Railway (e.g., `domain.proxy.rlwy.net`).
3. **Port:** The port assigned by the TCP Proxy (e.g., `12345`).

#### 🔹 **Usable Modes on the 8080 Inbound:**

* **🔴 TCP Reality:**
* **Transport:** `TCP` | **Security:** `Reality` | **SNI:** Valid domains (like `yahoo.com` or `cloudflare.com`)


* **🟢 xHTTP Reality:**
* **Transport:** `xHTTP` | **Path:** `/` | **Security:** `Reality`


* **🔵 Trojan gRPC Reality (Special Recommendation ⚡):**
* **Protocol:** `Trojan` | **Transport:** `gRPC` | **gRPC Mode:** `Multi` | **Authority / Service Name:** `/` | **Security:** `Reality`



---

## 🧬 **URI Pattern Structure and Client Configuration**

### 1. Standard VLESS/VMess Pattern on WebSocket or HTTP Upgrade

For inbounds connected to the Reverse Proxy (ports 8001 to 8050):

```text
vless://[UUID]@[PUBLIC_DOMAIN]:443?type=ws&security=tls&host=[PUBLIC_DOMAIN]&path=%2Fin1&sni=[PUBLIC_DOMAIN]#WS_Inbound_Sample


```

**How to convert to an Outbound object in the client core:**

```json
"streamSettings": {
  "network": "ws",
  "security": "tls",
  "tlsSettings": {
    "serverName": "[PUBLIC_DOMAIN]"
  },
  "wsSettings": {
    "path": "/in1",
    "headers": {
      "Host": "[PUBLIC_DOMAIN]"
    }
  }
}


```

### 2. Standard Trojan gRPC Pattern with Reality (Connected to TCP Proxy)

For direct inbounds on port 8080:

```text
trojan://[PASSWORD]@[TCP_PROXY_DOMAIN]:[TCP_PROXY_PORT]?type=grpc&mode=multi&serviceName=%2F&security=reality&pbk=[PUBLIC_KEY]&fp=chrome&sni=[SNI_DOMAIN]#Trojan_gRPC_Sample


```

---

## 🧭 **Installation and Deployment Guide**

### 1. Connecting to Railway:

1. Log in to [Railway.app](https://railway.app/?utm_source=gemini).
2. Create a new project and select the **Deploy from GitHub repo** option.
3. Select the `Xui-Panel` repository.

### 2. Configuring TCP Proxy (if port 8080 is needed):

* In the **Settings > Networking** section, create a new TCP Proxy for port `8080`.

### 3. Accessing the Panel:

```text
[https://your-app.up.railway.app/managepanel/](https://your-app.up.railway.app/managepanel/)


```

* **Default Username**: `admin`
* **Default Password**: `admin`

---

## 📁 **Project Structure**

```text
Xui-Panel/
├── Dockerfile              # Docker image based on Alpine 3.19 + Nginx & 3X-UI v3.6.0
├── nginx.conf.template     # Nginx configuration template with Mappings and CF Real IP
├── start.sh                # Startup and variable configuration script
└── README.md               # Project documentation


```

---

## 🔗 **Useful Links**

| Source | Address |
| --- | --- |
| Project Repository | [AyhanMansur/Xui-Panel](https://github.com/AyhanMansur/Xui-Panel?utm_source=gemini) |
| Official 3X-UI Panel | [MHSanaei/3x-ui](https://github.com/mhsanaei/3x-ui?utm_source=gemini) |
| Railway Platform | [railway.app](https://railway.app/?utm_source=gemini) |

---

## 🤝 **Contribute!**

If you have any ideas for improvement, we'd love it if you:

* Open an **Issue**
* Submit a **Pull Request**
* Or even give us a **Star** ⭐ so others can find it!

---

## 📜 **License**

This project is released under the **MIT** license — free to use, modify, and distribute.

---
