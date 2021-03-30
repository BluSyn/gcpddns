# Google Cloud Platform Dynamic DNS Docker

This project is a containerized implementation of work done [here](https://github.com/ianlewis/cloud-dyndns-client/cmd/cloud-dyndns-client)
It contains both the underlying application and necessary components to launch it directly in Docker.

## Requirements

1.  GCP Project with domains setup with DNS and Service Accounts
2.  Docker

## Configuration

You'll need to already have setup your DNS in GCP. This is beyond the scope of this project but instructions can be found online. You'll also need to setup a service account and get credentials for it. To do so, follow the directions below.

### GCP Service Account Setup

1.  Create a GCP service account

    SA_EMAIL=$(gcloud iam service-accounts --format='value(email)' create gcpddns)

2.  Create a JSON key file associated with the new service account

    gcloud iam service-accounts keys create service-account.json --iam-account=$SA_EMAIL

3.  Add an IAM policy to the service account for the project.

    PROJECT=$(gcloud config list core/project --format='value(core.project)')
    gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$SA_EMAIL --role roles/dns.admin

Once you've secured your GCP credentials, save the JSON as `google.json` in a directory that will be accessible to the running image (/config below)

### Docker Setup

Volumes

-   /config

Ports

-   8080

Environmental

-   GOOGLE_APPLICATION_CREDENTIALS

1.  Save the `google.json` service account credential in the directory you'll be using for this container.
2.  In that same directory, create a `config.json` for the client. Enter the domain name you want to update, the GCP project ID, and Cloud DNS managed zone name. Multiple domains can be added as part of the configuration.


    {
      "domains": {
        "mydomain.example.com": {
          "provider": "gcp",
          "provider_config": {
             "project_id": "example-project",
             "managed_zone": "example-zone",
          }
        }
      }
    }

I strongly suggest using a JSON linter at this step—especially if you're using multiple domains.

## Running the Container

To run the container in Docker:

    docker run -d --name gcpddns \
    -v $PATH_TO_CONFIG:/config \
    -p 8080:8080 \
    -e "GOOGLE_APPLICATION_CREDENTIALS=/config/google.json" \
    charlestephen/gcpddns:latest
