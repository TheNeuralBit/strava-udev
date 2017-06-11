#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LOG=${DIR}/../upload.log

if [ "${ACTION}" = add -a -e "${DEVNAME}" -a "${ID_FS_LABEL}" = GARMIN ]; then
    DIR=`mktemp -d`
    echo "Mounting to ${DIR}" >> ${LOG}
    mount $DEVNAME $DIR
    for f in ${DIR}/GARMIN/ACTIVITY/*.FIT; do
        if [-f $f]; then
            echo "Uploading $f..." >> ${LOG}
            /var/strava-upload/upload.sh $f >> ${LOG}
            if [$?]; then
                echo "Success! Erasing $f" >> ${LOG}
                rm $f
            else
                echo "Failed" >> ${LOG}
            fi
        fi
    done
    umount $DIR
    rm -rf $DIR
fi
