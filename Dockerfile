FROM python:3.9-bullseye AS install

RUN apt-get update; apt-get full-upgrade -y; rm -rf /var/lib/apt/lists

ARG CHIA_VERSION=1.3.4
ARG VIRTUAL_ENV=/venv

# Setup virtualenv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --no-cache-dir -U pip setuptools wheel

# Install chia-blockchain
RUN pip install "chia-blockchain==${CHIA_VERSION}"

###

FROM python:3.9-slim-bullseye AS production

RUN apt-get update; apt-get full-upgrade -y; rm -rf /var/lib/apt/lists

ARG VIRTUAL_ENV=/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY --from=install $VIRTUAL_ENV/ $VIRTUAL_ENV/
COPY start-*.sh /usr/local/bin

# Full Node
EXPOSE 8555
# Farmer
EXPOSE 8559
# Harvester
EXPOSE 8560
# Wallet
EXPOSE 9256

CMD [ "start-full-node.sh" ]
