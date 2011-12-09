#!bash

BACKUP_DIR="$SERVER_DIR/backups"
WORLD=$(grep 'level-name=' server.properties | cut -d '=' -f 2)
DATE=$(date +%Y%m%d-%H%M%S)

cd "$SERVER_DIR"
mkdir -p "$BACKUP_DIR"

if status; then
	action cmd 'save-off'
	sleep 1
fi

zip -r "$BACKUP_DIR/$WORLD-$DATE.zip" "$WORLD"

if status; then
	action cmd 'save-on'
fi

