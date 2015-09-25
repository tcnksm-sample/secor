FROM java:openjdk-7-jdk

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
                              git \
                              curl \
            && rm -rf /var/lib/apt/lists/*

# Install apache maven
# References https://github.com/carlossg/docker-maven
ENV MAVEN_VERSION 3.2.3
RUN curl -sSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
    && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

# Install pinterest/secor
RUN git clone https://github.com/pinterest/secor /tmp/secor
WORKDIR /tmp/secor

ENV SECOR_INSTALL_DIR /opt/secor
ENV SECOR_VERSION 0.2
RUN mkdir $SECOR_INSTALL_DIR \
    && mvn package \
    && tar -zxvf target/secor-${SECOR_VERSION}-SNAPSHOT-bin.tar.gz -C $SECOR_INSTALL_DIR \
    && rm -fr /tmp/secor

ADD run.sh ${SECOR_INSTALL_DIR}/run.sh

WORKDIR $SECOR_INSTALL_DIR
CMD ["./run.sh"]

