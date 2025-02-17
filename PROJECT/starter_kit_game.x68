*-----------------------------------------------------------
* Title      : Game Starter Kit - Bentos World
* Written by : Philip Bourke + Mark Lambert (C00192497)
* Date       : 05/02/2025 - 16/02/2025
* Description: Project 1 Assembly - Tiny World - BENTO'S WORLD
*-----------------------------------------------------------
;WHEN ENOUGH COINS COLLECTED (10000 POINTS) CUBE GETS BIGGER?
;SOUNDS RETRIEVED FROM STREETS OF RAGE 1 AND 2 SFX
;https://www.sounds-resource.com/genesis_32x_scd/streetsofrage/sound/7357/
;https://www.sounds-resource.com/genesis_32x_scd/streetsrage2/sound/359/
    ORG    $1000
START:                              ; first instruction of program

*-----------------------------------------------------------
* Section       : Trap Codes
* Description   : Trap Codes used throughout StarterKit
*-----------------------------------------------------------
* Trap CODES
TC_SCREEN   EQU         33          ; Screen size information trap code
TC_S_SIZE   EQU         00          ; Places 0 in D1.L to retrieve Screen width and height in D1.L
                                    ; First 16 bit Word is screen Width and Second 16 bits is screen Height
TC_KEYCODE  EQU         19          ; Check for pressed keys
TC_DBL_BUF  EQU         92          ; Double Buffer Screen Trap Code
TC_BCK_SCRN EQU         94          ; Paint the offscreen buffer to current screen
TC_CURSR_P  EQU         11          ; Trap code cursor position

TC_EXIT     EQU         09          ; Exit Trapcode

*-----------------------------------------------------------
* Section       : Charater Setup
* Description   : Size of Player and Enemy and properties
* of these characters e.g Starting Positions and Sizes
*-----------------------------------------------------------
PLYR_W_INIT EQU             16      ; Players initial Width
PLYR_H_INIT EQU             16      ; Players initial Height

PLYR_DFLT_V EQU             00      ; Default Player Velocity
PLYR_JUMP_V EQU             -20     ; Player Jump Velocity
PLYR_DFLT_G EQU             01      ; Player Default Gravity

GND_TRUE    EQU             01      ; Player on Ground True
GND_FALSE   EQU             00      ; Player on Ground False

RUN_INDEX   EQU             00      ; Player Run Sound Index  
JMP_INDEX   EQU             01      ; Player Jump Sound Index  
HIT_INDEX   EQU             02      ; Player Hit Sound Index
WRM_INDEX   EQU             03      ; Worm Hit Sound Index
BEGIN_INDEX EQU             04      ; Begin Sound Index
THNDR_INDEX EQU             05  

ENMY_W_INIT EQU             16      ; Enemy initial Width
ENMY_H_INIT EQU             16      ; Enemy initial Height
ENMY_DMG    EQU             35      ; Enemy damage amount 

WRM_W_INIT EQU              16      ; Worms initial width
WRM_H_INIT EQU              16      ; Worms initial height
WRM_X_OFFSET EQU            540     ; Worms offset from enemy pos
WRM_Y_OFFSET EQU            600     ; Hide worms initially

ENTITY_SPD  EQU             05      ; Entity speed, alter depending on delta
DELTA_AMT   EQU             6000    ; Delta amount
NEW_MODE    EQU             500     ; Amount to unlock the new mode
*-----------------------------------------------------------
* Section       : Game Stats
* Description   : Points
*-----------------------------------------------------------
POINTS      EQU             01      ; Points added

*-----------------------------------------------------------
* Section       : Keyboard Keys
* Description   : Spacebar and Escape or two functioning keys
* Spacebar to JUMP and Escape to Exit Game
*-----------------------------------------------------------
SPACEBAR    EQU             $20     ; Spacebar ASCII Keycode
ESCAPE      EQU             $1B     ; Escape ASCII Keycode
P           EQU             $50     ; P ASCII code

WELCOME_SCREEN:
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$1809,         D1      ; Col 18, Row 09 (Roughly center)
    TRAP    #15                     ; Trap (Perform action)
    LEA     WELCOME_MSG,    A1
    MOVE    #13,            D0
    TRAP    #15
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$1110,         D1      ; Col 11, Row 10 (Next line)
    TRAP    #15                     ; Trap (Perform action)
    LEA     CONTROLS_MSG,   A1
    MOVE    #13,            D0
    TRAP    #15
    
    ;HIDE CURSOR       
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$7020,         D1      ; Move so invisible
    TRAP    #15                     ; Trap (Perform action)
    
    MOVE    #05,            D0      ; Await for user to input ANY key to begin game
    TRAP    #15
MISSION_DETAIL:
    ; Repaint Screen
    MOVE.B  #TC_BCK_SCRN,            D0
    TRAP    #15

    ; Clear the screen
    MOVE.B	#TC_CURSR_P,    D0      ; Set Cursor Position
	MOVE.W	#$FF00,         D1      ; Clear contents
	TRAP    #15                     ; Trap (Perform action)
	
	; LINE ONE
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$1009,         D1      ; Col 10, Row 09 (Roughly center)
    TRAP    #15                     ; Trap (Perform action)
    LEA     WELCOME_1,      A1
    MOVE    #14,            D0
    TRAP    #15
    
    MOVE.L  #GREEN,         D1      ; Set Font color
    MOVE.B  #21,            D0      ; Task for Font Color
    TRAP    #15                     ; Trap (Perform action)
    
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$1809,         D1      ; Col 18, Row 09 
    TRAP    #15                     ; Trap (Perform action)
    LEA     WELCOME_2,      A1
    MOVE    #14,            D0
    TRAP    #15
    
    MOVE.L  #WHITE,         D1      ; Set Font color
    MOVE.B  #21,            D0      ; Task for Font Color
    TRAP    #15                     ; Trap (Perform action)
    
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$2009,         D1      ; Col 20, Row 09 
    TRAP    #15                     ; Trap (Perform action)
    LEA     WELCOME_3,      A1
    MOVE    #14,            D0
    TRAP    #15
    
    ; LINE TWO
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$0710,         D1      ; Col 07, Row 10 (Next line)
    TRAP    #15                     ; Trap (Perform action)
    LEA     WELCOME_4,      A1
    MOVE    #14,            D0
    TRAP    #15
    
    MOVE.L  #FUCHSIA,       D1      ; Set Font color
    MOVE.B  #21,            D0      ; Task for Font Color
    TRAP    #15                     ; Trap (Perform action)
    
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$1510,         D1      ; Col 15, Row 10 
    TRAP    #15                     ; Trap (Perform action)
    LEA     WELCOME_5,      A1
    MOVE    #14,            D0
    TRAP    #15
    
    MOVE.L  #WHITE,         D1      ; Set Font color
    MOVE.B  #21,            D0      ; Task for Font Color
    TRAP    #15                     ; Trap (Perform action)
    
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$2010,         D1      ; Col 20, Row 10 
    TRAP    #15                     ; Trap (Perform action)
    LEA     WELCOME_6,      A1
    MOVE    #14,            D0
    TRAP    #15
    
    
    ;HIDE CURSOR
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$7020,         D1      ; Move so invisible
    TRAP    #15                     ; Trap (Perform action)
    
    MOVE    #05,            D0      ; Await for user to input ANY key to begin game
    TRAP    #15
