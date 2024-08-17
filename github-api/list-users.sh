#!/bin/bash

#######
# About: This shell script will show you the list of users who have access to the repository.
# Input Parameters Required: You need to export the username and the token name, then you need to provide command line
# arguments while executing the shell scripting i.e., ./list-user.sh REPO_OWNER REPO_NAME
# Owner: Abhishek Veeramalla
######

#If the shell scripted with all the required pararmeters then move with the next lines of the script. And if the user has not
# provider with the required information then the script will fail here itself, saying that please execute the scirpt with all
# the required parameters
helper()

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$username
TOKEN=$token

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    # -z operator is used to check if it is empty or not. That is here it will check if the collaborators section is empty or not.
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Add helper function. This helper function will let us know how to execute the shell script.
# Without providing the command line argument it will show error like the way of execuitng the shell scripting is wrong.
# where -ne means not equal to
function helper{ 
 expected-cmd_args = 2
 if [$# -ne $expected-cmd_args]; then
     echo "please execute the script with required cmd args"
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
