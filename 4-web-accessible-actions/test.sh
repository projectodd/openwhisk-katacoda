#! /bin/sh

if [ "$RESET" ]
then
	rm -rf echo
	wsk -i action delete echo

	mvn -q -B archetype:generate \
		 -DarchetypeGroupId=org.apache.openwhisk.java \
		 -DarchetypeArtifactId=java-action-archetype \
		 -DarchetypeVersion=1.0-SNAPSHOT \
		 -DgroupId=com.example \
		 -DartifactId=echo

	cat > echo/src/main/java/com/example/FunctionApp.java <<EOF
package com.example;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

/**
* Echo FunctionApp
*/
public class FunctionApp {
	public static JsonObject main(JsonObject args) {
		JsonObject response = new JsonObject();
		response.add("response", args);
		return response;
	}
}
EOF

	cat > echo/src/test/java/com/example/FunctionAppTest.java <<EOF
package com.example;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import org.junit.Test;

/**
 * Echo FunctionAppTest
 */
public class FunctionAppTest {
	@Test
	public void testFunction() {
		JsonObject args = new JsonObject();
		args.addProperty("name", "test");
		JsonObject response = FunctionApp.main(args);
		assertNotNull(response);
		String actual = response.get("response").getAsJsonObject().get("name").getAsString();
		assertEquals("test", actual);
	}
}
EOF
fi

cd echo
mvn package

wsk -i action update --web=true echo target/echo.jar --main com.example.FunctionApp

WEB_URL=`wsk -i action get echo --url | awk 'FNR==2{print $1}'`
AUTH=`oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}'`

echo $WEB_URL

echo Empty request
curl -k $WEB_URL.json

echo GET
curl -k $WEB_URL.json?key=value

echo POST
curl --insecure -d '{"key1":"value1", "key2":"value2"}' -H "Content-Type: application/json" -X POST $WEB_URL.json

