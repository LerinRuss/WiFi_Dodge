How to set a control to the player?
It seems that it's impossible to use scenes only in cases where it has graphics.
As you cannot export custom classes only built-in, resourse and so on.

ToDo's:
- What if spirits actually catch the victim and hauling them somewhere?
- What if players can also be spirits?
- Add small pop-up showing when you click one "Connect" button and saying that 
you should be in the same WiFi to play together
- what's the difference between Node and Scene? I thought that Scene is just 
sub-tree of nodes
-[] What if a player decided to play another mode during the running game, would it be 
difficult to change it?
- It must be impossible to create already created game (as there is an error right now)
- It must be impossible to connect when you are already the server
- to make competition is fair I need to expand pictures accordingly on each phone
- Edit suggested to add a few lives to the player 
- How to add moving eye?
- Fix bug when the server frees Player but in the client side the client synchronizer 
tries to sync state (vector step) but on server side this synchronizer doesn't exist anymore
- What is this ip address (169.254.252.13) gotten from IP.get_local_addresses()?
About music:
- What should be done with music and sounds when the client just connected in running game?
I have three options how to solve this issue:
1) Just no care, leave it as it is
2) When a player connected he has its own "waiting" music
3) When a player's connected then he gets the synchronized music from the server in an exact time
as the server currently is
- Can I use change annotation of RPC in rpc.await.gd from `any_peer` to authority and maybe for 
messages it's better to make them reliable?

Bugs:
1) 
Intro: When client connects to a running game his message still remains "Dodge the crepes" 
from the main menu while game is playing yet
Steps:
- Run server
- Connect to the server while the server's player is still alive
Actual:
The main menu's "Dodge the crepes" text is on the screen
Expcted:
It's empty (hidden, removed and so on)
2)
Intro: This is floating bug and it seems it happens due to race conditions.
When server's player dies on the client side there is no message "Dodge the Creeps"
after "Game over" message
steps:
- Run server
- Connect client
- After some restarts look what happens after "Game over" message
Expected:
The same message as in server
Actual:
Nothing
3)
Intro: Movement of the character is not smooth. The next aimation frame 
is a bit below than prefious one.
Steps: just run and look
4)
Intro: In the beginning when the game is only started there is no animation.
Steps: Start the game and don't move the character
Expected: Animation is running
Actual: Not
5)
It seems score is not synchronized when the player hust connected into running game

Client 1:
Character 1 + Movement Direction + Control
Character 2

Client 2:
Character 1
Character 2 + Movement Direction + Control

Server:
Character 1 + Movement Direction + Updater
Character 2 + Movement Direction + Updater
