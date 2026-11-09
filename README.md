
⚡🧑‍💻 Friends, join the Telegram channel for more information: https://t.me/ayhandeveloper

---

# 🚀 **3X-ui-Panel** | Cloud Deployment of 3X-UI on Railway with Nginx Reverse Proxy

---

<p align="center"> 
  <img src="https://img.shields.io/badge/3Xui--Panel-v3.10.2-blue?logo=github" /> 
  <img src="https://img.shields.io/badge/Based-Docker-2496ED?logo=docker" /> 
  <img src="https://img.shields.io/badge/Deploy-Railway-0B0D0E?logo=railway" /> 
</p>

### ✨ **Full support for WebSocket, HTTP Upgrade, TCP Reality, and gRPC on a single cloud port**

---

## 🌟 **Project Architecture**

In this project, all web traffic (panel management, subscription links, and HTTP/WS inbounds) is handled through an **Nginx Reverse Proxy** on standard public ports (80/443). For advanced protocols that rely on direct TCP/gRPC/Reality streams on port **8080**, the **Railway TCP Proxy** feature is used so the connection can be established without disrupting the web layer.

> 💡 **Why is this structure better?** Cloud services like Railway typically only assign ports 80/443 for Web Services. With this architecture, 50 HTTP/WS inbounds are routed behind Nginx, and direct traffic ports are connected directly to the core via TCP Proxy.

---

## 🔥 **Key Features**

| Feature | Description |
| --- | --- |
| ⚡ **3X-UI v3.10.2** | Upgraded to the latest official 3X-UI version with higher performance |
| 🛡️ **Nginx Reverse Proxy** | Manages routes and web protocols behind a single port |
| 🔌 **Railway TCP Proxy** | Direct routing of port `8080` traffic for Reality / gRPC protocols |
| 🌐 **CF Real IP — usable only when using your own personal domain registered behind Cloudflare** | Real detection of client IPs from behind the Cloudflare CDN network |
| 🔀 **50 dedicated Inbound routes** | Default routing from `/in1` (internal port 8001) to `/in50` (internal port 8050) |
| 🔄 **WS & HTTP Upgrade Ready** | Full support for WS and HTTP Upgrade on internal ports 8001 to 8050 |
| ⚡ **TCP Reality & xHTTP** | Direct support for TCP Reality and xHTTP on port 8080 |
| 📑 **Direct Sub/Panel support** | Transparent routing of `/managepanel/` to port 3000 and `/sub/` to port 2096 |

---

## 🛠️ **Internal Routing Map**

| URL Path / Port | Internal destination service | Connection type / Purpose |
| --- | --- | --- |
| `/managepanel/` | `127.0.0.1:3000` | 3X-UI management dashboard |
| `/sub/` | `127.0.0.1:2096` | Retrieval of client subscription links |
| `/in1` to `/in50` | `127.0.0.1:8001` to `8050` | Nginx traffic inbounds (WS / HTTP Upgrade) |
| **Port 8080** | `127.0.0.1:8080` | Direct inbound via Railway TCP Proxy (Reality / xHTTP / gRPC) |

---

## 🔒 **Comprehensive Guide to Configuring Security and Inbounds (Inbound & Security Guide)**

### 1️⃣ **Inbounds for routes `/in1` to `/in50` (WS / HTTP Upgrade)**

For the 50 inbounds connected to Nginx (internal ports `443,8002` to `8050`):

* **Usable transports:** **`WebSocket (WS)`** or **`HTTP Upgrade`**
* **Security in the panel:** Must be set to **`none`** (because SSL/TLS is handled by the external CDN/Railway layer).
* **Host settings (in the Panel Host/Domain section with the Add Host button):**
  * **Address / Host:** The main domain address of the panel (e.g., `your-app.up.railway.app`)
  * **Port:** The number `443`
  * **Security / TLS:** Enabled
                                                                                                            * **And use your-app.up.railway.app as the SNI**
---

### 2️⃣ **Port `8080` inbound (direct connection to Railway TCP Proxy)**

Port `8080` is reserved for direct transport-layer protocols. To use this inbound:

