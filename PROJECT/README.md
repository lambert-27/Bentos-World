# Small World Game StarterKit #

A starter kit for building "Small World" themed games using Easy68K assembly for [Games Fleadh 2025](https://gamesfleadh.ie/).

### Theme Overview ###

Create a game that explores the concept of a "Small World" where:
* Interconnected micro-environments or miniature worlds
* Focus on small-scale interactions and consequences
* Potential for games about microscopic worlds, tiny civilizations, or interconnected mini-ecosystems

### Getting Started ###

* Install Easy68K on your PC
* Download this StarterKit
* Use the example code below to start building your small world game
* Consider mechanics that fit the theme (e.g., scaling between micro/macro views, managing tiny populations)

### Example Code ###

* Basic Program Structure (Memory location $1000)
```assembly
* MEMORY START POSITION OF ASM PROG $1000
    ORG    $1000             ; Set the starting address of the program to $1000
START:
* CODE GOES HERE
    SIMHALT                  ; Halt the program (for simulation purposes)
* DATA HERE
    END    START             ; Mark the end of the program
```

* Hello Small World Example
```assembly
    ORG    $1000             ; Set the starting address of the program to $1000
START:
    LEA MESSAGE, A1          ; Load the address of the message into register A1
    MOVE.B #14, D0           ; Load the message length (14 characters) into D0
    TRAP #15                 ; Call the system to display the message

    SIMHALT                  ; Halt the program (for simulation purposes)

MESSAGE DC.B 'Welcome to the Small World', 0  ; Store the message as a null-terminated string

    END    START             ; Mark the end of the program
```

* Memory Operations Example
```assembly
    ORG    $1000             ; Set the starting address of the program to $1000
START:
    MOVE    #5, D0           ; Move the value 5 into data register D0
    MOVE    D0, $3000        ; Move the value in D0 to memory location $3000
    MOVE    D0, 3000         ; Move the value in D0 to memory location 3000 (hex format)
    
    MOVE.B  #3, 100          ; Move the value 3 into memory location 100 (hex format)
    MOVE.B  100, D1          ; Move the value from memory location 100 into D1
    
    MOVE.B  #100, D1         ; Initialize Health at 100 in D1
    MOVE.B  D1, $4050        ; Store Health value at memory location 4050

    SIMHALT                  ; Halt the program (for simulation purposes)
    END    START             ; Mark the end of the program
```

* Branching Code Example
```assembly
    ORG    $1000             ; Set the starting address of the program to $1000
START:
    MOVE.B #3, D0           ; Move the value 3 into register D0
NEXT:    
    MOVE.B  #3, D2           ; Move the value 3 into register D2
    CMP #3, D2               ; Compare the values in D2 and D0
    BNE EXIT                 ; Branch to EXIT if D2 is not equal to D0
    MOVE.B #4, D3            ; Move the value 4 into register D3
    SUB #1, D0               ; Subtract 1 from D0
    BNE NEXT                 ; If D0 is not zero, continue looping at NEXT
    
    BRA MICRO_WORLD          ; Jump to MICRO_WORLD section

MACRO_WORLD:
    MOVE.W  #2000, D1        ; Move the value 2000 to D1 (indicating a macro world)
    BRA START                ; Jump back to the START section

MICRO_WORLD:
    MOVE.W  #10, D1          ; Move the value 10 to D1 (indicating a micro world)
    BRA MACRO_WORLD          ; Jump to MACRO_WORLD section
    
EXIT:
    SIMHALT                  ; Halt the program (for simulation purposes)
    END    START             ; Mark the end of the program
```

* Simple Game Loop
```assembly
    ORG    $1000             ; Set the starting address of the program to $1000
START:
    MOVE.B      #1, $2000    ; Initialize the game state to 1 (for example, player alive)
    MOVE.B      $2000, D1    ; Move the game state value into D1
    CMP         #1, D1       ; Compare the game state with 1 (player alive)
    BNE         END_GAME     ; If not equal, jump to END_GAME
    BSR         GAME_LOOP    ; Call the game loop subroutine
    
GAME_LOOP:
    BSR INPUT                ; Call the input handling subroutine
    BSR UPDATE               ; Call the update subroutine (game logic)
    BSR DRAW                 ; Call the drawing subroutine (rendering)
    BRA GAME_LOOP            ; Repeat the game loop

INPUT:
    MOVE        #4, D0       ; Load input data into D0 (e.g., read input)
    TRAP        #15          ; Call system trap to process the input
    MOVE.B      D1, $2000    ; Store the processed input into game state memory
    RTS                      ; Return from subroutine

UPDATE:
    MOVE.B      $2000, D1    ; Load the game state value into D1
    CMP         #1, D1       ; Compare game state to check if player is alive
    BNE END_GAME             ; If not equal, jump to end of game
    RTS                      ; Return from subroutine

DRAW:
    RTS                      ; Return from subroutine (for now, no drawing implemented)

END_GAME:
    LEA         MESSAGE, A1  ; Load address of end game message
    MOVE.B      #14, D0      ; Set the message length (14 characters)
    TRAP        #15          ; Call system trap to display the message

    SIMHALT                  ; Halt the program (for simulation purposes)

MESSAGE DC.B    'Thanks for exploring our Small World!', 0  ; End game message

    END    START             ; Mark the end of the program
```

* Resource Management Loop Example (e.g., for managing micro-ecosystems)
```assembly
    ORG    $1000             ; Set the starting address of the program to $1000
START: 
    LEA MESSAGE, A1          ; Load the message address into A1
    MOVE.W #500, $2000       ; Store initial resource levels in memory location $2000
    MOVE.B #3, D0            ; Set the number of ecosystem cycles to 3
    
NEXT:
    SUB #1, D0               ; Decrease cycle counter by 1
    ADD.B #1, D1             ; Add 1 to resources (D1)
    
    MOVE.B D0, D2            ; Store current cycle count in D2 temporarily
    
    CMP #2, D1               ; Compare resources with threshold value 2
    BSR BALANCE_ECOSYSTEM    ; If threshold reached, balance ecosystem
    
    MOVE.B #14, D0
    TRAP    #15              ; Display message (ecosystem cycle in progress)
    
    MOVE.B D2, D0            ; Restore cycle counter
    
    CMP #0, D0               ; Check if all cycles are complete
    BNE NEXT                 ; If not, continue to the next cycle

BALANCE_ECOSYSTEM:
    SUB.W #10, $2000         ; Adjust ecosystem resources (example action)
    RTS                      ; Return from subroutine

    SIMHALT                  ; Halt the program (for simulation purposes)  

MESSAGE DC.B    'Ecosystem Cycle Complete', 0   ; Resource management message

    END    START             ; Mark the end of the program
```

* Random Number Generator (useful for environmental variations)
```assembly
    ORG    $1000            ; Set program starting location in memory to $1000

START:    
    BSR RANDOM_NUMBER       ; Branch to subroutine RANDOM_NUMBER to generate a random number

    MOVE.B #3, D0           ; Load immediate value 3 into Data Register D0 (for function call or message display)
    TRAP #15                ; Trap to BIOS service to perform an operation (like displaying output or handling the system)

    BRA END_PROG            ; Branch to END_PROG to finish execution of the program

RANDOM_NUMBER:             
    MOVE.B #8, D0           ; Load immediate value 8 into Data Register D0 (for system call code related to random number generation)
    TRAP #15                ; Trap to BIOS service (generating random number or handling internal system functions)

    AND.L #$5FFFFF, D1      ; Perform a bitwise AND with D1 and the mask $5FFFFF to limit the randomness to a specific range
    DIVU #100, D1           ; Divide unsigned value in D1 by 100, result goes into D1 (this reduces the range of the random value)
    
    SWAP D1                 ; Swap the high and low parts of D1 (to manipulate the number format)

    ADDQ.W #1, D1           ; Add 1 to the value in D1 (to adjust the final result)

    MOVE.W D1, D2           ; Move the value in D1 to D2 to preserve it for later use

    CLR.L D1                ; Clear D1 register to prepare for further operations

    MOVE.W D2, D1           ; Restore the value in D2 back into D1

    RTS                      ; Return from subroutine, control passes back to the calling code

END_PROG:                    
    SIMHALT                 ; Halt the simulation (end program execution)

    END    START            ; Mark the end of the program and indicate where the program starts
```

* String Input Example (for naming worlds/creatures)
```assembly
    ORG    $1000           ; Set program starting location in memory to $1000

START:  
    MOVE.B  #2, D0         ; Load immediate value 2 into Data Register D0 (used as function code for input)
    
string:
    LEA $3000, A1          ; Load effective address of memory location $3000 (where input string will be stored) into Address Register A1
    TRAP #15               ; Trap to BIOS input service to read a string from the user

    MOVE.L D1, D2          ; Move the value in Data Register D1 (return address from TRAP) to D2 for later use

    LEA $3000, A1          ; Reload effective address of memory location $3000 into Address Register A1
    MOVE.B #14, D0         ; Load immediate value 14 into Data Register D0 (function code for outputting text)
    TRAP #15               ; Trap to BIOS service to display a string (CRLF or "end of line")

    MOVE.L  D2, D1         ; Restore the value of D2 (the address returned by the input) back to D1
    MOVE.B   #3, D0        ; Load immediate value 3 into Data Register D0 (function code to end process)
    TRAP #15               ; Trap to BIOS service to print a message or handle further output
        
    SIMHALT                ; Halt the simulation (end program execution)

CRLF DC.B $0D, $0A        ; Define the CRLF (Carriage Return + Line Feed) sequence for text formatting
    END    START           ; Mark the end of the program and indicate where the program starts  
```

* Memory Traversal Operations
```assembly
    ORG    $1000
START:
    MOVE.B #1, $3000      ; Initialize first micro-world
    MOVE.B #2, $3001      ; Initialize second micro-world
    MOVE.B #3, $3002      ; Initialize third micro-world
    
    LEA $3000, A2
    
    MOVE.B (A2)+, D2      ; Move to next world
    MOVE.B (A2)+, D2      ; Move to next world
    MOVE.B (A2)+, D2      ; Move to next world
    
    SIMHALT         
    END    START 
```

### Games Fleadh 2025 Participation ###

To be eligible for [Games Fleadh 2025](https://gamesfleadh.ie/):

- Games must incorporate the "Small World" theme
- Projects should demonstrate creative interpretation of microscopic or miniature worlds
- Consider including elements like:

    - Scaling mechanics between different sized worlds
    - Interconnected mini-environments
    - Cause-and-effect relationships in small ecosystems
    - Management of tiny populations or resources


### Support ###

* For technical questions: philip.bourke@setu.ie
* For Games Fleadh queries: Check the official [Games Fleadh 2025](https://gamesfleadh.ie/) website

### Example Game Concepts ###

* Microscopic Explorer: Navigate through cellular environments
* Tiny Town Manager: Build and manage a miniature civilization
* Micro-Ecosystem Keeper: Balance a delicate small-scale environment
* Subatomic Puzzle: Solve challenges at the particle level
* Mini-World Connector: Link different microscopic realms


### Useful Resources ###

* Documentation
    - [Easy68K Official Documentation](http://www.easy68k.com/documentation.htm)
    - [68000 Instruction Set](http://www.easy68k.com/QuickStart/QuickStart.htm)
    - [Easy68K Quick Start Guide](http://www.easy68k.com/QuickStart/InsSet.htm)

* Development Tools
    - [Easy68K Download Page](http://www.easy68k.com/downloads.htm)
    - [Visual Studio Code](https://code.visualstudio.com/) - Recommended editor with 68k assembly extensions
    - [68k Assembly Extension for VSCode](https://marketplace.visualstudio.com/items?itemName=steventattersall.hla-68k-assembly)

* Learning Resources
    - [Motorola 68000 Programming Guide](https://www.nxp.com/docs/en/reference-manual/M68000PRM.pdf)
    - [Assembly Language Tutorial](https://www.tutorialspoint.com/assembly_programming/index.htm)

* Game Design Resources
    - [Games Fleadh Official Website](http://www.gamesfleadh.ie/)
    - [Pixel Art Tools](https://www.piskelapp.com/) - For creating game sprites
    - [Sound Effects Generator](https://sfxr.me/) - For creating game sounds
    - [Free Game Assets](https://itch.io/game-assets/free) - For prototyping

* Additional Tools
    - [Hex Editor](https://hexed.it/) - Online hex editor for binary files
    - [Number Base Converter](https://www.rapidtables.com/convert/number/index.html) - For converting between decimal, hex, and binary


Remember to maintain the assembly language principles while implementing your creative "Small World" concept and to check usage rights and licenses when using external resources in your game!