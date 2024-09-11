#!/bin/bash
##
## FILE: extract-crds.sh
##
## DESCRIPTION: Checks a Helm chart for crds to delete after de-installation. Not fullproof - use only for indicative purposes only.
##
## AUTHOR: Chris Buckley (github.com/chrisbuckleycode)
##
## USAGE: extract-crds.sh <helm_repo> <helm_chart>
##        e.g. extract_crds.sh https://prometheus-community.github.io/helm-charts kube-prometheus-stack
##             extract_crds.sh https://vmware-tanzu.github.io/helm-charts velero       
## 
## Note: This script works in approx. 90% of cases and needs further development to resolve failures. 


# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <helm_repo> <helm_chart>"
    exit 1
fi

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "yq is not installed. Please install yq and try again."
    exit 1
fi

HELM_REPO=$1
HELM_CHART=$2
TEMP_DIR="/tmp/helm_chart_extract"
OUTPUT_FILE="crd_deletion_commands.sh"

# Array to store CRD deletion commands
declare -a CRD_COMMANDS

echo "Adding Helm repository..."
helm repo add myrepo $HELM_REPO

echo "Updating repository..."
helm repo update

echo "Downloading chart..."
helm pull myrepo/$HELM_CHART -d /tmp

echo "Extracting chart..."
mkdir -p $TEMP_DIR
tar -xzf /tmp/$HELM_CHART-*.tgz -C $TEMP_DIR

# Function to process YAML files
process_yaml() {
    local file=$1
    echo "Processing file: $file"
    
    # Use yq to parse the YAML file, suppressing errors for non-matches
    while IFS= read -r crd_name; do
        if [[ ! -z "$crd_name" ]]; then
            CRD_COMMANDS+=("kubectl delete crd $crd_name")
            echo "Found CRD: $crd_name"
        fi
    done < <(yq e '.kind as $kind | select($kind == "CustomResourceDefinition") | .metadata.name' "$file" 2>/dev/null)
}

echo "Traversing chart directory..."
file_count=0
while IFS= read -r file; do
    ((file_count++))
    process_yaml "$file"
done < <(find $TEMP_DIR -name "*.yaml" -type f)

echo "Processed $file_count YAML files."
echo "Found ${#CRD_COMMANDS[@]} CRDs."

# Clean up
echo "Cleaning up..."
rm -rf $TEMP_DIR
rm /tmp/$HELM_CHART-*.tgz
helm repo remove myrepo

echo "Script completed."

# Echo all CRD deletion commands at the end and write to file
if [ ${#CRD_COMMANDS[@]} -gt 0 ]; then
    echo "CRD deletion commands:"
    printf '%s\n' "${CRD_COMMANDS[@]}"
    
    # Write commands to file
    echo "#!/bin/bash" > "$OUTPUT_FILE"
    printf '%s\n' "${CRD_COMMANDS[@]}" >> "$OUTPUT_FILE"
    chmod +x "$OUTPUT_FILE"
    echo "CRD deletion commands have been written to $OUTPUT_FILE and the file has been made executable."
else
    echo "No CRDs found in this chart."
    echo "#!/bin/bash" > "$OUTPUT_FILE"
    echo "echo \"No CRDs found in this chart.\"" >> "$OUTPUT_FILE"
    chmod +x "$OUTPUT_FILE"
    echo "An empty script has been created as $OUTPUT_FILE and made executable."
fi