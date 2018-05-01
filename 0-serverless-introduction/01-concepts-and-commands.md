# Introduction to Serverless Concepts and Apache OpenWhisk Commands

During this step of the course, we will be discussing some basic concepts of Serverless and a few of the Apache OpenWhisk commands.

## Serverless Concepts

The term Serverless is often used interchangeably with the term FaaS (Function-as-a-Service).  Serverless platforms provide APIs
that allow users to run code functions (also called actions) and return the results of each function.  Serverless platforms provide
HTTPS endpoints to allow the developer to retrieve function results.  These endpoints can be used as inputs for other functions, 
thereby providing a sequence (or chaining) of related functions.

On most Serverless platforms, the user deploys (or creates) the functions first before executing them.  The Serverless platform 
then has all the necessary code to execute the functions when it is told to.  The execution of a Serverless function can be invoked
manually by the user via a command or it may be triggered by an event source that is configured to activate the function in
response to events such as cron job alarms, file upload, or any of the many events that can be chosen.

## Apache OpenWhisk Concepts and Commands

Apache OpenWhisk offers the developer a straight forward programming model based on 4 concepts: packages, triggers, actions, 
and rules.

Packages provide event feeds. Triggers associated with those feeds fire when an event occurs, and developers can map 
actions — or functions — to triggers using rules.  An activation is an instance of an action execution.

Anyone can create a new package for others to use, and developers can write their actions in any language. There’s first class
support for JavaScript, Java, Python, and Swift but any other SDK can be packaged as Docker image.

Some of the more commonly used commands in Apache OpenWhisk are:

``wsk -i action create`` is used to create an action (or function) so it is deployed to the Serverless platform.

``wsk -i action update`` is used to update a deployed action.

``wsk -i action delete`` is used to delete a deployed action.

``wsk -i action list`` is used to list all the actions that are currently deployed and ready to execute.

``wsk -i action invoke`` is used to execute an action.

``wsk -i activation list`` is used to dump out the activation log which shows all the activations of actions.
