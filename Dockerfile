FROM alpine:3.10

ENV NVM_VERSION=v0.33.6 ENV=/root/.ashrc

# Install PHP + mods
RUN apk --update --no-cache --update-cache --allow-untrusted add \
    ruby ruby-rdoc nodejs npm yarn git curl php7 php7-json php7-mbstring openssl php7-openssl php7-phar g++ make autoconf \
    bash ca-certificates ncurses coreutils python2 make gcc libgcc linux-headers grep util-linux binutils findutils && \
    gem install bundler && \
    # Install Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    # Configure php.ini
    echo $'memory_limit = 1024M' >> /etc/php7/php.ini && \
    yarn global add yarn-outdated-formatter && \
    npm install --global @oclif/config @oclif/plugin-help @oclif/command bundle-outdated-formatter && \
    # NVM install
    apk add --update --no-cache --virtual build-dependencies && \
    cd /root && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash && \
    echo "#NVM Setup" >> $ENV && \
    echo 'export NVM_DIR="$HOME/.nvm"' >> $ENV && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> $ENV && \
    source $ENV && \
    # Cleanup image
    apk del make g++ gcc binutils autoconf build-dependencies && \
    rm -rf /tmp/* /var/cache/apk/* && \
    echo "{}" > ~/.composer/composer.json

ENV PATH="/gitlab-package-updater/bin:${PATH}"

COPY . /gitlab-package-updater

# Install composer packages
RUN cd /gitlab-package-updater && bundle install

WORKDIR /gitlab-package-updater/
