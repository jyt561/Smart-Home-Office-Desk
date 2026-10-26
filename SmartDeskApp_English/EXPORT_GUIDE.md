# SmartDeskApp Installer Export Guide

## Prerequisite: MATLAB Compiler

Check whether MATLAB Compiler is installed by running this command in the
MATLAB Command Window:

```matlab
ver('compiler')
```

If version information is displayed, the product is installed. If MATLAB
Compiler is unavailable, install it before running the packaging script.

To add MATLAB Compiler to the MATLAB R2026a installation used by the supplied
build script:

1. Run the MATLAB R2026a installer from the Windows Start menu, or download the
   installer from your MathWorks account. Sign in with the same MathWorks
   account used for MATLAB.
2. Choose the products to install and select **MATLAB Compiler**. Your licence
   must include this product.
3. After installation, run `ver('compiler')` in MATLAB again to confirm that
   it is available.

## Running the Packaging Script

The supplied `build_package.m` script uses the existing build folder
`D:\Matlab\work` and output folder `D:\Matlab\work\package`.
Place the English versions of `SmartDeskApp.m` and `build_package.m` in
`D:\Matlab\work` before running it. If you use another build folder, update
the paths in the script first.

Run the following commands in MATLAB:

```matlab
cd('D:\Matlab\work')
build_package
```

The script performs two build steps:

1. Calls `mcc -m` to compile `SmartDeskApp.m` into the standalone
   `SmartDeskApp.exe` application.
2. Calls `compiler.build.standaloneWindowsApplication` for the Windows
   application build.

The script reports its packaging output under `D:\Matlab\work\package`.
The intended distribution includes an installer and a compiled executable.
MATLAB Runtime is required on the target computer; a full MATLAB installation
is not required to run a compiled application.

## Distribution Options

**Option A: Installer.** If the build produces an installer, distribute that
installer to the recipient. Depending on the packaging options, installation
can download MATLAB Runtime or use a bundled copy. Downloading the Runtime
requires an internet connection; subsequent app use can be offline.

**Option B: Portable build.** Copy the entire `for_redistribution_files` folder
from the generated distribution to the recipient. The target computer must
already have the MATLAB Runtime release required by the build. The supplied
script's messages refer to R2026a; use the Runtime matching the MATLAB release
actually used to compile the app.

## Notes

- The app uses Windows .NET `System.Speech` for voice input and spoken
  feedback. Voice availability depends on the target Windows computer's
  audio devices and installed speech components. The Command Tester can be
  used when microphone input is unavailable.
- A compiled app requires the matching MATLAB Runtime rather than a full
  MATLAB installation or additional MATLAB products on the target computer.
- Windows Defender SmartScreen may display an unknown-publisher prompt for
  an unsigned application. Verify that the package came from a trusted source
  before running it.
- This English translation preserves the supplied packaging script's
  commands and paths. The retained `BUILD_OK_validation.log` is the original
  project's status log; it does not certify that a new installer was generated.
