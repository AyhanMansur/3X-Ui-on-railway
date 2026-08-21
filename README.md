
# 🚀 **3X-ui-Panel** | استقرار ابریِ ۳X-UI روی Railway با Nginx Reverse Proxy

<p align="center"> 
  <img src="https://img.shields.io/badge/Xui--Panel-v4.0-blue?logo=github" /> 
  <img src="https://img.shields.io/badge/Based-Docker-2496ED?logo=docker" /> 
  <img src="https://img.shields.io/badge/Deploy-Railway-0B0D0E?logo=railway" /> 
</p>

### ✨ **پشتیبانی کامل از WebSocket ،HTTP Upgrade ،TCP Reality و gRPC روی یک پورت ابری**

---

## 🌟 **معماری پروژه**

در این پروژه، تمام ترافیک‌های وب (مدیریت پنل، لینک‌های سابسکریپشن و اینباندهای HTTP/WS) از طریق **Nginx Reverse Proxy** روی پورت‌های عمومی standard (80/443) مدیریت می‌شوند. برای پروتکل‌های پیشرفته متکی بر جریان مستقیم TCP/gRPC/Reality روی پورت **8080**، از قابلیت **Railway TCP Proxy** استفاده می‌شود تا اتصال بدون اختلال لایه وب برقرار گردد.

> 💡 **چرا این ساختار بهتر است؟** سرویس‌های ابری مانند Railway به‌طور معمول فقط پورت 80/443 را برای Web Services اختصاص می‌دهند. با این معماری، ۵۰ اینباند HTTP/WS پشت Nginx هدایت شده و پورت‌های ترافیک مستقیم مستقیم از طریق TCP Proxy به هسته متصل می‌شوند.

---

## 🔥 **ویژگی‌های کلیدی**

| ویژگی | توضیح |
| --- | --- |
| ⚡ **3X-UI v3.6.0** | ارتقا به آخرین نسخه رسمی ۳X-UI با کارایی بالاتر |
| 🛡️ **Nginx Reverse Proxy** | مدیریت مسیرها و پروتکل‌های وب پشت یک پورت واحد |
| 🔌 **Railway TCP Proxy** | هدایت مستقیم ترافیک پورت `8080` برای پروتکل‌های Reality / gRPC |
| 🌐 **پشتیبانی فقط در زمانیکه از دامنه‌یشخصی خود که در پشتکلود فلر ثبت‌شده است قابلاستفاده است CF Real IP ** | شناسایی واقعی IP کلاینت‌ها از پشت شبکه CDN کلادفلر |
| 🔀 **۵۰ مسیر اختصاصی Inbound** | مسیریابی پیش‌فرض از `/in1` (پورت داخلی 8001) تا `/in50` (پورت داخلی 8050) |
| 🔄 **WS & HTTP Upgrade Ready** | پشتیبانی کامل از WS و HTTP Upgrade روی پورت‌های داخلی 8001 تا 8050 |
| ⚡ **TCP Reality & xHTTP** | پشتیبانی مستقیم از TCP Reality و xHTTP روی پورت 8080 |
| 📑 **پشتیبانی مستقیم Sub/Panel** | هدایت شفاف مسیر `/managepanel/` به پورت 3000 و `/sub/` به پورت 2096 |

---

## 🛠️ **جدول مسیریابی داخلی (Routing Map)**

| مسیر URL (Path) / پورت | سرویس مقصد داخلی | نوع اتصال / کاربرد |
| --- | --- | --- |
| `/managepanel/` | `127.0.0.1:3000` | داشبورد مدیریت ۳X-UI |
| `/sub/` | `127.0.0.1:2096` | دریافت لینک‌های اشتراک کلاینت‌ها |
| `/in1` تا `/in50` | `127.0.0.1:8001` تا `8050` | اینباندهای ترافیکی Nginx (WS / HTTP Upgrade) |
| **Port 8080** | `127.0.0.1:8080` | اینباند مستقیم از طریق Railway TCP Proxy (Reality / xHTTP / gRPC) |

---

## 🔒 **راهنمای جامع تنظیم امنیت و اینباندها (Inbound & Security Guide)**

### 1️⃣ **اینباندهای مسیرهای `/in1` تا `/in50` (WS / HTTP Upgrade)**

برای ۵۰ اینباند متصل به Nginx (پورت‌های داخلی `8001` تا `8050`):

* **ترانسپورت‌های قابل استفاده:** **`WebSocket (WS)`** یا **`HTTP Upgrade`**
* **Security در پنل:** حتماً روی **`none`** تنظیم شود (چون SSL/TLS توسط لایه بیرونی CDN/Railway هندل می‌شود).
* **تنظیمات Host (در بخش Panel Host/Domain با دکمه Add Host):**
  * **Address / Host:** آدرس اصلی دامنه پنل (مثلاً `your-app.up.railway.app`)
  * **Port:** عدد `443`
  * **Security / TLS:** فعال (Enabled)
                                                                                                            * **و از your-app.up.railway.app به عنوان sni استفاده کنید* 
---

### 2️⃣ **اینباند پورت `8080` (ارتباط مستقیم با Railway TCP Proxy)**

