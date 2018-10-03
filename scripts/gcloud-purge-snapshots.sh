#!/bin/bash
set -e

# HOSTNAME_SHORT=$(hostname --short)
HOSTNAME_SHORT="projectmailer-2"

# Get a list of all discs with prefix "local-"
SNAPSHOT_LIST_LOCAL="$(gcloud compute snapshots list --filter="name~'local-[^-]+-${HOSTNAME_SHORT}-.*'" --uri)"

# loop trough local list
echo "${SNAPSHOT_LIST_LOCAL}" | while read line ; do
  
  # get the snapshot name from the uri
  SNAPSHOT_NAME=${line##*/}
  
  # # get the date that the snapshot was created
  # SNAPSHOT_DATETIME="$(gcloud compute snapshots describe ${SNAPSHOT_NAME} | grep "creationTimestamp" | cut -d " " -f 2 | tr -d \')"

  SNAPSHOT_DATETIME=$(echo "${SNAPSHOT_NAME}" | awk -F'--' '{print $2}' | awk -F'-' '{print $1$2$3}')
  
  # # format the date
  # SNAPSHOT_DATETIME="$(date -d ${SNAPSHOT_DATETIME} +%Y%m%d)"

  echo "name: $SNAPSHOT_NAME Datetime: $SNAPSHOT_DATETIME"

  # Get date to delete from
  SNAPSHOT_EXPIRY="$(date -d "-30 days" +"%Y%m%d")"
  
  echo "Expiry: $SNAPSHOT_EXPIRY"

  SNAPSHOTS_TO_DELETE=""

  # Make sure it's older than 30 days
  if [ $SNAPSHOT_EXPIRY -ge $SNAPSHOT_DATETIME ];
    then
    # Make sure its not first day in month
    if [ $(date -d $SNAPSHOT_DATETIME +%d) != "01" ]
      then
      # #Delete snapshot
      # echo "$(gcloud compute snapshots delete ${SNAPSHOT_NAME} --quiet)"
      SNAPSHOTS_TO_DELETE="${SNAPSHOTS_TO_DELETE} ${SNAPSHOT_NAME} "
    fi
  fi

  if [ "${SNAPSHOTS_TO_DELETE}" != "" ]
    then
    #Delete snapshots
    echo "${SNAPSHOTS_TO_DELETE}"
    # echo "$(gcloud compute snapshots delete ${SNAPSHOTS_TO_DELETE} --quiet)"
  fi
done

