#!/bin/bash

#i-01ab5628454fe8343

CMD=$1
INSTANCE_ID=i-01ab5628454fe8343

if [[ ${CMD} == "start" ]]; then
    aws ec2 start-instances --instance-ids ${INSTANCE_ID}
elif [[ ${CMD} == "stop" ]]; then
    aws ec2 stop-instances --instance-ids ${INSTANCE_ID}
elif [[ ${CMD} == "connect" ]]; then
    IP=$(aws ec2 describe-instances --instance-ids ${INSTANCE_ID} | jq .Reservations[0].Instances[0].PublicIpAddress | sed 's/"//g')
    ssh -i bbb-access.key ubuntu@${IP}
else
    echo "invalid command"
fi

