(continued story from https://github.com/mukundha/hipster-apim-demo)

Previously, the Hipster Shop Website has been spun up and configured as an Apigee-registered application with an associated API Key consuming an API Product which contains services such as:
```
productcatalogservice.default.svc.cluster.local
recommendationservice.default.svc.cluster.local
currencyservice.default.svc.cluster.local
cartservice.default.svc.cluster.local
```

Now, we will continue to use the Hipster Shop REST API to create a new digital channel - a chat/voice assistant...


1. Apigee
- Create new spec
	- import YAML
	- save as ‘Hipster Shop’
- Publish API Proxy
	- tbd

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
