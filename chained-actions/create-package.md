# Create the Split Function

For the first step in our sequence, we'll use a Java function to take in a comma delimited list of words and split it around those commas.


**1. Create a package to hold the functions**

Apache OpenWhisk supports the notion of packages to bundle together related Actions making it easier to manage and share related 
functions.  To start, we'll create a new a package for our Actions:

``wsk -i package create sequence``{{execute}}

We will use this package to group the Actions we are about to create in to one logical unit.

# Next

With this out of the way, let's turn our attention to the actual functions in our sequence.