LETS_GO:
; Repaint Screen
    MOVE.B  #TC_BCK_SCRN,   D0
    TRAP    #15

    ; Clear the screen
    MOVE.B	#TC_CURSR_P,    D0      ; Set Cursor Position
	MOVE.W	#$FF00,         D1      ; Clear contents
	TRAP    #15                     ; Trap (Perform action)
	
	; LINE ONE
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$1209,         D1      ; Col 12, Row 09 (Roughly center)
    TRAP    #15                     ; Trap (Perform action)
    LEA     WELCOME_7,      A1
    MOVE    #14,            D0
    TRAP    #15
    
    ; LINE TWO
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$0710,         D1      ; Col 07, Row 10 (Next line)
    TRAP    #15                     ; Trap (Perform action)
    LEA     WELCOME_8,      A1
    MOVE    #14,            D0
    TRAP    #15
    
    ;HIDE CURSOR
    MOVE.B  #TC_CURSR_P,    D0      ; Set Cursor Position
    MOVE.W  #$7020,         D1      ; Move so invisible
    TRAP    #15                     ; Trap (Perform action)
    
    MOVE    #05,            D0      ; Await for user to input ANY key to begin game
    TRAP    #15
    
    ; PLAY A SPOOKY SOUND TO BEGIN
    BSR     BEGIN_LOAD
    BSR     PLAY_BEGIN
*-----------------------------------------------------------
* Subroutine    : Initialise
* Description   : Initialise game data into memory such as 
* sounds and screen size
*-----------------------------------------------------------
INITIALISE:
    ; Initialise Sounds
    BSR     RUN_LOAD                ; Load Run Sound into Memory
    BSR     JUMP_LOAD               ; Load Jump Sound into Memory
    BSR     HIT_LOAD                ; Load Hit (Collision) Sound into Memory
    BSR     WORM_LOAD               ; Load Worm Collision Sound into memory
    BSR     THUNDER_LOAD 
   
    
    MOVE.B  #00,    HARD_MODE       ;Initialise hardmode to false
    ; Screen Size
    MOVE.B  #TC_SCREEN,     D0      ; access screen information
    MOVE.L  #TC_S_SIZE,     D1      ; placing 0 in D1 triggers loading screen size information
    TRAP    #15                     ; interpret D0 and D1 for screen size
    MOVE.W  D1,             SCREEN_H    ; place screen height in memory location
    SWAP    D1                          ; Swap top and bottom word to retrive screen size
    MOVE.W  D1,             SCREEN_W    ; place screen width in memory location

    ; Place the Player at the center of the screen
    EOR.L   D1, D1                      - Ammended CLR (EOR = inverter) So, using D1 as the operand on itself flips the bits that are 1 to 0
    MOVE.W  SCREEN_W,       D1          ; Place Screen width in D1
    ;---------------------------
    ;Right shift?
    ;---------------------------
    DIVU    #02,            D1          ; divide by 2 for center on X Axis

    MOVE.L  D1,             PLAYER_X    ; Players X Position

    EOR.L   D1, D1                      - Ammended CLR
    MOVE.W  SCREEN_H,       D1          ; Place Screen width in D1
    ;---------------------------
    ;Right Shift?
    ;---------------------------
    DIVU    #02,            D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,             PLAYER_Y    ; Players Y Position

    ; Initialise Player Health to 100
    EOR.L   D1,             D1          - Ammended CLR
    MOVE.L  #100,           D1          ; Initialises health to 100
    MOVE.L  D1,             PLAYER_HEALTH

    ; Initialise Player Score
    EOR.L   D1, D1                      - Ammended CLR
    MOVE.L  #00,            D1          ; Init Score 
    MOVE.L  D1,             PLAYER_SCORE

    ; Initialise Player Velocity
    EOR.L   D1,             D1          - Ammended CLR
    MOVE.B  #PLYR_DFLT_V,   D1          ; Init Player Velocity
    MOVE.L  D1,             PLYR_VELOCITY

    ; Initialise Player Gravity
    EOR.L   D1,             D1          - Ammended CLR
    MOVE.L  #PLYR_DFLT_G,   D1          ; Init Player Gravity
    MOVE.L  D1,             PLYR_GRAVITY

    ; Initialize Player on Ground
    MOVE.L  #GND_TRUE,      PLYR_ON_GND ; Init Player on Ground

    ; Initial Position for Enemy
    EOR.L   D1, D1                      - Ammended CLR
    MOVE.W  SCREEN_W,       D1          ; Place Screen width in D1
    MOVE.L  D1,             ENEMY_X     ; Enemy X Position

    EOR.L   D1,             D1          - Ammended CLR
    MOVE.W  SCREEN_H,       D1          ; Place Screen width in D1
    ;---------------------------
    ;Right shift?
    ;---------------------------
    DIVU    #02,            D1          ; divide by 2 for center on Y Axis
    MOVE.L  D1,             ENEMY_Y     ; Enemy Y Position
    
    ;Initialise Worm Pos
    EOR.L   D1,             D1
    MOVE.W  SCREEN_W,       D1
    ADD.L   #WRM_X_OFFSET,  D1          ;Shifts the worm to offset it from the enemy (horizontally)
    MOVE.L  D1,             WORM_X
    
    EOR.L   D1,             D1  
    MOVE.W  SCREEN_H,       D1
    DIVU    #02,            D1          ;Gets exactly half the screen
    ADD.L   #WRM_Y_OFFSET,  D1          ;Offset the y-pos of worm so they are initially hidden
    MOVE.L  D1,             WORM_Y


    ; Enable the screen back buffer(see easy 68k help)
	MOVE.B  #TC_DBL_BUF,    D0          ; 92 Enables Double Buffer
    MOVE.B  #17,            D1          ; Combine Tasks
	TRAP	#15                         ; Trap (Perform action)

    ; Clear the screen (see easy 68k help)
    MOVE.B  #TC_CURSR_P,    D0          ; Set Cursor Position
	MOVE.W  #$FF00,         D1          ; Fill Screen Clear
	TRAP	#15                         ; Trap (Perform action)
	

    

