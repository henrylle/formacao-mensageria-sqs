FROM amazonlinux:2

# Install AWS CLI and jq
RUN yum install -y aws-cli jq

# Set the working directory
WORKDIR /app

# Copy the script into the container
COPY processar-mensagem-sqs.sh .

# Make the script executable
RUN chmod +x processar-mensagem-sqs.sh

# Command to run the script
CMD ["./processar-mensagem-sqs.sh"]