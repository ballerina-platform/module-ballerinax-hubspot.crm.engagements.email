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

import ballerina/http;

service / on new http:Listener(8081) {
    resource function post .(http:Caller caller, http:Request req) returns error? {
        // Simulate the response for creating a new email
        json payload = check req.getJsonPayload();
        string timeStamp = check payload.properties.hs_timestamp.ensureType();
        string ownerId = check payload.properties.hubspot_owner_id.ensureType();
        string emailDirection = check payload.properties.hs_email_direction.ensureType();
        string emailStatus = check payload.properties.hs_email_status.ensureType();
        string emailSubject = check payload.properties.hs_email_subject.ensureType();
        string emailText = check payload.properties.hs_email_text.ensureType();
        string emailHeaders = check payload.properties.hs_email_headers.ensureType();

        json response = {
            "createdAt": "2025-02-14T05:56:04.184Z",
            "archived": false,
            "archivedAt": "2025-02-14T05:56:04.184Z",
            "propertiesWithHistory": {
                "additionalProp1": [
                {
                    "sourceId": "string",
                    "sourceType": "string",
                    "sourceLabel": "string",
                    "updatedByUserId": 0,
                    "value": "string",
                    "timestamp": "2025-02-14T05:56:04.184Z"
                }
                ],
                "additionalProp2": [
                {
                    "sourceId": "string",
                    "sourceType": "string",
                    "sourceLabel": "string",
                    "updatedByUserId": 0,
                    "value": "string",
                    "timestamp": "2025-02-14T05:56:04.184Z"
                }
                ],
                "additionalProp3": [
                {
                    "sourceId": "string",
                    "sourceType": "string",
                    "sourceLabel": "string",
                    "updatedByUserId": 0,
                    "value": "string",
                    "timestamp": "2025-02-14T05:56:04.184Z"
                }
                ]
            },
            "id": "512",
            "properties": {
                "hs_timestamp": timeStamp,
                "hubspot_owner_id": ownerId,
                "hs_email_direction": emailDirection,
                "hs_email_status": emailStatus,
                "hs_email_subject": emailSubject,
                "hs_email_text": emailText,
                "hs_email_headers": emailHeaders
            },
            "updatedAt": "2025-02-14T05:56:04.184Z"
            };

        check caller->respond(response);
    }
}