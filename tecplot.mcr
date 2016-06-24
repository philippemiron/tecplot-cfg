#!MC 1120

##################################################################
#                                                                #
#            Default tecplot.mcr file.                           #
#                                                                #
#  This file is processed automatically by tecplot on startup.   #
#  The macro functions defined here will appear in the quick     #
#  macro panel (from the "Scripting" menu).                      #
#                                                                #
##################################################################

# Macro to save layout and read layout to simplify reading changing data sets.
$!MACROFUNCTION NAME = "Auto-Reload"
	ShowInMacroPanel = True
$!SAVELAYOUT  "/tmp/reload123.lay"
	USERELATIVEPATHS = YES
$!OPENLAYOUT  "/tmp/reload123.lay"
$!REDRAWALL
$!SYSTEM "/bin/rm -f /tmp/reload123.lay"
$!ENDMACROFUNCTION

# Windows version
# Macro to save layout and read layout to simplify reading changing data sets.
#$!MACROFUNCTION NAME = "Auto-Reload (a)"
#KeyStroke = "a"
#ShowInMacroPanel = True
#$!SAVELAYOUT  "reload123.lay"
#USERELATIVEPATHS = YES
#$!OPENLAYOUT  "reload123.lay"
#$!REDRAWALL
#$!SYSTEM "cmd /C del reload123.lay"
#$!ENDMACROFUNCTION

$!MACROFUNCTION NAME = "Vorticity (2D)"
	ShowInMacroPanel = True

$!PROMPTFORTEXTSTRING |U|
INSTRUCTIONS = "Enter the variable number for U"
$!PROMPTFORTEXTSTRING |V|
INSTRUCTIONS = "Enter the variable number for V"
$!PROMPTFORTEXTSTRING |MAX|
    INSTRUCTIONS = "Enter min/max value of Vorticity contour"

$!GLOBALTWODVECTOR UVAR = |U|
$!GLOBALTWODVECTOR VVAR = |V|

$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'SetFieldVariables ConvectionVarsAreMomentum=\'F\' UVar=|U| VVar=|V| WVar=0 ID1=\'NotUsed\' Variable1=0 ID2=\'NotUsed\' Variable2=0'
$!EXTENDEDCOMMAND 
  COMMANDPROCESSORID = 'CFDAnalyzer4'
  COMMAND = 'Calculate Function=\'ZVORTICITY\' Normalization=\'None\' ValueLocation=\'Nodal\' CalculateOnDemand=\'T\' UseMorePointsForFEGradientCalculations=\'F\''

# Switch to Vorticy contour
$!FIELDLAYERS SHOWCONTOUR = YES
$!SETCONTOURVAR 
  VAR = |NUMVARS|
  CONTOURGROUP = 1
  
# Remove legend
$!GLOBALCONTOUR 1  LEGEND{SHOW = NO}
  
$!CONTOURLEVELS DELETERANGE RANGEMIN = |minc| RANGEMAX = |maxc|
$!Varset |Delta| = ((2*|MAX|)/(25))
$!Varset |Level| = (-|MAX| - |Delta|)
$!Loop 26
  $!Varset |Level| = (|Level| + |Delta|)
  $!CONTOURLEVELS ADD
  CONTOURGROUP = 1
  RAWDATA
  1
  |Level|
$!Endloop

$!REMOVEVAR |U|
$!REMOVEVAR |V|
$!REMOVEVAR |MAX|
$!REMOVEVAR |Delta|
$!REMOVEVAR |Level|
$!ENDMACROFUNCTION

# Macro to set Custom1 paper size
$!MACROFUNCTION NAME = "PaperSize"
	ShowInMacroPanel = True

# set width of the paper
$!VARSET |W| = 0
$!VARSET |H| = 0
$!WHILE |W| == 0
  $!PROMPTFORTEXTSTRING |W|
    INSTRUCTIONS = "Enter width of the paper. (in)"
  $!IF |W| < 0
    $!VARSET |W| = 0
    $!PAUSE "Size of the paper must be larger than 0in."
  $!ENDIF
$!ENDWHILE

# set height of the paper
$!WHILE |H| == 0
  $!PROMPTFORTEXTSTRING |H|
    INSTRUCTIONS = "Enter height of the paper. (in)"
  $!IF |H| < 0
    $!VARSET |H| = 0
    $!PAUSE "Size of the paper must be larger than 0in."
  $!ENDIF
$!ENDWHILE

