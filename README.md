# CS3217 Problem Set 4

**Name:** Tian Fang

**Matric No:** A0194568L

## Credits

1. <a href='https://pngtree.com/freepng/monster-octopus-octopus-monster-cartoon_3920369.html'>octopus png from pngtree.com</a>
2. <a href='https://pngtree.com/freepng/cute-halloween-decorative-pumpkin-lights_4050935.html'>pumpkin png from pngtree.com</a>
3. <a href='https://pngtree.com/freepng/soap-bubbles-vector-bow-reflection-soap-bubbles-aqua-wash-isolated-illustration_5204647.html'>soap bubbles png from pngtree.com</a>
4. <a href='https://pngtree.com/freepng/plastic-bag_5405009.html'>plastic bag png from pngtree.com</a>

## Dev Guide
### Design

#### Architecture

![Architecture Diagram](/Users/tf/Computer Science/CS3217/CS3217 Problem Set 3/diagrams/ArchitectureDiagram.png)

This Peggle Clone follows the conventional MVC pattern. The *Architecture Diagram* above explains the high-level design of the game. (Note that Constants and Utility classes are omitted.)

Given below is a quick overview of each component:

- `Storage`
  - handle level loading and level Saving

- `Model`
  - represents and stores data related to the game
  - determines rules and logic of the game and expose methods for external use
- `Controller`
  - serves as the bridge between `Model` and `View`
  - accepts user inputs and update `Model` accordingly
  - updates `View` when `Model` changes
- `View`
  - in charge of the representation of data on the screen
  - does not contain any domain logic



#### Interactions between Architecture Components

The *Sequence Diagram* below shows how the components interact with each other when the user **clicks on the SAVE button and input a valid level name** when designing a Peggle level.

![Save Sequence Diagram](/Users/tf/Computer Science/CS3217/CS3217 Problem Set 3/diagrams/SaveSequenceDiagram.png)

The *Sequence Diagram* below shows how the components interact with each other when the user **clicks on the screen to launch the ball** when playing a Peggle game.

![Launch Ball Sequence Diagram](/Users/tf/Computer Science/CS3217/CS3217 Problem Set 3/diagrams/LaunchBallSequenceDiagram.png)

The sections below give more details of each component.

#### Storage

![Storage Diagram](/Users/tf/Computer Science/CS3217/CS3217 Problem Set 3/diagrams/StorageDiagram.png)

The `Storage`

- retrieves all `json` files in the document directory and load corresponding Peggle levels in alphabetical order
- saves Peggle levels data in `json` format

#### Model

![Model Diagram](/Users/tf/Computer Science/CS3217/CS3217 Problem Set 3/diagrams/ModelDiagram.png)

The `Model` contains three parts:

1. `Physics Engine`
   - represents physics objects
   - simulates physics objects' movement and collision
   - detects physics objects' collision with the boundaries of a physics world
   - does not depend on other sub-components of `Model`
2. `Peggle Model`
   - encapsulates pegs in the Peggle game using `Peg` class
     - `Peg` class have a dependency on the `PhysicsShape` in the `Physics Engine`
   - encapsulates Peggle game levels using `PeggleLevel` class
     - exposes methods that can modify or inspect the state of a `Pegglelevel`

3. `Game Engine`
   - implements Peggle-specific logic - decide how should different game objects interact with each other
   - has `GameEngine` being the main class that inherits from the `PhysicsWolrd`
     - `GameEngine` has a `GameStatus` that stores the current status of the game such as the number of balls left and whether the game has reached an end (represented by `State`)
   - has `GamePeg` to represent a `Peg` as a `MovablePhysicsObject`

Note that the `Model` component does not depend on other components

#### Controller

![Controller Diagram](/Users/tf/Computer Science/CS3217/CS3217 Problem Set 3/diagrams/ControllerDiagram.png)

The `Controller`

- has individual controllers for each of the main screens (e.g. `LevelDesigner`)
- ensures  `Model` and `View` are in sync
- handles gestures such as single tap and call methods from `Model` to update it
- refreshes `View` to show the latest data when there a change to the `Model` (e.g. a peg is deleted)

