echo "🚀🚀🚀 Memulai update..."

ACTIVE_USER=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$ACTIVE_USER")
BACKUP_FOLDER=$USER_HOME/setup-server-p7/backup
IMMICH_BACKUP_FOLDER=$BACKUP_FOLDER/immich
NEXTCLOUD_BACKUP_FOLDER=$USER_HOME/setup-server-p7/app/nextcloud
SISAUANG_BACKUP_FOLDER=$BACKUP_FOLDER/sisauang
PENGASINAN7_BACKUP_FOLDER=$BACKUP_FOLDER/pengasinan7

git fetch && git pull
chmod +x $BACKUP_FOLDER/*.sh
chmod +x $IMMICH_BACKUP_FOLDER/*.sh
chmod +x $NEXTCLOUD_BACKUP_FOLDER/backup-data.sh
chmod +x $NEXTCLOUD_BACKUP_FOLDER/backup-db.sh
chmod +x $SISAUANG_BACKUP_FOLDER/*.sh
chmod +x $PENGASINAN7_BACKUP_FOLDER/*.sh
echo "✅🏁 Update selesai. Permission pada $BACKUP_FOLDER telah diperbarui."
echo "✅ Permission pada $IMMICH_BACKUP_FOLDER telah diperbarui."
echo "✅ Permission pada $NEXTCLOUD_BACKUP_FOLDER telah diperbarui."
echo "✅ Permission pada $SISAUANG_BACKUP_FOLDER telah diperbarui."
echo "✅ Permission pada $PENGASINAN7_BACKUP_FOLDER telah diperbarui."