*-----------------------------------------------------------
* Subroutine    : Game
* Description   : Game including main GameLoop. GameLoop is like
* a while loop in that it runs forever until interupted
* (Input, Update, Draw). The Enemies Run at Player Jump to Avoid
*-----------------------------------------------------------
GAME:
    BSR                     PLAY_RUN                ; Play Run Wav
GAMELOOP:
    ; Main Gameloop
    BSR     DELTA                       ; Delay before next frame
    BSR     INPUT                       ; Check Keyboard Input
    BSR     UPDATE                      ; Update positions and points
    BSR     IS_PLAYER_ON_GND            ; Check if player is on ground
    BSR     CHECK_COLLISIONS            ; Check for Collisions
    BSR     DRAW                        ; Draw the Scene
    BSR     GAMELOOP                    ; ...we go again
*-----------------------------------------------------------
* Subroutine    : DELTA and DELAY
* Description   : DELTA; establishes a timer
*Delay, iterates through timer and decrements each pass until 0
*-----------------------------------------------------------
DELTA:
    MOVE.L  #DELTA_AMT,     D0          ;Move 600 into D0, to begin loop for delay
DELAY:
    SUB.L   #1,             D0          ;Decrement by one, then compare
    BNE     DELAY                       ;If Z  = 0, continue with loop

*-----------------------------------------------------------
* Subroutine    : Input
* Description   : Process Keyboard Input
*-----------------------------------------------------------
INPUT:
    ; Process Input
    EOR.L   D1,             D1          ; Clear Data Register via an XOR operation
    MOVE.B  #TC_KEYCODE,    D0          ; Listen for Keys
    TRAP    #15                         ; Trap (Perform action)
    MOVE.B  D1,             D2          ; Move last key D1 to D2
    CMP.B   #00,            D2          ; Key is pressed (ie, if the value in D2 is 00, no key was pressed) 
    BEQ     PROCESS_INPUT               ; Process Key
    TRAP    #15                         ; Trap for Last Key 
    ; Check if key still pressed
    CMP.B   #$FF,           D1          ; Is it still pressed
    BEQ     PROCESS_INPUT               ; Process Last Key
    RTS                                 ; Return to subroutine

*-----------------------------------------------------------
* Subroutine    : Process Input
* Description   : Branch based on keys pressed
*-----------------------------------------------------------
PROCESS_INPUT:
    MOVE.L  D2,         CURRENT_KEY     ; Put Current Key in Memory
    CMP.L   #ESCAPE,    CURRENT_KEY     ; Is Current Key Escape
    BEQ     EXIT                        ; Exit if Escape
    CMP.L   #P,         CURRENT_KEY
    BEQ     PAUSE
    CMP.L   #SPACEBAR,  CURRENT_KEY     ; Is Current Key Spacebar
    BEQ     JUMP                        ; Jump
    BRA     IDLE                        ; Otherwise, we just runnin'
    RTS                                 ; Return to subroutine
    
    
*-----------------------------------------------------------
* Subroutine    : Pause
* Description   : Pauses game aand resumes upon keypress
*----------------------------------------------------------- 
PAUSE:
    ; Repaint Screen
    MOVE.B  #TC_BCK_SCRN,   D0
    TRAP    #15

    ; Clear the screen
    MOVE.B	#TC_CURSR_P,    D0          ; Set Cursor Position
	MOVE.W	#$FF00,         D1          ; Clear contents
	TRAP    #15                         ; Trap (Perform action)

    MOVE.B  #TC_CURSR_P,    D0          ; Set Cursor Position
    MOVE.W  #$2510,         D1          ; Col 25, Row 10 (Roughly center)
    TRAP    #15                         ; Trap (Perform action)
    
    LEA     PAUSED_MSG,     A1
    MOVE    #14,            D0          ; Print msg w/o newline
    TRAP    #15
    
    
    
    MOVE.B  #TC_CURSR_P,    D0          ; Set Cursor Position
    MOVE.W  #$7020,         D1          ; Set cursor so it's not viewable
    TRAP    #15                         ; Trap (Perform action)
    
*-----------------------------------------------------------------
*A FAUX PA(U)S(E)
*----------------------------------------------------------------
    MOVE    #05,            D0          ; Take input
    TRAP    #15
    
    RTS
    
*-----------------------------------------------------------
* Subroutine    : Update
* Description   : Main update loop update Player and Enemies                
*-----------------------------------------------------------
UPDATE: 
    BSR     CHECK_POINTS                ; Check for if player has unlocked new mode
    
    ; Update the Players Positon based on Velocity and Gravity
    EOR.L   D1,             D1          - Ammended CLR
    MOVE.L  PLYR_VELOCITY,  D1          ; Fetch Player Velocity
    MOVE.L  PLYR_GRAVITY,   D2          ; Fetch Player Gravity
    ADD.L   #01,            D2          ; Add 1 onto gravity so the block has a downforce
    ADD.L   D2,             D1          ; Add Gravity to Velocity
    MOVE.L  D1,             PLYR_VELOCITY ; Update Player Velocity
    ADD.L   PLAYER_Y,       D1          ; Add Velocity to Player
    MOVE.L  D1,             PLAYER_Y    ; Update Players Y Position
 
  
    ; Move the Enemy
    EOR.L   D1,             D1          - Ammended CLR
    EOR.L   D0,             D0          - Ammended CLR for D0 (Note, previous code cleared D1 register)
    MOVE.L  ENEMY_X,        D1          ; Move the Enemy X Position to D0
    CMP.L   #00,            D1
    BLE     RESET_ENEMY_POSITION        ; Reset Enemy if off Screen

    
    ;Move Worm
    EOR.L   D1,             D1
    EOR.L   D0,             D0
    MOVE.L  WORM_X,         D1
    CMP.L   #00,            D1      
    BLE     RESET_WORM_POSITION        ; If the worm position gets to 0, redraw and move again

    BRA     MOVE_ENTITY                 ; Move ALL entities

    RTS                                 ; Return to subroutine  
*-----------------------------------------------------------
* Subroutine    : Check Points
* Description   : when player hits 500 points, spawn worms
* and begin a hardmode                
*-----------------------------------------------------------
CHECK_POINTS:
    MOVE.L  PLAYER_SCORE,   D1
    CMP.L   #NEW_MODE,      D1          ; When player reaches x points, new mode unlocks
    BGE     SPAWN_WORM             
    RTS
SPAWN_WORM:
    EOR.L   D1,             D1  
    MOVE.W  SCREEN_H,       D1
    DIVU    #02,            D1          ;Gets exactly half the screen
    MOVE.L  D1,             WORM_Y      ;Worms have risen from the soil!
    
    CMP.B   #00,        HARD_MODE       ;...unfortunately so to does hard_mode begin
    BEQ     ACTIVATE_HARD_MODE
    RTS
