FROM ubuntu:24.04

LABEL maintainer="Florke64"

# # # # # # # # # #
# Build Arguments #
# # # # # # # # # #

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

WORKDIR /velocity

VOLUME /velocity

### Install APT packages ###
# Adds AWS repo's GPG keys and installs Amazon's Corretto 21.
# This follows instructions from https://docs.papermc.io/.

ARG JDK_APT_SOURCE="deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main"

RUN mkdir -p /etc/apt/apt.conf.d && printf \
	'%s\n' \
    'Dir::Cache "";' \
    'Dir::Cache::archives "";' \
    'Dir::Cache::srcpkgcache "";' \
    'Dir::Cache::pkgcache "";' \
    'Acquire::http::No-Cache "true";' \
    'Acquire::https::No-Cache "true";' \
 > /etc/apt/apt.conf.d/01nocache \
\
&& apt-get update && apt-get upgrade -y && apt-get install \
	--no-install-recommends -y \
	ca-certificates \
	apt-transport-https \
	gnupg \
	wget \
\
&& wget -O - https://apt.corretto.aws/corretto.key \
	| gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg \
\	
&& echo "${JDK_APT_SOURCE}" | tee /etc/apt/sources.list.d/corretto.list \
\
&& apt-get update && apt-get install \
	--no-install-recommends -y \
	java-21-amazon-corretto-jdk \
	libxi6 \
	libxtst6 \
	libxrender1

# Get the Velocity JAR file
# VELOCITY_URL is provided by .buildargs
ARG VELOCITY_URL
ARG SHA256

# Debug output (optional)
RUN echo "VELOCITY_URL: ${VELOCITY_URL}"
RUN echo "SHA256: ${SHA256}"

# Download and verify
RUN wget -O /velocity.jar "${VELOCITY_URL}" && \
    echo "${SHA256}  /velocity.jar" | sha256sum -c -

RUN chmod +x /entrypoint.sh

# Expose default proxy's port
EXPOSE 25565
