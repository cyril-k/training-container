# Bumped CUDA version
FROM nvidia/cuda:12.1.0-base-ubuntu20.04

ENV PYTHONUNBUFFERED=1

# Install Python 3.10
RUN --mount=type=cache,target=/var/cache/apt --mount=type=cache,target=/var/lib/apt \
    apt-get update && \
    apt-get -y --no-install-recommends install \
    software-properties-common curl &&\
    add-apt-repository ppa:deadsnakes/ppa &&\
    apt-get update && \
    apt-get -y --no-install-recommends install \
    python3.10 && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10 && \
    rm -rf /var/lib/apt/lists/*
# Install poetry
RUN python3.10 -m pip install --no-cache-dir poetry
# Copy dependencies file
COPY pyproject.toml poetry.lock* ./
# Install dependencies
RUN poetry config virtualenvs.create false \
    && poetry install --no-dev --no-interaction --no-ansi
# Copy training script (ref https://gist.github.com/mlabonne/8eb9ad60c6340cb48a17385c68e3b1a5)
COPY app/train.py train.py
# Define entrypoint as training script
ENTRYPOINT [ "poetry", "run", "python3.10", "train.py" ]