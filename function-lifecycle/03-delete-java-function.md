# Delete Java Function

Having successfully created and updated a Java function, we will now see how to delete that function.

**1. Delete Java function**

Let's now delete the `hello-openwhisk` function:

``wsk -i action delete hello-openwhisk``{{execute}}

A successful delete of the function will show output like:

![Updated Action](../assets/ow_action_delete_result.png)

**3. Verify the delete**

``wsk -i action list | grep hello-openwhisk``{{execute}}

The above command should return no results.

# Congratulations

Congratulations you have now successfully deleted the Java function.
