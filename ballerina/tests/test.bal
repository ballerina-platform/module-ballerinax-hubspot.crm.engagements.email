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
import ballerina/http;

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

string testEmailId = "76600938205";
string expectedStatus = "COMPLETE";
int expectedTotal = 17;

@test:Config {
    groups: ["mock_tests"]
}
public function testCreateEmailEp() returns error? {
    // Create a new email. Will throw error if the response type is not SimplePublicObject
    SimplePublicObject response = check hubspotClient->/.post({
        "associations": [
            {
            "types": [],
            "to": {
                "id": "84058501871"
            }
            }
        ],
        "objectWriteTraceId": "string",
        "properties": {
            "hs_timestamp": "2025-10-30T03:30:17.883Z",
            "hubspot_owner_id": "77405866",
            "hs_email_direction": "EMAIL",
            "hs_email_status": "SENT",
            "hs_email_subject": "Let's talk about Ballerina",
            "hs_email_text": "Thanks for your interest let's find a time to talk",
            "hs_email_headers": "{\"from\":{\"email\":\"from@domain.com\",\"firstName\":\"FromFirst\",\"lastName\":\"FromLast\"},\"sender\":{\"email\":\"sender@domain.com\",\"firstName\":\"SenderFirst\",\"lastName\":\"SenderLast\"},\"to\":[{\"email\":\"ToFirst+ToLast<to@test.com>\",\"firstName\":\"ToFirst\",\"lastName\":\"ToLast\"}],\"cc\":[],\"bcc\":[]}"
        }
    });

    // Store the id of the created email for use in other testcases
    testEmailId = response.id;

    boolean expectedArchived = false;

    // Check if the response contains the archived status as false
    test:assertEquals(response.archived, expectedArchived);
}

@test:Config {
    groups: ["mock_tests"],
    dependsOn: [testCreateEmailEp]
}
public function testGetAllEmailsEp() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubspotClient->/.get();
    test:assertTrue(response.results.length() == 10);
}

@test:Config {
    dependsOn: [testCreateEmailEp],
    enable: isLiveServer
}
public function testGetAEmailEp() returns error? {
    // Retrieve test email
    SimplePublicObjectWithAssociations response = check hubspotClient->/[testEmailId];
    test:assertEquals(response.id, testEmailId);
}

@test:Config {
    dependsOn: [testCreateEmailEp],
    enable: isLiveServer
}
public function testUpdateEmailEp() returns error? {
    // Update email properties
    SimplePublicObject response = check hubspotClient->/[testEmailId].patch({
        "properties": {
            "hs_lastmodifieddate":"2025-02-18T06:43:02.683Z"
        }
    });

    test:assertTrue(response.length() > 0);
}

@test:Config {
    dependsOn: [testCreateEmailEp],
    enable: isLiveServer
}
public function testDeleteEmailEp() returns error? {
    // Delete the created email
    http:Response response = check hubspotClient->/[testEmailId].delete();

    // Check if the response status is 204
    test:assertTrue(response.statusCode == 204);
}

@test:Config {
    groups: ["mock_tests"]
}
public function testCreateBatchEp() returns error? {
    // Create a new batch. Will throw error if the response type is not BatchResponseSimplePublicObject
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubspotClient->/batch/create.post({
        "inputs": [
            {
            "associations": [
                {
                "types": [],
                "to": {
                    "id": "84058501871"
                }
                }
            ],
            "objectWriteTraceId": "string",
            "properties": {
                "property_date": "1572480000000",
                "property_radio": "option_1",
                "property_number": "17",
                "property_string": "value",
                "property_checkbox": "false",
                "property_dropdown": "choice_b",
                "property_multiple_checkboxes": "chocolate;strawberry"
            }
            }
        ]
    });

    test:assertEquals(response.status, expectedStatus);
}

@test:Config {
    // dependsOn: [testCreateBatchEp],
    enable: isLiveServer
}
public function testArchiveBatchEp() returns error? {
    http:Response response = check hubspotClient->/batch/archive.post({
        "inputs": [
            {
            "id": testEmailId
            }
        ]
    });

    // Check if the response status is 204
    test:assertTrue(response.statusCode == 204);
}

@test:Config {
    dependsOn: [testCreateBatchEp],
    enable: isLiveServer
}
public function testReadBatchEp() returns error? {
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubspotClient->/batch/read.post({
        "propertiesWithHistory": [
            "string"
        ],
        "idProperty": "string",
        "inputs": [
            {
            "id": testEmailId
            }
        ],
        "properties": [
            "string"
        ]
    });

    test:assertEquals(response.status, expectedStatus);
}

@test:Config {
    dependsOn: [testCreateBatchEp],
    enable: isLiveServer
}

    public function testUpdateBatchEp() returns error? {
    // Update batch properties
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check hubspotClient->/batch/update.post({
        "inputs": [
            {
            "id": testEmailId,
            "properties": {
                "property_date": "1572480000000"
            }
            }
        ]
    });

    test:assertEquals(response.status, expectedStatus);
}

@test:Config {
    dependsOn: [testCreateBatchEp],
    enable: isLiveServer
}

public function testSearchEmailsEp() returns error? {
    // Search for emails
    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check hubspotClient->/search.post({});

    test:assertEquals(response.total, expectedTotal);
}
