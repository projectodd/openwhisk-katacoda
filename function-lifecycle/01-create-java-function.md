# Create Java Function

Having successfully deployed [Apache OpenWhisk](https://openwhisk.apache.org/) to [OpenShift](https://openshift.com) and [OpenWhisk CLI](https://github.com/apache/incubator-openwhisk-cli/releases/) is now configured to work with the OpenWhisk, we will now write a simple Java function.


**1. Create a Java function**

The Java function can be created using the [Java Action Maven Archetype](https://github.com/apache/incubator-openwhisk-devtools/tree/master/java-action-archetype).  

``cd /root/projects``{{execute}}

Create a Java function project called `hello-openwhisk`

``mvn archetype:generate -DarchetypeGroupId=org.apache.openwhisk.java -DarchetypeArtifactId=java-action-archetype -DarchetypeVersion=1.0-SNAPSHOT -DgroupId=com.example -DartifactId=hello-openwhisk``{{execute}}

Move to the project directory

``cd /root/projects/hello-openwhisk``{{execute}}

Click the link below to open pom.xml and update the `finalName` with value `${artifactId}` that helps us avoid long jar names during function deployment on OpenWhisk:

``/root/projects/hello-openwhisk/pom.xml``{{open}}

Let's open the Java source file `src/main/java/com/example/FunctionApp.java` to review its contents.  Click the link below to open the source file in the editor:

``/root/projects/hello-openwhisk/src/main/java/com/example/FunctionApp.java``{{open}}

All OpenWhisk Java function classes should have a `main` method with a signature that takes a `com.google.gson.JsonObject` as parameter and returns a `com.google.gson.JsonObject`.

Build the project

``mvn clean package``{{execute}}

`NOTE`: The Java action maven archetype is not in maven central yet.  If you plan to use it in your local OpenWhisk environment you then 
need to build and install from [sources](https://github.com/apache/incubator-openwhisk-devtools/tree/master/java-action-archetype).

**2. Deploy the function**

Let's now create a function called `hello-openwhisk` in OpenWhisk:

``wsk -i action create hello-openwhisk target/hello-openwhisk.jar --main com.example.FunctionApp``{{execute}}

When we create Java function the parameter `--main` is mandatory.  It defines which Java class will be called during OpenWhisk Action invocation.

Let's check if the function is created correctly:

``wsk -i action list | grep 'hello-openwhisk'``{{execute}}

The output of the command should show something like:

```sh
/whisk.system/hello-openwhisk                             private java
```

**3. Verify the function**

Having created the function `hello-openwhisk`, let's now verify the function.

**Unblocked invocation**

All OpenWhisk action invocations are `unblocked` by default.  Each action invocation will return an activation ID which can be used to check the result later.

![Web Console Login](../assets/ow_action_with_activation_id.png)

The activation ID can be used to  check the response using `wsk` CLI:

```sh
wsk -i activation result <activation_id>
```

e.g. 

```sh
wsk -i activation result ffb2966350904356b29663509043566e
```

Let's now invoke our Java function in unblocked manner:

``ACTIVATION_ID=$(wsk -i action invoke hello-openwhisk | awk '{print $6}')``{{execute}}

Let's check the result of the invocation:

``wsk -i activation result $ACTIVATION_ID``{{execute}}

You should see this result:

```json
{
    "greetings": "Hello! Welcome to OpenWhisk"
}
```

**Blocked invocation**

We can also make the OpenWhisk action invocation to be synchronous by adding a `--result` parameter to `wsk` CLI command: 

``wsk -i action invoke hello-openwhisk --result``{{execute}}

Executing the above command should return us this JSON payload:

```json
{
    "greetings": "Hello! Welcome to OpenWhisk"
}
```

# Congratulations

Congratulations you have now successfully developed a Java function and deployed the same on to OpenWhisk.   In next step we will see how to update the function and redeploy it.
