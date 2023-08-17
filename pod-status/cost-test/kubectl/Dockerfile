FROM bitnami/kubectl

USER root

RUN apt-get update \
 && apt-get install bash

WORKDIR /var

COPY script.sh .

ENTRYPOINT ["sh", "script.sh"]