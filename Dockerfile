FROM postgres:latest

# Install necessary software
RUN apt-get update && \
    apt-get -y install cron

# Add crontab file
COPY crontab /etc/cron.d/crontab

# Add script files
COPY ./scripts/start.sh /start.sh
COPY ./scripts/auto_dump.sh /auto_dump.sh

# Give execution rights on the cron job
RUN chmod 0755 /etc/cron.d/crontab

# Give execution rights on the scripts
RUN chmod 0755 /start.sh
RUN chmod 0755 /auto_dump.sh

# Create the log file to be able to run tail
RUN touch /auto_dump_log.txt

# Apply the cron job
RUN crontab /etc/cron.d/crontab

# Start the cron service and postgres
CMD /start.sh

# Expose ports
EXPOSE 5432