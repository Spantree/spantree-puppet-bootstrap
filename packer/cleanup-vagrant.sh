PROJECT_DIR=$(echo "$1")

echo "Cleaning out any cached interfaces."
rm -f /etc/udev/rules.d/70-persistent-net.rules

# echo "Cleaning out apt cache, lists, and autoremoving any packages."
rm -f /var/lib/apt/lists/lock
rm -f /var/lib/apt/lists/*_*
rm -f /var/lib/apt/lists/partial/*
# apt-get -y autoremove
# apt-get -y clean

echo "Removing Project Source (will be a shared folder in Vagrant)"
rm -Rf "${PROJECT_DIR}"

sleep 3

exit