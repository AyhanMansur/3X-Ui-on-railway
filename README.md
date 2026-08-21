# 🚀 **3X-ui-Panel** | استقرار ابریِ ۳X-UI روی Railway با Nginx Reverse Proxy


<p align="center"> <img src="https://img.shields.io/badge/Xui--Panel-v4.0-blue?logo=github" /> <img src="https://img.shields.io/badge/Based-Docker-2496ED?logo=docker" /> <img src="https://img.shields.io/badge/Deploy-Railway-0B0D0E?logo=railway" > </p>

### ✨ **پشتیبانی کامل از WebSocket ،HTTP Upgrade ،TCP Reality و gRPC روی یک پورت ابری**

---

## 🌟 **معماری جدید: بدون نیاز به TCP Proxy پیچیده!**

در این نسخه، معماری پروژه با اضافه شدن **Nginx Reverse Proxy** به طور کامل ارتقا یافته است. تمام ترافیک‌های ورودی (مدیریت پنل، لینک‌های سابسکریپشن و اینباندهای ترافیکی) تنها از طریق **یک پورت عمومی HTTP/HTTPS** متصل به Nginx هدایت می‌شوند.

> 💡 **چرا این ساختار بهتر است؟** Railway و سرویس‌های ابری مشابه به‌طور معمول فقط پورت 80/443 را به Load Balancer اختصاص می‌دهند. با این معماری، تا ۵۰ اینباند مختلف بدون نیاز به باز کردن پورت‌های متعدد، روی مسیرهای اختصاصی WebSocket، HTTP Upgrade و TCP Reality کار می‌کنند.

---

## 🔥 **ویژگی‌های جدید و کلیدی**

| ویژگی | توضیح |
| --- | --- |
| ⚡ **3X-UI v3.5.0** | ارتقا به آخرین نسخه رسمی ۳X-UI با کارایی بالاتر |
| 🛡️ **Nginx Reverse Proxy** | مدیریت تمام مسیرها و پروتکل‌ها پشت یک پورت واحد |
| 🌐 **پشتیبانی CF Real IP** | شناسایی واقعی IP کلاینت‌ها از پشت شبکه CDN کلادفلر |
| 🔀 **۵۰ مسیر اختصاصی Inbound** | مسیریابی پیش‌فرض از `/in1` (پورت داخلی 8001) تا `/in50` (پورت داخلی 8050) |
| 🔄 **WS & HTTP Upgrade Ready** | پشتیبانی کامل از WS و HTTP Upgrade روی پورت‌های داخلی 8001 تا 8050 |
| ⚡ **TCP Reality & xHTTP** | پشتیبانی مستقیم از TCP Reality و xHTTP روی پورت 8080 |
| 📑 **پشتیبانی مستقیم Sub/Panel** | هدایت شفاف مسیر `/managepanel/` به پورت 2053 و `/sub/` به پورت 2096 |

---

## 🛠️ **جدول مسیریابی داخلی (Routing Map)**

ترافیک‌های ورودی بر اساس مسیر URL توسط Nginx تفکیک می‌شوند:

| مسیر URL (Path) | سرویس مقصد داخلی | کاربرد |
| --- | --- | --- |
| `/managepanel/` | `127.0.0.1:2053` | داشبورد مدیریت ۳X-UI |
| `/sub/` | `127.0.0.1:2096` | دریافت لینک‌های اشتراک کلاینت‌ها |
| `/in1` تا `/in50` | `127.0.0.1:8001` تا `8050` | اینباندهای ترافیکی (WS / HTTP Upgrade) |
| `/` | `127.0.0.1:8080` | اینباند مستقیم (TCP Reality / xHTTP / gRPC) |

---

## 🔒 **راهنمای جامع تنظیم امنیت و اینباندها (Inbound & Security Guide)**

### 1️⃣ **اینباندهای مسیرهای `/in1` تا `/in50` (WS / HTTP Upgrade)**

برای ۵۰ اینباند متصل به Nginx (پورت‌های داخلی `8001` تا `8050`):

* **ترانسپورت‌های قابل استفاده:** **`WebSocket (WS)`** یا **`HTTP Upgrade`**
* **Security در پنل:** حتماً روی **`none`** تنظیم شود (چون SSL/TLS توسط لایه بیرونی CDN/Railway هندل می‌شود).
* **تنظیمات Host (در بخش Panel Host/Domain با دکمه Add Host):**
* **Address / Host:** آدرس اصلی دامنه پنل (مثلاً `your-app.up.railway.app`)
* **Port:** عدد `443`
* **Security / TLS:** فعال (کلاینت از طریق TLS و پورت 443 متصل می‌شود).



