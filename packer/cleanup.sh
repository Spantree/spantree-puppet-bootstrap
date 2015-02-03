PROJECT_DIR=$(echo "$1")

echo "Removing logs from initialization."
rm -f /var/log/*.log /var/log/*.gz /var/log/dmesg*
rm -fr /var/log/syslog /var/log/upstart/*.log /var/log/{b,w}tmp /var/log/udev

echo "Getting rid of bash history."
rm -f $HOME/.bash_history

echo "Removing any Linux kernel packages that we aren't using to boot."
dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' | xargs sudo apt-get -y purge

sleep 3

exit