$!PAPER PAPERSIZE = CUSTOM1
$!PAPER ORIENTPORTRAIT = YES
$!PAPER PAPERSIZEINFO {CUSTOM1 {WIDTH = |W|}}
$!PAPER PAPERSIZEINFO {CUSTOM1 {HEIGHT= |H|}}
$!PAPER SHOWPAPER = YES
$!PAPER SHOWGRID = NO
$!WORKSPACEVIEW FITPAPER
$!ENDMACROFUNCTION

#
# Convenience wrappers and functions for accessing Tecplot's pages
#     Jim Carson 01 April 2008
#
$!MACROFUNCTION NAME = "Create new page"
  SHOWINMACROPANEL = FALSE  #We don't want this to show in the quick macro panel
# 
# The page name is not set by default; however, later functions may use it.
#
$!PROMPTFORTEXTSTRING |TMP| INSTRUCTIONS = "Enter the name of the page."
$!PAGECONTROL CREATE
$!PAGENAME "|TMP|"
$!REMOVEVAR |TMP|
$!ENDMACROFUNCTION

$!MACROFUNCTION NAME = "Rename this page"
  SHOWINMACROPANEL = FALSE  #We don't want this to show in the quick macro panel
$!PROMPTFORTEXTSTRING |TMP| INSTRUCTIONS = "Enter the name of the page."
$!PAGENAME "|TMP|"
$!REMOVEVAR |TMP|
$!ENDMACROFUNCTION

$!MACROFUNCTION NAME = "Get this page's name"
  SHOWINMACROPANEL = FALSE  #We don't want this to show in the quick macro panel
$!PAGEGETNAME |TMP|
#
# Tecplot's default page does not have the name set
#
$!IF "|TMP|" == ""
   $!PAUSE "The current page has no name."
$!ELSE
   $!PAUSE "The current page is named |TMP|"
$!ENDIF
$!REMOVEVAR |TMP|
$!ENDMACROFUNCTION

$!MACROFUNCTION NAME = "Go to page named..."
  SHOWINMACROPANEL = FALSE  #We don't want this to show in the quick macro panel
$!PROMPTFORTEXTSTRING |TMP| INSTRUCTIONS = "Enter the name of the page."
$!PAGECONTROL SETCURRENTBYNAME NAME = "|TMP|"
$!REMOVEVAR |TMP|
$!ENDMACROFUNCTION 

$!MACROFUNCTION NAME = "Page >>"
  SHOWINMACROPANEL = FALSE  #We don't want this to show in the quick macro panel
$!PAGECONTROL SETCURRENTTONEXT
$!ENDMACROFUNCTION

$!MACROFUNCTION NAME = "<< Page"
  SHOWINMACROPANEL = FALSE  #We don't want this to show in the quick macro panel
$!PAGECONTROL SETCURRENTTOPREV
$!ENDMACROFUNCTION

$!MACROFUNCTION NAME = "Delete this page"
  SHOWINMACROPANEL = FALSE  #We don't want this to show in the quick macro panel
$!PROMPTFORYESNO = |MakeItSo| INSTRUCTIONS = "Are you sure you want to delete the current page?"
$!IF "|MakeItSo|" == "YES"
   $!PAGECONTROL DELETE
$!ENDIF
$!REMOVEVAR |MakeItSo|
$!ENDMACROFUNCTION


# 
# List all of the pages currently in use -- Jim Carson   1 April 2008
# 
# This one is tricky because there's no unique identifier accessible for
# pages.  Also, by default, frames do not have names.  To work around these
# issues, we temporarily rename the first frame something no user (except Jim)
# would reasonably choose.  When we're done counting, we'll reset its name back.
# A side effect of this is function is the layout is tainted, needing to be
# saved.
# 
$!MACROFUNCTION NAME = "List all of the pages"
  SHOWINMACROPANEL = FALSE  #We don't want this to show in the quick macro panel
