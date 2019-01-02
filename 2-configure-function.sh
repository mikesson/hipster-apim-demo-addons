# SCRIPT TO ADJUST THE INDEX.JS FUNCTIONS FILE FOR YOUR PROJECT

echo -e "\n\nBefore deploying the JavaScript (Node.js) function to Cloud Functions, the following details are required and will be updated in the 'index.js' file:\n"

echo -e "Enter the Dialogflow Client ID (which can be found under the Dialogflow project settings as 'Service Account'):"
read dialogflow_client_id

echo -e "Enter the Apigee organization (same as before):"
read org

echo -e "Enter the Apigee environment (same as before):"
read env

echo -e "Enter the API Key of the previously created Application (e.g. Hipster Voice App) on the Apigee Developer Portal:"
read apigee_api_key


echo -e "\nInserting the above values into index.js ...\n"

cd cloud-functions/fulfillment/functions
cp index.js.template index.js

sed -i '' 's/<%org%>/'"$org"'/g' index.js
sed -i '' 's/<%env%>/'"$env"'/g' index.js
sed -i '' 's/<%apigee_api_key%>/'"$apigee_api_key"'/g' index.js
sed -i '' 's/<%dialogflow_client_id%>/'"$dialogflow_client_id"'/g' index.js

cd ..
cd ..
cd ..

echo -e "The index.js is now ready for deployment. (Updated file: cloud-functions/fulfillment/functions/index.js)\n"
echo -e "(Note: you can rerun this script which uses a template file (index.js.template) and overwrites index.js)"

echo -e "\n========== ✓ Done! ==========\n"

echo -e "Continue with the next steps to deploy this function to Cloud Functions\n"

