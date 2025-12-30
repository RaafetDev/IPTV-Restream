# Base image
FROM php:8.1-apache

# Install dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql gd zip \
    && a2enmod rewrite

# Set working dir
WORKDIR /var/www/html

# Copy source
COPY . .

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-dev --optimize-autoloader

# Permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