#
# Tecplot will have a minimum of one page.
#
$!VARSET |PageCount| = 1
#
# Tecplot's default page does not have the name set.  To determine where to 
# stop, pick something unique.
#
$!VARSET |LoopUntil| = "Tecplot Is Awesome!"
$!VARSET |FirstPageName| = ""
$!VARSET |PageNames| = "|PageCount| = "
$!PAGEGETNAME |TMP|
   #
   # The first page typically does not have a name.  But check anyway.
   #
    $!IF "|TMP|" == ""
       $!VARSET |PageNames| = "|PageNames| (unnamed)"
    $!ELSE
       $!VARSET |PageNames| = "|PageNames| |TMP|"
       #
       # Save the real page name.
       #
       $!VARSET |FirstPageName| = "|TMP|"
    $!ENDIF
    #
    # Temporarily rename the first page - this is the only way we can
    # know we've counted all pages.
    #
    $!PAGENAME "|LoopUntil|"

    # 
    # The loop counter serves two purposes:
    #    1) limits Tecplot locking up if Jim made a programming error (after 
    #    all, he is a marketing person)
    #    2) lets us iterate.  Ideally, we'd have a $!do..$!until
    # 
    $!LOOP 999
       # 
       # Go to the next page, get its name
       #
       $!PAGECONTROL SETCURRENTTONEXT
       $!PAGEGETNAME |TMP|
       #
       # Have we got back to the start?
       #
       $!IF "|TMP|" == "|LoopUntil|"
          $!break
       $!ENDIF
       # 
       # Keep counting.
       #
       $!VarSet |PageCount| += 1
       $!VarSet |PageNames| = "|PageNames|,\n|PageCount| = "
       $!IF "|TMP|" == ""
          $!VarSet |PageNames| = "|PageNames| (unnamed)"
       $!ELSE
          $!VarSet |PageNames| = "|PageNames| |TMP|"
       $!ENDIF
    $!ENDLOOP

#
# Reset the starting page's name
# 
$!IF "|FirstPageName|" == ""
   $!PAGENAME "(unnamed)"
$!ELSE
   $!PAGENAME "|FirstPageName|"
$!ENDIF

#
# now print the results...
# 
$!IF |PageCount| == 1
    # In honor of Super Dave, correct grammar:
    $!PAUSE "There is one page: |PageNames|"
$!ELSE
    $!PAUSE "There are |PageCount| pages:\n|PageNames|"
$!ENDIF
#
# Now clean up variables.
#
$!REMOVEVAR |PageCount|
$!REMOVEVAR |PageNames|
$!REMOVEVAR |FirstPageName|
$!REMOVEVAR |TMP|
$!REMOVEVAR |LoopUntil|
$!ENDMACROFUNCTION

#
# Function 3D Rotation Animation  - Ardith Ketchum, Revised 11/2003
#
# This macro function will rotate a 3D plot, allowing the user to 
# choose the axis for rotation, how many degrees the plot will be 
# rotated with each step, how many rotation steps will occur, and
# whether the animation will be saved to a file.  When a file is 
# saved, it will be found in the Tecplot home directory with an 
# appropriate name.  For example, an AVI file showing rotation 
# around the x axis will be called xaxisrotation.avi. 
#
$!Macrofunction Name = "3D Rotation Animation"
                ShowInMacroPanel = True
  $!PromptForTextString |RotationAxis|
    Instructions = "Enter axis for rotation (X,Y,Z,PSI,...)."
  $!PromptForTextString |RotationAngle|
    Instructions = "Enter number of degrees for each rotation step."
  $!PromptForTextString |NumSteps|
    Instructions = "Enter the number of rotation steps."
  $!PromptForTextString |Animation|
    Instructions = "Enter 0 for No Animation File, 1 for an AVI file, 2 for an RM file, 3 for a Flash file."
  $!If |Animation| != 0
    $!Varset |format| = "AVI"
    $!Varset |Extension| = "AVI"
    $!If |Animation| == 2
      $!Varset |format| = "Rastermetafile"
      $!Varset |Extension| = "RM"
    $!Elseif |Animation| == 3
      $!Varset |format| = "Flash"
      $!Varset |Extension| = "swf"

    $!Endif
    $!EXPORTSETUP EXPORTFORMAT = |format|
    $!EXPORTSETUP IMAGEWIDTH = 546
    $!EXPORTSETUP EXPORTFNAME = "|RotationAxis|AxisRotation.|Extension|"
    $!EXPORTSTART 
  $!Endif
  $!Loop |NumSteps|
    $!ROTATE3DVIEW |RotationAxis|
      ANGLE = |RotationAngle|
      ROTATEORIGINLOCATION = DEFINEDORIGIN
    $!Redraw
    $!If |Animation| != 0
      $!EXPORTNEXTFRAME 
    $!Endif
    $!Endloop
  $!If |Animation| != 0
    $!EXPORTFINISH 
  $!Endif
  $!Pause "Animation is completed.  If the rotated image is off-center or off-screen, reset the center of rotation and animate again."
