# 🛡️ Suricata IDS on Google Cloud Platform (Free tier)

## 📌 Overview
This project is an **expansion of the Splunk and Log Source Lab**, where Splunk was deployed as a SIEM and a dedicated log-source VM was used to generate system logs. 

In this phase, Suricata is introduced as a **network-based Intrusion Detection System (IDS)** to provide network telemetry and security alerts. Suricata monitors network traffic between the attacker and the log-source VM and generates alerts that can be forwarded to Splunk for correlation and analysis.

The goal of this guide is to document the **installation, configuration, and validation of Suricata** in the lab environment.

## 🎯 Objectives
- Install Suricata on a dedicated sensor VM
- Configure Suricata for packet capture
- Enable and update detection rules
- Validate detection using test attacks
- Generate IDS alerts for SIEM ingestion

## 🖥️ Environment
- OS: Ubuntu / Debian / Kali Linux
- Privileges: Root or sudo access
- Existing Lab: Splunk Server VM and Log Source VM already deployed
- Suricata VM acts as a dedicated network sensor

## ⚙️ Step-by-Step Suricata Installation

### 1️⃣ Update the System
```bash
sudo apt update && sudo apt upgrade -y
```
### 2️⃣ Install Suricata
```bash
sudo apt install suricata -y
```
Verify installation:
```bash
suricata -V
```
### 3️⃣ Identify Network Interface
Suricata must listen on the correct interface to capture traffic.
```bash
ip a
```
Common interface names:
- eth0
- ens4 (Common for GCP VMs) 
- enp0s3

### 4️⃣ Configure Suricata
Edit the configuration file:
```bash
sudo nano /etc/suricata/suricata.yaml
```
**4.1 Configure HOME_NET**
Set the monitored network range:
```yaml
HOME_NET: "[192.168.1.0/24]" #The subnet where the VM belong
```
For lab testing:
```yaml
HOME_NET: "any"
```

**4.2 Configure Capture Interface**
Find the `af-packet` section and set your interface:
```bash
af-packet:
  - interface: eth0
```
Replace `eth0` with your actual interface.

### 5️⃣ Update Detection Rules
Download and update Suricata rules:
```bash
sudo suricata-update
```
Rules are stored in:
```bash
/var/lib/suricata/rules/
```
### 6️⃣ Start Suricata
Enable Suricata to run at boot and start the service:
```bash
sudo systemctl enable suricata
sudo systemctl start suricata
```
Check status:
```bash
sudo systemctl status suricata
```
### 7️⃣ Validate Detection
Trigger a known test signature:
```bash
curl http://testmynids.org/uid/index.html
```
Check alerts:
```bash
cat /var/log/suricata/fast.log
```
A successful alert confirms Suricata is inspecting network traffic.

8️⃣ Suricata Log Files
Logs are stored in:
```bash
/var/log/suricata/
```
Key files:
| File           | Description                    |
| -------------- | ------------------------------ |
| `fast.log`     | Human-readable alerts          |
| `eve.json`     | JSON events for SIEM ingestion |
| `suricata.log` | Engine logs and errors         |
| `stats.log`    | Performance statistics         |

## 📤 Forward Suricata Logs to Splunk (Universal Forwarder)
This project builds on the earlier **Splunk and Log Source Lab**, where the **Splunk Universal Forwarder (UF)** was already introduced.
For detailed UF installation steps, follow the instructions in the previous repository:

**Reference:** ***Splunk and Log Source Lab → Universal Forwarder Installation Guide***
(Add your GitHub repo link here)

### 1️⃣ Install Splunk Universal Forwarder (Suricata VM)
Follow the same installation steps from the earlier project to install and start the Splunk Universal Forwarder on the Suricata VM.

### 2️⃣ Forward Suricata Logs
Add Suricata logs to Splunk monitoring:
```bash
sudo /opt/splunkforwarder/bin/splunk add monitor /var/log/suricata/eve.json -index suricata -sourcetype suricata:json
sudo /opt/splunkforwarder/bin/splunk add monitor /var/log/suricata/fast.log -index suricata -sourcetype suricata:alert
```

🧠 How This Extends the Splunk Lab
The previous Splunk and Log Source Project focused on host-based logging.
This expansions adds network-level detection, enabling:
- Visibility into scanning and brute-force attacks
- Network-based alerting
- Correlation between host logs and IDS alerts in Splunk

This simulates a real-world SOC environment where **endpoint logs and network telemetry are analyzed together**.
