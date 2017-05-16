#!/bin/bash
curl -so /tmp/startup-script "https://raw.githubusercontent.com/stiang/devops/master/scripts/gcloud-post-boot.sh?cachebuster=$(date '+%Y-%m-%d-%H-%M-%N')"
chmod u+x /tmp/startup-script
/tmp/startup-script