ACTIVATE_HARD_MODE:
    BSR     PLAY_THUNDER
    ADD.B   #01,        HARD_MODE       ;Set hardmode to true
    RTS
    
*-----------------------------------------------------------
* Subroutine    : Move Entity
* Description   : Move Entities Right to Left
* Note, the speed of the entities may be modified depending on
* the delta value, for example on my PC delta 6000 = perfect
* speed. On my 2012 macbook running Mint however... 500 is questionable
* Moral of the story, CPU and clock cycles matter greatly
*-----------------------------------------------------------
MOVE_ENTITY:
    SUB.L   #ENTITY_SPD,        ENEMY_X     ; Move enemy by X Value
    SUB.L   #ENTITY_SPD,        WORM_X
    RTS

*-----------------------------------------------------------
* Subroutine    : Reset Enemy
* Description   : Reset Enemy if to passes 0 to Right of Screen
*-----------------------------------------------------------
RESET_ENEMY_POSITION:
    EOR.L   D1, D1                          - Ammended CLR
    MOVE.W  SCREEN_W,       D1              ; Place Screen width in D1
    MOVE.L  D1,         ENEMY_X             ; Enemy X Position
    RTS
*-----------------------------------------------------------
* Subroutine    : Reset Worm
* Description   : Reset Worm if it passes 0 to Right of Screen
*-----------------------------------------------------------
RESET_WORM_POSITION:
    EOR.L   D1, D1
    MOVE.W  SCREEN_W,       D1  
    MOVE.L  D1,         WORM_X
    RTS
*-----------------------------------------------------------
* Subroutine    : Draw
* Description   : Draw Screen
*-----------------------------------------------------------
DRAW: 
    ; Repaint Screen
    MOVE.B  #TC_BCK_SCRN,   D0
    TRAP    #15

    ; Clear the screen
    MOVE.B	#TC_CURSR_P,    D0              ; Set Cursor Position
	MOVE.W	#$FF00,         D1              ; Clear contents
	TRAP    #15                             ; Trap (Perform action)
    BSR     DRAW_PLATFORM
    BSR     DRAW_PLYR_DATA                  ; Draw Draw Score, HUD, Player X and Y
    BSR     DRAW_PLAYER                     ; Draw Player
    BSR     DRAW_WORM                       ; Draw Worm
    BSR     DRAW_ENEMY                      ; Draw Enemy
    BSR     CHECK_HARD_MODE                 ; Check if hard mode flag is true
    BEQ     BEGIN_HARD_MODE                 ; If true, begin new mode 

    RTS                                     ; Return to subroutine
*-----------------------------------------------------------
* Subroutine    : Draw Hard Mode
* Description   : Draw Message displaying harad mode is  acative
*-----------------------------------------------------------
BEGIN_HARD_MODE:
    BSR     DRAW_RAIN
    BSR     CHECK_HARD_MODE

DRAW_HARD_MODE:
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$0f08,         D1              ; Col 25, Row 08 (Roughly center)
    TRAP    #15                             ; Trap (Perform action)
    
    LEA     HARDMODE_MSG,   A1
    MOVE    #14,            D0              ; Print msg w/o newline
    TRAP    #15
    
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$0709,         D1              ; Col 25, Row 08 (Roughly center)
    TRAP    #15                             ; Trap (Perform action)
    
    LEA     HARDMODE_MSG2,  A1
    MOVE    #14,            D0
    TRAP    #15
    
    MOVE.L  #RED,           D1              ; Set Font color
    MOVE.B  #21,            D0              ; Task for Font Color
    TRAP    #15                             ; Trap (Perform action)
    
    MOVE.B  #TC_CURSR_P,    D0
    MOVE.W  #$4409,         D1
    TRAP    #15
    
    LEA     SPICY_MSG,      A1
    MOVE    #14,            D0
    TRAP    #15
    
    MOVE.L  #WHITE,         D1              ; Set Font color
    MOVE.B  #21,            D0              ; Task for Font Color
    TRAP    #15                             ; Trap (Perform action)
    
CHECK_HARD_MODE:
    MOVE.B  HARD_MODE,      D1             
    CMP.B   #01,            D1    
    RTS

*-----------------------------------------------------------
* Subroutine    : Draw Player Data
* Description   : Draw Player X, Y, Velocity, Gravity and OnGround
*-----------------------------------------------------------
DRAW_PLYR_DATA:
    EOR.L   D1,             D1              - Ammended CLR
    
    ; Player Health Message
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$0200,         D1              ; Col 02, Row 00 (Top row)
    TRAP    #15                             ; Trap (Perform action)
    LEA     HEALTH_MSG,     A1              ; Health Message
    MOVE    #13,            D0              ; No Line feed
    TRAP    #15                             ; Trap (Perform action)

    ; Player Health Value
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$0900,         D1              ; Col 09, Row 01
    TRAP    #15                             ; Trap (Perform action)
    MOVE.B  #03,            D0              ; Display number at D1.L
    MOVE.L  PLAYER_HEALTH,  D1              ; Move Health to D1.L
    TRAP    #15                             ; Trap (Perform action)
    
    ; Player Score Message
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$0201,         D1              ; Col 02, Row 01
    TRAP    #15                             ; Trap (Perform action)
    LEA     SCORE_MSG,      A1              ; Score Message
    MOVE    #13,            D0              ; No Line feed
    TRAP    #15                             ; Trap (Perform action)

    ; Player Score Value
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$1001,         D1              ; Col 10, Row 01
    TRAP    #15                             ; Trap (Perform action)
    MOVE.B  #03,            D0              ; Display number at D1.L
    MOVE.L  PLAYER_SCORE,   D1              ; Move Score to D1.L
    TRAP    #15                             ; Trap (Perform action)
    
    ; CM message
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$1401,         D1              ; Col 14, Row 01
    TRAP    #15                             ; Trap (Perform action)
    LEA     CM_MSG,         A1              ; Score Message
    MOVE    #13,            D0              ; No Line feed
    TRAP    #15                             ; Trap (Perform action)
        
    ; Show Keys Pressed
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$2001,         D1              ; Col 20, Row 1
    TRAP    #15                             ; Trap (Perform action)
    LEA     KEYCODE_MSG,    A1              ; Keycode
    MOVE    #13,            D0              ; No Line feed
    TRAP    #15                             ; Trap (Perform action)

    ; Show KeyCode
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$3001,         D1              ; Col 30, Row 1
    TRAP    #15                             ; Trap (Perform action)    
    MOVE.L  CURRENT_KEY,    D1              ; Move Key Pressed to D1
    MOVE.B  #03,            D0              ; Display the contents of D1
    TRAP    #15                             ; Trap (Perform action)

    
