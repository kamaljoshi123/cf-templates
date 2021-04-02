# cf-templates
These repo contains the cf templates for aws resources

* Add any env level configuration in the file - _**env/${REGION}-${STAGE_NAME}-cf-configuration**_
> eg. These are mandatory parameters
>    * "PrivateSubnetMain=<subnet-#########>"
>    * "PrivateSubnetBackup=<subnet-#########>"
>    * "DBSecurityGroups=<sg-#############>"
>    * "AlertNotificationEmailGroup=<xyz@example.com>"
>    * "SlackChannel=#slack"

* Add any stack level tags in the file - _**shared/tags/stack_tags**_

Run below command to add slack webhook in the parameter store with name slack_webhook_url

 Run below command to deploy everyything in the repo i.e postgres db and alarm. stage can be changed to any other value -if required
 >`make do-everything  stage-name=dev region=us-east-1 slack_webhook_url=https://hooks.slack.com/services/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`