#### View

![View Diagram](/Users/tf/Computer Science/CS3217/CS3217 Problem Set 3/diagrams/ViewDiagram.png)

The `View`

- has individual view classes that handle the on-screen representations of game elements
- sends user interactions to `Controller`



### Implementation

Given below are some noteworthy details on how certain features are implemented

#### LevelDesignerController

The `LevelDesignerController` controls the level design screen, on which the user can add/delete/move/resize pegs to create their own Peggle level

- Buttons
  - Home button - show the main menu via storyboard segue
  - Palette
    - Peg buttons for adding peg - switch to "adding peg mode" by setting `selectedPaletteButton`, and the corresponding `PaletteButton`'s method `select()` will be called (to lighten the selected peg button) due to `didSet` of `selectedPaletteButton`
    - Erase button - switch to "deleting peg mode" by setting `selectedPaletteButton`
  - Load button - show `LevelChooser` via storyboard segue, and set the `LevelChooser`'s attribute `isLoading` to true so that it knows it should load levels in `Level Designer` instead of playing them
  - Save button - save the current level using save alert from `Alert` class
  - Reset button - reset the level by calling corresponding methods in `PeggleLevel`. The `GameBoardView` will be updated accordingly
  - Start button -  show `PeggleGame` via storyboard segue. The game will be initialized with the current game level using `prepare` method in `LevelDesignerController`
- Gestures
  - Single Tap 
    - if `selectedPaletteButton` is the erase button, delete a peg
    - else
      - if there is a peg at the tap position, set `currentSelectedPeg` to that peg. And the selected peg will  `glow()` due to `currentSelectedPeg`'s `didSet`
      - add a peg otherwise if it's valid on the game board
  - Long Press - delete a peg if there is a peg at the Long Pressed position. The `Model` and `View` will be updated accordingly
  - Dragging - drag a peg around. The position of the dragged peg and the corresponding `PegView` will be updated whenever there is some translation detected by the `UIPanGestureRecognizer`. The peg being dragged will be glowing.
  - Pinch - resize the `currentSelectedPeg` by the scale detected by the `UIPinchGestureRecognizer` if `currentSelectedPeg` is not nil. The `Model` and `View` will be updated accordingly

##### Activity Diagram for Single tap on the game board

![SingleTapActivityDiagram](/Users/tf/Computer Science/CS3217/Problem Set 2/diagrams/SingleTapActivityDiagram.png)

#### LevelChooserController

The `LevelChooserController` controls the level selection screen. If the previous screen is `Level Designer`, the selected level will be loaded in the `Level Designer`. If the previous screen is `Main Menu`, then the selected level will be loaded in `Peggle Game` for the user to play. The most important view on the level selection screen is a `UITableView` that lists names of saved levels. Hence, the `LevelChooserController` naturally has to follow two protocols `UITableViewDataSource` and `UITableViewDelegate`, and it's achieved with the help from `LevelLoader`. 

- Buttons
  - Home button - show the main menu via storyboard segue
- Gestures
  - Tap on a table cell - `currentSelectedLevel` will be updated to the selected level. Note that ` LevelChooserController` detects the previous screen by keeping a varible `isLoading`, based on which it decides which screen it should segue to (if `isLoading` is true, it will be `Level Designer`; otherwise, it will be `Peggle Game`)

#### PeggleGameController

The `PeggleGameController` controls the Peggle game screen. Its main job is to sync the `GameEngine` with the view. `PeggleGameController` gets notified when there are some changes to the `GameEngine` via the `GameEventHandlerDelegate` protocol. Therefore, `PeggleGameController` implements methods to deal with the respective event that happens in a Peggle game (e.g. if `ballDidMove()`, then the corresponding `BallView` should also be moved).  `PeggleGameController` has a `TableView` for selecting `Master`s. Hence, the `PeggleGameController` naturally has to follow two protocols `UITableViewDataSource` and `UITableViewDelegate`. 

- Buttons
  - Home button - show the main menu via storyboard segue
  - Replay button - reset the level for replay. it will reset both the `GameEngine` (mode) and `GameBoardView` (view)
