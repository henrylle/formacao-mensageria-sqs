#!/bin/bash

echo "Processando mensagem da fila: $SQS_QUEUE_URL"

# Exibe a mensagem
echo "Mensagem lida: $BODY"
echo "ReceiptHandle: $RECEIPT_HANDLE"
echo "Processando mensagem..."

# Simula um pequeno tempo de processamento
sleep 1

# Mensagem processada
echo "Mensagem processada com sucesso!"

# Exclui a mensagem da fila
aws sqs delete-message --queue-url "$SQS_QUEUE_URL" --receipt-handle "$RECEIPT_HANDLE"
echo "Mensagem removida da fila."