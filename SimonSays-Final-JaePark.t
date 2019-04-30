% Jae Park
% 2018-05-15
% Mr. Rosen
% This program is a Simon Says game that requires colour memory

import GUI

% Global Declaration Section
var levelCount : int := 1 % Counts the level
var timeShownCount : int := 1 % Factor for the delay as game progresses (shorter delay)
var colourShownCount : int := 0 % Counts the number of colours that must be received by userinput
var mouseX, mouseY, button : int := 0 % Mousewhere variables
var count : int := 1 % Count for window GUI commands in main menu
% Windows and buttons
var introWindow := Window.Open ("position:center;center,graphics:640;400")
var mainMenuWindow, goodbyeWindow : int := 0
var mainMenuButton, exitButton, instructionsButton, playButton : int := 0
% Answer array variable
var colourAnswer : array 1 .. 9 of int := init (0, 0, 0, 0, 0, 0, 0, 0, 0)

forward procedure mainMenu

% Introduction music
process music
    Music.PlayFileLoop ("mario theme song.mp3")
end music

% Program title
procedure title
    cls
    locate (1, 35)
    put "Simon Says"     % Actual title display
    put " "
end title

% Sets the new colour answer sequence for the 3 levels
procedure answerSequences
    for i : 1 .. 9
	randint (colourAnswer (i), 1, 4) % Sets all 10 array values as random from 1-4 for the four colours
    end for
end answerSequences

% Pauses program
procedure pauseProgram
    var reply : string (1)
    put " "
    locate (15, 25)
    put "Press any key to continue...." ..
    getch (reply)
end pauseProgram

% Instructions window- displays the rules for playing game
procedure instructions
    GUI.Hide (playButton)     % Hides all buttons
    GUI.Hide (exitButton)
    GUI.Hide (instructionsButton)
    title
    locate (3, 34) % Displays the instructions
    put "Instructions:"
    put " "
    locate (6, 5)
    put "Press Play to begin the game."
    locate (8, 5)
    put "This game is played by memorizing the sequence of colours that were flashed."
    locate (10, 5)
    put "AFTER seeing the sequence, you must repeat it by clicking on the correct"
    locate (11, 5)
    put "colour in order."
    locate (13, 5)
    put "There are no retries. Once you fail any level, you have lost the game."
    locate (15, 5)
    put "You win the game by beating the third level."
    locate (17, 5)
    put "The levels get progressively harder."
    locate (23, 35)
    put "Good luck!"
    mainMenuButton := GUI.CreateButton (265, 0, 0, "Main Menu", mainMenu) % Returning to main menu button
    View.Update % Updates screen
end instructions

% Goodbye procedure- goodbye message
procedure goodbye
    Window.Close (mainMenuWindow)
    goodbyeWindow := Window.Open ("position:centre;centre") % Opens goodbye window
    title
    locate (12, 30)
    put "Thanks for playing!"
    locate (13, 33)
    put "By: Jae Park"
    Music.PlayFile ("gameover.mp3")
    Music.PlayFileStop % Stops playing music
    pauseProgram
    GUI.Quit % Quits GUI
end goodbye

