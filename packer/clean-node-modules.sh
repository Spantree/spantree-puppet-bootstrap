PROJECT_DIR=$(echo "$1")

for app in "common" "status" "game" "matchmaking"
do
	NODE_MODULES_FOLDER="${PROJECT_DIR}/${app}/node_modules"
	echo "Clearing ${NODE_MODULES_FOLDER}"
	rm -Rf "${NODE_MODULES_FOLDER}"
done