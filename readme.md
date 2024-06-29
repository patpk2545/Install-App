## Setup (windows)

```powershell
# ตรวจสอบว่าติดตั้ง git แล้วหรือไม่โดยรันคำสั่งนี้ใน windows powerShell:
git --version

# หากไม่ได้ติดตั้ง git ให้ติดตั้งโดยใช้ scoop:
# อนุญาตให้เรียกใช้สคริปต์จากอินเทอร์เน็ต:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Download and install scoop:
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Install git using scoop:
scoop install git

#
หลังจากติดตั้ง git ให้ปิดและเปิด windows powerShell อีกครั้งเพื่อ git commands

# Clone the Install App git repository to your home directory:
git clone https://github.com/patzaba8/Install-App.git $ENV:USERPROFILE/Install_App

# Set the execution policy to allow running the install script:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run the install script to set up the Install App:
~/Install App/install.ps1
```
