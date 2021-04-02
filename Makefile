# defaults
region?=$(AWS_DEFAULT_REGION)

# common names
REGION=$(region)

STAGE_NAME=$(stage-name)
STACK_NAME=$(stage-name)

# must have different stack names deployed
postgres_stack_name=$(STACK_NAME)-postgres
alarm_stack_name=$(STACK_NAME)-alarm
do-everything: | build-cf-templates deploy-cf-infrastructure

delete-everything: | delete-cf-service delete-cf-infrastructure

deploy-cf-infrastructure:
	@echo 'Adding webhook url in ssm'
	@aws ssm put-parameter --name "slack_webhook_url" --type "SecureString" --value "${slack_webhook_url}" --overwrite
	@echo 'deploy cf templates'
	@aws cloudformation deploy --no-fail-on-empty-changeset --template-file build/deploy/1-postgres.yml \
		 --stack-name $(postgres_stack_name) \
		--region $(REGION) \
		--capabilities CAPABILITY_NAMED_IAM \
		--tags file://shared/tags/stack_tags \
		--parameter-overrides '$(shell cat env/${REGION}-${STAGE_NAME}-cf-configuration)'
	@aws cloudformation deploy --no-fail-on-empty-changeset --template-file build/deploy/2-alarm.yml \
		 --stack-name $(alarm_stack_name) \
		--region $(REGION) \
		--capabilities CAPABILITY_NAMED_IAM \
		--tags file://shared/tags/stack_tags \
		--parameter-overrides '$(shell cat env/${REGION}-${STAGE_NAME}-cf-configuration)'

delete-cf-infrastructure:
	@echo "Deleting Postgres Stack"
	@aws cloudformation delete-stack --stack-name $(postgres_stack_name) --region $(REGION)
	@aws cloudformation wait stack-delete-complete --stack-name $(postgres_stack_name) --region $(REGION)
	@echo "Deleting Alarm Stack"
	@aws cloudformation delete-stack --stack-name $(alarm_stack_name) --region $(REGION)
	@aws cloudformation wait stack-delete-complete --stack-name $(alarm_stack_name) --region $(REGION)

build-cf-templates:
	@echo 'build cf template'
	@mkdir -p build/deploy
	@cat RdsPostgres/postgres.yml 			| sed 's/{{STACK_NAME}}/$(STACK_NAME)/' > build/deploy/1-postgres.yml
	@cat RdsPostgres/alarm.yml 	     	| sed 's/{{STACK_NAME}}/$(STACK_NAME)/' > build/deploy/2-alarm.yml

