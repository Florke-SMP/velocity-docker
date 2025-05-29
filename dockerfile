FROM ubuntu:24.04

LABEL maintainer="Florke64"

# # # # # # # # # #
# Build Arguments #
# # # # # # # # # #

# Dedicated Velocity's build (URL to velocity.jar)
ENV VELOCITY_URL="https://api.papermc.io/v2/projects/velocity/versions/3.4.0-SNAPSHOT/builds/509/downloads/velocity-3.4.0-SNAPSHOT-509.jar"

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
	libxrender1 \
&& wget -O /velocity.jar "${VELOCITY_URL}"

RUN chmod +x /entrypoint.sh

# Expose default proxy's port
EXPOSE 25565
