(continued story from https://github.com/mukundha/hipster-apim-demo / https://github.com/mukundha/hipster-apim-demo/tree/istio-grpc-transcode)

Previously, the Hipster Shop Website has been spun up and configured as an Apigee-registered application with an associated API Key consuming an API Product which contains services such as:
```
productcatalogservice.default.svc.cluster.local
recommendationservice.default.svc.cluster.local
currencyservice.default.svc.cluster.local
cartservice.default.svc.cluster.local
```

Now, we will continue to use the Hipster Shop REST API to create a new digital channel - a chat/voice assistant.


# Prerequisites:
- apigeetool (https://www.npmjs.com/package/apigeetool)


# Steps:

## 1. Publish the Hipster Shop API via Apigee

###  1.1 Store the Hipster Shop API's Gateway URL in an environment variable

`export GATEWAY_URL=http://$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')`

###  1.2 Run the *1-apigee-init.sh* script 
The script is deploying the API Proxy, creating an API Product and adjusting the API Spec to your environment.
`./1-apigee-init.sh`
When promoted, enter your Apigee (1) `username`, (2) `password`, target (3) `organization` and (4) `environment`.
	
###  1.3 Upload API Spec
The previous script created a new file under the directory `/specs` as `hipster-shop-{your_org}-{your_env}.yaml`
- Open the Edge UI and go to [Develop] > [Specs]
- Under [+ Spec], choose `Import File` and select the file created
- Select the `hipster-shop-{your_org}-{your_env}` spec which has been added to the list
- Verify that the host attribute contains the desired organization and environment

![specs](https://github.com/mikesson/hipster-apim-demo_assistant-app/blob/master/img/specs.png?raw=true)

###  1.4 Create API Portal
To create a new API Portal, go to [Publish] > [Portals]
- Under [+ Portal], enter a name (e.g. Hipster Shop API Portal) and select [Create]
- Select the [API] section
- Select [+ API]
- Select the `Hipster Shop API Product` and hit [Next >]
- Under `Spec Source`, select `Choose a different spec`, choose `hipster-shop-{your_org}-{your-env}` and hit [Select]
- Set Audience to `Anonymous users`
- (Optional) Under Image, hit [Select] > [External Image], and paste the following URL: 
`https://images.pexels.com/photos/1994/red-vintage-shoes-sport.jpg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260`
- Select [Add]
- Select [Finish]
	
###  1.5 Create Developer App (API Key)
Under [Publish] > [Portals] > [Hipster Shop API Portal], select `Live Portal (beta)` at the top right corner
- From within the API portal, select `Sign In`
- Select `Create Account`
- Open your email account and select the verification link from the message being sent to you
- Login to the developer portal with your credentials
- Under your email address on the top right, select `My Apps`
- Select [+ New App]
- Enter `Hipster Voice App` as the app name and select the `Hipster Shop API Product` 
- Hit [Create]
- Copy the API Key to your clipboard
- Go to [APIs] > [Hipster Shop API Product]
- Select *Authorize* on the top left and select the App created before
- Close the *Authorize* window and select the GET /currencies resource from the left-side list
- Select *Execute* from the testing tab on the right
- Verify that the API call returns a valid response (incl. JSON payload)

![specs](https://github.com/mikesson/hipster-apim-demo_assistant-app/blob/master/img/portal_auth.png?raw=true)


## 2. Deploy Voice/Chat Assistant Application Infrastructure

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
- Adjust the functions JavaScript file by running the **`./2-configure-function.sh`** script
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