پورت `8080` برای پروتکل‌های لایه ترانسپورت مستقیم رزرو شده است. جهت استفاده از این اینباند:

#### 🔹 **گام اول: فعال‌سازی TCP Proxy در Railway**
1. در داشبورد Railway وارد پروژه خود شده و به بخش **Settings > Networking** بروید.
2. روی گزینه **Add TCP Proxy** کلیک کنید.
3. پورت داخلی را روی **`8080`** قرار دهید.
4. دامنه اختصاصی TCP Proxy (مانند `domain.proxy.rlwy.net`) و پورت اختصاص‌یافته (مانند `12345`) را کپی کنید.

#### 🔹 **گام دوم: تنظیم بخش Host در پنل ۳X-UI**
1. وارد پنل شوید، اینباند پورت `8080` را ویرایش کرده و روی **Add Host** کلیک کنید.
2. **Address / Host:** دامنه TCP Proxy کپی‌شده از Railway (مثلاً `domain.proxy.rlwy.net`)
3. **Port:** پورت اختصاص‌یافته توسط TCP Proxy (مثلاً `12345`)

#### 🔹 **حالت‌های قابل استفاده روی اینباند 8080:**
* **🔴 TCP Reality:**
  * **Transport:** `TCP` | **Security:** `Reality` | **SNI:** دامنه‌های معتبر (مانند `yahoo.com` یا `cloudflare.com`)
* **🟢 xHTTP Reality:**
  * **Transport:** `xHTTP` | **Path:** `/` | **Security:** `Reality`
* **🔵 Trojan gRPC Reality (پیشنهاد ویژه ⚡):**
  * **Protocol:** `Trojan` | **Transport:** `gRPC` | **gRPC Mode:** `Multi` | **Authority / Service Name:** `/` | **Security:** `Reality`

---

## 🧬 **ساختار الگویی URI و ساختار کانفیگ کلاینت‌ها**

### ۱. الگوی استاندارد VLESS/VMess روی WebSocket یا HTTP Upgrade
برای اینباندهای متصل به Reverse Proxy (پورت‌های ۸۰۰۱ تا ۸۰۵۰):

```text
vless://[UUID]@[PUBLIC_DOMAIN]:443?type=ws&security=tls&host=[PUBLIC_DOMAIN]&path=%2Fin1&sni=[PUBLIC_DOMAIN]#WS_Inbound_Sample

```

**نحوه تبدیل به شیء Outbound در هسته کلاینت:**

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

### ۲. الگوی استاندارد Trojan gRPC همراه با Reality (متصل به TCP Proxy)

برای اینباندهای مستقیم روی پورت ۸۰۸۰:

```text
trojan://[PASSWORD]@[TCP_PROXY_DOMAIN]:[TCP_PROXY_PORT]?type=grpc&mode=multi&serviceName=%2F&security=reality&pbk=[PUBLIC_KEY]&fp=chrome&sni=[SNI_DOMAIN]#Trojan_gRPC_Sample

```

---

## 🧭 **راهنمای نصب و استقرار**

### ۲. اتصال به Railway:

1. وارد [Railway.app](https://railway.app/) شوید.
2. پروژه جدید ایجاد کرده و گزینه **Deploy from GitHub repo** را انتخاب کنید.
3. ریپازیتوری `Xui-Panel` را انتخاب کنید.

### ۳. تنظیم TCP Proxy (در صورت نیاز به پورت 8080):

* در بخش **Settings > Networking** یک TCP Proxy جدید برای پورت `8080` ایجاد کنید.

### ۴. دسترسی به پنل:

```text
[https://your-app.up.railway.app/managepanel/](https://your-app.up.railway.app/managepanel/)

```

* **نام کاربری پیش‌فرض**: `admin`
* **رمز عبور پیش‌فرض**: `admin`

---

## 📁 **ساختار پروژه**

```text
Xui-Panel/
├── Dockerfile              # تصویر داکری بر پایه Alpine 3.19 + Nginx & 3X-UI v3.6.0
├── nginx.conf.template     # قالب پیکربندی Nginx همراه با Mappings و CF Real IP
├── start.sh                # اسکریپت استارت و تنظیم متغیرها
└── README.md               # مستندات پروژه

```

---

## 🔗 **لینک‌های مفید**

| منبع | آدرس |
| --- | --- |
| مخزن پروژه | [AyhanMansur/Xui-Panel](https://github.com/AyhanMansur/Xui-Panel) |
| پنل اصلی ۳X-UI | [MHSanaei/3x-ui](https://github.com/mhsanaei/3x-ui) |
| پلتفرم Railway | [railway.app](https://railway.app/) |

---

## 🤝 **مشارکت کنید!**

اگر ایده‌ای برای بهبود دارید، خوشحال می‌شیم:

* **Issue** باز کنید
* **Pull Request** بفرستید
* یا حتی یک **Star** ⭐ به ما بدید تا بقیه هم پیدا کنند!

---

## 📜 **لایسنس**

این پروژه تحت لایسنس **MIT** منتشر شده است — آزاد برای استفاده، تغییر و توزیع.

---
