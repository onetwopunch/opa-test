## OPA demo

First install OPA using their instructions: https://www.openpolicyagent.org/docs/latest/#running-opa



### First Example

```
opa eval --input example/input.json --data example/example.rego 'data.example.allow'
```

## Terraform Example

This example shows how to whitelist Google API services that are either in Terraform state or plan with OPA

First you'll need to get a valid terraform directory to work with. For this case I used the test/setup directory
in https://github.com/terraform-google-modules/terraform-google-bastion-host which has a state file as part of
the integration tests that are run. However you can use can any state file where you have added `google_project_service`
resources.

### Terraform State Rego

```
opa eval --input terraform.tfstate --data services_state.rego --format=pretty 'data.services.state.test'
```


### Terraform Plan Rego

For this, let's go ahead and add a `google_project_service` resource to the terraform code you used above
that is not in the whitelist. Let's say `youtube.googleapis.com`. Then create the terraform plan as follows
and validate that the rule fails.

```
terraform plan -out=terraform.tfplan
terraform show -json terraform.tfplan > terraform.tfplan.json
opa eval --input terraform.tfplan.json --data services_plan.rego --format=pretty 'data.services.plan.test'
```

### Using the REPL

Unlike Rego, the OPA REPL uses the `data` identifier to represent the top-level object as opposed to `input`
so when trying out statements you'll need to start with that and set other variables as needed. This is a
great way to debug and learn the language.

```
$ opa run terraform.tfstate
OPA 0.15.1 (commit , built at )

Run 'help' to see a list of commands.

> data.resources[_].type
+---------------------------------------------+
|           data.resources[_].type            |
+---------------------------------------------+
| "google_organization"                       |
| "null_data_source"                          |
| "google_compute_shared_vpc_service_project" |
| "google_compute_subnetwork_iam_member"      |
| "google_project"                            |
| "google_project_iam_member"                 |
| "google_project_service"                    |
| "google_project_services"                   |
+---------------------------------------------+
```