$!Endmacrofunction

#
# Macro Function Reset Center of Rotation
# This allows Tecplot to change the center of rotation based on 
# the minimum and maximum values of x, y and z to allow better
# 3D Rotation.
#
$!Macrofunction Name = "Reset Center of Rotation"
  ShowInMacroPanel = True
$!RESET3DORIGIN ORIGINRESETLOCATION = DATACENTER
$!View Datafit
$!Endmacrofunction


#
# This macro function is used by the Cascade and Tile
# frames macros. It will prompt the user for PaperWidth
# and PaperHeight dimensions.  If the values are invalid,
# it will require the user to retype the values.
#
# In version 10 and later, |PAPERWIDTH| and |PAPERHEIGHT|
# are intrinsic macro variables, so this function is not
# needed, but it remains here for backward compatability
#
$!MACROFUNCTION
  NAME = "GetPaperDim"
  SHOWINMACROPANEL = FALSE  #We don't want this to show in the quick macro panel
  #
  # If you always use one paper size, instead of prompting
  # for the paper size, you can just set it explicitly.  Example:
  #
  # $!VARSET |PAPERWIDTH| = 11
  # $!VARSET |PAPERHEIGHT| = 8.5
  #
  
  #
  # Get the paper width
  #
  $!VARSET |PAPERDIMOK| = 0
  $!WHILE |PAPERDIMOK| == 0
    $!PROMPTFORTEXTSTRING |PAPERWIDTH|
      INSTRUCTIONS = "Enter the paper width."
    $!VARSET |PAPERDIMOK| = 1
    $!IF |PAPERWIDTH| < 1
      $!VARSET |PAPERDIMOK| = 0
      $!PAUSE "Paper width must be greater than or equal to 1."
    $!ENDIF
  $!ENDWHILE
  
  #
  # Get the paper height
  #
  $!VARSET |PAPERDIMOK| = 0
  $!WHILE |PAPERDIMOK| == 0
    $!PROMPTFORTEXTSTRING |PAPERHEIGHT|
      INSTRUCTIONS = "Enter the paper height."
    $!VARSET |PAPERDIMOK| = 1
    $!IF |PAPERHEIGHT| < 1
      $!VARSET |PAPERDIMOK| = 0
      $!PAUSE "Paper height must be greater than or equal to 1."
    $!ENDIF
  $!ENDWHILE 
  $!REMOVEVAR |PAPERDIMOK| 
$!ENDMACROFUNCTION


