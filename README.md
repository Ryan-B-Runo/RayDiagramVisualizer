# Ray Diagram Visualizer

 Generates basic ray diagrams for optical devices.

 ## Build from Source Code
 ???

 ## Install
???
 ## Instructions
- Select optical device (converging lens, diverging lens, converging mirror, diverging mirror) on top row
  - Selected device will appear as text
- Select variable to solve for (focal length, image distance, object distance) on second row
  - Selected variable will appear as text
- Input the two known variables in bottom text fields

  
## Notes
The dimensions of all quantities are in pixels, so not all screens will fit all conditions.
- You can scale the variables to make an image fit.
Application window and screen size can affect image appearance.
- Generally, using the application in fullscreen yields optimal image quality.

## Validation and Errors
All Devices:
- Object distance cannot be equal to focal length
- Object distance must be greater than zero
- Focal length cannot equal zero
  
Diverging lens and mirror:
- Focal length must be negative
  
Converging lens and mirror:
- Focal length must be positive
 
Some errors will prevent the canvas from updating, and some will change the background of the text fields red, even though an image will still form.
The red background indicated an incorrect image.
