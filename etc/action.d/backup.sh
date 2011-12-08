#!bash

action cmd 'save-off'
sleep 1

cd "$SRV"
mkdir -p "$BACKUP_DIR"

WORLD=$(grep 'level-name=' server.properties | cut -d '=' -f 2)
DATE=$(date +%Y%m%d-%H%M%S)
zip -r "$BACKUP_DIR/$WORLD-$DATE.zip" "$WORLD"

action cmd 'save-on'

