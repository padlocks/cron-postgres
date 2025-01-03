# PostgreSQL Cron Backup System

This project provides a Docker-based solution for automating backups of a PostgreSQL database using cron jobs. The system is designed to run a PostgreSQL server and perform scheduled backups, ensuring that your data is regularly saved and can be restored when needed.

## Project Structure

- **scripts/**: Contains the backup and startup scripts.
  - **auto_dump.sh**: Script responsible for performing PostgreSQL backups using the `pg_dump` command. It saves backups to a specified directory and deletes backups older than a certain number of days.
  - **start.sh**: Script that starts the cron service and the PostgreSQL server, ensuring that the backup jobs are executed alongside the database service.
  
- **Dockerfile**: Defines the Docker image for the PostgreSQL backup system. It installs necessary software, copies the script files and crontab configuration, sets permissions, and specifies the command to run when the container starts.

- **crontab**: Contains the cron job configuration for scheduling the backup script. It specifies the timing and the command to execute the backup script.

- **build.bat**: Batch file used to build the Docker image for the PostgreSQL backup system.

- **run-docker.bat**: Batch file that runs the Docker container with the necessary volume mounts and configurations for PostgreSQL and backup storage.

## Getting Started

1. **Build the Docker Image**: Run `build.bat` to create the Docker image for the PostgreSQL backup system.
2. **Run the Docker Container**: Execute `run-docker.bat` to start the container with the appropriate configurations.
3. **Check Backups**: Backups will be stored in the specified directory, and old backups will be automatically deleted based on the logic defined in `auto_dump.sh`.

## License

This project is licensed under the MIT License.