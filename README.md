# PMS
Password Management System Simulation using Bash and Linux

A password management system helps us keep track of all our passwords for different systems, instead of relying on the same password for everything because of poor memory. Here I will provide a password manager on a client-server model to mimic centralised password managers.

The PMS has the the following functions: <br><br>
<b>init</b> Create a new folder to store a user’s passwords. <br>
<b>insert</b> Create a new file in a user’s folder containing the login and password for a service. <br>
<b>edit</b> Edit the credentials. <br>
<b>show</b> Read the information stored for a service. <br>
<b>ls</b> List the services that a user has registered a password for. <br>
<b>rm</b> Delete the file corresponding to a service. <br>

Navigate to the folder containing all PMS scripts. Then add the execution rights for all scripts by entering 'chmod u+x script_name.sh' in terminal. Launch the server in the terminal by entering './server.sh'. The server runs in an infinit loop until stopped by the client (this functionality is just implemented in order to stop the server after finishing the simulation).<br>
Launch the client in a separate terminal by entering './client.sh $clientId $req [args]' where $clienId is the unique identifier of this client and $req is one of init, insert, show, edit, rm, ls or shutdown. args is a list of arguments an depends on the service used. See the following example:

<b>init<b> check that a client id and user name were given and send an init request to the server:<br>
  $ ./client.sh client1 init user1
  Error: user already exists
  $ ./init.sh newUser
  OK: user created
<br><br>
<b>insert<b> check that a client id, user name and service name were given, ask user to input login
and password, and send init request to server:
  $ ./client.sh client1 insert user1 Bank/myNewBank 
  Please write login: #Written by client.sh
  myLogin #Written by user
  Please write password: #Written by client.sh
  myPassword #Written by user
  OK: service created
  
  
