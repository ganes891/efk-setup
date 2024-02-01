FROM fluent/fluentd:v1.10-debian-1
USER root
#createDir
#testpnc
RUN mkdir /etc/fluent
ADD fluent.conf /etc/fluent/
RUN gem install fluent-plugin-record-reformer
RUN gem install fluent-plugin-elasticsearch
ENTRYPOINT ["fluentd", "-c", "/etc/fluent/fluent.conf"]
