# Demo Add-Ons to [hipster-apim-demo](https://github.com/mukundha/hipster-apim-demo)

[In the previous steps](https://github.com/mukundha/hipster-apim-demo), the Hipster Shop Website has been deployed and configured as an Apigee-registered application. With an associated API Key, it consumes the API Product comprising services such as:
```
productcatalogservice.default.svc.cluster.local
recommendationservice.default.svc.cluster.local
currencyservice.default.svc.cluster.local
cartservice.default.svc.cluster.local
...
```

This repository contains the following add-ons to the previous demo:
- Publishing the Hipster Shop REST API via Apigee API Management (incl. a Developer Portal)
- Deploying a chat/voice assistant appliation consuming the REST API


## Prerequisites
- all steps from [this repo](https://github.com/mukundha/hipster-apim-demo)
- [apigeetool](https://www.npmjs.com/package/apigeetool) installed


## Add-Ons

- [Publishing the Hipster Shop REST API via Apigee API Management](https://github.com/mikesson/hipster-apim-demo-addons/1-managed-api)

- [Deploying a chat/voice assistant appliation](https://github.com/mikesson/hipster-apim-demo-addons/2-assistant-api)

