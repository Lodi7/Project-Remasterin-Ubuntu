#!/bin/bash
# Skrip First Boot LOS: Git + Docker + Workspace + Shortcut + Banner ASCII + Pesan Ramah

# ===== Fungsi warna =====
HIJAU='\033[0;32m'
SIAU='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# ===== Banner ASCII LOS =====
# ===== Banner ASCII LOS =====
clear
echo -e "${MAGENTA}"
echo "░▒▓█▓▒░      ░▒▓██████▓▒░ ░▒▓███████▓▒░ ";
echo "░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ";
echo "░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ";
echo "░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░  ";
echo "░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░ ";
echo "░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░ ";
echo "░▒▓████████▓▒░▒▓██████▓▒░░▒▓███████▓▒░  ";
echo ""
echo "       Selamat datang di LOS!"
echo "Mohon tunggu sebentar, sistem akan dikonfigurasi untuk penggunaan pertama."
echo "Beberapa pengaturan dan folder akan dibuat secara otomatis."
echo -e "${NC}"
sleep 1

# ===== Langkah 1: Update & Upgrade Sistem =====
echo -e "${SIAU}[1/5] Mohon tunggu sebentar, memperbarui dan meng-upgrade sistem...${NC}"
apt update && apt -y upgrade
apt -y autoremove && apt -y autoclean
echo -e "${HIJAU}[OK] Sistem LOS telah diperbarui!${NC}"
sleep 0.5

# ===== Langkah 2: Konfigurasi Git =====
echo -e "${SIAU}[2/5] Mohon tunggu sebentar, mengatur Git...${NC}"
read -p "Masukkan Nama Git Anda: " GIT_NAME
read -p "Masukkan Email Git Anda: " GIT_EMAIL
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
echo -e "${HIJAU}[OK] Git berhasil dikonfigurasi!${NC}"
sleep 0.5

# ===== Langkah 3: Tambahkan User ke Grup Docker =====
TARGET_USER=${SUDO_USER:-$(whoami)}
echo -e "${SIAU}[3/5] Mohon tunggu sebentar, menambahkan user '$TARGET_USER' ke grup Docker...${NC}"
# Pastikan grup docker sudah ada di chroot
if ! getent group docker > /dev/null 2>&1; then
    groupadd docker
    echo -e "${HIJAU}[OK] Grup Docker dibuat!${NC}"
fi
usermod -aG docker "$TARGET_USER"
echo -e "${HIJAU}[OK] User '$TARGET_USER' berhasil ditambahkan ke grup Docker!${NC}"
sleep 0.5

# ===== Langkah 4: Buat Workspace & Shortcut =====
echo -e "${SIAU}[4/5] Mohon tunggu sebentar, membuat folder workspace dan shortcut...${NC}"
sudo -u $TARGET_USER mkdir -p /home/$TARGET_USER/Workspace
sudo -u $TARGET_USER mkdir -p /home/$TARGET_USER/Projects
# Shortcut VS Code jika terpasang
if [ -f /usr/bin/code ]; then
    sudo -u $TARGET_USER ln -sf /usr/bin/code /home/$TARGET_USER/Desktop/VSCode
fi
echo -e "${HIJAU}[OK] Folder workspace & shortcut LOS siap digunakan!${NC}"
sleep 0.5

# ===== Langkah 5: Finish & Cleanup =====
echo -e "${SIAU}[5/5] Mohon tunggu sebentar, menyelesaikan konfigurasi...${NC}"
if [ -f /etc/systemd/system/firstboot.service ]; then
    systemctl disable firstboot.service
    rm -f /etc/systemd/system/firstboot.service
fi
echo -e "${HIJAU}[OK] First boot setup LOS selesai!${NC}"
sleep 0.5

# ===== Banner Selesai =====
echo -e "${MAGENTA}"
echo "============================================"
echo "     First boot LOS selesai!"
echo " Silakan logout/login atau restart agar grup Docker aktif."
echo "============================================"
echo -e "${NC}"
