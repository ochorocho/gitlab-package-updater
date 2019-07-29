FROM alpine:3.10

# Install PHP + mods
RUN apk --update --no-cache --update-cache --allow-untrusted add \
    ruby ruby-rdoc nodejs npm yarn git curl php7 php7-json php7-mbstring php7-openssl php7-phar g++ make autoconf && \
    gem install bundler && \
    # Install Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    # Configure php.ini
    echo $'memory_limit = 1024M' >> /etc/php7/php.ini && \
    yarn global add yarn-outdated-formatter && \
    npm install --global @oclif/config @oclif/plugin-help @oclif/command bundle-outdated-formatter && \
    # Cleanup image
    apk del make g++ gcc binutils curl autoconf && \
    rm -rf /var/cache/apk/* && \
    echo "{}" > ~/.composer/composer.json

ENV PATH="/gitlab-package-updater/bin:${PATH}"

COPY . /gitlab-package-updater

# Install composer packages
RUN cd /gitlab-package-updater && bundle install

WORKDIR /gitlab-package-updater/
