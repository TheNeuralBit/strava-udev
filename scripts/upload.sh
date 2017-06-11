#! /bin/bash

FNAME=$1

STRAVA_ACCESS_TOKEN="<access token here>"

RESULT=`curl -s -X POST https://www.strava.com/api/v3/uploads \
    -H "Authorization: Bearer ${STRAVA_ACCESS_TOKEN}" \
    -H activity_type=run \
    -F file=@${FNAME} -F data_type=fit`

ERROR=`echo $RESULT | jq .error`

if [ "${ERROR}" == null ]; then
    echo "Uploaded"
    exit 0
else
    echo "Error uploading:"
    echo "${RESULT}" | jq
    exit 1
fi
