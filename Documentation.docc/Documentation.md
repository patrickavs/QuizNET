# ``GameDemo``

This is a Quiz-App, where you can play either in Single- or Multiplayer mode through a private network.

## Overview

- This App uses the Multipeer Connectivity Framework from Apple to communicate with other devices through a local network
    - You need to add 2 Bonjour-services to the Info.plist file
    - It works only when you try it on 2 Simulators

- When you want to play in Multiplayer mode, you will see all available devices you can connect to and which are already connected

![PeerOverview](peerOverview.png)

- You can choose question parameters e.g. category, amount of questions or the type of answers (true or false, multiple answers)

![QuestionOverview](questionOverview.png)

- You can also see with whom you play with

![PlayerOverview](playerOverview.png)

