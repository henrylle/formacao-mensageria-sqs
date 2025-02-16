#!/bin/bash

# Substitua pela URL da sua fila SQS
SQS_QUEUE_URL="https://sqs.us-east-1.amazonaws.com/194722436911/formacao-mensageria"

echo "Processando mensagem da fila: $SQS_QUEUE_URL"
# Lê a mensagem da fila
response=$(aws sqs receive-message --queue-url "$SQS_QUEUE_URL" --max-number-of-messages 1 --wait-time-seconds 20)

# Verifica se o response não está vazio e é um JSON válido
if [[ -n "$response" && "$response" == *"Messages"* ]]; then
    # Extrai o corpo da mensagem e o ReceiptHandle
    mensagem=$(echo "$response" | jq -r '.Messages[0].Body')
    receipt_handle=$(echo "$response" | jq -r '.Messages[0].ReceiptHandle')

    # Exibe a mensagem
    echo "Mensagem lida: $mensagem"
    echo "Processando mensagem..."

    # Simula um pequeno tempo de processamento
    sleep 1

    # Mensagem processada
    echo "Mensagem processada com sucesso!"

    # Exclui a mensagem da fila
    aws sqs delete-message --queue-url "$SQS_QUEUE_URL" --receipt-handle "$receipt_handle"
    echo "Mensagem removida da fila."
else
    echo "Nenhuma mensagem encontrada na fila ou resposta inválida."
fi