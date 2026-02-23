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
