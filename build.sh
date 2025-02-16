aws ecr get-login-password --region us-east-1 --profile SEU_PROFILE | docker login --username AWS --password-stdin ID_DA_SUA_CONTA.dkr.ecr.us-east-1.amazonaws.com
docker build -t formacao-mensageria/processar .
docker tag formacao-mensageria/processar:latest ID_DA_SUA_CONTA.dkr.ecr.us-east-1.amazonaws.com/formacao-mensageria/processar:latest
docker push ID_DA_SUA_CONTA.dkr.ecr.us-east-1.amazonaws.com/formacao-mensageria/processar:latest