# Create Java Function

For the first step in our sequence, we'll use a Java function to take in a comma delimited list of words and split it around those commas.


**1. Create a package to hold the functions**

Apache OpenWhisk supports the notion of packages to bundle together related Actions making it easier to manage and share related 
functions.  To start, we'll create a new a package for our Actions:

``wsk -i package create sequence``{{execute}}

**2. Create a Java function**

Next, it's time to create the Java Action to do the first step in our sequence.  This function can be created using the [Java Action 
Maven Archetype](https://github.com/apache/incubator-openwhisk-devtools/tree/master/java-action-archetype).  

``cd /root/projects``{{execute}}

Create a Java function project called `splitter`

```bash
mvn archetype:generate \
    -DarchetypeGroupId=org.apache.openwhisk.java \
    -DarchetypeArtifactId=java-action-archetype \
    -DarchetypeVersion=1.0-SNAPSHOT \
    -DgroupId=com.example \
    -DartifactId=splitter
```{{execute}}

Move to the project directory

``cd splitter``{{execute}}

Click the link below to open pom.xml and update the `finalName` with value `${artifactId}` that helps us avoid long jar names during function deployment on OpenWhisk:

``splitter/pom.xml``{{open}}

Let's open the Java source file `src/main/java/com/example/FunctionApp.java` to review its contents.  Click the link below to open the source file in the editor:

``splitter/src/main/java/com/example/FunctionApp.java``{{open}}

All OpenWhisk Java function classes should have a `main` method with a signature that takes a `com.google.gson.JsonObject` as parameter and returns a `com.google.gson.JsonObject`.
We need to update the generated function with our desired behavior.  Update the FunctionApp class with this code:

<pre class="file" data-filename="splitter/src/main/java/com/example/FunctionApp.java" data-target="replace">
package com.example;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
 * Splitter FunctionApp
 */
public class FunctionApp {
  public static JsonObject main(JsonObject args) {
    JsonObject response = new JsonObject();
    String text = null;
    if (args.has("text")) {
      text = args.getAsJsonPrimitive("text").getAsString();
    }
    String[] results = new String[] { text };
    if (text != null && text.indexOf(",") != -1) {
      results = text.split(",");
    }
    JsonArray splitStrings = new JsonArray();
    for (String var : results) {
      splitStrings.add(var);
    }
    response.add("result", splitStrings);
    return response;
  }
}
</pre>

With the main function updated, now we need to update the tests.

Update the FunctionAppTest class with this code:

<pre class="file" data-filename="splitter/src/test/java/com/example/FunctionAppTest.java" data-target="replace">
package com.example;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import org.junit.Test;

/**
 * Splitter FunctionAppTest
 */
public class FunctionAppTest {
  @Test
  public void testFunction() {
    JsonObject args = new JsonObject();
    args.addProperty("text", "apple,orange,banana");
    JsonObject response = FunctionApp.main(args);
    assertNotNull(response);
    JsonArray results = response.getAsJsonArray("result");
    assertNotNull(results);
    assertEquals(3, results.size());
    ArrayList<String> actuals = new ArrayList<>();
    results.forEach(j -> actuals.add(j.getAsString()));
    assertTrue(actuals.contains("apple"));
    assertTrue(actuals.contains("orange"));
    assertTrue(actuals.contains("banana"));
  }
}
</pre>

Build the project

``mvn clean package``{{execute}}

`NOTE`: The Java Action maven archetype is not in maven central yet.  If you plan to use it in your local OpenWhisk environment you then need to build and install from [sources](https://github.com/apache/incubator-openwhisk-devtools/tree/master/java-action-archetype).

**3. Deploy the function**

Let's now create a function called `splitter` in OpenWhisk:

``wsk -i action create splitter target/splitter.jar --main com.example.FunctionApp``{{execute}}

When we create Java function the parameter `--main` is mandatory.  It defines which Java class will be called during OpenWhisk Action invocation.

Let's check if the function is created correctly:

``wsk -i action list | grep 'splitter'``{{execute}}

The output of the command should show something like:

```sh
/whisk.system/splitter                             private java
```

**4. Verify the function**

Having created the function `splitter`, let's now verify the function.

``wsk -i action invoke splitter --result``{{execute}}

Executing the above command should return us this JSON payload:

```json
{
    "greetings": "Hello! Welcome to OpenWhisk"
}
```

# Congratulations

Congratulations you have now successfully developed a Java function and deployed the same on to OpenWhisk.   In next step we will see how to update the function and redeploy it.
