########################
# Stage 1: Builder
########################
FROM ubuntu:24.04 AS builder

ARG TERRAFORM_VERSION=1.11.4
ARG ANSIBLE_VERSION=2.18.7

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    PATH="/opt/venv/bin:$PATH"

# Install build dependencies
RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        wget unzip gnupg software-properties-common \
        ca-certificates build-essential \
        libssl-dev libffi-dev \
        python3 python3-venv python3-pip \
        curl git; \
    rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python3 -m venv /opt/venv

# Upgrade pip inside venv
RUN pip3 install --upgrade pip wheel

# Install Terraform
RUN arch="$(dpkg --print-architecture)"; \
    wget -q "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${arch}.zip"; \
    unzip -o "terraform_${TERRAFORM_VERSION}_linux_${arch}.zip" -d /usr/local/bin/; \
    rm "terraform_${TERRAFORM_VERSION}_linux_${arch}.zip"

# Copy Azure and Ansible requirements
COPY ./requirements-azure.txt ./requirements-azure.txt
COPY ./requirements.yml ./requirements.yml

# Install Python packages in venv
RUN pip3 install --no-cache-dir -r requirements-azure.txt \
    ansible-core==${ANSIBLE_VERSION} jinja2==3.1.6

# Install Ansible Galaxy collections
RUN ansible-galaxy collection install -r requirements.yml

########################
# Stage 2: Runtime
########################
FROM ubuntu:24.04 AS runtime

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8 \
    PATH="/opt/venv/bin:$PATH"

# Minimal runtime dependencies
RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        python3 python3-venv python3-pip \
        sshpass \
        openssh-client \
        ca-certificates \
        git unzip wget curl; \
    rm -rf /var/lib/apt/lists/*

# Copy Terraform binary
COPY --from=builder /usr/local/bin/terraform /usr/local/bin/terraform

# Copy virtual environment from builder
COPY --from=builder /opt/venv /opt/venv

# Copy Ansible Galaxy collections
COPY --from=builder /root/.ansible /root/.ansible

# Default command
CMD ["bash"]
