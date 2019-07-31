FROM ubuntu:18.04

SHELL [ "/bin/bash", "-l", "-c" ]

ENV NVM_VERSION=v0.33.6 ENV=/root/.bashrc
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apt update && apt install -y apt-utils curl ca-certificates openssl coreutils make gcc g++ grep util-linux binutils findutils \
    software-properties-common ruby rdoc git curl php php-json php-mbstring openssl php-phar make autoconf nodejs npm libreadline-dev zlib1g-dev && \
    gem update --system && gem install bundler

# Setup NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash && \
	echo "#NVM Setup" >> $ENV && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> $ENV && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> $ENV && \
    . $HOME/.nvm/nvm.sh
RUN . ~/.nvm/nvm.sh; nvm install stable
RUN . ~/.nvm/nvm.sh; nvm use stable
RUN npm install --global @oclif/config @oclif/plugin-help @oclif/command bundle-outdated-formatter

# Setup Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update && apt install -y yarn && \
    yarn global add yarn-outdated-formatter

# Setup Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    echo $'memory_limit = 1024M' >> /etc/php/php.ini && \
    echo "{}" > ~/.composer/composer.json

#RUN apt-add-repository -y ppa:rael-gc/rvm
#RUN apt update
#RUN apt -y install rvm

RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
RUN curl -sSL https://get.rvm.io | bash -s stable
ENV PATH=$PATH:/opt/rvm/bin:/opt/rvm/sbin
RUN rvm list remote

#RUN rvm install ruby-2.6.3 --binary

#RUN gem install bundler:2.0.1

#RUN /bin/bash -l -c "which npm"
#RUN /bin/bash -l -c "rvm list remote"
#RUN /bin/bash -l -c "rvm install ruby-2.6.3 --binary"

# Clean image
RUN apt remove -y --purge wget nano gcc g++ apache2

 #&& \
 #   apt autoclean && apt autoremove -y

ENV PATH="/gitlab-package-updater/bin:${PATH}"

COPY . /gitlab-package-updater

# Install packages
RUN cd /gitlab-package-updater && bundle install

WORKDIR /gitlab-package-updater/
