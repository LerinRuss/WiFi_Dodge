How to set a control to the player?
It seems that it's impossible to use scenes only in cases where it has graphics.
As you cannot export custom classes only built-in, resourse and so on.

Я хочу, чтобы последная стадия в следующей королевской битве была такой же
как в этой игре (если остаются одни травоядные), но вопрос, откуда будут 
появляться призраки, если карта тороидальная?
Еще у меня идея для след игры:
- Травоядные и хищники
- Игра разделена на стадии где они эволюционирут, когда наберут подходящее число очков
- Чтобы сэкономить время, они выбирают эволюционное дерево заранее перед игрой. 

From Fedya:
- должен ли игрок быть призраком в компететив?
- Тороидальная карта?
- Выше скорость перемещения?

- Толкать друг друга
- Спринт, ускоряшка
- И выплавашки, уведмлялки что кто-то зашел и что делать 

ToDo's:
- Make animation smoother 
- Draw beatiful background (Parallax)
- Add "power-ups"
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
- Reduce enemy max velocity (Kanat said that's OK)?
- It would be great to add in settings choice of which control type the user prefer.
Or it'd be ideal to create system where it chooses a random control type and users can change it
if they don't like it and this choice would affect the probability of the choise of the control type.
- Edit prefer to replace tail with legs
- Nelly suggested to change color for brown fishes and she sent the picture which color suits others well.
- Also Nelly suggested to leave only one eye to the main character
- Let the users to choose colors for player, mobs and background

Or at least to correct collision shape and size
- Reduce Joystick size?
- Reducing SIZE of apk file?
- What is Stretch:Mode?
- Is screen size set up in settings affected by Stretch:Mode?
- [AS] Make Start button and Joysting unaffected from scratching
- [AS] Solve "Expensing" of screen problem.
= it seems I solved but I don't know how it affects other devices. 
I just set Stretch:Mode to "Canvas Items" and Stretch:Aspect to "Ignore"

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
6) 
The size of the world is set in the Host and there is a case when 
another man plays on big device with better pixel quality for him
there will be "gaps" (he will see how spirits are spawned)
7) 
Кажется, что используя tpc сооединение я делаю лаги в игре
Чтобы это проверить надо играть с двух телефонов
8)
Лейбл текущего режима не обновляется
9)
Какой-то баг, когда чел отвалился или типа того, игра не рехостуется,
постоянные "Game Over"

Client 1:
Character 1 + Movement Direction + Control
Character 2

Client 2:
Character 1
Character 2 + Movement Direction + Control

Server:
Character 1 + Movement Direction + Updater
Character 2 + Movement Direction + Updater

Steps to export Project
- Remove old "Exports" from Export folder
- Export desirible build
- Upload it to itch.io

Acronyms:
[AS] - "After Study" means that I need to learn/study more and after gaining proper 
knowledge to come back to this TODO or task and so on. 
