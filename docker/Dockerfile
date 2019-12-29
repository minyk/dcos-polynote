FROM mesosphere/spark:2.9.0-2.4.3-scala-2.11-hadoop-2.9

ARG SPARK_VERSION=2.9.0-2.4.3-scala-2.11-hadoop-2.9
ARG POLYNOTE_VERSION

ENV DEBIAN_FRONTEND noninteractive

RUN  apt update && apt-get install --yes default-jdk software-properties-common wget tar libssl-dev libcurl4-openssl-dev libsasl2-dev python3-dev libxml2-dev

ENV JAVA_HOME="/usr/lib/jvm/default-java/"
ENV PATH="$PATH:$JAVA_HOME/bin"

# Prepare python
RUN wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && rm get-pip.py

# hadoop config
ENV HADOOP_CONF_DIR /etc/hadoop/conf/
RUN mkdir -p $HADOOP_CONF_DIR

# polynote python support
run pip3 install jep jedi 'pyspark==2.4.3' virtualenv numpy pandas koalas

# polynote install
ENV SPARK_MESOS_EXECUTOR_DOCKER_IMAGE mesosphere/spark:$SPARK_VERSION
WORKDIR /opt
RUN wget -q -O polynote-dist.tar.gz "https://github.com/polynote/polynote/releases/download/${POLYNOTE_VERSION}/polynote-dist.tar.gz" && \
tar xzf polynote-dist.tar.gz && rm polynote-dist.tar.gz

WORKDIR /opt/polynote
COPY conf/config ./config
COPY start.sh /start.sh

WORKDIR /opt/spark

CMD ["/start.sh"]
