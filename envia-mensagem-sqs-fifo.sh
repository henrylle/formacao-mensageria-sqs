#!/bin/bash

echo "Grupo da mensagem: $2"

# Substitua pela URL da sua fila SQS
SQS_QUEUE_URL="https://sqs.us-east-1.amazonaws.com/194722436911/formacao-mensageria.fifo"

# Perfil configurado no AWS CLI
AWS_PROFILE="user-mensageria"


# Envia a mensagem para a fila SQS
response=$(aws sqs send-message --queue-url "$SQS_QUEUE_URL" --message-body "$1" --message-group-id "$2" --message-deduplication-id "$1"  --profile "$AWS_PROFILE")

# Verifica se o envio foi bem-sucedido
if [[ $? -eq 0 ]]; then
    message_id=$(echo "$response" | jq -r '.MessageId')
    echo "Mensagem enviada com sucesso! ID: $message_id"
else
    echo "Falha ao enviar a mensagem."
fi
