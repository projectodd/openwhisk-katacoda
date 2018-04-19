# Setup Activation Polling Terminal

In this step, you will open a second terminal window and execute an OpenWhisk command to do activation polling.

**1. Open Second Terminal**

To the immediate right of the terminal tab is a +.  Click on this plus and choose Terminal to open a second terminal window.
Once the second terminal opens, click on it and enter a command to set the path so the wsk command is accesible:

``export PATH="${HOME}/openwhisk/bin:${PATH}"``{{execute}}

**2. Start Activation Polling**

Let's now use the OpenWhisk command to start activation polling in this second terminal:

``wsk -i action poll``{{execute}}