#### 🔹 **Step 1: Enable TCP Proxy in Railway**
1. In the Railway dashboard, enter your project and go to **Settings > Networking**.
2. Click on **Add TCP Proxy**.
3. Set the internal port to **`8080`**.
4. Copy the dedicated TCP Proxy domain (e.g., `domain.proxy.rlwy.net`) and the assigned port (e.g., `12345`).

#### 🔹 **Step 2: Configure the Host section in the 3X-UI panel**
1. Enter the panel, edit the port `8080` inbound, and click **Add Host**.
2. **Address / Host:** The TCP Proxy domain copied from Railway (e.g., `domain.proxy.rlwy.net`)
3. **Port:** The port assigned by TCP Proxy (e.g., `12345`)

#### 🔹 **Usable modes on the 8080 inbound:**
* **🔴 TCP Reality:**
  * **Transport:** `TCP` | **Security:** `Reality` | **SNI:** Valid domains (e.g., `yahoo.com` or `cloudflare.com`)
* **🟢 xHTTP Reality:**
  * **Transport:** `xHTTP` | **Path:** `/` | **Security:** `Reality`
* **🔵 Trojan gRPC Reality (special recommendation ⚡):**
  * **Protocol:** `Trojan` | **Transport:** `gRPC` | **gRPC Mode:** `Multi` | **Authority / Service Name:** `/` | **Security:** `Reality`

---

## 🧬 **Sample URI Structure and Client Config Structure**

### 1. Standard VLESS/VMess pattern on WebSocket or HTTP Upgrade
For inbounds connected to the Reverse Proxy (ports 8001 to 8050):

```text
vless://[UUID]@[PUBLIC_DOMAIN]:443?type=ws&security=tls&host=[PUBLIC_DOMAIN]&path=%2Fin1&sni=[PUBLIC_DOMAIN]#WS_Inbound_Sample

```

**How to convert it into an Outbound object in the client core:**

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

### 2. Standard Trojan gRPC pattern with Reality (connected to TCP Proxy)

For direct inbounds on port 8080:

```text
trojan://[PASSWORD]@[TCP_PROXY_DOMAIN]:[TCP_PROXY_PORT]?type=grpc&mode=multi&serviceName=%2F&security=reality&pbk=[PUBLIC_KEY]&fp=chrome&sni=[SNI_DOMAIN]#Trojan_gRPC_Sample

```

---

## 🧭 **Installation and Deployment Guide**

### 2. Connecting to Railway:

1. Go to [Railway.app](https://railway.app/).
2. Create a new project and select **Deploy from GitHub repo**.
3. Select the `Xui-Panel` repository.

### 3. Configure TCP Proxy (if you need port 8080):

* In the **Settings > Networking** section, create a new TCP Proxy for port `8080`.

### 4. Access the panel:

```text
[https://your-app.up.railway.app/managepanel/](https://your-app.up.railway.app/managepanel/)

```

* **Default username**: `admin`
* **Default password**: `admin`

---

## 📁 **Project Structure**

```text
Xui-Panel/
├── Dockerfile              # Docker image based on Alpine 3.19 + Nginx & 3X-UI v3.6.0
├── nginx.conf.template     # Nginx configuration template with Mappings and CF Real IP
├── start.sh                # Startup script and variable setup
└── README.md               # Project documentation

```

---

## 🔗 **Useful Links**

| Resource | Address |
| --- | --- |
| Project repository | [AyhanMansur/Xui-Panel](https://github.com/AyhanMansur/Xui-Panel) |
| Main 3X-UI panel | [MHSanaei/3x-ui](https://github.com/mhsanaei/3x-ui) |
| Railway platform | [railway.app](https://railway.app/) |

---

## 🤝 **Contribute!**

If you have an idea for improvement, we'd be happy if you:

* Open an **Issue**
* Send a **Pull Request**
* Or even give us a **Star** ⭐ so others can find it too!

---

## 📜 **License**

This project is released under the **MIT** license — free to use, modify, and distribute.

---

<p align="center">
  <b>✨ With Xui-Panel, take proxy management to the peak of simplicity ✨</b><br/>
  <i>No VPS, just a container and a little creativity!</i>
</p>
