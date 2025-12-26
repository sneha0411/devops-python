FROM google/cloud-sdk:slim

# Terraform version
ARG TERRAFORM_VERSION=1.7.5

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      unzip \
      ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
      -o /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    rm /tmp/terraform.zip

# Verify installation (build-time check)
RUN terraform version && gcloud version

# Default command
CMD ["bash"]