#
# Function Cascade Frames - Scott Fowler 11/2001
#
# This macro function will move and resize all the frames
# the layout in a cascading fashion. If there are too many
# frames to fit in one cascade, multiple layers of cascading
# frames will be produced. Frame order is maintained.
#
$!MACROFUNCTION
  NAME = "Cascade Frames"

  $!IF |TECPLOTVERSION| < 100
    $!RUNMACROFUNCTION "GetPaperDim"
  $!ENDIF

  # Change the delta to change the distance 
  # in which the frame are cascaded
  $!VARSET |DELTA|  = 0.25

  # These two values define the margin between the paper
  # and the edge of the outer frames.
  $!VARSET |STARTX| = 0.15
  $!VARSET |STARTY| = 0.15

  # This calculates a width and height such that all frames are
  # the same size.
  $!VARSET |FRAMEDIMOK| = 0
  $!VARSET |NUMLAYERS| = 1
  $!VARSET |FRAMESPERLAYER| = |NUMFRAMES|
  $!WHILE |FRAMEDIMOK| == 0
    $!VARSET |FRAMEWIDTH|  = ((|PAPERWIDTH|)  - ((|FRAMESPERLAYER|-1)*|DELTA|) - (|STARTX|*2))
    $!VARSET |FRAMEHEIGHT| = ((|PAPERHEIGHT|) - ((|FRAMESPERLAYER|-1)*|DELTA|) - (|STARTY|*2))

    $!VARSET |FRAMEDIMOK| = 1
    $!IF |FRAMEWIDTH| < 0.5
      $!VARSET |FRAMEDIMOK| = 0
    $!ENDIF
    $!IF |FRAMEHEIGHT| < 0.5
      $!VARSET |FRAMEDIMOK| = 0
    $!ENDIF
    $!IF |FRAMEDIMOK| == 0
      $!VARSET |NUMLAYERS| += 1
      $!VARSET |FRAMESPERLAYER| = (ceil(|NUMFRAMES|/|NUMLAYERS|))
    $!ENDIF
  $!ENDWHILE
  #
  # Now, reposition and resize each frame.
  #
  $!DRAWGRAPHICS NO
  $!VARSET |NUMFRAMESDRAWN| = 0
  $!LOOP |NUMLAYERS|
    $!VARSET |XPOS| = |STARTX|
    $!VARSET |YPOS| = |STARTY|
    $!LOOP |FRAMESPERLAYER|
      $!IF |NUMFRAMESDRAWN| < |NUMFRAMES|
        $!FRAMECONTROL POP
          FRAME = 1
        $!IF |LOOP| != 1
          $!VARSET |XPOS| += |DELTA|
          $!VARSET |YPOS| += |DELTA|
        $!ENDIF
        $!FRAMELAYOUT XYPOS
          {
            X = |XPOS|
            Y = |YPOS|
          }
        $!FRAMELAYOUT WIDTH  = |FRAMEWIDTH|
        $!FRAMELAYOUT HEIGHT = |FRAMEHEIGHT|
        #
        # Make sure the data fits in the frame
        #
        $!VIEW DATAFIT
        $!VARSET |NUMFRAMESDRAWN| += 1
      $!ENDIF
    $!ENDLOOP
  $!ENDLOOP
  $!FRAMECONTROL FITALLTOPAPER
  $!WORKSPACEVIEW FITALLFRAMES
  $!DRAWGRAPHICS YES

  $!REMOVEVAR |DELTA|
  $!REMOVEVAR |STARTX|
  $!REMOVEVAR |STARTY|
  $!REMOVEVAR |FRAMEDIMOK|
  $!REMOVEVAR |NUMLAYERS|
  $!REMOVEVAR |FRAMESPERLAYER|
  $!REMOVEVAR |FRAMEWIDTH|
  $!REMOVEVAR |FRAMEHEIGHT|
  $!REMOVEVAR |NUMFRAMESDRAWN|
  $!REMOVEVAR |XPOS|
  $!REMOVEVAR |YPOS|

  $!IF |TECPLOTVERSION| < 100
    $!REMOVEVAR |PAPERWIDTH|
    $!REMOVEVAR |PAPERHEIGHT|
  $!ENDIF

$!ENDMACROFUNCTION


