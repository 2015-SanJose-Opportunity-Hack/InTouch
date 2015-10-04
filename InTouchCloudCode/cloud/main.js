
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.afterSave("Task", function(request) {
    if (request.object.existed() == false) {
        var senderObject = request.object.get('sender');
        var forCharmObject = request.object.get('forCharm');
        // Get sender user object
        var senderQuery = new Parse.Query("_User");
        senderQuery.get(senderObject.id, {
            success: function(senderObjectReal) {
                // The object was retrieved successfully.
                console.log(senderObjectReal);
                var senderName = senderObjectReal.get("firstName") + " " + senderObjectReal.get("lastName").charAt(0) + ".";
                var charmQuery = new Parse.Query("Charm");
                charmQuery.get(forCharmObject.id, {
                    success: function(charmObjectReal) {
                        // The object was retrieved successfully.
                        var charmName = charmObjectReal.get("name");

                        var receiverNotificationText = senderName + " added a Moment to " + charmName + ".";
                        var receiverPushQuery = new Parse.Query(Parse.Installation);
				        var ownerObject = charmObjectReal.get('owner');
                        var targetUserObject;
                        console.log(senderObject);
                        console.log(ownerObject);
                        if (senderObject.id === ownerObject.id){
                            targetUserObject = charmObjectReal.get("gifter");
                        }
                        else{
                            targetUserObject = ownerObject;
                        }
                        receiverPushQuery.equalTo('deviceType', 'ios');
                        receiverPushQuery.equalTo('currentUser', targetUserObject);
                        Parse.Push.send({
                            where: receiverPushQuery, // Set our Installation query
                            data: {
                                alert: receiverNotificationText,
                                sound: "",
                                subtitle: charmObjectReal.id,
                                title: "",
                            }
                        }, {
                            success: function() {
                                console.log("success!");
                                    // Push was successful
                                console.log(receiverPushQuery);
                            },
                            error: function(error) {
                                throw "Got an error " + error.code + " : " + error.message;
                            }
                        });
                    },
                    error: function(error) {
                    }
                    });
                },
            error: function(object, error) {
            	console.log(error.code + error.message);

            }
        });//senderquery

    }
    else{
    	// Task existed
    	// Check if responded is true
    	// If true, schedule notification for tomorrow
    	// If false, 
    }
});