# Base image with gcloud SDK
FROM google/cloud-sdk:slim

# Set Terraform version
ARG TERRAFORM_VERSION=1.7.5

# Install required packages and Terraform
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    ca-certificates \
    && curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
    && unzip terraform.zip \
    && mv terraform /usr/local/bin/terraform \
    && rm terraform.zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Verify installations (fails build if broken)
RUN gcloud version && terraform version

# Default command
CMD ["bash"]
docker build -t terraform-gcloud:1.7.5 .