*-----------------------------------------------------------
* Subroutine    : Player is on Ground
* Description   : Check if the Player is on or off Ground
*-----------------------------------------------------------
IS_PLAYER_ON_GND:
    ; Check if Player is on Ground
    EOR.L   D1,             D1               - Ammended CLR
    EOR.L   D2,             D2               - Ammended CLR
    MOVE.W  SCREEN_H,       D1              ; Place Screen width in D1
    ;---------------------------
    ;Right shift
    ;--------------------------    
    DIVU    #02,            D1              ; divide by 2 for center on Y Axisxis
    MOVE.L  PLAYER_Y,       D2              ; Player Y Position
    CMP     D1,             D2              ; Compare middle of Screen with Players Y Position 
    BGE     SET_ON_GROUND                   ; The Player is on the Ground Plane
    BLT     SET_OFF_GROUND                  ; The Player is off the Ground
    RTS                                     ; Return to subroutine


*-----------------------------------------------------------
* Subroutine    : On Ground
* Description   : Set the Player On Ground
*-----------------------------------------------------------
SET_ON_GROUND:
    EOR.L   D1,             D1              - Ammended CLR 
    MOVE.W  SCREEN_H,       D1              ; Place Screen width in D1
    ;---------------------------
    ;Right shift?
    ;---------------------------
    DIVU    #02,            D1              ; divide by 2 for center on Y Axis
    MOVE.L  D1,         PLAYER_Y            ; Reset the Player Y Position
    EOR.L   D1,             D1              - Ammended CLR  
    MOVE.L  #00,            D1              ; Player Velocity
    MOVE.L  D1,         PLYR_VELOCITY       ; Set Player Velocity
    MOVE.L  #GND_TRUE,  PLYR_ON_GND         ; Player is on Ground
    RTS

*-----------------------------------------------------------
* Subroutine    : Off Ground
* Description   : Set the Player Off Ground
*-----------------------------------------------------------
SET_OFF_GROUND:
    MOVE.L  #GND_FALSE, PLYR_ON_GND         ; Player if off Ground
    RTS                                     ; Return to subroutine
*-----------------------------------------------------------
* Subroutine    : Jump
* Description   : Perform a Jump
*-----------------------------------------------------------
JUMP:
    CMP.L   #GND_TRUE,PLYR_ON_GND           ; Player is on the Ground ?
    BEQ     PERFORM_JUMP                    ; Do Jump
    BRA     JUMP_DONE               
PERFORM_JUMP:
    BSR     PLAY_JUMP                       ; Play jump sound
    MOVE.L  #PLYR_JUMP_V,PLYR_VELOCITY      ; Set the players velocity to true
    RTS                                     ; Return to subroutine
JUMP_DONE:
    RTS                                     ; Return to subroutine
    
*-----------------------------------------------------------
* Subroutine    : Damage
* Description   : Deduct damage from player
;Struggled for a while with defining my own ENMY_DMG 
;Constant and getting it to work on the health, when I moved
;it to D2 like MOVE.L   ENMY_DMG, D2, D2 was FFFFF and health
;was incremented UP by 1 each time... Until I browsed this
;starter more for hints. I noticed how #POINTS increments
;the score. So, I needed to define that it was the LITERAL
;value in ENMY_DMG to subtract.
*----------------------------------------------------------- 
DAMAGE:
    EOR.L   D1,             D1              ;Clear contents of D1
    MOVE.L  PLAYER_HEALTH,  D1              ;Move players health into D1 for an arithmetic operation
    SUB.L   #ENMY_DMG,      D1              ;Subtract the constant ENMY_DMG from D1
    CMP.L   #00,            D1              ;Check if the player has ran out of health
    BLE     GAME_OVER                       ;If so, end game
    MOVE.L  D1,     PLAYER_HEALTH           ;Move the new health value to PLAYER_HEALTH
    BRA     RESET_ENEMY_POSITION           

    RTS                                     ;Else if, return to sender
    
DAMAGE_WORM:
    EOR.L   D1,             D1              ;Clear contents of D1
    MOVE.L  PLAYER_HEALTH,  D1              ;Move players health into D1 for an arithmetic operation
    SUB.L   #05,            D1              ;Subtract the constant ENMY_DMG from D1
    CMP.L   #00,            D1              ;Check if the player has ran out of health
    BLE     GAME_OVER                       ;If so, end game
    MOVE.L  D1,     PLAYER_HEALTH           ;Move the new health value to PLAYER_HEALTH       

    RTS                                     ;Else if, return to sender
*-----------------------------------------------------------
* Subroutine    : Game Over
* Description   : Ends game
*----------------------------------------------------------- 
GAME_OVER:
    ; Repaint Screen
    MOVE.B  #TC_BCK_SCRN,   D0
    TRAP    #15

    ; Clear the screen
    MOVE.B	#TC_CURSR_P,    D0              ; Set Cursor Position
	MOVE.W	#$FF00,         D1              ; Clear contents
	TRAP    #15                             ; Trap (Perform action)

    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$1809,         D1              ; Col 18, Row 09 (Roughly center)
    TRAP    #15                             ; Trap (Perform action)
    
    LEA     GAMEOVER_MSG,   A1
    MOVE    #13,            D0
    TRAP    #15
    
    MOVE    #05,            D0 
    TRAP    #15

    ; Player Score Message
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$1810,         D1              ; Col 02, Row 01
    TRAP    #15                             ; Trap (Perform action)
    LEA     SCORE_MSG,      A1              ; Score Message
    MOVE    #13,            D0              ; No Line feed
    TRAP    #15                             ; Trap (Perform action)

    ; Player Score Value
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$4010,         D1              ; Col 09, Row 01
    TRAP    #15                             ; Trap (Perform action)
    MOVE.B  #03,            D0              ; Display number at D1.L
    MOVE.L  PLAYER_SCORE,   D1              ; Move Score to D1.L
    TRAP    #15                             ; Trap (Perform action)

    SIMHALT
    
*-----------------------------------------------------------
* Subroutine    : Idle
* Description   : Perform an Idle sound effect (run!)
*----------------------------------------------------------- 
IDLE:
    BSR     PLAY_RUN                        ; Play Run Wav
    RTS                                     ; Return to subroutine

*-----------------------------------------------------------
* Subroutines   : Sound Load and Play
* Description   : Initialise game sounds into memory 
* Current Sounds are RUN, JUMP and Hit for Collision
*-----------------------------------------------------------
RUN_LOAD:
    LEA     RUN_WAV,        A1              ; Load Wav File into A1
    MOVE    #RUN_INDEX,     D1              ; Assign it INDEX
    MOVE    #71,            D0              ; Load into memory
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine

