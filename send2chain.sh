#!/bin/bash

#  Usage:  ./send2chain.sh
#  Finds out how much liquid coin is available, rounds to whole number
#  If liquid coins are available, continue
#  Opens wallet $WALLET
#  Sends coin to $TOACCT (using $MEMO) 
#  Locks wallet
#
# NOTE:  Requires special permission on your telos acct named 'tgtrsfr'

CLEOSPATH="" #Path to the cleos executable (i.e. /var/local/)

ACCT="" #the sending acct name
TOACCT="" #The receiving account
MEMO="" #Optional memo field contents

WALLET="" #Local wallet name
KEY="" #Local wallet password

#FOR TESTING, USE THIS VARIABLE AND UNCOMMENT THE SENDAMT=0
# TRIGGER=50
TRIGGER=5500

AMT=`$CLEOSPATHcleos get account $ACCT -j | jq '.core_liquid_balance'`
AMTT=${AMT%.*}
COIN=${AMTT:1}

if [ $COIN -gt $TRIGGER ] 
then
    SENDAMT=`expr $COIN - 500`
    echo "Net send is "$SENDAMT

    # FOR TESTING ONLY
    # SENDAMT=10

    $CLEOSPATHcleos wallet unlock -n $WALLET --password $KEY
    echo "Balance is $AMT.  Coin is $COIN."
    $CLEOSPATHcleos push action eosio.token transfer "{\"from\":\""$ACCT"\" \"to\":\""$TOACCT"\" \"quantity\":\""$SENDAMT".0000 TLOS\" \"memo\":\""$MEMO"\"}" -p "$ACCT@tgtrsfr"
    $CLEOSPATHcleos wallet lock -n $WALLET
else
    echo "Liquid balance is less than $TRIGGER.  Balance is $AMT.  Bye."
fi
