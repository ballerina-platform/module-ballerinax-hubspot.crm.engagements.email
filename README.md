# Ballerina HubSpot CRM Engagements Email connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/hubspot.crm.engagements.email.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%hubspot.crm.engagements.email)

## Overview

[HubSpot](https://www.hubspot.com) is an AI-powered customer relationship management (CRM) platform. 

The `ballerinax/hubspot.crm.engagements.email` package offers APIs to connect and interact with the [HubSpot CRM Engagements Email API](https://developers.hubspot.com/docs/reference/api/crm/engagements/email) endpoints, specifically based on the [HubSpot REST API](https://developers.hubspot.com/docs/reference/api/overview).

## Setup guide

To use the HubSpot CRM Engagements Email connector, you must have access to the HubSpot API through a HubSpot developer account and a HubSpot App under it. Therefore you need to register for a developer account at HubSpot if you don't have one already.

### Step 1: Create/Login to a HubSpot developer account

If you have an account already, go to the [HubSpot developer portal](https://app.hubspot.com/)

If you don't have a HubSpot Developer Account you can sign up to a free account [here](https://developers.hubspot.com/get-started)

### Step 2: Create a developer test account (Optional)

Within app developer accounts, you can create a [developer test account](https://developers.hubspot.com/beta-docs/getting-started/account-types#developer-test-accounts) under your account to test apps and integrations without affecting any real HubSpot data.

> **Note:** These accounts are only for development and testing purposes. In production you should not use developer test accounts.

1. Go to `Test Account` section from the left sidebar.

   ![Hubspot Developer Portal](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/main/docs/resources/test_acc_1.png) 

2. Click Create developer test account.

   ![Hubspot Developer Test Account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/main/docs/resources/test_acc_2.png)

3. In the dialogue box, give a name to your test account and click create.

   ![Hubspot Developer Test Account](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/main/docs/resources/test_acc_3.png)

### Step 3: Create a HubSpot app

1. In your developer account, navigate to the "Apps" section. Click on "Create App"

   ![Hubspot Create App](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/main/docs/resources/create_app_1.png)

2. Provide the necessary details, including the app name and description.

### Step 4: Configure the authentication flow.

1. Move to the `Auth` Tab. (Second tab next to App Info)

   ![Hubspot Developer Config Auth](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/main/docs/resources/create_app_2.png )

2. In the `Scopes` section, add the following scope for your app using the "Add new scope" button.

   * `crm.objects.contacts.read`
   * `crm.objects.contacts.write`
   * `sales-email-read`

   ![Hubspot Developer App Add Scopes](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/main/docs/resources/scopes.png )

4. Add your Redirect URI in the relevant section. You can also use `localhost` addresses for local development purposes. Click Create App.

   ![Hubspot Create Developer App](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/main/docs/resources/create_app_final.png )

### Step 5: Get your client id and client secret

- Navigate to the Auth section of your app. Make sure to save the provided Client ID and Client Secret.

   ![Hubspot Get Credentials](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/main/docs/resources/get_credentials.png )

### Step 6: Setup authentication flow

Before proceeding with the Quickstart, ensure you have obtained the Access Token using the following steps:

1. Create an authorization URL using the following format:

   ```
   https://app.hubspot.com/oauth/authorize?client_id=<YOUR_CLIENT_ID>&scope=<YOUR_SCOPES>&redirect_uri=<YOUR_REDIRECT_URI>
   ```

   Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_SCOPES>` with your specific value.

> **Note:** If you are using a `localhost` redirect url, make sure to have a listener running at the relevant port before executing the next step.

2. Paste it in the browser and select your developer test account to install the app when prompted.

   ![Hubspot Get Auth Code](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/main/docs/resources/install_app.png)

3. A code will be displayed in the browser. Copy the code.

4. Run the following curl command. Replace the `<YOUR_CLIENT_ID>`, `<YOUR_REDIRECT_URI>` and `<YOUR_CLIENT_SECRET>` with your specific value. Use the code you received in the above step 3 as the `<CODE>`.

   - Linux/macOS

     ```bash
     curl --request POST \
     --url https://api.hubapi.com/oauth/v1/token \
     --header 'content-type: application/x-www-form-urlencoded' \
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   - Windows

     ```bash
     curl --request POST ^
     --url https://api.hubapi.com/oauth/v1/token ^
     --header 'content-type: application/x-www-form-urlencoded' ^
     --data 'grant_type=authorization_code&code=<CODE>&redirect_uri=<YOUR_REDIRECT_URI>&client_id=<YOUR_CLIENT_ID>&client_secret=<YOUR_CLIENT_SECRET>'
     ```

   This command will return the access token necessary for API calls.

   ```json
   {
     "token_type": "bearer",
     "refresh_token": "<Refresh Token>",
     "access_token": "<Access Token>",
     "expires_in": 1800
   }
   ```

5. Store the access token securely for use in your application.

## Quickstart

To use the `HubSpot CRM Engagements Email` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `hubspot.crm.engagements.email` module and `oauth2` module.

```ballerina
import ballerina/oauth2;
import ballerinax/hubspot.crm.engagements.email as hsceemail;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

   ```toml
    clientId = <Client Id>
    clientSecret = <Client Secret>
    refreshToken = <Refresh Token>
   ```

2. Instantiate a `hsceemail:ConnectionConfig` with the obtained credentials and initialize the connector with it.

    ```ballerina 
    configurable string clientId = ?;
    configurable string clientSecret = ?;
    configurable string refreshToken = ?;

    OAuth2RefreshTokenGrantConfig auth = {
         clientId,
         clientSecret,
         refreshToken,
         credentialBearer: oauth2:POST_BODY_BEARER
    };

    final hsceemail:Client hubspot = check new ({auth});
    ```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations. A sample usecase is shown below.

#### Read a batch of emails by internal ID, or unique property values
    
```ballerina
public function main() returns error? {
    hsceemail:BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubspotClient->/batch/read.post({
        propertiesWithHistory: [
            "string"
        ],
        idProperty: "string",
        inputs: [
            {
            id: testBatchId
            }
        ],
        properties: [
            "string"
        ]
    });
}
```

## Examples

The `HubSpot CRM Engagements Email` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/tree/main/examples/), covering the following use cases:

1. [Bulk update sender information in scheduled emails](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/tree/main/examples/bulk_update_sender_info/) - Automate the process of updating sender information for all scheduled emails, ensuring accuracy and consistency in email communication.

2. [Detect and resend failed emails](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/tree/main/examples/detect_resend_failed_emails/) - Identify emails with a status of "FAILED" or "BOUNCED" and attempt to resend them, ensuring important messages reach their intended recipients.

3. [Email analytics and reporting](https://github.com/ballerina-platform/module-ballerinax-hubspot.crm.engagements.email/tree/main/examples/email_analytics_reporting/) - Retrieve and analyze key email performance metrics such as sent, bounced, failed, and scheduled emails to monitor delivery status and optimize communication strategies.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`hubspot.crm.engagements.email` package](https://central.ballerina.io/ballerinax/hubspot.crm.engagements.email/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
