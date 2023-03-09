FROM sqlfluff/sqlfluff:latest

# Switch to root user to install additional pip packages
USER root
RUN pip install sqlfluff-templater-dbt==2.0.0a6
RUN pip install dbt-bigquery==1.4.0

# Switch back to user to run sqlfluff
USER 5000
