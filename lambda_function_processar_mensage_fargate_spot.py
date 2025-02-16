import boto3
import json
import logging
import os

# Configurar o logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Inicializar o cliente ECS
ecs_client = boto3.client('ecs')

def lambda_handler(event, context):
    try:
        # Extrair mensagens do evento SQS
        for record in event['Records']:
            message_body = record['body']
            logger.info(f'Received message: {message_body}')

            # Obter configurações do ambiente no momento da invocação
            task_definition = os.environ.get('TASK_DEFINITION', 'task-def-processar-mensagem')
            cluster_name = os.environ.get('CLUSTER_NAME', 'cluster-formacao-mensageria')
            container_name = os.environ.get('CONTAINER_NAME', 'processar-mensagem')
            sqs_queue_url = os.environ.get('SQS_QUEUE_URL', 'https://sqs.us-east-1.amazonaws.com/123456789012/queue-formacao-mensageria')

            # Iniciar uma tarefa Fargate com a mensagem recebida
            response = ecs_client.run_task(
                cluster=cluster_name,
                capacityProviderStrategy=[
                    {
                        'capacityProvider': 'FARGATE_SPOT',
                        'weight': 1,
                        'base': 1
                    }
                ],
                taskDefinition=task_definition,
                networkConfiguration={
                    'awsvpcConfiguration': {
                        'subnets': ['subnet-0805b9ff8f5e9e073'],  # Substitua pelo seu subnet ID
                        'securityGroups': ['sg-035854274188565b6'],  # Substitua pelo seu security group ID
                        'assignPublicIp': 'ENABLED'
                    }
                },
                overrides={
                    'containerOverrides': [
                        {
                            'name': container_name,
                            'environment': [
                                {'name': 'BODY', 'value': message_body},
                                {'name': 'RECEIPT_HANDLE', 'value': record['receiptHandle']},
                                {'name': 'SQS_QUEUE_URL', 'value': sqs_queue_url}
                            ]
                        }
                    ]
                }
            )

            logger.info(f'Fargate task started: {response}')

        # Lançar um erro para que a mensagem não seja excluída da fila
        raise Exception("Intencionalmente levantando um erro para evitar a exclusão da mensagem pelo Lambda")

    except Exception as e:
        logger.error(f'Erro ao processar mensagem: {str(e)}')
        raise
