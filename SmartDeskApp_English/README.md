# SmartDeskApp UI Rebuild - User Guide

## Overview

This project rebuilds the AI Smart Desk System interface as a programmatic
MATLAB app using `uifigure`. Its functional layout matches the original
application (`SmartDeskApp.exe`) and includes an additional Voice Control page.

| Page | Features |
|------|----------|
| A Posture & Rhythm | Desk height control / sedentary detection / AI posture recognition / work duration monitoring / height preference learning |
| B Adaptive Lighting | Brightness and color temperature / ambient light sensing / lighting modes / light preview |
| C Safety & Controls | Safety status / one-touch actions / operation log / motor status |
| D Environment | Scent diffusion / fan speed / humidity / mood lighting / combined environment scenes |
| E Space & Objects | Item search / RFID status / desk grid / AI organisation suggestions |
| F Privacy | Storage strategy / sensor controls / AI permissions / user profiles / decision explanations |
| G Scene Switcher | Eight scene cards / desk tilt / embedded screen settings |
| H Voice Control (additional page) | Speech recognition and spoken feedback / microphone level / command tester / command log |

## Voice Control on Page H

- Uses the Windows .NET `System.Speech` library; no additional MATLAB toolbox
  is required for the voice module.
- Approximately 70 English voice commands cover all modules on pages A-G:
  - Desk height: `sit down`, `stand up`, and preset height commands from 70 to
    110 cm, such as `set height seventy`.
  - Lighting: `brightness up`, `brightness down`, seven lighting modes, and
    automatic dimming controls.
  - Safety: `check safety`, `reset desk`, and related safety commands.
  - Environment: `fan up`, `scent on`, `lavender scent`, `mood focus`, and
    combined environment scenes.
  - Objects: `find phone`, `find keys`, `find cable`, and `register item`.
  - Privacy: `privacy report` and `stop automation`.
  - Scenes: eight mode commands and tilt presets of 0, 15, and 30 degrees.
  - System: `status`, `help`, and `stop listening`.
- Commands can switch to the relevant page, perform an action, update the
  interface, provide spoken feedback, and write to the command log.
- The Command Tester simulates voice input without a microphone, making it
  useful for demonstrations.
- If microphone input is unavailable, the app falls back to simulation mode
  and animates the microphone level indicator for demonstration purposes.

## Requirements

The source app requires **a full installation of MATLAB R2023a or later**,
including support for App Designer and `uifigure`. No additional toolbox is
required to run the interface. Windows is required for the `System.Speech`
voice features.

MATLAB Runtime alone cannot run the `.m` source files. It is used to run a
compiled application. To obtain a full MATLAB installation, check your
institution's campus licence or software portal, the
[MathWorks trial page](https://www.mathworks.com/campaigns/products/trials.html),
or an appropriate individual licence.

Creating a standalone executable or installer additionally requires
**MATLAB Compiler**. See [EXPORT_GUIDE.md](EXPORT_GUIDE.md).

## Running the App

1. Open a full installation of MATLAB.
2. Set MATLAB's Current Folder to the folder containing `SmartDeskApp.m`, or
   copy the file to a folder already on the MATLAB path.
3. Enter the following command in the Command Window:

```matlab
SmartDeskApp
```

The rebuilt interface will open.

## Implemented Interactive Features

- The eight sidebar buttons, A-H, switch pages and highlight the active page
  in blue.
- Page A: the desk height slider updates the displayed value; the Sitting and
  Standing buttons select 72 cm and 108 cm. Learn New Preference adds the
  current height to the preference list.
- Page B: brightness and color temperature sliders update their displayed
  values; changing the lighting mode updates the preview.
- Page C: six action buttons write timestamped entries to the operation log
  and update the displayed motor status.
- Page D: scent intensity, fan speed, and humidity sliders update their
  displayed values; mood buttons change the displayed mood lighting mode.
- Page E: item search selects the matching registered item; RFID registration
  adds a new demonstration item.
- Page F: storage options, sensor controls, and AI permissions can be changed;
  Clear Local Data displays a demonstration warning dialog.
- Page G: eight scene cards change the active scene; the tilt slider updates
  the displayed angle.
- Page H: the Command Tester runs English commands and records them in the
  voice command log; microphone input and spoken feedback use `System.Speech`.
- The clock in the lower-right corner updates in real time. Closing the app
  stops its timer.

## Extending the App

- The code uses one main function, a build function for each page, and shared
  callbacks. Edit the relevant build function to change a page's controls.
- To migrate to an App Designer `.mlapp` project, create a new app and use the
  component properties in `SmartDeskApp.m` as a reference while recreating
  the controls in App Designer's Code View.

## Project Files

| File | Purpose |
|------|---------|
| `SmartDeskApp.m` | Main app, including pages A-H and shared callbacks |
| `build_package.m` | Existing standalone build and packaging script |
| `README.md` | English user guide |
| `EXPORT_GUIDE.md` | English build and distribution guide |
| `BUILD_OK_validation.log` | Retained build-status log from the supplied project |
