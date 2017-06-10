#! /bin/bash

FNAME=$1

STRAVA_ACCESS_TOKEN="<access token here>"

RESULT=`curl -s -X POST https://www.strava.com/api/v3/uploads \
    -H "Authorization: Bearer ${STRAVA_ACCESS_TOKEN}" \
    -H activity_type=run \
    -F file=@${FNAME} -F data_type=fit`

ACTIVITY_ID=`echo $RESULT | jq .activity_id`

if [ "${ACTIVITY_ID}" == null ]; then
    echo "Error uploading:"
    echo "${RESULT}"
    exit 1
else
    echo "Uploaded, ID=${ACTIVITY_ID}"
    exit 0
fi
