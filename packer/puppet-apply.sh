PROJECT_DIR=$(echo "$1")
USERNAME=$(echo $2)

export FACTER_ssh_username=$USERNAME

echo "Running puppet apply"
/usr/local/bin/puppet apply --verbose --debug --modulepath="/etc/puppet/modules:${PROJECT_DIR}/puppet/modules" --manifestdir "${PROJECT_DIR}/puppet/manifests" --hiera_config "${PROJECT_DIR}/hiera.yaml" --parser future --debug --detailed-exitcodes "${PROJECT_DIR}/puppet/manifests/default.pp"

# ignore the "changes" detailed exit code
if [ $? = 2 ]; then
	exit 0
else
	exit $?
fi