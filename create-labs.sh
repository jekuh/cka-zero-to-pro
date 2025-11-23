#!/usr/bin/env bash
set -euo pipefail

# Run this script from the repo root (where 01-core-concepts, 02-Scheduling live).
SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR"

create_lab() {
  local dir="$1"
  local file="$2"
  local title="$3"

  mkdir -p "$dir"

  local full_path="${dir}/${file}"

  if [[ -e "$full_path" ]]; then
    echo "Skipping ${full_path} (already exists)"
    return
  fi

  # Extract the lab number from "lab-XX-..." (characters 5–6)
  local lab_number="${file:4:2}"

  echo "Creating ${full_path}"
  cat > "$full_path" <<EOF
# Lab ${lab_number} – ${title}

<!-- Your notes for ${title} go here -->
EOF
}

########## DEFINE YOUR LABS HERE ##########
# 01-core-concepts
create_lab "01-core-concepts/labs" "lab-04-services.md"             "Services"
create_lab "01-core-concepts/labs" "lab-05-namespaces.md"           "Namespaces"
create_lab "01-core-concepts/labs" "lab-06-imperative-commands.md"  "Imperative Commands"

# 02-Scheduling
create_lab "02-Scheduling/labs"    "lab-07-manual-scheduling.md"    "Manual Scheduling"
create_lab "02-Scheduling/labs"    "lab-08-labels-and-selectors.md" "Labels and Selectors"
create_lab "02-Scheduling/labs"    "lab-09-taints-and-tolerations.md" "Taints and Tolerations"
create_lab "02-Scheduling/labs"    "lab-10-node-affinity.md" "Node Affinity"
create_lab "02-Scheduling/labs"    "lab-11-resource-limits.md" "Resource Limits"
create_lab "02-Scheduling/labs"    "lab-12-daemon-sets.md" "Daemon Sets"
create_lab "02-Scheduling/labs"    "lab-13-static-pods.md" "Static Pods" 
create_lab "02-Scheduling/labs"    "lab-14-priority-classes.md" "Priority Classes"
create_lab "02-Scheduling/labs"    "lab-15-multiple-schedulers.md" "Multiple Schedulers"
create_lab "02-Scheduling/labs"    "lab-16-admission-controllers.md" "Admission Controllers"
create_lab "02-Scheduling/labs"    "lab-17-validating-and-mutating-admission-controllers.md" "Validating and Mutating Admission Controllers"

# 03-Logging-and-Monitoring (extend as needed):
create_lab "03-Logging-and-Monitoring/labs" "lab-18-monitoring-cluster-component.md" "Monitoring Cluster Components"
create_lab "03-Logging-and-Monitoring/labs" "lab-19-monitor-application-logs.md" "Monitor Application Logs"

# 04-Application-lifecycle-Management:
create_lab "04-Application-lifecycle-Management/labs" "lab-20-rolling-updates-rollbacks.md" "Rolling Updates & Rollbacks"
create_lab "04-Application-lifecycle-Management/labs" "lab-21-commands-and-arguments.md" "Commands & Arguments"
create_lab "04-Application-lifecycle-Management/labs" "lab-22-environment-variables.md" "Environment Variables"
create_lab "04-Application-lifecycle-Management/labs" "lab-23-secrets" "Secrets"
create_lab "04-Application-lifecycle-Management/labs" "lab-24-multi-container-pods.md" "Multi Container Pods" 
create_lab "04-Application-lifecycle-Management/labs" "lab-25-init-containers.md" "Init Containers"
create_lab "04-Application-lifecycle-Management/labs" "lab-26-manual-scaling.md" "Manual Scaling"
create_lab "04-Application-lifecycle-Management/labs" "lab-27-horizontal-pod-autoscaling.md" "Horizontal Pod Autoscaling" 
create_lab "04-Application-lifecycle-Management/labs" "lab-28-install-vpa.md" "Install VPA"
create_lab "04-Application-lifecycle-Management/labs" "lab-29-modify-cpu-resources-in-vpa.md" "Modify CPU Resources in VPA"

# 05-Cluster-Maintenance:
create_lab "05-Cluster-Maintenance/labs" "lab-30-os-upgrades.md" "OS Upgrades"
create_lab "05-Cluster-Maintenance/labs" "lab-31-cluster-upgrades.md" "Cluster Upgrades"
# create_lab "03-Another-Topic/labs" "lab-11-another-topic.md" "Another Topic"
###########################################
