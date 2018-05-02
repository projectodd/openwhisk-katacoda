# Serverless Framework

The Serverless Framework is a tool that allows developers to deploy their serverless functions to a choice of different
Serverless platforms.  It supports AWS Lambda, Azure Function, Google Cloud Functions, Apache OpenWhisk, and several other FaaS
platforms.  In this step, we will create the files used by Serverless Framework to deploy a weather javascript function to
OpenShift Cloud Functions and deploy and execute the function.  In this first step, we will install the Serverless Framework
and create the files to deploy a weather function via the Serverless Framework.

**1. Install Serverless Framework**

To install the Serverless Framework we use **npm** to install both the Serverless Framework package and the OpenWhisk plugin.
Execute the following commands to accomplish this:

``npm install -g serverless``{{execute}}

``npm install -g serverless-openwhisk ``{{execute}}

**2. Create a weather JavaScript function**

Now we are ready to create the files.  First, we need to create JavaScript file, click on the link below to create an empty
file called **weather.js** in the directory **/root/projects/ocf** : 
``weather.js``{{open}}

Once the created file is opened in the editor, you can then copy the content below into the file (or use the `Copy to editor` button):

<pre class="file" data-filename="/root/projects/ocf/weather.js" data-target="replace">
'use strict';

var request = require('request');

function main(params) {
    var location = params.location || 'Vermont';
    var url = 'https://query.yahooapis.com/v1/public/yql?q=select item.condition from weather.forecast where woeid in (select woeid from geo.places(1) where text="' + location + '")&format=json';

    return new Promise(function(resolve, reject) {
        request.get(url, function(error, response, body) {
            if (error) {
                reject(error);
            }
            else {
                var condition = JSON.parse(body).query.results.channel.item.condition;
                var text = condition.text;
                var temperature = condition.temp;
                var output = 'It is ' + temperature + ' degrees in ' + location + ' and ' + text;
                resolve({msg: output});
            }
        });
    });
}

exports.handler = main;
</pre>

**3. Create the Serverless Framework package.json file**

Next, we will create the **package.json** file.  Click on the link below to create the empty file in the directory 
**/root/projects/ocf**:
``package.json``{{open}}

Once the created file is opened in the editor, you can then copy the content below into the file (or use the 
`Copy to editor` button):

<pre class="file" data-filename="/root/projects/ocf/package.json" data-target="replace">
{
  "name": "openwhisk-node-weather",
  "version": "0.1.0",
  "description": "Example of creating a function that returns the weather for a given location.",
  "scripts": {
    "postinstall": "npm link serverless-openwhisk",
    "test": "echo \"Error: no test specified\" && exit 1"
  }
}
</pre>

**4. Create the Serverless Framework serverless.yml file**

Finally, we need to create the **serverless.yml** file.  Click on the link below to create the empty file in the directory 
**/root/projects/ocf**:
``serverless.yml``{{open}}

Once the created file is opened in the editor, you can then copy the content below into the file (or use the 
`Copy to editor` button):

<pre class="file" data-filename="/root/projects/ocf/serverless.yml" data-target="replace">
service: my_weather

provider:
  name: openwhisk

functions:
  weather:
    handler: weather.handler
      
plugins:
    - serverless-openwhisk
</pre>

Now that we have created the files, we can proceed to deploying the function in the next step of the scenario.
