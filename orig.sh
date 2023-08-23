		#!/bin/bash
		 
		BASEURL="http://10.10.10.3/Services/REST"
		USERNAME="admin"
		PASSWORD="admin"
		TOKEN=""
		 
		# LOGIN - TOKEN
		RESPONSE=$(curl -s $BASEURL"/v1/login?password="$PASSWORD"&username="$USERNAME)
		pattern='BAMAuthToken(.{42})'
		TOKEN=$(grep -E -o $pattern <<< $RESPONSE)
		 
		#AUTH HEADER TO REUSE ON SUBSEQUENT API CALLS
		HEADER_AUTH="Authorization: $TOKEN"
		 
		 
		# SUBSEQUENT API CALLS
		apiURL=$BASEURL"/v1/getSystemInfo"
		RESPONSE=$(curl -s -X GET -H "${HEADER_AUTH}" "${apiURL}")
		 
		echo $RESPONSE
  
