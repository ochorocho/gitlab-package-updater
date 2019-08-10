FROM ubuntu:18.04

SHELL [ "/bin/bash", "-l", "-c" ]
ENTRYPOINT ["/bin/bash", "-l", "-c"]

ENV ENV=/root/.bashrc
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# sudo update-alternatives --set php /usr/bin/php7.0

RUN apt update && apt install -y apt-utils curl ca-certificates openssl coreutils make gcc g++ grep util-linux \
    software-properties-common ruby rdoc git curl php php-json php-mbstring openssl php-phar make autoconf nodejs npm libreadline-dev zlib1g-dev && \
    gem update --system && gem install bundler && \
    add-apt-repository ppa:ondrej/php && \
    apt update && \
    apt install -y php7.1-cli php7.2-cli php7.3-cli && \
    rm -rf /var/lib/apt/lists/*

# Setup NVM
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash && \
	echo "#NVM Setup" >> $ENV && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> $ENV && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> $ENV && \
    . $HOME/.nvm/nvm.sh && \
    . ~/.nvm/nvm.sh; nvm install stable && \
    . ~/.nvm/nvm.sh; nvm use stable && \
    npm install --global @oclif/config @oclif/plugin-help @oclif/command bundle-outdated-formatter && \
# Setup Yarn
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update && apt install -y yarn && \
    yarn global add yarn-outdated-formatter && \
# Setup Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
#    echo $'memory_limit = 1024M' >> /etc/php/php.ini && \
    echo "{}" > ~/.composer/composer.json && \
    rm -rf /var/lib/apt/lists/* && \
# Setup rvm
    curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s stable
ENV PATH=$PATH:/opt/rvm/bin:/opt/rvm/sbin
RUN rvm install ruby-2.6.3 --binary && \
    gem install bundler

# Clean image
RUN apt remove -y --purge gcc-7 nano apt-utils python2.7 python3 wget nano gnupg make linux-headers gcc g++ apache2 && apt clean && apt autoclean && apt autoremove -y

ENV PATH="/gitlab-package-updater/bin:${PATH}"

COPY . /gitlab-package-updater
RUN cd /gitlab-package-updater && bundle install
WORKDIR /gitlab-package-updater/
