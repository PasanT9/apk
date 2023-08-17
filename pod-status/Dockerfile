FROM bitnami/kubectl

USER root

RUN apt-get update \
 && apt-get install bash curl

WORKDIR /var

COPY script.sh .

ENTRYPOINT ["bash", "script.sh"]