---

### 2️⃣ **اینباند پورت `8080` (TCP Reality / xHTTP / gRPC)**

پورت `8080` برای مسیر عمومی `/` رزرو شده است و امکان استفاده مستقیم از پروتکل‌های پیشرفته لایه ترانسپورت را فراهم می‌کند:

#### 🔴 **الف) TCP Reality (مستقیم با مسیر `/`)**

* **Transport:** `TCP`
* **Security:** `Reality`
* **Path / SNI:** تنظیم دامنه‌های معتبر (مانند `yahoo.com` یا `cloudflare.com`)

#### 🟢 **ب) xHTTP Reality (مسیر ساده `/`)**

* **Transport:** `xHTTP`
* **Path:** `/`
* **Security:** `Reality`

#### 🔵 **ج) Trojan gRPC Reality (پیشنهاد ویژه ⚡)**

* **Protocol:** `Trojan`
* **Transport:** `gRPC`
* **gRPC Mode:** `Multi`
* **Authority / Service Name:** `/` (یا دامنه اصلی پنل)
* **Security:** `Reality`

---

## 🧬 **ساختار الگویی URI و ساختار کانفیگ کلاینت‌ها**

کلاینت‌های متصل‌شونده، رشته‌های URI را پارس کرده و آن‌ها را به اشیاء پیکربندی JSON جهت ارتباط با هسته منبع (Xray-core) تبدیل می‌کنند:

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

### ۲. الگوی استاندارد Trojan gRPC همراه با Reality

برای اینباندهای مستقیم روی پورت ۸۰۸۰:

```text
trojan://[PASSWORD]@[PUBLIC_DOMAIN]:443?type=grpc&mode=multi&serviceName=%2F&security=reality&pbk=[PUBLIC_KEY]&fp=chrome&sni=[SNI_DOMAIN]#Trojan_gRPC_Sample

```

---

## 🧭 **راهنمای نصب و استقرار**

### ۱. کلون کردن مخزن:

```bash
git clone https://github.com/AyhanMansur/Xui-Panel.git
cd Xui-Panel

```

### ۲. اتصال به Railway:

1. وارد [Railway.app](https://railway.app/) شوید.
2. پروژه جدید ایجاد کرده و گزینه **Deploy from GitHub repo** را انتخاب کنید.
3. ریپازیتوری `Xui-Panel` را انتخاب کنید.

### ۴. دسترسی به پنل:

```text
https://your-app.up.railway.app/managepanel/

```

* **نام کاربری پیش‌فرض**: `admin`
* **رمز عبور پیش‌فرض**: `admin`

---

## 📁 **ساختار پروژه**

```text
Xui-Panel/
├── Dockerfile              # تصویر داکری بر پایه Alpine 3.19 + Nginx & 3X-UI v3.5.0
├── nginx.conf.template     # قالب پیکربندی Nginx همراه با Mappings و CF Real IP
├── start.sh                # اسکریپت استارت و تنظیم متغیرها
└── README.md               # مستندات پروژه

```
---

## 🔗 **لینک‌های مفید**

| منبع | آدرس |
|------|------|
| مخزن پروژه | [AyhanMansur/Xui-Panel](https://github.com/AyhanMansur/Xui-Panel) |
| پنل اصلی ۳X-UI | [MHSanaei/3x-ui](https://github.com/mhsanaei/3x-ui) |
| پلتفرم Railway | [railway.app](https://railway.app/) |
---

## 🤝 **مشارکت کنید!**

اگر ایده‌ای برای بهبود دارید، خوشحال می‌شیم:
- **Issue** باز کنید
- **Pull Request** بفرستید
- یا حتی یک **Star** ⭐ به ما بدید تا بقیه هم پیدا کنند!

---

## 📜 **لایسنس**

این پروژه تحت لایسنس **MIT** منتشر شده است — آزاد برای استفاده، تغییر و توزیع.

---

<p align="center">
  <b>✨ با Xui-Panel، مدیریت پروکسی را به اوج سادگی برسانید ✨</b><br/>
  <i>بدون VPS، فقط یک کانتینر و کمی خلاقیت!</i>
</p>
