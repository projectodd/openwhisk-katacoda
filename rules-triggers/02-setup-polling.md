# Setup Activation Polling Terminal

In this step, you will open a second terminal window and execute an OpenWhisk command to do activation polling.

**1. Open Second Terminal**

To the immediate right of the terminal tab is a +.  Click on this plus and choose Terminal to open a second terminal window.
Once the second terminal opens, enter a command to set the path so the wsk command is accesible:

``export PATH="${HOME}/openwhisk/bin:${PATH}"``{{execute}}

**2. Start Activation Polling**

Let's now use the OpenWhisk command to start activation polling in this second terminal:

``wsk -i activation poll``{{execute}}

The polling should start in the second terminal and show some "invokerHealthTestAction0" messages like:

```sh
Activation: 'invokerHealthTestAction0' (f5bca1d1ef334533bca1d1ef333533de)
[]

Activation: 'invokerHealthTestAction0' (956669d570eb4490a669d570ebe490bd)
[]

Activation: 'invokerHealthTestAction0' (4b88bebf2a97485a88bebf2a97e85a08)
[]
```

**3 Verify Timestamp Activation**

Now click on the first terminal tab and invoke your timestamp function manually so we can verify that it shows up in the 
activation polling in the second window:

``wsk -i action invoke --blocking timestamp``{{execute}}

This will echo the resulting JSON message to the current window and log the activation in the other window.  Click on the
second terminal to verify that the activation polling shows the execution of the timestamp function.
