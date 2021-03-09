From python:3.7.9-slim-buster

RUN apt-get update --yes \
  && apt-get install --yes --no-install-recommends \
    apt-utils \
    git \
  && apt-get purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN python -m pip install -U pip \
  && git clone https://github.com/teamsoranzo/sccaf \
  && pip install --no-cache-dir ./sccaf
