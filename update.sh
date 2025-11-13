echo "🚀🚀🚀 Memulai update..."

ACTIVE_USER=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$ACTIVE_USER")
BACKUP_FOLDER=$USER_HOME/setup-server-p7/backup
IMMICH_BACKUP_FOLDER=$USER_HOME/immich

git fetch && git pull
chmod +x $BACKUP_FOLDER/*.sh
chmod +x $IMMICH_BACKUP_FOLDER/*.sh

echo "✅🏁 Update selesai. Permission pada $BACKUP_FOLDER telah diperbarui."
echo "✅ Permission pada $IMMICH_BACKUP_FOLDER telah diperbarui."
