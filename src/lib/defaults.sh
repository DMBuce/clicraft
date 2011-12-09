#!bash

SRV="${SRV-$CLICRAFT/srv}"

BACKUP_DIR="${BACKUP_DIR-$SRV/backups}"
SERVER_NAME="${SERVER_NAME-minecraft}"

case "$SERVER_TYPE" in
  "bukkit")
	SERVER_JAR="${SERVER_JAR-$SRV/craftbukkit.jar}"
	SERVER_URL="${SERVER_URL-http://ci.bukkit.org/job/dev-CraftBukkit/promotion/latest/Recommended/artifact/target/craftbukkit-0.0.1-SNAPSHOT.jar}"
  ;;
  "minecraft"|*)
	SERVER_JAR="${SERVER_JAR-$SRV/minecraft_server.jar}"
	SERVER_URL="${SERVER_URL-https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft_server.jar}"
  ;;
esac

START_COMMAND="${START_COMMAND-java -jar '$SERVER_JAR' nogui}"
DOWNLOAD_COMMAND="${DOWNLOAD_COMMAND-curl -# -o '$SERVER_JAR' '$SERVER_URL'}"

