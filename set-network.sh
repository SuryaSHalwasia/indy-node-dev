./v-network/manage rm
./v-network/manage start

# Pause the script for 5 seconds
sleep 60

mkdir ~/.indy-cli
mkdir ~/.indy-cli/networks
mkdir ~/.indy-cli/networks/sandbox

wget http://localhost:9000/genesis pool_transactions_genesis

mv pool_transactions_genesis ~/.indy-cli/networks/sandbox/pool_transactions_genesis