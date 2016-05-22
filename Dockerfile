FROM java:openjdk-8u72-jdk
MAINTAINER ototadana@gmail.com

ENV FIREFOX_VERSION 43.0~linuxmint1+betsy
ENV CHROME_VERSION 50.0.2661.102-1
ENV GITLAB_CI_RUNNER_VERSION 1.2.0

ENV WORKSPACE /var/workspace

RUN useradd -d ${WORKSPACE} -u 1000 -m -s /bin/bash owner
RUN mkdir -p /app && chown owner:owner /app

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list \
    && echo "deb http://packages.linuxmint.com debian import " > /etc/apt/sources.list.d/firefox.list \
    && curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | bash \
    && apt-get install -y --force-yes firefox=${FIREFOX_VERSION} gitlab-ci-multi-runner=${GITLAB_CI_RUNNER_VERSION} \
       google-chrome-stable=${CHROME_VERSION} jq make sudo vim xvfb \
    && rm -rf /var/lib/apt/lists/*

RUN echo "owner ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

COPY ./config/. /config/
RUN chown -R owner:owner /config
RUN chmod +x /config/*

USER owner
RUN ln -s ~ /tmp/user_home
WORKDIR /tmp

ENTRYPOINT ["/config/entrypoint"]

ENV DISPLAY :99
ENV SCREEN_WxHxD 1024x768x24
