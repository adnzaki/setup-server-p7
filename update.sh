echo "🚀🚀🚀 Memulai update..."

ACTIVE_USER=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$ACTIVE_USER")
BACKUP_FOLDER=$USER_HOME/setup-server-p7/backup
IMMICH_BACKUP_FOLDER=$BACKUP_FOLDER/immich
NEXTCLOUD_BACKUP_FOLDER=$USER_HOME/setup-server-p7/app/nextcloud

git fetch && git pull
chmod +x $BACKUP_FOLDER/*.sh
chmod +x $IMMICH_BACKUP_FOLDER/*.sh
chmod +x $NEXTCLOUD_BACKUP_FOLDER/backup-db.sh

echo "✅🏁 Update selesai. Permission pada $BACKUP_FOLDER telah diperbarui."
echo "✅ Permission pada $IMMICH_BACKUP_FOLDER telah diperbarui."
echo "✅ Permission pada $NEXTCLOUD_BACKUP_FOLDER/backup-db.sh telah diperbarui."