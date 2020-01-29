#   Copyright 2020 Google, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
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
