#!/bin/bash


# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
#Make sure you export the env variables named username and token in the same shell where you run this file.
USERNAME=$username
TOKEN=$token

echo $USERNAME
echo $TOKEN
# Organisation , user and repository information
ORG=$1
REPO_OWNER=$2
REPO_NAME=$3


# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"
     
    # Send a GET request to the GitHub API with authentication
    # -s runs the curl command in silent mode and -u is used to specify username and password.
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"
    echo "$endpoint"
    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull=true)| [.login]')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}


function list_members_of_org {
    local endpoint="orgs/${ORG}/members"

    # Fetch the list of collaborators on the repository
    members="$(github_api_get "$endpoint" | jq -r '.[] | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$members" ]]; then
        echo "The organisation name ${ORG} has no members"
    else
        echo "Members of the org ${ORG}:"
        echo "$members"
    fi
}


# Main script

echo "Let us first list the members of the org $ORG"
list_members_of_org

echo "Let us now list the users with having read access for the repository ${REPO_NAME}"
list_users_with_read_access 



