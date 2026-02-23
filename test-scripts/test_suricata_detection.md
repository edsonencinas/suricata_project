## ✅ 1. First — verify Suricata is actually inspecting traffic
On the **Suricata VM**, run:
```bash
sudo suricata -T -c /etc/suricata/suricata.yaml -v
```
If OK, then confirm it’s monitoring the correct interface:
```bash
ip a
```
Check the interface name (ex: eth0, ens4, etc.)
Then confirm Suricata is running:
```bash
sudo systemctl status suricata
```
And confirm alerts file updates:
```bash
sudo tail -f /var/log/suricata/fast.log
```
## ✅ 2. Make sure Suricata HAS brute-force detection rules
SSH brute force alerts come from:
- ET Open ruleset
- Usually rule name like:
```code
ET SCAN Potential SSH Scan
ET HUNTING Suspicious SSH BruteForce
ET POLICY SSH Bruteforce attempt
```
Check if rules exist:
```bash
grep -i ssh /var/lib/suricata/rules/*.rules
```
If nothing appears, update rules:
```bash
sudo suricata-update
sudo systemctl restart suricata
```

## ✅ 4. Enable password auth TEMPORARILY (Lab-safe method)
On Suricata target VM, Edit SSH config:
```bash
sudo nano /etc/ssh/sshd_config
```
Change:
```bash
PasswordAuthentication yes
```
Restart SSH:
```bash
sudo systemctl restart ssh
```
Create a fake user for testing:
```bash
sudo adduser testuser
```
Set weak password like:
```bash
123456
```
***Note: For testing purpose, I opened the SSH port of TARGET VM with the allow rule set to my laptops' IP address.***
***After the test I disable password auth again***
To disable password auth:
```yaml
PasswordAuthentication no
```
Restart SSH.
This keeps your VM secure.

## ✅ 3. Create the attack simulation VM
Use **another VM in same subnet** (NOT Suricata VM).
Install attack tool:
```bash
sudo apt update
sudo apt install hydra -y
```
Hydra is safe for lab brute-force testing.

## ✅ 4. Perform SSH brute-force test (LAB ONLY)
From attacker VM:
```bash
hydra -l testuser -P password.txt ssh://TARGET_VM_IP
```
Install **crunch** for the password list you can also install **wordlist** :
```bash
sudo apt install crunch
```
For faster test:
```bash
hydra -l root -P password.txt -t 4 ssh://TARGET_VM_IP
```
