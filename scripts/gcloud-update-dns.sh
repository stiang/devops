#/bin/bash
set -e

zone="grytoyr-in"
domain="grytoyr.in"
name="$(curl -sH 'Metadata-Flavor: Google' 'http://metadata/computeMetadata/v1/instance/hostname' | awk -F  "." '{print $1}')"
ip="$(curl -sH 'Metadata-Flavor: Google' 'http://metadata/computeMetadata/v1/instance/network-interfaces/0/ip')"
fullname="${name}.${domain}."

current="$(gcloud dns record-sets list --name="${fullname}" --zone="${zone}" 2> /dev/null)"
current_ip_row="$(echo "${current}" | grep "${fullname}" || true)"
current_ip="$(echo ${current_ip_row} | awk '{print $4}')"
current_ttl="$(echo ${current_ip_row} | awk '{print $3}')"

if [ "${ip}" != "${current_ip}" ]
then
  (gcloud dns record-sets transaction abort --zone=${zone} || true) 2> /dev/null
  gcloud dns record-sets transaction start --zone=${zone}
  if [ "${current_ip}x" != "x" ]
  then
    gcloud dns record-sets transaction remove --zone=${zone} --name="${fullname}" --ttl="${current_ttl}" --type=A "${current_ip}"
  fi
  gcloud dns record-sets transaction add --zone=${zone} --name="${fullname}" --type=A --ttl=60 "${ip}"
  gcloud dns record-sets transaction execute --zone=${zone}
else
  echo "Internal host IP did not change, no update needed"
fi
