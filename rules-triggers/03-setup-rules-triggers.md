# Setup Rules And Triggers

In this step, you will go back to your first terminal window and setup a trigger and a rule to invoke the timestamp
function periodically. If you have not clicked on the first terminal tab, do so now. 

**1. Setup `every-10-seconds` Trigger**

This trigger uses the built-in alarm package feed to fire events every 10 seconds. This is specified through cron syntax
in the `cron` parameter. The `maxTriggers` parameter ensures that it only fires for 100 seconds (10 times), rather than
indefinitely.  To create the trigger enter the following command:

``
wsk -i trigger create every-10-seconds \
    --feed  /whisk.system/alarms/alarm \
    --param cron '*/10 * * * * *' \
    --param maxTriggers 10
``{{execute}}

**2. Create `invoke-periodically` Rule **

This rule shows how the `every-10-seconds` trigger can be declaratively mapped to the `timestamp.js` action. 
Notice that it's named somewhat abstractly so that if we wanted to use a different trigger 
- perhaps something that fires every minute instead - we could still keep the logical name. To create the rule
enter the folleing command:

``
wsk -i rule create \
    invoke-periodically \
    every-10-seconds \
    timestamp
``{{execute}}

At this point, you can click on the second terminal tab to check the activation polling to confirm that the timestamp
action is invoked by the trigger.  You should see something like this:

```sh
Activation: 'timestamp' (a9a18cde63964cf7a18cde6396fcf719)
[
    "2018-04-19T17:38:46.626950489Z stdout: Invoked at: 4/19/2018, 5:38:46 PM"
]
```