PLAY_RUN:
    MOVE    #RUN_INDEX,     D1              ; Load Sound INDEX
    MOVE    #72,            D0              ; Play Sound
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine

JUMP_LOAD:
    LEA     JUMP_WAV,       A1              ; Load Wav File into A1
    MOVE    #JMP_INDEX,     D1              ; Assign it INDEX
    MOVE    #71,            D0              ; Load into memory
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine

PLAY_JUMP:
    MOVE    #JMP_INDEX,     D1              ; Load Sound INDEX
    MOVE    #72,            D0              ; Play Sound
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine

HIT_LOAD:
    LEA     HIT_WAV,        A1              ; Load Wav File into A1
    MOVE    #HIT_INDEX,     D1              ; Assign it INDEX
    MOVE    #71,            D0              ; Load into memory
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine

PLAY_HIT:
    MOVE    #HIT_INDEX,     D1              ; Load Sound INDEX
    MOVE    #72,            D0              ; Play Sound
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine
    
WORM_LOAD:
    LEA     WORM_WAV,       A1              ; Load Wav File into A1
    MOVE    #WRM_INDEX,     D1              ; Assign it INDEX
    MOVE    #71,            D0              ; Load into memory
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine

PLAY_WORM:
    MOVE    #WRM_INDEX,     D1              ; Load Sound INDEX
    MOVE    #72,            D0              ; Play Sound
    TRAP    #15                             ; Trap (Perform action)
    RTS

BEGIN_LOAD:
    LEA     BEGIN_WAV,      A1              ; Load Wav File into A1
    MOVE    #BEGIN_INDEX,   D1              ; Assign it INDEX
    MOVE    #71,            D0              ; Load into memory
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine

PLAY_BEGIN:
    MOVE    #BEGIN_INDEX,   D1              ; Load Sound INDEX
    MOVE    #72,            D0              ; Play Sound
    TRAP    #15                             ; Trap (Perform action)
    RTS    

THUNDER_LOAD:
    LEA     THUNDER_WAV,      A1              ; Load Wav File into A1
    MOVE    #THNDR_INDEX,   D1              ; Assign it INDEX
    MOVE    #71,            D0              ; Load into memory
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine

PLAY_THUNDER:
    MOVE    #THNDR_INDEX,   D1              ; Load Sound INDEX
    MOVE    #72,            D0              ; Play Sound
    TRAP    #15                             ; Trap (Perform action)
    RTS        

*-----------------------------------------------------------
* Subroutine    : Draw Player
* Description   : Draw Player Square
*-----------------------------------------------------------
DRAW_PLAYER:
    ; Set Pixel Colors
    MOVE.L  #GREEN,         D1              ; Set Background color
    MOVE.B  #80,            D0              ; Task for Background Color
    TRAP    #15                             ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  PLAYER_X,       D1              ; X
    MOVE.L  PLAYER_Y,       D2              ; Y
    MOVE.L  PLAYER_X,       D3
    ADD.L   #PLYR_W_INIT,   D3              ; Width
    MOVE.L  PLAYER_Y,       D4 
    ADD.L   #PLYR_H_INIT,   D4              ; Height
    
    ; Draw Player
    MOVE.B  #87,            D0              ; Draw Player
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine

*-----------------------------------------------------------
* Subroutine    : Draw Enemy
* Description   : Draw Enemy Square
*-----------------------------------------------------------
DRAW_ENEMY:
    ; Set Pixel Colors
    MOVE.L  #RED,           D1              ; Set Background color
    MOVE.B  #80,            D0              ; Task for Background Color
    TRAP    #15                             ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  ENEMY_X,        D1              ; X
    MOVE.L  ENEMY_Y,        D2              ; Y
    MOVE.L  ENEMY_X,        D3
    ADD.L   #ENMY_W_INIT,   D3              ; Width
    MOVE.L  ENEMY_Y,        D4 
    ADD.L   #ENMY_H_INIT,   D4              ; Height
    
    ; Draw Enemy    
    MOVE.B  #87,            D0              ; Draw Enemy
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine
    
DRAW_WORM:
    ; Set Pixel Colors
    MOVE.L  #GOLD,          D1              ; Set Background color
    MOVE.B  #80,            D0              ; Task for Background Color
    TRAP    #15                             ; Trap (Perform action)

    ; Set X, Y, Width and Height
    MOVE.L  WORM_X,        D1               ; X
    MOVE.L  WORM_Y,        D2               ; Y
    MOVE.L  WORM_X,        D3
    ADD.L   #WRM_W_INIT,   D3               ; Width
    MOVE.L  WORM_Y,        D4 
    ADD.L   #WRM_H_INIT,   D4               ; Height
    
    ; Draw Worm    
    MOVE.B  #87,           D0               ; Draw Worm
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine
    
DRAW_PLATFORM:
    ; Set Pixel Colors
    MOVE.L  #WHITE,         D1              ; Set Background color
    MOVE.B  #80,            D0              ; Task for Background Color
    TRAP    #15                             ; Trap (Perform action)
   
    ;Platform is a rectangle, starting at (0, (screen_height / 2) + SPRITE HEIGHT) 
    ;ends at (screen width, (screen_h / 2) + SPRITE HEIGHT)
    MOVE.W  #00,            D1  ;X1
    MOVE.W  SCREEN_H,       D2  ;Y1
    DIVU    #02,            D2
    ADD.W   #PLYR_H_INIT,   D2
    
    MOVE.W  #SCREEN_W,      D3  ;X2
    MOVE.W  #SCREEN_H,      D4  ;Y2
    DIVU    #02,            D4
    ADD.W   #PLYR_H_INIT,   D4
    
    ; Draw Platform    
    MOVE.B  #87,            D0              ; Draw Platform
    TRAP    #15                             ; Trap (Perform action)
    RTS                                     ; Return to subroutine
    