#
# Function Tile Frames - Scott Fowler 11/2001
#                        Revised 8/2002
#                        Revised 8/15/2003 - Prompts for number of frames across rather than calculating automatically
#
# This macro function will move and resize all the frames
# the layout in a tile fashion.
#
# If there are too many frames using the specified |MARGIN|,
# the |MARGIN| will be reduced until all frames fit on the
# paper.  |MARGIN| can be negative which will result in 
# overlapping frames. Frame order is maintained.
#
$!MACROFUNCTION
  NAME = "Tile Frames"
  SHOWINMACROPANEL = TRUE

  # Before Tecplot 10 there were no |PAPERWIDTH| and |PAPERHEIGHT|
  # intrinsics, so we must prompt for them.
  $!IF |TECPLOTVERSION| < 100
    $!RUNMACROFUNCTION "GetPaperDim"
  $!ENDIF
  
  # Change the margin to change the distance 
  # between frames and the margin to the edge of the paper.
  # This value may be modified automatically if there are
  # too many frames for the specified area.
  $!VARSET |MARGIN|  = 0.0

  # These two values define the margin from the edge of the paper
  # to the edge of the outer frames.
  $!VARSET |XPOS|   = 0.15
  $!VARSET |YPOS|   = 0.15

  #
  # Get number of frames across
  #
  $!VARSET |NUMFRAMESACROSS| = 0
  $!WHILE |NUMFRAMESACROSS| == 0
    $!PROMPTFORTEXTSTRING |NUMFRAMESACROSS|
      INSTRUCTIONS = "Enter number of frames across paper."
    $!IF |NUMFRAMESACROSS| < 1
      $!VARSET |NUMFRAMESACROSS| = 0
      $!PAUSE "Number of frames across paper must be greater than or equal to 1."
    $!ENDIF
  $!ENDWHILE


  $!VARSET |TMP| = (int(|NUMFRAMESACROSS|))
  # If NUMFRAMESACROSS is not an integer, "round" up
  $!IF |NUMFRAMESACROSS| > |TMP|
    $!VARSET |NUMFRAMESACROSS| = (|TMP|)
    $!IF |PAPERWIDTH| >= |PAPERHEIGHT|
      $!VARSET |NUMFRAMESACROSS| += 1
    $!ENDIF
  $!ENDIF

  $!VARSET |NUMFRAMESDOWN| = (|NUMFRAMES|/|NUMFRAMESACROSS|)
  $!VARSET |TMP| = (int(|NUMFRAMESDOWN|))
  # If NUMFRAMESDOWN is not an integer, "round" up
  $!IF |NUMFRAMESDOWN| > |TMP|
    $!VARSET |NUMFRAMESDOWN| = (|TMP|+1)
  $!ENDIF

  # This calculates a width and height such that all frames are
  # the same size, and fit with the specified margin.  

  $!VARSET |FRAMEDIMOK| = 0
  $!WHILE |FRAMEDIMOK| == 0
    $!VARSET |FRAMEWIDTH|  = ((|PAPERWIDTH|-(|XPOS|*2)-((|NUMFRAMESACROSS|-1)*|MARGIN|))/(|NUMFRAMESACROSS|))
    $!VARSET |FRAMEHEIGHT| = ((|PAPERHEIGHT|-(|YPOS|*2)-((|NUMFRAMESDOWN|-1)*|MARGIN|))/(|NUMFRAMESDOWN|))

    $!VARSET |FRAMEDIMOK| = 1
    $!IF |FRAMEWIDTH| < 0.5
      $!VARSET |FRAMEDIMOK| = 0
    $!ENDIF
    $!IF |FRAMEHEIGHT| < 0.5
      $!VARSET |FRAMEDIMOK| = 0
    $!ENDIF
    $!IF |FRAMEDIMOK| == 0
      $!VARSET |MARGIN| -= 0.01
    $!ENDIF
  $!ENDWHILE
 
  $!DRAWGRAPHICS NO

  $!VARSET |FRAMESDRAWN| = 1
  $!VARSET |NUMDOWNDRAWN| = 1

  $!LOOP |NUMFRAMESDOWN|        
    $!LOOP |NUMFRAMESACROSS|
      # Make sure that we want to draw this frame
      $!IF |FRAMESDRAWN| <= |NUMFRAMES|        
        $!FRAMECONTROL POP
          FRAME = 1
        $!VARSET |FRAMEX| = ((|LOOP|-1)*(|FRAMEWIDTH|+|MARGIN|)+|XPOS|)
        $!VARSET |FRAMEY| = ((|NUMDOWNDRAWN|-1)*(|FRAMEHEIGHT|+|MARGIN|)+|YPOS|)
        $!FRAMELAYOUT XYPOS
          {
            X = |FRAMEX|
            Y = |FRAMEY|
          }
        $!FRAMELAYOUT WIDTH  = |FRAMEWIDTH|
        $!FRAMELAYOUT HEIGHT = |FRAMEHEIGHT|
        #
        # Make sure the data fits in the frame
        #
        $!VIEW DATAFIT
        $!VARSET |FRAMESDRAWN| += 1
      $!ENDIF
    $!ENDLOOP    
    # Increment the number of down rows.
    $!VARSET |NUMDOWNDRAWN| += 1
  $!ENDLOOP
  $!FRAMECONTROL FITALLTOPAPER
  $!WORKSPACEVIEW FITALLFRAMES
  $!DRAWGRAPHICS YES

  $!REMOVEVAR |MARGIN|
  $!REMOVEVAR |XPOS|
  $!REMOVEVAR |YPOS|
  $!REMOVEVAR |NUMFRAMESACROSS|
  $!REMOVEVAR |NUMFRAMESDOWN|
  $!REMOVEVAR |TMP|
  $!REMOVEVAR |FRAMEDIMOK|
  $!REMOVEVAR |FRAMEWIDTH|
  $!REMOVEVAR |FRAMEHEIGHT|
  $!REMOVEVAR |FRAMESDRAWN|
  $!REMOVEVAR |NUMDOWNDRAWN|
  $!REMOVEVAR |FRAMEX|
  $!REMOVEVAR |FRAMEY|

  $!IF |TECPLOTVERSION| < 100
    $!REMOVEVAR |PAPERWIDTH|
    $!REMOVEVAR |PAPERHEIGHT|
  $!ENDIF

$!ENDMACROFUNCTION


$!MACROFUNCTION NAME = "Load AddOn"
$!PROMPTFORTEXTSTRING |addon|
  INSTRUCTIONS = "Enter the name of the add-on you wish to load."
$!LOADADDON "|addon|"
$!ENDMACROFUNCTION

