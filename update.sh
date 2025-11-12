echo "🚀🚀🚀 Memulai update..."

ACTIVE_USER=${SUDO_USER:-$(whoami)}
USER_HOME=$(eval echo "~$ACTIVE_USER")
BACKUP_FOLDER=$USER_HOME/setup-server-p7/backup

git fetch && git pull
chmod +x $BACKUP_FOLDER/*.sh

echo "✅🏁 Update selesai. Permission pada $BACKUP_FOLDER telah diperbarui."