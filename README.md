# send2chain
This document explains how to setup an automatic recurring token transfer between two accounts on **TELOS**. This should work on other **EOSIO** chains with minimal changes.

---

# OVERVIEW
First, we create a new permission "ACCOUNT/tgtrsfr" with a unique KEY
NOTE: This unique key will only be allowed to transfer tokens from YOUR account. This prevents someone who may compromise this acct from performing other actions, but transferring tokens has significant consequences, so use caution.

Next, we create a separate wallet "claim" and provide ONLY this unique KEY

This shell script "send2chain.sh" will:

- Unlock a dedicated wallet that contains the private key for the ACCOUNT/tgtrsfr permission.
- Execute the token transfer action
- Lock the wallet

_Best practice is to setup a LOCAL USER cron job to run as frequently as you wish._

# INSTALLATION
- Create new EOS KEY Pair (there are many ways to do this).
  NOTE: SAVE the KEY info!
- Create permission:
`cleos set account permission ACCOUNT_NAME tgtrsfr '{"threshold":1,"keys":[{"key":"YOUR_NEW_CLAIMER_PUB_KEY","weight":1}]}' "active" -p ACCOUNT_NAME@active`

`cleos set action permission ACCOUNT_NAME eosio transfer tgtrsfr`

- Create Wallet
`cleos wallet create -n WALLET_NAME -f KEY_FILE_NAME`

**NOTE: SAVE** the wallet key!

- Add NEW key pair to the wallet
`cleos wallet import -n WALLET_NAME`

- paste PRIVATE key when prompted
- LOCK THE WALLET (OPTIONAL STEP. We do this so it's in correct state for the script)
`cleos wallet lock -n WALLET_NAME`

- COPY THE WALLET from `$HOME/telos-wallet` folder to `$HOME/eosio-wallet`

NOTE: I'm not sure why, but seems cleos looks for this wallet in the eosio-wallet folder ¯\(ツ)/¯
`cp $HOME/telos-wallet/YOUR_WALLET_NAME.wallet $HOME/eosio-wallet/`

- Create the file "send2chain.sh". See file in this repo.

- Make the file executable
`sudo chmod 755 send2chain.sh`

## Setup LOCAL_USER crontab job
NOTE: Need to have local user added to /etc/cron.d/cron.allow
If file doesn't exist, create it and all 2 lines:
root
LOCAL_USERNAME <-replace with your specific username
`crontab -e`

- ADD THE FOLLOWING LINE ( will run every top of the hour ):
`5 * * * * /FULL_PATH/send2chain.sh >>/FULL_PATH/transfers.log 2>&1`
