# Use the official Python image.
# https://hub.docker.com/_/python
FROM python:3.7-slim

ENV GOOGLE_APPLICATION_CREDENTIALS "/service_account.json"
ENV BUCKET_NAME pangeam-general-ops-urlsigner
# Copy local code to the container image.

COPY . /

# Install production dependencies.
RUN pip install -r requirements.txt

# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 main:app
