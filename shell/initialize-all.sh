SCRIPT_ROOT=$(echo "$1")

$SCRIPT_ROOT/os-detect-setup.sh $SCRIPT_ROOT
$SCRIPT_ROOT/initial-setup.sh $SCRIPT_ROOT
$SCRIPT_ROOT/update-puppet.sh $SCRIPT_ROOT
$SCRIPT_ROOT/librarian-puppet-vagrant.sh $SCRIPT_ROOT