% --------------------------------------------------------------------------------<<Main Game>>--------------------------------------------------------------------------------
procedure level
    GUI.Hide (mainMenuButton)     % Hides all buttons
    GUI.Hide (playButton)         % Hides all buttons
    GUI.Hide (exitButton)         % Hides all buttons
    GUI.Hide (instructionsButton) % Hides all buttons
    title
    var indexCheck : int := 1 % Array index checking variable for determining if user input is correct
    var indexNumber : int := 1 % Checks the answer array to see what must be flashed
    var clickCount : int := 0 % Variable for counting number of clicks that the user has done on the wheel
    var correctClickCount : int := 0 % Counts the number of correct answers that the user has clicked
    levelCount := 1 % Resets level progress every time a new game is started
    answerSequences % Gets a random answer colour sequence by calling randomizing procedure
    timeShownCount := 1 % Resets the size of factor in delay time

    % Draws the initial colour wheel on screen
    for i : 0 .. 120
	%  (TOP RIGHT)
	drawoval (320, 200, i, i, 7)     % Black Border
	drawoval (321, 200, i, i, 7)     % Black Border
    end for
    for i : 0 .. 110
	drawarc (320, 200, i, i, 0, 90, 4)      % Red Part
	drawarc (321, 200, i, i, 0, 90, 4)      % Red Part
	drawarc (320, 200, i, i, 90, 180, 2)    % Green Part
	drawarc (321, 200, i, i, 90, 180, 2)    % Green Part
	drawarc (320, 200, i, i, 180, 270, 1)   % Blue Part
	drawarc (321, 200, i, i, 180, 270, 1)   % Blue Part
	drawarc (320, 200, i, i, 270, 0, 6)     % Yellow Part
	drawarc (321, 200, i, i, 270, 0, 6)     % Yellow Part
    end for
    for i : 0 .. 30
	% Centre
	drawoval (320, 200, i, i, 7)         % Black border
	drawoval (321, 200, i, i, 7)         % Black border
    end for
    for i : 0 .. 20
	% Centre
	drawoval (320, 200, i, i, 0)     % White centre
	drawoval (321, 200, i, i, 0)     % White centre
    end for
    View.Update

    % Countdown for game to start
    for decreasing i : 5 .. 1
	locate (2, 10)
	put "Game starting in .. ", i
	View.Update
	delay (1000)
    end for
    locate (2, 10) % Erases the countdown text
    put "" : 20
    View.Update

    loop  %  <<<<<<Main game loop>>>>>>
	colourShownCount := 0     % Resets the number of colours to show so that user has to input all previous colours from prev levels
	indexNumber := 1     % Checks what to flash in each term of flashing sequence- starts at 1 to display every term from the beginning every time
	indexCheck := 1     % Checks answer array in user inputed sequence (resets to 1 so it starts checking from beginning) in user input
	locate (3, 35)
	if levelCount >= 1 and levelCount < 4 then
	    locate (3, 35)
	    put "Level: ", levelCount     % Displays level if the game is in play
	    View.Update
	    delay (3000)
	    locate (3, 34)
	    put "" : 5, "GO!", "" : 5
	    View.Update
	    delay (200)
	end if
	% -----<START OF FLASHING SEQUENCE>-----
	loop
	    if colourAnswer (indexNumber) = 1 then     % Set 1 in array as red flash- checks if red
		% COLOUR FLASH
		drawfillarc (320, 200, 120, 120, 0, 90, 7)        % Black Border
		drawfillarc (320, 200, 110, 110, 0, 90, 12)       % Red Part 1
		drawfillarc (320, 201, 110, 110, 0, 90, 12)       % Red Part 2
		drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		drawfilloval (320, 200, 20, 20, 0)                % White centre
		View.Update
		delay (round (1500 / timeShownCount)) % Smaller delay as game progresses

		% FLASH COLOUR ERASE
		drawfillarc (320, 200, 120, 120, 0, 90, 7)        % Black Border
		drawfillarc (320, 200, 110, 110, 0, 90, 4)        % Red Part 1
		drawfillarc (320, 201, 110, 110, 0, 90, 4)        % Red Part 2
		drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		drawfilloval (320, 200, 20, 20, 0)                % White centre
		View.Update
		delay (200)

		colourShownCount := colourShownCount + 1     % Adds one to number of colours shown and needed for user input
		exit when colourShownCount = levelCount * 3  % Stops flashing when reaches designated amount of colours that need to be shown in level
	    elsif colourAnswer (indexNumber) = 2 then     % Set 2 in array as green flash- checks if green
		% COLOUR FLASH
		drawfillarc (320, 200, 120, 120, 90, 180, 7)      % Black Border
		drawfillarc (320, 200, 110, 110, 90, 180, 10)     % Green Part 1
		drawfillarc (320, 201, 110, 110, 90, 180, 10)     % Green Part 2
		drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		drawfilloval (320, 200, 20, 20, 0)                % White centre
		View.Update
		delay (round (1500 / timeShownCount)) % Smaller delay as game progresses

		% FLASH COLOUR ERASE
		drawfillarc (320, 200, 120, 120, 90, 180, 7)      % Black Border
		drawfillarc (320, 200, 110, 110, 90, 180, 2)      % Green Part 1
		drawfillarc (320, 201, 110, 110, 90, 180, 2)      % Green Part 2
		drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		drawfilloval (320, 200, 20, 20, 0)                % White centre
		View.Update
		delay (200)

		colourShownCount := colourShownCount + 1     % Adds one to number of colours shown and needed user input
		exit when colourShownCount = levelCount * 3  % Stops flashing when reaches designated amount of colours that need to be shown in level
	    elsif colourAnswer (indexNumber) = 3 then     % Set 3 in array as blue flash- checks if blue
		% FLASH COLOUR CHANGE
		drawfillarc (320, 200, 120, 120, 180, 270, 7)     % Black Border
		drawfillarc (320, 200, 110, 110, 180, 270, 11)    % Blue Part 1
		drawfillarc (320, 201, 110, 110, 180, 270, 11)    % Blue Part 2
		drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		drawfilloval (320, 200, 20, 20, 0)                % White centre
		View.Update
		delay (round (1500 / timeShownCount)) % Smaller delay as game progresses

		% FLASH COLOUR ERASE
		drawfillarc (320, 200, 120, 120, 180, 270, 7)     % Black Border
		drawfillarc (320, 200, 110, 110, 180, 270, 1)     % Blue Part 1
		drawfillarc (320, 201, 110, 110, 180, 270, 1)     % Blue Part 2
		drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		drawfilloval (320, 200, 20, 20, 0)                % White centre
		View.Update
		delay (200)

		colourShownCount := colourShownCount + 1     % Adds one to number of colours shown and needed user input
		exit when colourShownCount = levelCount * 3  % Stops flashing when reaches designated amount of colours that need to be shown in level
	    elsif colourAnswer (indexNumber) = 4 then     % Set 4 as yellow- checks if yellow
		% FLASH COLOUR CHANGE
		drawfillarc (320, 200, 120, 120, 270, 0, 7)       % Black Border
		drawfillarc (320, 200, 110, 110, 270, 0, 14)      % Yellow Part 1
		drawfillarc (320, 201, 110, 110, 270, 0, 14)      % Yellow Part 2
		drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		drawfilloval (320, 200, 20, 20, 0)                % White centre
		View.Update
		delay (round (1500 / timeShownCount)) % Smaller delay as game progresses

		% FLASH COLOUR ERASE
		drawfillarc (320, 200, 120, 120, 270, 0, 7)       % Black Border
		drawfillarc (320, 200, 110, 110, 270, 0, 6)       % Yellow Part 1
		drawfillarc (320, 201, 110, 110, 270, 0, 6)       % Yellow Part 2
		drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		drawfilloval (320, 200, 20, 20, 0)                % White centre
		View.Update
		delay (200)

		colourShownCount := colourShownCount + 1     % Adds one to number of colours shown and needed user input
		exit when colourShownCount = levelCount * 3  % Stops flashing when reaches designated amount of colours that need to be shown in level
	    end if
	    if levelCount >= 1 and levelCount < 4 then     % Sees if game is still in play
		indexNumber := indexNumber + 1     % Adds one to index checker to flash all necessary colours
	    end if
	end loop
	%-----<END OF FLASHING SEQUENCE>-----

	%-----<START OF USER INPUT>-----
	locate (3, 35)
	put "" : 10
	locate (24, 10)
	put "Please repeat the pattern you saw by clicking in the colour wheel!"
	View.Update
	loop % User input loop
	    mousewhere (mouseX, mouseY, button) % Starts mousewhere
	    if button = 1 then     % Checks if mouse was pressed
		if whatdotcolour (mouseX, mouseY) = 2 then % Green space click animation
		    drawfillarc (320, 200, 120, 120, 90, 180, 7)      % Black Border
		    drawfillarc (320, 200, 110, 110, 90, 180, 10)     % Green Part 1
		    drawfillarc (320, 201, 110, 110, 90, 180, 10)     % Green Part 2
		    drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		    drawfilloval (320, 200, 20, 20, 0)                % White centre
		    View.Update
		    delay (750)

		    % FLASH COLOUR ERASE
		    drawfillarc (320, 200, 120, 120, 90, 180, 7)      % Black Border
		    drawfillarc (320, 200, 110, 110, 90, 180, 2)      % Green Part 1
		    drawfillarc (320, 201, 110, 110, 90, 180, 2)      % Green Part 2
		    drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		    drawfilloval (320, 200, 20, 20, 0)                % White centre
		    View.Update
		    delay (200)

		    if indexCheck = 1 then  % Sees if user was correct
			locate (24, 10)
			put "" : 70 % Erases the Instruction message after one click
		    end if

		    if colourAnswer (indexCheck) = 2 then     % Checks if the answer has the same colour
			clickCount := clickCount + 1                  % Adds one to the click count
			correctClickCount := correctClickCount + 1    % Adds one to the correct answer count
			indexCheck := indexCheck + 1          % Moves on to check the next array value
		    else
			clickCount := clickCount + 1                  % Adds one to the click count
		    end if
		    exit when clickCount = colourShownCount or correctClickCount not= clickCount    % Exits user input stage when user is wrong on their click or has completed level
		elsif whatdotcolour (mouseX, mouseY) = 1 then % Blue space click
		    % FLASH COLOUR CHANGE
		    drawfillarc (320, 200, 120, 120, 180, 270, 7)     % Black Border
		    drawfillarc (320, 200, 110, 110, 180, 270, 11)    % Blue Part 1
		    drawfillarc (320, 201, 110, 110, 180, 270, 11)    % Blue Part 2
		    drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		    drawfilloval (320, 200, 20, 20, 0)                % White centre
		    View.Update
		    delay (750)

		    % FLASH COLOUR ERASE
		    drawfillarc (320, 200, 120, 120, 180, 270, 7)     % Black Border
		    drawfillarc (320, 200, 110, 110, 180, 270, 1)     % Blue Part 1
		    drawfillarc (320, 201, 110, 110, 180, 270, 1)     % Blue Part 2
		    drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		    drawfilloval (320, 200, 20, 20, 0)                % White centre
		    View.Update
		    delay (200)

		    if indexCheck = 1 then  % Sees if user was correct
			locate (24, 10)
			put "" : 70 % Erases the Instruction message after one click
		    end if

		    if colourAnswer (indexCheck) = 3 then     % Checks if the answer has the same colour
			clickCount := clickCount + 1                  % Adds one to the click count
			correctClickCount := correctClickCount + 1    % Adds one to the correct answer count
			indexCheck := indexCheck + 1          % Moves on to check the next array value
		    else
			clickCount := clickCount + 1                  % Adds one to the click count
		    end if
		    exit when clickCount = colourShownCount or correctClickCount not= clickCount    % Exits user input stage when user is wrong on their click or has completed level
		elsif whatdotcolour (mouseX, mouseY) = 4 then % Red space click
		    % FLASH COLOUR CHANGE
		    drawfillarc (320, 200, 120, 120, 0, 90, 7)        % Black Border
		    drawfillarc (320, 200, 110, 110, 0, 90, 12)       % Red Part 1
		    drawfillarc (320, 201, 110, 110, 0, 90, 12)       % Red Part 2
		    drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		    drawfilloval (320, 200, 20, 20, 0)                % White centre
		    View.Update
		    delay (750)

		    % FLASH COLOUR ERASE
		    drawfillarc (320, 200, 120, 120, 0, 90, 7)        % Black Border
		    drawfillarc (320, 200, 110, 110, 0, 90, 4)        % Red Part 1
		    drawfillarc (320, 201, 110, 110, 0, 90, 4)        % Red Part 2
		    drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		    drawfilloval (320, 200, 20, 20, 0)                % White centre
		    View.Update
		    delay (200)

		    if indexCheck = 1 then   % Sees if user was correct
			locate (24, 10)
			put "" : 70 % Erases the Instruction message after one click
		    end if

		    if colourAnswer (indexCheck) = 1 then     % Checks if the answer has the same colour
			clickCount := clickCount + 1                  % Adds one to the click count
			correctClickCount := correctClickCount + 1    % Adds one to the correct answer count
			indexCheck := indexCheck + 1          % Moves on to check the next array value
		    else
			clickCount := clickCount + 1                  % Adds one to the click count
		    end if
		    exit when clickCount = colourShownCount or correctClickCount not= clickCount   % Exits user input stage when user is wrong on their click or has completed level
		elsif whatdotcolour (mouseX, mouseY) = 6 then % Yellow space click
		    % FLASH COLOUR CHANGE
		    drawfillarc (320, 200, 120, 120, 270, 0, 7)       % Black Border
		    drawfillarc (320, 200, 110, 110, 270, 0, 14)      % Yellow Part 1
		    drawfillarc (320, 201, 110, 110, 270, 0, 14)      % Yellow Part 2
		    drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		    drawfilloval (320, 200, 20, 20, 0)                % White centre
		    View.Update
		    delay (750)

		    % FLASH COLOUR ERASE
		    drawfillarc (320, 200, 120, 120, 270, 0, 7)       % Black Border
		    drawfillarc (320, 200, 110, 110, 270, 0, 6)       % Yellow Part 1
		    drawfillarc (320, 201, 110, 110, 270, 0, 6)       % Yellow Part 2
		    drawfilloval (320, 200, 30, 30, 7)                % Centre Black border
		    drawfilloval (320, 200, 20, 20, 0)                % White centre
		    View.Update
		    delay (200)

		    if indexCheck = 1 then   % Sees if user was correct
			locate (24, 10)
			put "" : 70 % Erases the Instruction message after one click
		    end if

		    if colourAnswer (indexCheck) = 4 then     % Checks if the answer has the same colour
			clickCount := clickCount + 1                  % Adds one to the click count
			correctClickCount := correctClickCount + 1    % Adds one to the correct answer count
			indexCheck := indexCheck + 1          % Moves on to check the next array value
		    else
			clickCount := clickCount + 1                  % Adds one to the click count
		    end if
		    exit when clickCount = colourShownCount or correctClickCount not= clickCount    % Exits user input stage when user is wrong on their click or has completed level
		end if
	    end if
	end loop
	clickCount := 0 % Resets the amount of times mouse was clicked
	%-----<END OF USER INPUT>-----

	% <WIN/LOSE CHECK>
	% Lose Cases:
	% Incorrect click on any level
	if correctClickCount not= colourShownCount then
	    locate (23, 20)
	    put "OOF! BETTER LUCK NEXT TIME... You LOSE." ..
	    View.Update
	    Music.PlayFile ("mariodeath.mp3") %Plays losing sound
	    delay (1000)
	end if
	% Win Condition:
	if correctClickCount = colourShownCount and levelCount = 3 then % If last level and all correct
	    locate (10, 2)
	    put "Good job, you WIN!" ..
	    View.Update
	    Music.PlayFile ("mariowin.mp3") %Plays winning sound
	    delay (1000)
	end if

	exit when levelCount = 3 or correctClickCount not= colourShownCount     % Main Game exit condition (highest level reached or not correct)
	correctClickCount := 0                 % Resets the number of correct clicks user has inputed, after checking if they pass the level
	timeShownCount := timeShownCount + 1   % Increases the size of divisor for delay time so it's shorter
	levelCount := levelCount + 1           % Adds one to the level count, if they pass the current level
    end loop
    mainMenuButton := GUI.CreateButton (500, 30, 0, "Main Menu", mainMenu)     % Main menu exit after game finishes
    View.Update
