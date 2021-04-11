# iOS-Connect4
A 4th Year iOS Connect4 project where the player is against alphaC4 Bot

![connect4](https://github.com/k3vonk/iOS-Connect4/blob/main/Images/connect4.png)

# Architecture
The development process of the Connect4 iOS game was based on four core features of the physical game:
1. Game Board & Wedge (draw)
2. Discs (subview)
3. Behavior (colliders, gravity, item behavior)
4. Gestures & Game Mechanics (tap, swipe)

# Game Board
The game board was drawn and centerized for all iOS phone systems. The board itself was a rectangle with circles (bezier path) cut out at calculated points. Wedges were in place such that disc objects did not fall past the board or fall into neighbouring columns. 

# Discs
The discs were created from instances of DiscView which are subviews of the core Connect4View. The discs has properties such as the 'move' it was dropped, the color to be displayed, and the behavior.

# Behavior
Discs had gravitational properties such that it falls when the player clicks on the screen. Additionally, resistance and elasticity values were set to provide a more realistic sense of the discs as it bounces off the frame or other discs. If discs falls out of bounds (out of screen) then the discs take the action of destroying themselves to collect up the memory. Wedges and invisible barriers are calculated to prevent discs from crossing boundaries.

# Gestures & Game Mechanics
The tap gesture was used to drop a disc on a region above the game board. Each region is separated by the columns on the connect4 board. Threads were used to separate and delay inputs so both the AI and the player would have a small waiting period before they can drop a disc. 

The game itself is handled by a session, recording which user is in play, the amount of turns that have been executed, and if the game is completed. In order to restart the game, the player must swipe the wedge bar to reset the game. 

When a game session is one, the turn that the disc was placed will be displayed, as well as highlighted.

# Core Data and Tab Bar Controller
Persistence in this game only occurs when a game has an outcome. This persistance enables a replay of the game. Core data is saved with attributes botStart, move, outcome, thumbnail, and winningPieces. These attributes are all obtained from the public information of the game. Each replay session is then stored on the History Collection View Controller. Users can click on any past games to replay the actions taken. 

<img src="https://github.com/k3vonk/iOS-Connect4/blob/main/Images/Screen%20Shot%202020-03-24%20at%202.42.55%20PM.png" height="500">


