FROM hashicorp/terraform:light

#####
# The python installation has been adopted from
# https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/blob/master/Dockerfile

# The aws cli installation has been adopted from
# https://docs.aws.amazon.com/de_de/cli/latest/userguide/install-linux-al2017.html
# Note: The path is set in entrypoint.sh

# This hack is widely applied to avoid python printing issues in docker containers.
# See: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/pull/13
ENV PYTHONUNBUFFERED=1

RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    \
    echo "**** install aws cli ***" && \
    apk add --no-cache bash && \
    pip3 install --no-cache --upgrade --user awscli

# docker-entrypoint.sh will add the aws cli into the path
# and run terraform
COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /root

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
