<p align="center">
  <a>
  <a href="https://github.com/charlestephen/gcpddns/blob/master/LICENSE"><img alt="Github License" src="https://img.shields.io/github/license/charlestephen/gcpddns.svg?style=for-the-badge"></a>
  <a href="https://github.com/charlestephen/gcpddns/issues"><img alt="Open Issues" src="https://img.shields.io/github/issues/charlestephen/gcpddns.svg?style=for-the-badge"></a>
  <a href="https://hub.docker.com/repository/docker/charlestephen/gcpddns"><img alt="Docker Stars" src="https://img.shields.io/docker/stars/charlestephen/gcpddns.svg?style=for-the-badge">
  <a href="https://hub.docker.com/repository/docker/charlestephen/gcpddns"><img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/charlestephen/gcpddns.svg?style=for-the-badge">
  <a href="https://twitter.com/handyhomo"><img src="https://img.shields.io/twitter/url?url=https%3A%2F%2Fgithub.com%2Fcharlestephen%2Fgcpddns.svg?style=social&logo=twitter">
	</a>
</p>

# Google Cloud Platform Dynamic DNS Docker

This project is a containerized implementation of work done [here.](https://github.com/ianlewis/cloud-dyndns-client/cmd/cloud-dyndns-client)
It contains both the underlying application and necessary components to launch it directly in Docker.

## Requirements

1.  Google Cloud Platform project with Cloud DNS API enabled and domains active
2.  Docker

## Configuration and Setup

You'll need to already have setup your DNS in GCP. This is beyond the scope of this project but instructions can be found online. You'll also need to setup a service account and get credentials for it. To do so, follow the directions below.

### GCP Service Account Setup

1.  Create a GCP service account

    `SA_EMAIL=$(gcloud iam service-accounts --format='value(email)' create gcpddns)`

2.  Create a JSON key file associated with the new service account

    `gcloud iam service-accounts keys create service-account.json --iam-account=$SA_EMAIL`

3.  Add an IAM policy to the service account for the project.

    `PROJECT=$(gcloud config list core/project --format='value(core.project)')`
    `gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$SA_EMAIL --role roles/dns.admin`

Once you've secured your GCP credentials, save the JSON as `google.json` in a directory that will be accessible to the running image (/config below)

### Docker Setup

#### Docker Variables

Environmental

-   GOOGLE_APPLICATION_CREDENTIALS

Ports

-   8080:8080

Volumes

-   {$Path_to_config}/config:/config

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

I strongly recommend using a JSON linter at this step—especially if you're using multiple domains.

## Running the Container

To run the container in Docker:

      docker run -d --name gcpddns \
      -v ${PATH}/config:/config \
      -p 8080:8080 \
      -e "GOOGLE_APPLICATION_CREDENTIALS=/config/google.json" \
      charlestephen/gcpddns:latest
