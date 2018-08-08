#!/usr/bin/env bash

# more bash-friendly output for jq
JQ="jq --raw-output --exit-status"

APP_NAME=$1
ENVIRONMENT=$2
TEAM_NAME=$3
VERSION=$4

SERVICE_NAME="$ENVIRONMENT-$TEAM_NAME-$APP_NAME-service"
BUILD_NUMBER=${CIRCLE_BUILD_NUM}
IMAGE_TAG=${CIRCLE_SHA1}
TASK_FAMILY="$ENVIRONMENT-$TEAM_NAME-$APP_NAME-task-family"

configure_aws_cli(){
	aws --version
	aws configure set default.region us-east-1
	aws configure set default.output json
}

push_ecr_image(){
    eval $(aws ecr get-login --region us-east-1 --no-include-email)

    echo docker build -t $ENVIRONMENT-${TEAM_NAME}-$APP_NAME  .

    docker build -t $ENVIRONMENT-${TEAM_NAME}-$APP_NAME .

    docker tag $ENVIRONMENT-${TEAM_NAME}-$APP_NAME $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$ENVIRONMENT-${TEAM_NAME}-$APP_NAME:$VERSION

    echo docker tag $ENVIRONMENT-${TEAM_NAME}-$APP_NAME $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$ENVIRONMENT-${TEAM_NAME}-$APP_NAME:$VERSION

    if  [ ${ENVIRONMENT} != "accountopen" ]; then

        eval $(aws ecr get-login --region us-east-1 --no-include-email)

    fi

    docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$ENVIRONMENT-${TEAM_NAME}-$APP_NAME:$VERSION

    echo docker push $AWS_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/$ENVIRONMENT-${TEAM_NAME}-$APP_NAME:$VERSION
}

deploy_cluster(){

	make_task_def
	register_task_definition

    if  [ ${ENVIRONMENT} != "prod" ]; then
        echo ${CLUSTER_NAME}
    	echo ${SERVICE_NAME}

    	DESIRED_COUNT=$(aws ecs describe-services --cluster ${CLUSTER_NAME} --services ${SERVICE_NAME} | egrep "desiredCount" | head -1 | tr "/" " " | awk '{print $2}' | sed 's/,$//')
    	if [ ${DESIRED_COUNT} = "0" ]; then
    	    DESIRED_COUNT="1"
    	fi


        tasks=$(aws --region us-east-1 ecs list-tasks --cluster $CLUSTER_NAME --family ${TASK_FAMILY} | jq -r '.taskArns | map(.[40:]) | reduce .[] as $item (""; . + $item + " ")')
        for task in $tasks; do
            aws --region us-east-1 ecs stop-task --task $task --cluster $CLUSTER_NAME
            echo "Service stoped: $task"
        done
        #aws --region us-west-2 ecs deregister-container-instance --cluster $cluster --container-instance $container_instance

    	if [[ $(aws ecs update-service --cluster $CLUSTER_NAME --service $SERVICE_NAME --task-definition $revision --desired-count ${DESIRED_COUNT} | \
                       $JQ '.service.taskDefinition') != $revision ]]; then
            echo "Error updating service."
            return 1
        else
            echo "Update service.."
        fi
    fi


}

make_task_def(){
    TASK_ALL=$(aws ecs describe-task-definition --task-definition ${TASK_FAMILY})
    echo "Task All: $TASK_ALL"


	TASK_TEMPLATE=$(aws ecs describe-task-definition --task-definition ${TASK_FAMILY} | jq -r .taskDefinition.containerDefinitions[0])
    echo "Template anterior: $TASK_TEMPLATE"

    NEW_CONTAINER_DEFINITIONS=$(echo "$TASK_TEMPLATE" | jq ".image = \"%s.dkr.ecr.us-east-1.amazonaws.com/${ENVIRONMENT}-${TEAM_NAME}-${APP_NAME}:%s\""  )

    echo "Template nuevo: $NEW_CONTAINER_DEFINITIONS"

	task_def=$(printf "$NEW_CONTAINER_DEFINITIONS" $AWS_ACCOUNT_ID $VERSION)
}

register_task_definition() {
	#--container-definitions "$task_def"
    if revision=$(aws ecs register-task-definition --container-definitions "$task_def" --family $TASK_FAMILY | $JQ '.taskDefinition.taskDefinitionArn'); then
        echo "Revision: $revision"
    else
        echo "Failed to register task definition"
        return 1
    fi

}

setup_env_amazon()
{
    if   [ ${ENVIRONMENT} = "prod" ]; then
         export AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID_PROD
         export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_PROD
         export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_PROD
         CLUSTER_NAME="bdb-accountopen-$ENVIRONMENT-adapters-cluster"
    elif [ ${ENVIRONMENT} = "staging" ]; then
         export AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID_STAGING
         export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_STAGING
         export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_STAGING
         CLUSTER_NAME="bdb-common-$ENVIRONMENT-adapters-cluster"
    elif [ ${ENVIRONMENT} = "qa" ]; then
        if [ ${TEAM_NAME} = "avengers" ]; then
           export AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID_MVP2
           export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID_MVP2
           export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY_MVP2
           CLUSTER_NAME="bdb-$ENVIRONMENT-$TEAM_NAME-cluster"
        elif [ ${TEAM_NAME} = "accountopen" ]; then
           export AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID
           export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
           export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
           CLUSTER_NAME="bdb-$TEAM_NAME-$ENVIRONMENT-adapters-cluster"
        elif [ ${TEAM_NAME} = "digi" ]; then
           export AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID
           export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
           export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
           CLUSTER_NAME="bdb-qa-digi-cluster"
        fi

    fi
}

setup_env_amazon
configure_aws_cli
push_ecr_image
deploy_cluster