# cf-templates - 
These repo contains the 
> * cf templates for postgress db based on best practice
> * Alarms for cpu,storage,iops,memory,swap,database connection
> * Alerts for db configuration, availabilty or security related changes
> * Code for integration with slack to send customized alerts
> * Makefile to integrate with CI/CD


* Add any env level configuration in the file - _**env/${REGION}-${STAGE_NAME}-cf-configuration**_
> eg. These are mandatory parameters
>    * "PrivateSubnetMain=<subnet-#########>"
>    * "PrivateSubnetBackup=<subnet-#########>"
>    * "DBSecurityGroups=<sg-#############>"
>    * "AlertNotificationEmailGroup=<xyz@example.com>"
>    * "SlackChannel=#slack"

* Add any stack level tags in the file - _**shared/tags/stack_tags**_


 Run below command to deploy everyything in the repo i.e postgres db and alarm. stage can be changed to any other value -if required.
 ## Usage
 ```sh
 aws ssm put-parameter --name "slack_webhook_url" --type "SecureString" --value "${slack_webhook_url}" --overwrite
 make do-everything  stage-name=dev region=us-east-1
 ```


## jenkins file integration
>
```sh 
withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: <>, accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
        stage('Deploy CF Templates') {
            def status = sh(returnStatus: true, script: "make do-everything  stage-name=dev region=us-east-1")
            if (status != 0) {
                throw new Exception("Deploy-cf-templates step is FAILED")
            }
        }
```
