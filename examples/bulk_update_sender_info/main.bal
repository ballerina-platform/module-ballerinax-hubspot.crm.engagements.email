import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.engagements.email as hsceemail;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

public function main() returns error? {

    // Create the config for authorization to the API
    hsceemail:OAuth2RefreshTokenGrantConfig auth = {
        clientId,
        clientSecret,
        refreshToken,
        credentialBearer: oauth2:POST_BODY_BEARER // This line should be added to create auth object.
    };

    hsceemail:Client hubspotClient = check new ({auth});

    // Get all emails
    string[] properties = ["hs_email_status"];
    hsceemail:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check hubspotClient->/.get(properties=properties);

    final string newSenderEmailAddress = "new_sender_address@example.com";
    final string newSenderFirstName = "SenderFirst";
    final string newSenderLastName = "SenderLast";

    foreach hsceemail:SimplePublicObject email in response.results {
        string emailStatus = email?.properties["hs_email_status"] ?: "";

        // Apply the change only to SCHEDULED emails
        if emailStatus == "SCHEDULED" {
            string updatedHeaderInfo = string `{
                "sender": {
                    "email": "${newSenderEmailAddress}",
                    "firstName": "${newSenderFirstName}",
                    "lastName": "${newSenderLastName}"
                }
            }`;

            hsceemail:SimplePublicObject updated = check hubspotClient->/[email.id].patch({
                "properties": {
                    "hs_email_headers": updatedHeaderInfo
                }
            });

            io:println(string `Updated email ${updated.id}'s sender address to ${newSenderEmailAddress}`);
        }
        else {
            io:println(string `Email ${email.id} is not SCHEDULED. Skipping...`);
        }
    }
}
