FROM svenbrnn/runpod-ollama:0.18.2

ARG MODEL_NAMES
ENV MODEL_NAMES=$MODEL_NAMES
ADD preload_model.sh /preload_model.sh
RUN apt-get update && apt-get install bash
RUN chmod +x /preload_model.sh && /preload_model.sh

# Copy the model to the volume
FROM svenbrnn/runpod-ollama:0.18.2
COPY --from=0 /runpod-volume /runpod-volume