end level
% --------------------------------------------------------------------------------<<End of Main Game>>--------------------------------------------------------------------------------

% Program Introduction
procedure introduction
    Window.Show (introWindow)
    title
    locate (3, 10)
    put "This is a memory game using colours! Welcome to Simon Says!"
    for i : 0 .. 300                    % Simon circle entrance- animation
	setscreen ("offscreenonly")
	drawfilloval (320, i - 101, 121, 121, 0)         % Erase
	% Frame
	drawfilloval (320, i - 100, 120, 120, 7)          % Black Border
	drawfilloval (320, i - 100, 110, 110, 0)          % White Part
	% Centre
	drawfilloval (320, i - 100, 30, 30, 7)         % Black border
	drawfilloval (320, i - 100, 20, 20, 0)         % White centre

	delay (5)
	View.Update
    end for
    for i : 30 .. 110
	% (TOP RIGHT)
	drawarc (320, 200, i, i, 0, 90, 4)          % Red Part
	drawarc (321, 200, i, i, 0, 90, 4)
	drawarc (320, 201, i, i, 0, 90, 4)
	drawarc (321, 201, i, i, 0, 90, 4)
	% (TOP LEFT)
	drawarc (320, 200, i, i, 90, 180, 2)          % Green Part
	drawarc (321, 200, i, i, 90, 180, 2)
	drawarc (320, 201, i, i, 90, 180, 2)
	drawarc (321, 201, i, i, 90, 180, 2)
	% (BOTTOM RIGHT)
	drawarc (320, 200, i, i, 180, 270, 1)          % Blue Part
	drawarc (321, 200, i, i, 180, 270, 1)
	drawarc (320, 201, i, i, 180, 270, 1)
	drawarc (321, 201, i, i, 180, 270, 1)
	% (BOTTOM LEFT)
	drawarc (320, 200, i, i, 270, 0, 6)         % Yellow Part
	drawarc (321, 200, i, i, 270, 0, 6)
	drawarc (320, 201, i, i, 270, 0, 6)
	drawarc (321, 201, i, i, 270, 0, 6)

	delay (10)
	View.Update
    end for
    mainMenuButton := GUI.CreateButton (265, 0, 0, "Main Menu", mainMenu)
    View.Update
