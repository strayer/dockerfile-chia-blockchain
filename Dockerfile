FROM python:3.10-bullseye AS install

RUN apt-get update; apt-get full-upgrade -y; rm -rf /var/lib/apt/lists

# renovate: datasource=pypi depName=chia-blockchain
ARG CHIA_VERSION=1.8.0
ARG VIRTUAL_ENV=/venv

# Setup virtualenv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install --no-cache-dir -U pip setuptools wheel

# Install chia-blockchain
RUN pip install "chia-blockchain==${CHIA_VERSION}"

# Compile installed code:
RUN python -c "import compileall; \
  compileall.compile_path(maxlevels=10)"

###

FROM python:3.10-slim-bullseye AS production

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
