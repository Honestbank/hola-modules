aws ecr get-login-password --profile test \
    --region ap-southeast-1 \
| docker login \
    --username AWS \
    --password-stdin 840278898628.dkr.ecr.ap-southeast-1.amazonaws.com