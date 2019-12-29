#!/bin/bash

CONF_DIR="/opt/polynote"

# templating polynote config with DC/OS bootstrap cli
cp -f ${CONF_DIR}/config ${MESOS_SANDBOX}/config
export CONFIG_TEMPLATE_config="config,/opt/polynote/config.yml"
/opt/mesosphere/bootstrap -resolve=false -verbose

if [ -f "${MESOS_SANDBOX}/hdfs-site.xml" ]; then
  cp "${MESOS_SANDBOX}/hdfs-site.xml" "${HADOOP_CONF_DIR}"
fi
if [ -f "${MESOS_SANDBOX}/core-site.xml" ]; then
  cp "${MESOS_SANDBOX}/core-site.xml" "${HADOOP_CONF_DIR}"
fi

if [ -f "${MESOS_SANDBOX}/hive-site.xml" ]; then
  cp "${MESOS_SANDBOX}/hive-site.xml" "${HADOOP_CONF_DIR}"
fi

# Install extra python packages
if [ -n "$PYTHON_PACKAGES" ]; then
  if [ -n "$PIP_PATH" ]; then
    $PIP_PATH install $PYTHON_PACKAGES
  elif [[ $PYSPARK_PYTHON == python3* ]]; then
    pip3 install $PYTHON_PACKAGES
  else
    pip2 install $PYTHON_PACKAGES
  fi
fi

# Install custom cacerts
if [ -e ${MESOS_SANDBOX}/cacerts ]; then
	find /usr/lib/jvm -name cacerts -exec cp ${MESOS_SANDBOX}/cacerts '{}' \;
fi

# Add custom jars
find $MESOS_SANDBOX -iname "*.jar" \( -exec cp {} /opt/spark/jars/ \; -exec cp {} /opt/polynote/deps/ \; \)

# Add TZ
if [ "${TZ:+x}" == "x" ]; then
  if [ -e /usr/share/zoneinfo/$TZ ]; then
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
    echo $TZ > /etc/timezone
  fi
fi

SPARK_HOME=/opt/spark /opt/polynote/polynote
