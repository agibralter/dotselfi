FROM sqlfluff/sqlfluff:latest

# Switch to root user to install additional pip packages
USER root
RUN pip install sqlfluff-templater-dbt
RUN pip install dbt-bigquery

# Switch back to user to run sqlfluff
USER 5000