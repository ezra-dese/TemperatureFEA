# TemperatureFEA
This project computes a Finite Element Analysis (FEA) of a house with a heater and non square area using MATLAB. The 2D Galerkin's method approach is taken along with bilinear shape functions to predict the temperature distribution within the house. There is one main script that controls the flow of the simulation, along with 11 custom functions built to support the main script. There are 9 controllobale paramters that goveren the analysis: 
1. Outside Temperature
2. Furnance Heat Flux
3. element size
4. global width
5. global height
6. wall thickness
7. k air
8. k water
9 - k wall

Some reccomendations: 
For Optimal results use 0.5 element size for coarse mesh and use 0.25 for fine mesh. Usually going to 0.1 element size may take too much time.

Enjoy!
