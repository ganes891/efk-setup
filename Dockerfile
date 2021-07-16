FROM fluent/fluentd:v1.10-debian-1
USER root
#createDir
RUN mkdir /etc/fluent
ADD fluent.conf /etc/fluent/
RUN gem install --http-proxy http://10.133.12.181:80 fluent-plugin-record-reformer
RUN gem install --http-proxy http://10.133.12.181:80 fluent-plugin-elasticsearch
ENTRYPOINT ["fluentd", "-c", "/etc/fluent/fluent.conf"]
