(continued story from https://github.com/mukundha/hipster-apim-demo / https://github.com/mukundha/hipster-apim-demo/tree/istio-grpc-transcode)

Previously, the Hipster Shop Website has been spun up and configured as an Apigee-registered application with an associated API Key consuming an API Product which contains services such as:
```
productcatalogservice.default.svc.cluster.local
recommendationservice.default.svc.cluster.local
currencyservice.default.svc.cluster.local
cartservice.default.svc.cluster.local
```

Now, we will continue to use the Hipster Shop REST API to create a new digital channel - a chat/voice assistant...


# Prerequisites:
- apigeetool (https://www.npmjs.com/package/apigeetool)


# Steps:

## 1. Publish the Hipster Shop API via Apigee

	
(!TBD: IP address of target server to fetch from a previous variable to point to right ingress-IP in proxy bundle, and other API Proxy changes in general to make CORS work properly)

###  1.1 Store the Hipster Shop API's Gateway URL in an environment variable

`export GATEWAY_URL=http://$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')`

###  1.2 Run the **1-apigee-init.sh** script 
the script is
(1) deploying the API Proxy,
(2) creating an API Product and
(3) adjusting the API Spec to your environment
	
when promoted,
	- enter your Apigee username and password
	- enter the target Apigee organization and environment
	
###  1.3 Upload API Spec
The previous script created a new file under the directory /specs as *hipster-shop-{your_org}-{your_env}.yaml*
	- Open the Edge UI and go to Develop > Specs
	- Under [+ Spec], choose 'Import File' and select the file mentioned above
	- Verify that the specification *hipster-shop-{your_org}-{your_env}* has been added

###  1.4 Create API Portal
To create a new API Portal, go to Publish > Portals
	- Under [+ Portal], enter a name (e.g. Hipster Shop API Portal) and select CREATE
	- Select the *API* section
	- Select [+ API]
	- Select the "Hipster Shop API Product" and hit [Next >]
	- Under *Spec Source*, select 'Choose a different spec', choose *hipster-shop-{your_org}-{your-env}* and hit [Select]
	- Set Audience = Anonymous users
	- (Optional) Under Image, hit Select > External Image, and paste the following URL: 
`https://images.pexels.com/photos/1994/red-vintage-shoes-sport.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260`
	- Select [Add]
	- Select [Finish]
	
###  1.5 Create Developer App (API Key)
	- Under Publish > Portals > Hipster Shop API Portal, select *Live Portal (beta)* at the top right corner
	- From within the developer portal, select *Sign In*
	- Select *Create Account*
	- Open your email account and select the verification link from the message being sent to you
	- Login to the developer portal with your credentials
	- Under your email address on the top right, select *My Apps*
	- Select [+ New App]
	- Enter "Hipster Voice App" as the app name and select the *Hipster Shop API Product* 
	- Hit [Create]
	- Copy the API Key to your clipboard
	- Go to APIs > Hipster Shop API Product
	- Select Authorize on the top left and select the App created before
	- Close the Authorize window and select the GET /currencies resource from the left-side list
	- Select *Execute* from the left testing tab
	- Verify that the API call returns a valid response (incl. JSON payload)
	

## 2. Deploy Voice/Chat Assistant Application Infrastructure

###  2.1 DialogFlow - Import Project  
	- Create new project: https://console.dialogflow.com/api-client/#/newAgent
	- Select your existing Google Cloud project from the drop-down
	- Set your time zone and select [Create]
	- Once created, make the following changes to your project:
		- Select API version V2
		- Enable BETA features
		- Check "Log interactions to Dialogflow" and "Log interactions to Google Cloud"
		- Make sure you hit [Save] at the top afterwards
	- Within the project settings (same section as above), select "Export and Import"
	- Select [Import from ZIP] and find dialogflow/Hipster-Shop.zip
		
###  2.2 Deploy fulfillment endpoint via Google Cloud Functions
	- npm install -g firebase-tools (beware npm permissions error)
	- firebase login (popup appears - login and allow access)
	- cd cloud-functions/fulfillment		
	- firebase use {your_project_id}
	- before deploying to Functions, do an “npm install” to all missing modules to populate the package.json file
	- Adjust the functions JS file by run the **2-configure-function.sh** script
	- Enter the following details:
		- Dialogflow Client ID (a.k.a Service Account)
		- Apigee Organization (same as before)
		- Apigee Environment (same as before)
		- API Key from App created via (Apigee) Developer Portal
	- deploy with “firebase deploy --only functions”
	- after deployment, the function appears here: https://console.cloud.google.com/functions
		
###  2.3 Dialogflow - Update the Fulfillment URL
	- Go to https://console.firebase.google.com/u/0/project/{your_project_id}/functions/list
	- (Note: if the project can't be found, add/import the existing project ID into the Firebase console) 
	- Copy the URL of the *hipstershopFulfillment* function
	- Go to *Fulfillment* and paste the link into the URL field - hit [Save]


