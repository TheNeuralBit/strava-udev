#! /bin/bash

FNAME=$1

STRAVA_API_CLIENTID="your_client_id"
STRAVA_API_SECRET="your_secret"

dir="."
token_file="${DIR}/.token"

echo "looking for token in ${token_file}"
if [ -f ${token_file} ]; then
    access_token=`cat ${token_file}`
else
    echo "Authorize at the following URL:"
    echo "https://www.strava.com/oauth/authorize?client_id=${STRAVA_API_CLIENTID}&response_type=code&scope=write&redirect_uri=http://theneuralbit.com"
    echo ""

    echo "code:"
    read code
    echo ""

    access_token=`curl -X POST https://www.strava.com/oauth/token \
        -F client_id=${STRAVA_API_CLIENTID} \
        -F client_secret=${STRAVA_API_SECRET} \
        -F code=${code} | jq -r .access_token`

    echo -n "$access_token" > ${token_file}
    echo "Got access token ${access_token}"
fi

RESULT=`curl -X POST https://www.strava.com/api/v3/uploads \
    -H "Authorization: Bearer ${access_token}" \
    -H activity_type=run \
    -F file=@${FNAME} -F data_type=fit | jq -r .errors`

if [ "${RESULT}" == null ]; then
    exit 0
else
    echo "Error uploading:"
    echo "${RESULT}"
    exit 1
fi