DRAW_RAIN:
     ; Player Health Message
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$0202,         D1              ; Col 02, Row 02 (Top row)
    TRAP    #15                             ; Trap (Perform action)
    LEA     RAIN,           A1              ; Health Message
  
    MOVE    #13,            D0              ; No Line feed
    TRAP    #15                             ; Trap (Perform action)

    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$0204,         D1              ; Col 02, Row 04 (Top row)
    TRAP    #15                             ; Trap (Perform action)
    LEA     RAIN2,          A1              ; Health Message
  
    MOVE    #13,            D0              ; No Line feed
    TRAP    #15                             ; Trap (Perform action) 

    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$0206,         D1              ; Col 02, Row 06 (Top row)
    TRAP    #15                             ; Trap (Perform action)
    LEA     RAIN3,          A1              ; Health Message
  
    MOVE    #13,            D0              ; No Line feed
    TRAP    #15                             ; Trap (Perform action)

    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$0208,         D1              ; Col 02, Row 08 (Top row)
    TRAP    #15                             ; Trap (Perform action)
    LEA     RAIN2,          A1              ; Health Message
  
    MOVE    #13,            D0              ; No Line feed
    TRAP    #15                             ; Trap (Perform action)

     ; Player Health Message
    MOVE.B  #TC_CURSR_P,    D0              ; Set Cursor Position
    MOVE.W  #$0209,         D1              ; Col 02, Row 09 (Top row)
    TRAP    #15                             ; Trap (Perform action)
    LEA     RAIN,           A1              ; Health Message
  
    MOVE    #13,            D0              ; No Line feed
    TRAP    #15                             ; Trap (Perform action)
        
  
    RTS
*-----------------------------------------------------------
* Subroutine    : Collision Check
* Description   : Axis-Aligned Bounding Box Collision Detection
* Algorithm checks for overlap on the 4 sides of the Player and 
* Enemy rectangles
* PLAYER_X <= ENEMY_X + ENEMY_W &&
* PLAYER_X + PLAYER_W >= ENEMY_X &&
* PLAYER_Y <= ENEMY_Y + ENEMY_H &&
* PLAYER_H + PLAYER_Y >= ENEMY_Y
*-----------------------------------------------------------
CHECK_COLLISIONS:
    EOR.L   D1,             D1              ; Clear D1 via XOR
    EOR.L   D2,             D2              ; Clear D2 via XOR
PLAYER_X_LTE_TO_ENEMY_X_PLUS_W:
    MOVE.L  PLAYER_X,       D1              ; Move Player X to D1
    MOVE.L  ENEMY_X,        D2              ; Move Enemy X to D2
    ADD.L   ENMY_W_INIT,    D2              ; Set Enemy width X + Width
    CMP.L   D1,             D2              ; Do the Overlap ?
    BLE     PLAYER_X_PLUS_W_LTE_TO_ENEMY_X  ; Less than or Equal ?
    BRA     PLAYER_X_LTE_TO_WORM_X_PLUS_W   ; If not no collision, check if one with other entity
PLAYER_X_PLUS_W_LTE_TO_ENEMY_X:             ; Check player is not  
    ADD.L   PLYR_W_INIT,    D1              ; Move Player Width to D1
    MOVE.L  ENEMY_X,        D2              ; Move Enemy X to D2
    CMP.L   D1,             D2              ; Do they OverLap ?
    BGE     PLAYER_Y_LTE_TO_ENEMY_Y_PLUS_H  ; Less than or Equal
    BRA     PLAYER_X_LTE_TO_WORM_X_PLUS_W  ; If not no collision   
PLAYER_Y_LTE_TO_ENEMY_Y_PLUS_H:     
    MOVE.L  PLAYER_Y,       D1              ; Move Player Y to D1
    MOVE.L  ENEMY_Y,        D2              ; Move Enemy Y to D2
    ADD.L   ENMY_H_INIT,    D2              ; Set Enemy Height to D2
    CMP.L   D1,             D2              ; Do they Overlap ?
    BLE     PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y  ; Less than or Equal
    BRA     PLAYER_X_LTE_TO_WORM_X_PLUS_W  ; If not no collision 
PLAYER_Y_PLUS_H_LTE_TO_ENEMY_Y:             ; Less than or Equal ?
    ADD.L   PLYR_H_INIT,    D1              ; Add Player Height to D1
    MOVE.L  ENEMY_Y,        D2              ; Move Enemy Height to D2  
    CMP.L   D1,             D2              ; Do they OverLap ?
    BGE     COLLISION                       ; Collision !
    BRA     PLAYER_X_LTE_TO_WORM_X_PLUS_W  ; If not no collision
    
PLAYER_X_LTE_TO_WORM_X_PLUS_W:
    MOVE.L  PLAYER_X,       D1              ; Move Player X to D1
    MOVE.L  WORM_X,        D2              ; Move Worm X to D2
    ADD.L   WRM_W_INIT,    D2              ; Set Worm width X + Width
    CMP.L   D1,             D2              ; Do the Overlap ?
    BLE     PLAYER_X_PLUS_W_LTE_TO_WORM_X  ; Less than or Equal ?
    BRA     COLLISION_CHECK_DONE            ; If not no collision
PLAYER_X_PLUS_W_LTE_TO_WORM_X:             ; Check player is not  
    ADD.L   PLYR_W_INIT,    D1              ; Move Player Width to D1
    MOVE.L  WORM_X,        D2              ; Move Worm X to D2
    CMP.L   D1,             D2              ; Do they OverLap ?
    BGE     PLAYER_Y_LTE_TO_WORM_Y_PLUS_H  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE            ; If not no collision   
PLAYER_Y_LTE_TO_WORM_Y_PLUS_H:     
    MOVE.L  PLAYER_Y,       D1              ; Move Player Y to D1
    MOVE.L  WORM_Y,        D2              ; Move Worm Y to D2
    ADD.L   WRM_H_INIT,    D2              ; Set Enemy Height to D2
    CMP.L   D1,             D2              ; Do they Overlap ?
    BLE     PLAYER_Y_PLUS_H_LTE_TO_WORM_Y  ; Less than or Equal
    BRA     COLLISION_CHECK_DONE            ; If not no collision 
PLAYER_Y_PLUS_H_LTE_TO_WORM_Y:             ; Less than or Equal ?
    ADD.L   PLYR_H_INIT,    D1              ; Add Player Height to D1
    MOVE.L  WORM_Y,        D2              ; Move Worm Height to D2  
    CMP.L   D1,             D2              ; Do they OverLap ?
    BGE     COLLISION_WORM                 ; Collision !
    BRA     COLLISION_CHECK_DONE            ; If not no collision
    
COLLISION_CHECK_DONE:                       ; No Collision Update points
    MOVE.L  ENEMY_X,        D1             
    MOVE.L  PLAYER_X,       D2
    CMP.L   D1,             D2              ; Has the player succesfully jumped PASSED the 
    BLE     END_COLLISION                   ; enemy? If not, end check
                                            ;If successfully got passed the enemy, increment score
    BRA     INCREMENT_POINTS

    BRA     END_COLLISION
    
INCREMENT_POINTS:
    ADD.L   #POINTS,    PLAYER_SCORE        ; Move points upgrade to D1   


    RTS
;Returns to the calling subroutine
END_COLLISION:
    RTS
