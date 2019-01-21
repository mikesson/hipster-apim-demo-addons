## 2. Deploying a chat/voice assistant application

###  2.1 DialogFlow - Import Project  
First of all, [create a new Dialogflow project](https://console.dialogflow.com/api-client/#/newAgent)
- Select your existing Google Cloud project from the drop-down
- Set your time zone and select [Create]
- Once created, make the following changes to your project (in the settings page):
	- Select API version V2
	- Enable BETA features
	- Check [Log interactions to Dialogflow] and [Log interactions to Google Cloud]
	- Make sure you hit [Save] at the top afterwards
- Within the project settings (same section as above), select [Export and Import]
- Select [Import from ZIP] and find `dialogflow/Hipster-Shop.zip`
		
###  2.2 Google Cloud Functions - Deploy *fulfillment* endpoint
- Install the Firebase CLI ([look here](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally) to resolve permission errors during installation) with
`npm install -g firebase-tools`
- login with `firebase login`. A browser popup appears - login and allow access
- `cd cloud-functions/fulfillment`		
- Visit the [Firebase console](https://console.firebase.google.com/) and add your project ID (otherwise the command below will not succeed)
- `firebase use {your_project_id}`
- before deploying to Functions, do an `npm install` inside `cloud-functions/fulfillment/functions` to all missing modules to populate the package.json file
- Adjust the functions JavaScript file by running the **`./configure-function.sh`** script
- Enter the following details:
	- Dialogflow Client ID (a.k.a Service Account)
	- Apigee Organization (same as before)
	- Apigee Environment (same as before)
	- API Key from App created via (Apigee) Developer Portal
- deploy function with `firebase deploy --only functions` (make sure you are in `cloud-functions/fulfillment/`)
- after deployment, look up the function [here](https://console.cloud.google.com/functions)
		
###  2.3 Dialogflow - Update the Fulfillment URL
- Go to `https://console.firebase.google.com/u/0/project/`*{your_project_id}*`/functions/list`
- (Note: if the project can't be found, add/import the existing project ID into the Firebase console) 
- Copy the URL of the `hipstershopFulfillment` function
- Go to [Fulfillment] (within your Dialogflow console) and paste the link into the URL field - hit [Save]

![specs](https://github.com/mikesson/hipster-apim-demo_assistant-app/blob/master/img/function_url.png?raw=true)


### 2.4 Try it out
- Open https://console.dialogflow.com, select your project (agent) and select *see how it works in Google Assistant* on the left hand side

![try_assistant](https://github.com/mikesson/hipster-apim-demo_assistant-app/blob/master/img/try_google_assistant.png?raw=true)

![chat_app](https://github.com/mikesson/hipster-apim-demo_assistant-app/blob/master/img/ads.png?raw=true)


- You can now test the assistant via the chat app and review the analytics on Apigee, e.g. with the traffic composition dashboard (https://apigee.com/platform/{your_org}/trafficcomposition)