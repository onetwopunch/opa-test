package services.state

# Allow only if there are no differences between
# expected and actual
test[{
	"passed": passed,
	"metadata" : metadata
}] {
	metadata := {
		"actual_services": actual_services,
		"diff": diff
	}
	passed := count(diff) == 0
}

# Set of actual services that are not in the
# allowed services
diff[name] {
	diff := actual_services - allowed_services
	name := diff[_]
}

# Get service names from resources where the type
# is google_project_service 
actual_services[name] {
	some i	
	res := input.resources
	res[i].type == "google_project_service"
	name := res[i].instances[_].attributes.service
}

allowed_services := {
	"cloudresourcemanager.googleapis.com",
  "serviceusage.googleapis.com",
  "compute.googleapis.com",
  "iam.googleapis.com"
}