*-----------------------------------------------------------
* Subroutine    : COLLISION
* Description   : Deals damage, resets enemy position and reset
* score
*-----------------------------------------------------------
COLLISION:
    BSR     PLAY_HIT                        ; Play Hit Wav
    BSR     DAMAGE                          ; Deduct damage from health
    MOVE.L  #00,        PLAYER_SCORE        ; Reset Player Score
    BRA     RESET_ENEMY_POSITION            ; Sets next Enemeies position back to 0, simulating a game restart for this life.
    
    RTS                                     ; Return to subroutine

COLLISION_WORM:
    BSR     PLAY_WORM                    ; Play Worm Wav
    BSR     DAMAGE_WORM
    ADD.L   #640,       PLAYER_SCORE        ; Add points to score
    BRA     RESET_WORM_POSITION            ; Sets next Enemeies position back to 0, simulating a game restart for this life.
    
    RTS      
*-----------------------------------------------------------
* Subroutine    : EXIT
* Description   : Exit message and End Game
*-----------------------------------------------------------
EXIT:
    ; Repaint Screen
    MOVE.B  #TC_BCK_SCRN,            D0
    TRAP    #15

    ; Clear the screen
    MOVE.B	#TC_CURSR_P,    D0      ; Set Cursor Position
	MOVE.W	#$FF00,         D1      ; Clear contents
	TRAP    #15                     ; Trap (Perform action)
	

    ; Show if Exiting is Running
    MOVE.B  #TC_CURSR_P,        D0          ; Set Cursor Position
    MOVE.W  #$4001,             D1          ; Col 40, Row 1
    TRAP    #15                             ; Trap (Perform action)
    LEA     EXIT_MSG,           A1          ; Exit
    MOVE    #13,                D0          ; No Line feed
    TRAP    #15                             ; Trap (Perform action)
   
 
    SIMHALT

*-----------------------------------------------------------
* Section       : Messages
* Description   : Messages to Print on Console, names should be
* self documenting
*-----------------------------------------------------------
SCORE_MSG       DC.B    'Distance : ', 0       ; Score Message
CM_MSG          DC.B    'cm',0
KEYCODE_MSG     DC.B    'KeyCode : ', 0     ; Keycode Message

HEALTH_MSG      DC.B    'HP:',0                     ; Health Message
WELCOME_MSG     DC.B    'Welcome to Bentos World',0 ; Welcome Message
WELCOME_1       DC.B    'You are ',0
WELCOME_2       DC.B    '<BENTO> ',0
WELCOME_3       DC.B    ' ruler of the great Frog Kingdom!',0
WELCOME_4       DC.B    'Your beloved ',0 
WELCOME_5       DC.B    '<FROGETTE> ',0
WELCOME_6       DC.B    ' has been tangled in a swarm of jungle vine..',0
WELCOME_7       DC.B    '... You know your mission, Bento',0
WELCOME_8       DC.B    'Be careful, its late... and a storm is brewing, Lord Bento..',0
RAIN            DC.B    '/           .     /    /   .  ,    .          ,    .     /    /  ,  /   .   ',0
RAIN2           DC.B    '  /       .    ,     .      .          ,    .           .  .       , .   /  ',0
RAIN3           DC.B    '.   .  ,   /   /       /    .      /     ,   ,   .        .     /      ,     ',0  
CONTROLS_MSG    DC.B    'Press <ANY> key to continue. <SPACE> to Jump',0 ; Controls Message
PAUSED_MSG      DC.B    'PAUSED',0                                                      ; Paused Message
GAMEOVER_MSG    DC.B    'GAMEOVER',0                                                    ; Gameover Message
HARDMODE_MSG    DC.B    'Oh no! Acid rain has flooded worms to the top!!!',0            ; Hardmode Message
HARDMODE_MSG2   DC.B    'The worms might be useful... but the acid rain has made them ',0
SPICY_MSG       DC.B    's p i c y',0 

EXIT_MSG        DC.B    'Exiting....', 0    ; Exit Message

*-----------------------------------------------------------
* Section       : Graphic Colors
* Description   : Screen Pixel Color
*-----------------------------------------------------------
GREEN           EQU     $002DBD17
RED             EQU     $000000FF
GOLD            EQU     $0000FFFF
WHITE           EQU     $00FFFFFF
FUCHSIA         EQU     $00FF00FF 

*-----------------------------------------------------------
* Section       : Screen Size
* Description   : Screen Width and Height
*-----------------------------------------------------------
SCREEN_W        DS.W    01  ; Reserve Space for Screen Width
SCREEN_H        DS.W    01  ; Reserve Space for Screen Height

*-----------------------------------------------------------
* Section       : Keyboard Input
* Description   : Used for storing Keypresses
*-----------------------------------------------------------
CURRENT_KEY     DS.L    01  ; Reserve Space for Current Key Pressed

*-----------------------------------------------------------
* Section       : Character Positions
* Description   : Player and Enemy Position Memory Locations
*-----------------------------------------------------------
PLAYER_X        DS.L    01  ; Reserve Space for Player X Position
PLAYER_Y        DS.L    01  ; Reserve Space for Player Y Position
PLAYER_SCORE    DS.L    01  ; Reserve Space for Player Score
PLAYER_HEALTH   DS.L    01  ; Reserve Space for Player Health
PLYR_VELOCITY   DS.L    01  ; Reserve Space for Player Velocity
PLYR_GRAVITY    DS.L    01  ; Reserve Space for Player Gravity
PLYR_ON_GND     DS.L    01  ; Reserve Space for Player on Ground
   
ENEMY_X         DS.L    01  ; Reserve Space for Enemy X Position
ENEMY_Y         DS.L    01  ; Reserve Space for Enemy Y Position

WORM_X          DS.L    01  ; Reserve Space for Worm X Pos
WORM_Y          DS.L    01  ; Reserve Space for Worm Y Pos
HARD_MODE       DS.B    01  ; Reserve Space for Hard_Mode flag
*-----------------------------------------------------------
* Section       : Sounds
* Description   : Sound files, which are then loaded and given
* an address in memory, they take a longtime to process and play
* so keep the files small. Used https://voicemaker.in/ to 
* generate and Audacity to convert MP3 to WAV
*-----------------------------------------------------------
JUMP_WAV        DC.B    'sounds/jump.wav',0        ; Jump Sound
RUN_WAV         DC.B    'sounds/run.wav',0         ; Run Sound
HIT_WAV         DC.B    'sounds/hit.wav',0         ; Collision Hit
WORM_WAV        DC.B    'sounds/worm.wav',0         ; Worm Hit
BEGIN_WAV       DC.B    'sounds/begin.wav',0       ; Begin sound
THUNDER_WAV     DC.B    'sounds/thunder.wav',0


    END    START                            ; last line of source
























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
