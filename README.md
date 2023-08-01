# <img src="https://github.com/johanlillja/i2i/blob/main/header.png?raw=true" alt="icon" width="100%" height="100%" title="icon">

Welcome to the development folder for the ion to image (i2i) application and sourcecode. Here you will find source code
, a precompiled version of the app, and documentation.

# License
i2i is a free software; you can redistribute it and/or modify it under the terms of the MIT license.

i2i is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.

# What is i2i

i2i is an application written in MATLAB for processing of mass spectrometry imaging data sets. The application
can be run targeted or untargeted data analysis. It currently supports .mzML files, 
we recomend Proteowizard MSConvert (https://proteowizard.sourceforge.io/) or ThermoRawFileParserGUI (https://github.com/compomics/ThermoRawFileParserGUI)

i2i was made to handle complex MSI experiments fast and convenient from an intuitive GUI,
some features includes:
* Usage of arbitrarily complex MS experiments (MSn, HCD, SIM, Multiplexing, ...)
* Alignment of individual line scans based on instrument duty cycle
* Perform region of interest analysis 
* Generate high quality figures
* Process data fast

# Requirements

The application is developed with MATLAB 2022a, please use this version when you test the application. There might be conflicts when trying to run the
code with other verisons of MATLAB.
After downloading the source code you need to add the whole folder to path, this is easily done by right clicking on the folder.
You also need the image processing toolbox and the parallel computing toolbox in MATLAB. 

# Description of the code

The live script 'Basic_functional_description.mlx' in the source folder is a live script that shows the basic structure of the code. 
If the source code has been added to path and all required packages are installed it can be executed.
The live script does not have all quality of life features available in the compiled application.

# Cite

Please cite any use of this software as: 
Ion-to-Image, i2i, a Mass Spectrometry Imaging Data Analysis Platform for Continuous Ionization Techniques
Johan Lillja, Kyle D. Duncan, and Ingela Lanekoff
Analytical Chemistry Article ASAP
DOI: 10.1021/acs.analchem.3c01615

# Reporting problems

Although we are not supporting the software, please file eventual issues under the issues tab on this github.

Please provide a short description of the problem and try to replicate it yourself before you report it.

In the report provide
* Version of MATLAB
* Copy of the error message


