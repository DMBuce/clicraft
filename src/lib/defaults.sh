#!bash

SERVER_DIR="${SERVER_DIR-$CLICRAFT/srv}"

SERVER_NAME="${SERVER_NAME-minecraft}"

SERVER_JAR="${SERVER_JAR-$SERVER_DIR/minecraft_server.jar}"
SERVER_URL="${SERVER_URL-https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft_server.jar}"

START_COMMAND="${START_COMMAND-java -jar '$SERVER_JAR' nogui}"
DOWNLOAD_COMMAND="${DOWNLOAD_COMMAND-curl -# -o "$SERVER_JAR" "$SERVER_URL"}"

