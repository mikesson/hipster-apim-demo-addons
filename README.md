(continued story from https://github.com/mukundha/hipster-apim-demo)

Previously, the Hipster Shop Website has been spun up and configured as an Apigee-registered application with an associated API Key consuming an API Product which contains services such as:
```
productcatalogservice.default.svc.cluster.local
recommendationservice.default.svc.cluster.local
currencyservice.default.svc.cluster.local
cartservice.default.svc.cluster.local
```

Now, we will continue to use the Hipster Shop REST API to create a new digital channel - a chat/voice assistant...


Prerequisites:
- apigeetool (https://www.npmjs.com/package/apigeetool)


Steps:

1. Publish the Hipster Shop API via Apigee

	
(!TBD: IP address of target server to fetch from a previous variable to point to right ingress-IP in proxy bundle, and other API Proxy changes in general to make CORS work properly)


- 1.1 Run init.sh script to (1) deploy API Proxy, (2) create API Product and (3) adjust API Spec
	- when promoted, enter your Apigee username and password
	- when promoted, enter the target Apigee organization and environment
	
- 1.2 Upload API Spec
	- The previous script created a new file under the directory /specs as *hipster-shop-{your_org}-{your_env}.yaml*
	- Open the Edge UI and go to Develop > Specs
	- Under [+ Spec], choose 'Import File' and select the file mentioned above
	- Verify that the specification *hipster-shop-{your_org}-{your_env}* has been added

- 1.3 Create API Portal
	- Go to Publish > Portals
	- Under [+ Portal], enter a name (e.g. Hipster Shop API Portal) and select CREATE
	- Select the *API* section
	- Select [+ API]
	- Select the "Hipster Shop API Product" and hit [Next >]
	- Under *Spec Source*, select 'Choose a different spec', choose *hipster-shop-{your_org}-{your-env}* and hit [Select]
	- Set Audience = Anonymous users
	- (Optional) Under Image, hit Select > External Image, and paste the following URL: https://images.pexels.com/photos/1994/red-vintage-shoes-sport.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260
	- Select [Add]
	- Select [Finish]
	
- 1.4 Create Developer App (API Key)
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
	

2. Develop/Deploy Voice/Chat Assistant Application Infrastructure

	- 2.1 Deploy fulfillment endpoint via Firebase/Google Cloud Functions
		- npm install -g firebase-tools (beware npm permissions error)
		- firebase login (popup appears)
		- cd <your_dir>
		- firebase init
			- select functions
			- select your firebase project
			- select JavaScript
			- select ESLint yes
			- select Yes on NPM dependencies
			-  wait for “firebase initialisation complete!” message
		- open index.js within /functions
		- (then I developed this index.js)
		- before deploying to Functions, do an “npm install” to all missing modules to populate the package.json file
		- deploy with “firebase deploy --only functions”
		- after deployment it appears here: https://console.google.com/functions
	- 2.2 Configure DialogFlow
		- create new project https://console.dialogflow.com/api-client/#/newAgent
		- enable both at LOG SETTINGS
		- enable BETA features (maybe?)
		- Select V2 API
	

- haven’t found URL in Cloud Functions, so added (existing) project from list into Firebase, now under “Functions” you can see the URL

- (include this URL in DialogFlow Fulfillment)

////////////old

Apigee Edge UI:
- Created API spec
- Create API Proxy w/ spec above (created API Product right away as part of wizard, test env only)
- create developer app to get API key, inserted into index.js function