Set up integration in Jenkins CI app in Slack, https://my.slack.com/services/new/jenkins-ci

curl -X POST --data-urlencode \
                  'payload={"channel": "#vdm_rosetta", \
                  "username": "jenkins", \
                  "attachments":[{ \
                    "fallback": "${JOB_NAME} - ${BUILD_DISPLAY_NAME} ${message}! <${BUILD_URL}|Open>", \
                    "color": "danger", \
                    "text": "${JOB_NAME} - ${BUILD_DISPLAY_NAME} ${message}! <${BUILD_URL}|Open>", \
                    "fields":[{ \
                      "value": "Project: ${project_name}", \
                      "short": "false" \
                    }] \
                  }], \
                  "icon_url": "https://jenkins.io/images/226px-Jenkins_logo.svg.png"}' \
                  https://hooks.slack.com/services/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

OR

slackSend (baseUrl: "https://excella.slack.com/services/hooks/jenkins-ci/", token: "3SrtHEOBo9dcS3vHeusjWxuk", channel: "#vdm-rosetta-devs", color: "#00FF00", message: "FAILURE: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")