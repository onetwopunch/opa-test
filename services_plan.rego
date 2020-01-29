package services.plan

# Allow only if there are no differences between
# expected and actual
test[{
	"passed": passed,
	"metadata" : metadata
}] {
	metadata := {
		"planned_services": planned_services,
		"diff": diff
	}
	passed := count(diff) == 0
}

# Get the list of planned services that are not in
# the allowed services
diff[name] {
	diff := planned_services - allowed_services
	name := diff[_]
}

# Get service names from resources where the type
# is google_project_service 
planned_services[name] {
	some i
	
	res := input.resource_changes[i].change
	any([
		res.actions[_] == "create",
		res.actions[_] == "update"
	])
	name := res.after.service
}

allowed_services := {
	"cloudresourcemanager.googleapis.com",
  "serviceusage.googleapis.com",
  "compute.googleapis.com",
  "iam.googleapis.com"
}
