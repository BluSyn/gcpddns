# Google Cloud Platform Dynamic DNS Docker

This project is a containerized implementation of work done [here](https://github.com/ianlewis/cloud-dyndns-client/cmd/cloud-dyndns-client)
It contains both the underlying application and necessary components to launch it directly in Docker.

##Docker Variables

Volumes
  - /config
Ports
  - 8080
Environmental
  - GOOGLE_APPLICATION_CREDENTIALS

##Configuration

1. You'll need to already have setup your DNS in GCP and created the necessary service account credentials, etc. This is beyond the scope of this project but instructions for it can be easily found online. Once you've secured your GCP credentials, save the JSON as `google.json`.

2. In that same directory, create a `config.json` for the client. Enter the domain name you want to update, the GCP project ID, and Cloud DNS managed zone name. Multiple domains can be added as part of the configuration.

```
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
```

I strongly suggest using a JSON linter at this step—especially if you're using multiple domains.

##Running the Container

To run the container in Docker:
```
docker run -d --name gcpddns \
-v $PATH_TO_CONFIG:/config \
-p 8080:8080 \
-e "GOOGLE_APPLICATION_CREDENTIALS=/config/google.json" \
charlestephen/gcpddns:latest
```
