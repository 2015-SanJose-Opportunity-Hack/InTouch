
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.afterSave("Task", function(request) {
    if (request.object.existed() == false) {
    	if (request.object.get('constraintType') == "Time"){
			// if constraintType is Time, schedule push to elder at next occurance of constraintTime
			var pushTime = new Date();
			var hour = request.object.get('constraintTime').split(":")[0];
			var minute = request.object.get('constraintTime').split(":")[1];
			pushTime.setUTCHours(hour);
			pushTime.setUTCMinutes(minute);
			pushTime.setUTCDate(pushTime.getDate() + 1);
			console.log("raw time is " + pushTime)
			var finalPushTime = pushTime.toISOString;
			console.log("finalPushTime time is " + finalPushTime)
			var elderPushQuery = new Parse.Query(Parse.Installation);
			var elderNotificationText = "Did you " + request.object.get('name') + "?";
			elderPushQuery.equalTo('currentUser', request.object.get('elder'));
            Parse.Push.send({
                where: elderPushQuery, // Set our Installation query
                data: {
                    alert: elderNotificationText,
                    sound: "",
                    subtitle: "",
                    title: "",
                    category: "inTouchCategory",
                    taskId: request.object.id,
                    push_time: pushTime
                }
            }, {
                success: function() {
                    console.log("success!");
                        // Push was successful
                    console.log(elderPushQuery);
                    console.log(finalPushTime);
                    console.log(elderNotificationText);
                },
                error: function(error) {
                    console.log(finalPushTime);
					console.log(request.object.get('constraintTime'));
                    throw "Got an error " + error.code + " : " + error.message;
                }
            });
        }//senderquery
    }
    else{
    	// Task existed
    	// Check if responded is true
    	// If true, schedule notification for tomorrow
    	// If false, 
    }
});

function convertDateToUTC(date) { 
    return new Date(date.getUTCFullYear(), date.getUTCMonth(), date.getUTCDate(), date.getUTCHours(), date.getUTCMinutes(), date.getUTCSeconds()); 
}
