# SCRIPT TO DEPLOY API PROXIES AND CONFIGURE RELATED SETTINGS ON APIGEE

if [ -z "$GATEWAY_URL" ]
then
      echo -e "\nERROR >>> \$GATEWAY_URL is empty, hence stopping script execution. Make sure you export the GATEWAY_URL as an environment variable as described in the README.\n"
      exit 1
else
      echo -e "\n✓ Gateway URL found."
      echo -e "\nTo auto-deploy the necessary configurations (API Proxy, API Product, App), please enter your Apigee username and  password as well as target organization (e.g. username-eval) and environment (e.g. test/prod).\n"
fi

mkdir -p apigee/proxies/apiproxy/targets
cp apigee/templates/default.xml.template apigee/proxies/apiproxy/targets/default.xml
sed -i '' 's~<%BACKEND_GATEWAY_URL%>~'"$GATEWAY_URL"'~g' apigee/proxies/apiproxy/targets/default.xml


echo -e "Enter username:"
read username

echo -e "Enter password:"
read -s password
echo -e "********"

echo -e "Enter organization:"
read org

echo -e "Enter environment:"
read env

proxy_name="Hipster-Shop-API"
apiproduct_name="Hipster-Shop-API-Product"
apiproduct_display_name="Hipster Shop API Product"

echo -e "\nStep 1 - Deploying API Proxy (name: '$proxy_name', backend gateway URL: '$GATEWAY_URL') ...\n"


cd apigee/proxies
apigeetool deployproxy -u $username -p $password -o $org -e $env -n $proxy_name -d .
cd ..
cd ..

echo -e "\nStep 2 - Creating API Product (name: '$apiproduct_name') ...\n"

auth_header_encoded_full="Authorization: Basic $(echo -n $username:$password | base64)"
#echo "full auth header: $auth_header_encoded_full"

curl -i --header "Content-Type: application/json" --header "$auth_header_encoded_full" -d "{
  \"name\" : \"$apiproduct_name\",
  \"displayName\": \"$apiproduct_display_name\",
  \"approvalType\": \"auto\",
  \"attributes\": [
    {
      \"name\": \"access\",
      \"value\": \"public\"
    }
  ],
  \"description\": \"Hipster Shop REST API\",
  \"apiResources\": [
    \"/shipping/quote\",
    \"/payments\",
    \"/\",
    \"/**\",
    \"/products\",
    \"/carts\",
    \"/currencies\",
    \"/orders/checkout\",
    \"/shipping\",
    \"/ads\",
    \"/products/*\",
    \"/recommendations/*\",
    \"/sendmail\",
    \"/carts/*\"
  ],
  \"environments\": [ \"test\", \"prod\"],
  \"proxies\": [\"$proxy_name\"],
  \"scopes\": [\"\"]
}" "https://api.enterprise.apigee.com/v1/organizations/$org/apiproducts"

echo -e "\n\n(Verify that the status code is '201 Created'.)\n"
password=""

echo -e "\nStep 3 - Adjusting API Spec file ...\n"

cd apigee/specs
cp hipster-shop-api-spec.yaml hipster-shop-$org-$env.yaml

sed -i '' 's/<%org%>/'"$org"'/g' hipster-shop-$org-$env.yaml
sed -i '' 's/<%env%>/'"$env"'/g' hipster-shop-$org-$env.yaml

cd ..
cd ..

echo -e "The Spec has been adjusted and saved as a new file: specs/hipster-shop-$org-$env.yaml\n"

echo -e "\n========== ✓ Done! ==========\n"