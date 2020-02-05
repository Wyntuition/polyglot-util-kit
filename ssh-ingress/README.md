# ingress

A Docker web proxy to access VPC AWS resources from your local development environment.

## Table of Contents

- [ingress](#ingress)
  - [Table of Contents](#table-of-contents)
  - [Requirements](#requirements)
  - [Getting Started](#getting-started)
    - [Create a Nonprod Bastion](#create-a-nonprod-bastion)
    - [Bastion Host IP](#bastion-host-ip)
    - [Nonprod SSH Key](#nonprod-ssh-key)
    - [Generate Self-signed SSL Certificate](#generate-self-signed-ssl-certificate)
    - [Build and Run ingress](#build-and-run-ingress)
    - [How To Use](#how-to-use)
    - [The Details](#the-details)

## Getting Started

### Create a Nonprod Bastion

See Requirements, above.

### Bastion Host IP

Set the `INGRESS_BASTION_IP` environment variable on your host machine of your bastion host's IP address. This environment variable will be passed to the container to set up SSH tunnels to your nonprod bastion.

### Nonprod SSH Key

Set the `INGRESS_SSH_KEY` environment variable on your host machine to the location of your SSH key. This file will be copied into the container at start up and used to establish SSH tunnels to your nonprod bastion.

**Note:** All `*.pem` files are ignored by Git via the `.gitignore` file. Please be _very_ careful that you don't manage to add your key to source control anyway (such as by checking `git status` prior to commits).

### Generate Self-signed SSL Certificate

To ensure end-to-end encryption to the proxied endpoints, you wil need to generate a self-signed SSL certificate in order to communicate via HTTPS with ingress itself. In the repository root directory, run:

`bash ./scripts/generate_self_signed_cert.sh`

This will generate the necessary files (which are ignored via `.gitignore`). Then, add the certificate to your system keychain:

`sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ingress.crt`

This should prevent browsers from showing you an invalid certificate warning.

### Build and Run ingress

ingress is run as a Docker container, using the image created by the [Dockerfile](Dockerfile) in the root directory.
Docker's **docker-compose** tool is used to simplify the local development experience. ingress has two services, **eve-ingress** and **_save-ingress_**, in [docker-compose.yml](docker-compose.yml).

Use the following command to run the container, replacing `SERVICE` with either `eve-ingress` or `save-ingress`:

```bash
docker-compose up -d SERVICE
```

### SAVE - Edit /etc/hosts

Edit the /etc/hosts file on your local computer to include the following lines:

```
127.0.0.1	xyz.com
127.0.0.1	abc.com
127.0.0.1	def.com
```

### How To Use

First, run `docker logs SERVICE`. The initial output will show something like this:

```
Setting up the following SSH tunnels:
  https://localhost:8443, http://ingress:8543  ->  https://xyz.com
  https://localhost:8444, http://ingress:8544  ->  https://abc.com
  https://localhost:8445, http://ingress:8545  ->  https://def.com
```

Any service in the above list is being proxied by ingress. To access any URL on the right, simply replace the domain name with the matching domain:port pair on the left. The correct pair to use depends on how you need to access the URL - see the following two subsections.

#### Browser / Local Machine Access

To access from your local machine, you would use the HTTPS endpoint, `https://localhost:8443/swagger-ui/index.html`.

#### Access From Other Containers

Communication within the `network` network uses separate ports that listen for HTTP traffic, rather than HTTPS. This is to avoid complicated SSL configuration issues while still remaining secure, as these ports are not exposed outside of the network.

The intra-network HTTP port is the port of the HTTPS connection + 100. For example, to access from another Docker container, you would use `http://eve-ingress:8543` in your Docker configuration.

### The Details

Looking at the log from the above section, the ports on the left are ports on your local machine that route to the ingress Docker container. ingress then proxies traffic from the ports on the left to the URLs on the right using nginx.

The problem with this approach is that if your local machine can't reach these services, the ingress Docker container can't either. This means that proxies by themselves aren't enough, because connections will still time out.

To create the necessary connection to a VPC resource, ingress uses the SSH key copied into the container to create SSH tunnels through your bastion, mapping local ports inside the container to those URLs. Using these tunnels, traffic can be properly routed to the previously inaccessible services.

At this point, the container can't route these requests using their actual URL because while we have SSH tunnels for traffic, we don't have one for our container's DNS name server. Using `localhost` would work, but incoming requests wouldn't have the proper hostname, and so they would reach an AWS ALB with a header of `Host: localhost`. The ALB doesn't know how to route this rule and would return a `503 Service Unavailable` error.

To solve this, the last step is to modify the `/etc/hosts` file. This file is roughly a hard-coded name server, and takes precedence over the container's general DNS name server. ingress modifies this file to translate the proxied URLs to 127.0.0.1 (e.g. `localhost`). This allows nginx to proxy the requests to the SSH tunnels mapped to `localhost` we created earlier. Proxied URLs can now be properly 'resolved' while also passing the correct `Host` header.
