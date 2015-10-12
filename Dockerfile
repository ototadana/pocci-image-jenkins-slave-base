FROM java:openjdk-8u66-jdk
MAINTAINER ototadana@gmail.com

ENV FIREFOX_VERSION 41.0.1~linuxmint1+betsy
ENV CHROME_VERSION 45.0.2454.101-1

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && echo "deb http://packages.linuxmint.com debian import " > /etc/apt/sources.list.d/firefox.list \
    && apt-get update \
    && apt-get install -y --force-yes firefox=${FIREFOX_VERSION} google-chrome-stable=${CHROME_VERSION} make sudo vim xvfb \
    && rm -rf /var/lib/apt/lists/*

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV JENKINS_HOME /var/jenkins_home

RUN useradd -d ${JENKINS_HOME} -u 1000 -m -s /bin/bash jenkins
RUN mkdir -p /app && chown jenkins:jenkins /app
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

COPY ./config/. /config/
RUN chown -R jenkins:jenkins /config
RUN chmod +x /config/*

USER jenkins
WORKDIR /tmp

ENTRYPOINT ["/config/entrypoint"]
CMD ["/config/startJenkinsSlave.sh"]

ENV DISPLAY :99
ENV SCREEN_WxHxD 1024x768x24
