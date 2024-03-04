*As of 2024 03 04 these directions work, and has been deployed in Pangeam Cloud run under https://upload.pangeam.com*


# Setup:

Run the following to create a serviceAccount that will be the background, download its key, create a bucket, allow the proper access to the service account, and set an open CORS policy.

```shell
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io
```

Grab the `service_account.json` file from 1password

https://start.1password.com/open/i?a=L56MDLUSX5HYHGKEUUJZ43WALY&v=73m7tyqutjftfbxj3s7ys57r3y&i=5uoutafsnvismlpqup5ai4shou&h=pangeam.1password.com


## Bootstrap
This should only need to be done to bootstrap the project. Unless you are standing up a new instance don't do this.
```shell
gcloud iam service-accounts create urlsigner --display-name="GCS URL Signer" --project=${PROJECT_NAME}
gcloud iam service-accounts keys  create service_account.json --iam-account=urlsigner@${PROJECT_NAME}.iam.gserviceaccount.com
gsutil mb gs://$PROJECT_NAME-urlsigner
gsutil iam ch  serviceAccount:urlsigner@${PROJECT_NAME}.iam.gserviceaccount.com:roles/storage.admin gs://$PROJECT_NAME-urlsigner
gsutil cors set cors.txt gs://$PROJECT_NAME-urlsigner
```

# Modifications

Next, build the Docker image and push to GCR:

```shell
docker build --platform linux/amd64 -t gcr.io/$PROJECT_NAME/uploader . && docker push gcr.io/$PROJECT_NAME/uploader:latest
```

# Deploy

Lastly, submit it to Cloud Run:

```shell
gcloud beta run deploy uploader --image gcr.io/$PROJECT_NAME/uploader:latest
```

See your files here:

https://console.cloud.google.com/storage/browser/pangeam-general-ops-urlsigner
