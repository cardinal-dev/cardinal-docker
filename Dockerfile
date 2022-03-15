# Cardinal

FROM ubuntu:focal
WORKDIR /opt

# Install dependencies & added extras
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git mysql-client nginx sudo nano python3-venv python3-dev libmysqlclient-dev build-essential netcat traceroute iputils-ping dnsutils curl

# Clone Cardinal into container
RUN git clone https://github.com/cardinal-dev/Cardinal.git

# Copy entrypoint.sh and wsgi.ini into container
COPY entrypoint.sh /opt/Cardinal
COPY wsgi.ini /opt/Cardinal/webapp
COPY nginx.conf /etc/nginx
COPY cardinal.ini /home

# Set permissions on entrypoint.sh
RUN chmod +x /opt/Cardinal/entrypoint.sh

# Create user/directory for Cardinal socket/logs
# Change permissions within container for necessary operation
RUN mkdir -p /var/lib/cardinal
RUN mkdir -p /var/log/cardinal
RUN touch /var/log/cardinal/cardinal.log
RUN useradd cardinal
RUN chown -R cardinal:cardinal /var/lib/cardinal
RUN chown -R cardinal:cardinal /var/log/cardinal
RUN chown -R cardinal:cardinal /var/log/nginx
RUN chown -R cardinal:cardinal /var/lib/nginx
RUN chown -R cardinal:cardinal /run

# Create a Python3 venv for Cardinal
RUN mkdir -p /opt/venv
RUN python3 -m venv /opt/venv/cardinal

# Install Cardinal dependencies (Python-specific)
RUN /opt/venv/cardinal/bin/python -m pip install -U pip
RUN /opt/venv/cardinal/bin/python -m pip install -r /opt/Cardinal/requirements.txt

# Environment variables
ENV CARDINALCONFIG=/home/cardinal.ini

# Change to cardinal
USER cardinal

# Send NGINX output to /dev/stdout
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# Finish it!
CMD ["/opt/Cardinal/entrypoint.sh"]
