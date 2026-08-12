ARG OLLAMA_VERSION=0.32.5

# Use an official base${OLLAMA_VERSION} image with your desired version
FROM ollama/ollama:${OLLAMA_VERSION}

ENV PYTHONUNBUFFERED=1


# Set up the working directory
WORKDIR /

RUN DEBIAN_FRONTEND=noninteractive apt-get update --yes --quiet \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
        software-properties-common \
        gpg-agent \
        build-essential \
        apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt-get install --reinstall --yes \
        ca-certificates \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
        bash \
        curl \
        git \
        python3-setuptools \
        python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Set the working directory
WORKDIR /work

# Add my src as /work
ADD ./src /work

# Set defaut ollama models directory to /runpod-volume where runpod will mount the volume by default
ENV OLLAMA_MODELS="/runpod-volume"

# Install runpod and its dependencies
RUN pip install --ignore-installed --break-system-packages --upgrade -r requirements.txt 
RUN chmod +x /work/start.sh
    
# Set the entrypoint
ENTRYPOINT ["/bin/sh", "-c", "/work/start.sh"]

# Preload a model
ENV MODEL_NAMES="gemma4:31b-it-qat"
RUN chmod +x /work/preload_model.sh \
    && /work/preload_model.sh