- Gestures
  - Pan on the screen - `rotateCannon` will be called and it will calculate the angle in a way that the cannon will always point to the position of the user's finger. Once, the angle is calculated, the `CannonView` will rotate correspondingly
  - Tap on the screen - `fireCannon` will be called and it will first ask `GameEngine` whether the user can fire a ball (e.g. cannot fire a ball if the previous ball is still bouncing around). If the ball is ready to be launched, it will call the engine to launch the ball and tell the view to add a `BallView` to the `GameBoardView` accordingly

## Rules of the Game
Please write the rules of your game here. This section should include the
following sub-sections. You can keep the heading format here, and you can add
more headings to explain the rules of your game in a structured manner.
Alternatively, you can rewrite this section in your own style. You may also
write this section in a new file entirely, if you wish.

### Cannon Direction
Please explain how the player moves the cannon.

### Win and Lose Conditions
Please explain how the player wins/loses the game.

## Level Designer Additional Features

### Peg Rotation
Please explain how the player rotates the pegs.

### Peg Resizing
Please explain how the player resizes the pegs.

## Bells and Whistles
Please write all of the additional features that you have implemented so that
your grader can award you credit.

## Tests
### Unit Testing

done in code

### Integration Testing

#### Main Menu Integration Testing

- Test buttons
  - Play button
    - open `Level Chooser`
  - Level Design button
    - open `Level Designer`

#### Level Chooser Integration Testing

