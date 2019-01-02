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
	


1. Apigee
- 1.1 Create new spec
	- import YAML
	- save as ‘Hipster Shop’
- 1.2 Deploy API Proxy and create API Product
	- run ./apigee/init.sh
	  (this will upload and deploy the Hipster Shop API Proxy and API Product)
- 1.3 
	
(!TBD: IP address of target server to fetch from a previous variable to point to right ingress-IP)


2. DialogFlow
- create new project https://console.dialogflow.com/api-client/#/newAgent
- enable both at LOG SETTINGS
- enable BETA features (maybe?)
- Select V2 API


3. Prepare fulfilment (https://developers.google.com/actions/sdk/deploy-fulfillment)
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
- after deployment it appears here: https://pantheon.corp.google.com/functions


- haven’t found URL in Cloud Functions, so added (existing) project from list into Firebase, now under “Functions” you can see the URL

- include this URL in DialogFlow Fulfillment



Apigee Edge UI:
- Created API spec
- Create API Proxy w/ spec above (created API Product right away as part of wizard, test env only)
- create developer app to get API key, inserted into index.js function
