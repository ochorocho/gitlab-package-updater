FROM ubuntu:18.04

ENV NVM_VERSION=v0.33.6 NODE_VERSION=stable ENV=/root/.bashrc
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update && apt install -y apt-utils curl ca-certificates openssl coreutils make gcc g++ grep util-linux binutils findutils \
    ruby rdoc git curl php php-json php-mbstring openssl php-phar make autoconf npm libreadline-dev zlib1g-dev && \
    gem update --system && gem install bundler

# RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash

# Install rbenv and ruby-build
RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> $ENV
RUN rbenv install 2.0.0-p648

# Setup NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash && \
	echo "#NVM Setup" >> $ENV && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> $ENV && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> $ENV && \
    . $HOME/.nvm/nvm.sh && \
    npm install --global @oclif/config @oclif/plugin-help @oclif/command bundle-outdated-formatter

# Setup Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update && apt install -y yarn && \
    yarn global add yarn-outdated-formatter

# Setup Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    echo $'memory_limit = 1024M' >> /etc/php/php.ini && \
    echo "{}" > ~/.composer/composer.json

# Clean image
# util-linux binutils findutils
RUN apt remove -y --purge wget nano gcc g++ apache2 && \
    apt autoclean && apt autoremove -y

ENV PATH="/gitlab-package-updater/bin:${PATH}"

COPY . /gitlab-package-updater

# Install packages
RUN cd /gitlab-package-updater && bundle install

WORKDIR /gitlab-package-updater/