- Test Storage
  - Close and Reopen the app to test the `Level Chooser`s opened from `Main Menu` AND from `Level Designer` 
    - the deleted/created/overwritten levels are showing up correctly with the correct name and correct data (i.e. check the peg's shape, color, positions, sizes, etc.)

- Test Buttons 
  - Main Menu button
    - return to the `Main Menu`
- Test Gestures
  - Single tap on one of the table cell
    - if the previous screen is `Main Menu`, a `Peggle Game` will appear loaded with the selected level
    - if the previous screen is `Level Designer`, `Level Designer` will load the selected level and show up
  - Swipe the table cell from right to left will reveal a "Delete" button, clicking on which will delete the corresponding level.

#### Level Designer Integration Testing

- Test Buttons

  - Main Menu button

    - return to the `Main Menu`

  - Palette button (Blue, Orange, Erase)

    - blue peg button should be selected by default
    - after a single click on one of the Palette buttons, other Palette buttons will have lower opacity to indicate that the Palette button is selected. 
    - nothing should happen if the already selected Palette button is clicked

  - Load button

    - open `Level Chooser`
    - when a level is clicked in the `Level Chooser`, the `Level Designer` loaded with the selected level should appear

  - Save button

    ​	<!-- after clicking the Save button, if there is no orange peg on the board, an alert will show up to notify the user (TODO: also change the one below) -->

    - After clicking the Save button, a save alert that asks for the level name will show up (if the level is newly created the default name will be "Untitled". if the level was previously stored, then the TextField will show its previous level name)
      - if the user clicks "cancel", the alert window disappears and nothing should happen
      - if the user clicks "save":
        - if the entered level name is invalid (level name should not be blank and it must be alpha-numerical)
          - Save alert will show up again, inform the user of the invalid level name to ask for a new one
        - if the entered level name already exists, overwrite alert shows up, asking whether the user wants to overwrite the original level
          - if the user clicks "Overwrite", the alert window disappears and the level file will be overwritten
          - if the user clicks "Cancel", the alert window disappears and nothing should happen
        - an error alert will show up if the game fails to save the file

  - Reset button

    - clear the game board (no pegs should remain after clicking Reset)

  - Start button

    - show the `Peggle Game` initialized with the data from the current level

- Test Gestures

  - Single Tap
    - When the Erase button is selected, and the user single taps on the game board:
      - If there is a peg at the tap location, the peg will be removed from the game board
      - If there is no peg at the tap location, nothing should happen
      - If there is a glowing peg (selected), that peg will dim down
    - When a Palette button other than the Erase button is selected, single tapping on the game board (specified by the background image) will result in:
      - If there is an existing peg at the tap position, the peg should light up (glowing)
      - If there is no existing peg at the tap position, a peg centered at that location will be created. If there is a glowing peg (selected), that peg will dim down. However, the peg will not be created in the following scenarios:
        - the new peg will overlap with other existing pegs
        - the new peg will have some part of it outside of the game board boundary (clicking near the boundary will not create a peg)
  - Dragging
    - dragging a peg will move the peg around on the game board and light up the peg regardless of which Palette button is selected
      - No matter how the user drags a peg, the peg will stay in the game board boundary
      - No matter how the user drags a peg, the peg will not overlaps with another peg
      - if there is no peg at the start position of dragging, nothing should happen no matter how the user drags
  - Long press
    - Long press on a peg should remove the peg regardless of which Palette button is selected
      - If there is a glowing peg (selected), that peg will dim down after long press peg removal
      - nothing should happen when the user long presses at a location with no peg

- Test Labels

  - Peg count labels should correctly reflect the actual numbers of pegs on the game board, check whether the count will be updated when following operations are performed
    - loading a saved level
    - reset
    - try with different shape, color, and size
      - add a peg
      - remove a peg via long-press/ erase button



#### Peggle Game Integration Testing

- Test Loading

  - the pegs on the screen should reflect the level passed by `Level Chooser` or `Level Designer`
    - all pegs are moved down by cannon's height. Therefore, no pegs should be touching the cannon
  - cannon should be pointing downward
  - labels are correctly initiated (see test Labels)

- Test Labels

  - initially

    - ball count should be 10
    - orange peg count should correctly reflect the number of orange pegs remaining on the screen

  - after ball launch

    - ball count will decrease by 1

  - after ball's exit from the bottom of the screen

    - orange peg count is updated (reduce the number of orange pegs that got cleared by the last ball)

      <!-- TODO: after ball enters the bucket -->

- Test Buttons 

  - Main Menu button
    - return to the `Main Menu`
  - Replay button
    - reset the level for replay
      - if there is a ball moving, it will disappear
      - cannon will be pointing downward
      - pegs in the Peggle level are restored, and none of them should be glowing

- Test Gestures

  - Pan on the screen

    - rotate the cannon
    - the cannon will always point to the position of the user's finger
    - the cannon will never point upward. Therefore, the "highest angle" the cannon can have is pointing towards left or right
    - panning outside the game board will do nothing (unless the initial position of panning is inside the game board)

  - Single Tap on the screen 

    - a ball will be fired from the top-center of the screen (i.e. inside cannon) at the direction specified by the user if

      - there is no ball on the screen

      <!-- TODO: more to come -->

- Test Game Play

  - Ball Launch
    - refer to single tap test under Peggle Game Integration Test's "Test Gestures"
  - Ball Movement
    - Once the ball is launched, it should move according to the laws of physics, specifically
      - the ball will have a downward acceleration (i.e. gravity)
      - both the acceleration and initial velocity will affect the movement of the ball
  - Ball Collision
    - Once the ball touches a wall or peg, the ball will bounce away in a natural and reasonable manner
      - the ball will be slowed down by a certain factor (COR: Coefficient of Restitution), representing the energy loss during a collision
      - peg's position will not be affected by collision (they stay where they are)
    - the ball should not collide with the top of the screen or cannon
  - Peg Lighting
    - Once the ball touches a peg, the peg should light up, indicating that the peg is hit
      - the ball can still collide with the lit-up peg
      - once a peg is lit, it should remain lit
  - Peg Removal
    - After the ball exits from the bottom, all glowing (hit) pegs will fade away.
    - if the game may reach a situation in which the ball is stuck, the peg(s) causing it will be removed prematurely



## Written Answers

### Reflecting on your Design
> Now that you have integrated the previous parts, comment on your architecture
> in problem sets 2 and 3. Here are some guiding questions:
> - do you think you have designed your code in the previous problem sets well
>   enough?
> - is there any technical debt that you need to clean in this problem set?
> - if you were to redo the entire application, is there anything you would
>   have done differently?

Your answer here
