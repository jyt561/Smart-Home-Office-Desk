# Smart Home Office Desk

### MATLAB-Based Intelligent Workstation Control System

A research-based smart home office desk control interface developed as part of doctoral research in Art and Design at the University of Wales Trinity Saint David (UWTSD), United Kingdom.

This project explores the integration of intelligent sensing, ergonomic furniture design, adaptive environmental control and multifunctional spatial organisation for compact home-working environments.

---

## Overview

The Smart Home Office Desk software is developed using MATLAB and the `uifigure` framework.

The application includes seven core functional modules (A–G) and an additional voice-control interface (H).

The software provides an interactive demonstration platform. Some functions use simulated responses and require further hardware integration for physical operation.

## Features

| Module | Function | Description |
|---|---|---|
| A | Posture & Rhythm Management | Desk height adjustment, posture monitoring and work rhythm management |
| B | Adaptive Lighting | Brightness, colour temperature and lighting scenarios |
| C | Safety & Controls | Safety monitoring, one-touch controls and operation logs |
| D | Environmental Regulation | Aroma, ventilation, humidity and mood lighting |
| E | Space & Object Management | RFID object registration, item search and desktop organisation |
| F | Privacy & Personalised Control | Sensor controls, data preferences and user permissions |
| G | Multi-Scenario Switching | Workspace presets, scene switching and desktop tilt settings |
| H | Voice Control | English speech commands, spoken feedback and command testing |

---

## System Requirements

- **Programming Language:** MATLAB
- **MATLAB Version:** R2023a or later
- **GUI Framework:** MATLAB `uifigure`
- **Operating System:** Windows for voice-control functionality
- **Speech Technology:** Windows .NET `System.Speech`
- **Additional MATLAB Toolboxes:** Not required for the source interface
- **Standalone Packaging:** MATLAB Compiler required

## Installation and Setup

### Step 1: Download the Source Code

Download or clone this repository.

### Step 2: Open MATLAB

Install MATLAB R2023a or later.

Set the MATLAB Current Folder to the directory containing `SmartDeskApp.m`.

### Step 3: Launch the Application

Enter the following command in the MATLAB Command Window:

```matlab
SmartDeskApp
```

The graphical user interface will open.

---

## Voice Control

The additional voice-control page supports English commands for desk height, lighting, environmental settings, object management, privacy and working scenarios.

Example commands:

```text
sit down
stand up
brightness up
check safety
fan up
find phone
privacy report
stop listening
```

The Command Tester allows users to simulate voice commands without using a microphone.

## Documentation

The English application folder contains:

| File | Description |
|---|---|
| `SmartDeskApp.m` | Main MATLAB application |
| `build_package.m` | Application packaging script |
| `README.md` | English user guide |
| `EXPORT_GUIDE.md` | Build and export instructions |
| `BUILD_OK_validation.log` | Retained build-status log |

The English source files are available in the [SmartDeskApp_English](SmartDeskApp_English/) folder.

---

## Research Context

This software forms part of a doctoral research project investigating intelligent, multifunctional home office furniture for young adults living in compact urban environments.

The research is informed by Human-Centred Design (HCD) and Human-Centred Artificial Intelligence (HCAI).

**Institution:** University of Wales Trinity Saint David (UWTSD)

**Research Area:** Art and Design

## Development Status

This repository provides the MATLAB software interface and supporting documentation. Interface-level interaction and simulation should be distinguished from verified physical hardware operation.

## Licence

No open-source licence has currently been assigned to this repository.
