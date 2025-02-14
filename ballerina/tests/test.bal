// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/oauth2;
import ballerina/os;
import ballerina/test;

final string clientId = os:getEnv("HUBSPOT_CLIENT_ID");
final string clientSecret = os:getEnv("HUBSPOT_CLIENT_SECRET");
final string refreshToken = os:getEnv("HUBSPOT_REFRESH_TOKEN");

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string serviceUrl = isLiveServer ? "https://api.hubapi.com/crm/v3/objects/emails" : "http://localhost:8081";

final Client hubspotClient = check initClient();

isolated function initClient() returns Client|error {
    if isLiveServer {
        OAuth2RefreshTokenGrantConfig auth = {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        };
        return check new ({auth}, serviceUrl);
    }
    return check new ({
        auth: {
            token: "test-token"
        }
    }, serviceUrl);
}

// Change this value and test
final int days = 30;

string testEmailId = "";

@test:Config {
    groups: ["mock_tests"]
}

public function testCreateEmailEp() returns error? {
    // Create a new email. Will throw error if the response type is not SimplePublicObject
    SimplePublicObject response = check hubspotClient->/.post({
        "properties": {
            "hs_timestamp": "2025-10-30T03:30:17.883Z",
            "hubspot_owner_id": "47550177",
            "hs_email_direction": "EMAIL",
            "hs_email_status": "SENT",
            "hs_email_subject": "Let's talk about Ballerina",
            "hs_email_text": "Thanks for your interest let's find a time to connect",
            "hs_email_headers": "{\"from\":{\"email\":\"from@domain.com\",\"firstName\":\"FromFirst\",\"lastName\":\"FromLast\"},\"sender\":{\"email\":\"sender@domain.com\",\"firstName\":\"SenderFirst\",\"lastName\":\"SenderLast\"},\"to\":[{\"email\":\"ToFirst+ToLast<to@test.com>\",\"firstName\":\"ToFirst\",\"lastName\":\"ToLast\"}],\"cc\":[],\"bcc\":[]}"
        },
        "associations": [
            {
            "to": {
                "id": "601"
            },
            "types": [
                {
                "associationCategory": "HUBSPOT_DEFINED",
                "associationTypeId": 210
                }
            ]
            },
            {
            "to": {
                "id": "602"
            },
            "types": [
                {
                "associationCategory": "HUBSPOT_DEFINED",
                "associationTypeId": 198
                }
            ]
            }
        ]
    });

    // Store the id of the created email for use in other testcases
    testEmailId = response.id;
}
