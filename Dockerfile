FROM ubuntu:18.04

ENV NVM_VERSION=v0.33.6 NODE_VERSION=v12.0 ENV=/root/.bashrc
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y bash curl ca-certificates openssl coreutils make gcc g++ grep util-linux binutils findutils \
    ruby rdoc git curl php php-json php-mbstring openssl php-phar make autoconf npm && \
    gem update --system && gem install bundler
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
RUN echo "#NVM Setup" >> $ENV && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> $ENV && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> $ENV && \
    . $HOME/.nvm/nvm.sh && \
    nvm install stable && nvm use stable


RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install yarn


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    # Configure php.ini
    echo $'memory_limit = 1024M' >> /etc/php/php.ini && \
    yarn global add yarn-outdated-formatter && \
    npm install --global @oclif/config @oclif/plugin-help @oclif/command bundle-outdated-formatter && \
    # Cleanup image
    echo "{}" > ~/.composer/composer.json

ENV PATH="/gitlab-package-updater/bin:${PATH}"

COPY . /gitlab-package-updater

# Install packages
RUN cd /gitlab-package-updater && bundle install

WORKDIR /gitlab-package-updater/
