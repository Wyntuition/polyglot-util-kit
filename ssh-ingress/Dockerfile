FROM nginx:latest

USER root

# Update packages
RUN apt-get update \
  && apt-get install -y ssh

# Set work directory
WORKDIR /app

# Copy over project artifacts
COPY . .

# Check if ingress.crt file exists
RUN if [ ! -f ./ingress.crt ] ; then echo "ingress.crt not found! See \"Generate Self-signed SSL Certificate\" in README." && exit 1 ; fi

# Entrypoint script
ENTRYPOINT ["./start.sh"]