end introduction

% Main Menu procedure
body procedure mainMenu
    Window.Hide (introWindow)  % Hides the introduction and buttons
    GUI.Hide (mainMenuButton)
    if count = 1 then
	mainMenuWindow := Window.Open ("position:440;400, graphics:640;400") % Opens window
    end if
    title
    % Animation
    for i : 0 .. 360
	setscreen ("offscreenonly")
	%  (TOP RIGHT)
	drawfillarc (420, 200, 120, 120, i, 90 + i, 7)     % Black Border
	drawfillarc (420, 200, 110, 110, i, 90 + i, 4)     % Red Part
	% (TOP LEFT)
	drawfillarc (420, 200, 120, 120, 90 + i, 180 + i, 7)     % Black Border
	drawfillarc (420, 200, 110, 110, 90 + i, 180 + i, 2)     % Green Part
	% (BOTTOM RIGHT)
	drawfillarc (420, 200, 120, 120, 180 + i, 270 + i, 7)     % Black Border
	drawfillarc (420, 200, 110, 110, 180 + i, 270 + i, 1)     % Blue Part
	% (BOTTOM LEFT)
	drawfillarc (420, 200, 120, 120, 270 + i, i, 7)     % Black Border
	drawfillarc (420, 200, 110, 110, 270 + i, i, 6)     % Yellow Part
	% Centre
	drawfilloval (420, 200, 30, 30, 7)              % Black border
	drawfilloval (420, 200, 20, 20, 0)              % White centre
	delay (5)
	View.Update
    end for
    instructionsButton := GUI.CreateButtonFull (150, 300, 0, "Instructions", instructions, 0, '^S', false)
    playButton := GUI.CreateButtonFull (150, 200, 0, "Play Game", level, 0, '^S', false)
    exitButton := GUI.CreateButtonFull (150, 100, 0, "Exit", goodbye, 0, '^S', false)
    View.Update
    count := count + 1
end mainMenu

% Main program
fork music
introduction
loop
    exit when GUI.ProcessEvent
end loop
Window.Close (goodbyeWindow)
% End of main program
