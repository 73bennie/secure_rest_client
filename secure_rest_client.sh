#!/usr/bin/env bash

<<comment
    1. Added checks for the presence of required environment variables (BASEURL, USERNAME, PASSWORD) at 
    the beginning of the script. This ensures that essential information is provided.

    2. Incorporated error handling for the login operation to check if a valid token is obtained. If the 
    login fails, it provides an error message and exits.

    3. Added error handling for the subsequent API call to check if the request was successful. If it fails, 
    it provides an error message and exits.

    4. Removed the unnecessary regular expression assignment (pattern) and directly extracted the token using 
    Bash's regular expression matching capabilities (BASH_REMATCH).

    5. Used consistent variable naming and formatting for improved readability.

    6. Removed non-breaking spaces from the script for clarity.

    7. Added comments for better code documentation.

Remember to set the BASEURL, USERNAME, and PASSWORD environment variables before executing the script. 
This script provides better error feedback and should be more robust in handling various situations.

comment


# Check if required environment variables are set
if [[ -z "$BASEURL" || -z "$USERNAME" || -z "$PASSWORD" ]]; then
    echo "Error: Please set BASEURL, USERNAME, and PASSWORD environment variables."
    exit 1
fi

# Perform user login and obtain a token
LOGIN_URL="${BASEURL}/v1/login"
RESPONSE=$(curl -s -X POST -d "username=${USERNAME}&password=${PASSWORD}" "${LOGIN_URL}")

# Check for successful login and extract the token
if [[ $RESPONSE =~ "BAMAuthToken"(.{42}) ]]; then
    TOKEN="${BASH_REMATCH[1]}"
else
    echo "Error: Failed to obtain a valid token. Check your credentials or the server response."
    exit 1
fi

# Set the authentication header
HEADER_AUTH="Authorization: $TOKEN"

# Make a subsequent API call
API_URL="${BASEURL}/v1/getSystemInfo"
RESPONSE=$(curl -s -X GET -H "${HEADER_AUTH}" "${API_URL}")

# Check for a successful API response
if [[ $? -eq 0 ]]; then
    echo "API Response: $RESPONSE"
else
    echo "Error: API request failed. Check your network connection or the server status."
    exit 1
fi
