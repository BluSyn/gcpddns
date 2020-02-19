# Google Cloud Platform Dynamic DNS Docker

This project is a containerized implementation of work done [here] (https://github.com/ianlewis/cloud-dyndns-client/cmd/cloud-dyndns-client)

It contains both the underlying application and necessary components to launch it directly in Docker.

##Expected Variables
GOOGLE_APPLICATION_CREDENTIALS

### Google Cloud Platform Setup

Set up the client to use GCP by first creating a service account.

1. Create a GCP service account

```
SA_EMAIL=$(gcloud iam service-accounts --format='value(email)' create cloud-dyndns-client)
```

2.  Create a JSON key file associated with the new service account

```
gcloud iam service-accounts keys create service-account.json --iam-account=$SA_EMAIL
```

3. Add an IAM policy to the service account for the project.

```
PROJECT=$(gcloud config list core/project --format='value(core.project)')
gcloud projects add-iam-policy-binding $PROJECT --member serviceAccount:$SA_EMAIL --role roles/dns.admin
```

### Configuration

Create a `config.json` for the client. Enter the domain name you want to update, the GCP project ID, and Cloud DNS managed zone name. Multiple domains can be added as part of the configuration.

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
