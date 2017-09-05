# Set the base image to java8
FROM openjdk:8-jre

# File Author / Maintainer
MAINTAINER Jorge Acetozi

# Define environment variables
ENV ARTIFACTORY_HOME=/opt/artifactory
ENV ARTIFACTORY_VERSION=5.4.6
ENV MIN_HEAP_SIZE="-Xms512m"
ENV MAX_HEAP_SIZE="-Xmx2g"

# Create artifactory group and user
RUN groupadd -g 1000 artifactory \
  && useradd -d "$ARTIFACTORY_HOME" -u 1000 -g 1000 -s /sbin/nologin artifactory

# Install artifactory
RUN wget "https://api.bintray.com/content/jfrog/artifactory/jfrog-artifactory-oss-${ARTIFACTORY_VERSION}.zip;bt_package=jfrog-artifactory-oss-zip" && \
	unzip "jfrog-artifactory-oss-${ARTIFACTORY_VERSION}.zip;bt_package=jfrog-artifactory-oss-zip" && \
	mv artifactory-oss-${ARTIFACTORY_VERSION} $ARTIFACTORY_HOME && \
	rm "jfrog-artifactory-oss-${ARTIFACTORY_VERSION}.zip;bt_package=jfrog-artifactory-oss-zip"

# Define mountable directories
VOLUME $ARTIFACTORY_HOME/data
VOLUME $ARTIFACTORY_HOME/etc
VOLUME $ARTIFACTORY_HOME/logs
VOLUME $ARTIFACTORY_HOME/backup
VOLUME $ARTIFACTORY_HOME/access

# Add initialization script
ADD entrypoint.sh /opt/artifactory/bin/entrypoint.sh

# Modify script permissions
RUN chmod 755 /opt/artifactory/bin/entrypoint.sh

# Change directories ownership to artifactory user and group
RUN chown -R artifactory:artifactory $ARTIFACTORY_HOME

# Run the container as artifactory user
USER artifactory

# Define default command
ENTRYPOINT ["/opt/artifactory/bin/entrypoint.sh"]

# Expose port
EXPOSE 8081
