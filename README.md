# Ray Diagram Visualizer

 Generates basic ray diagrams for optical devices.

## Install
(later)

## Build from Source Code
As far as I know, you must: 
- Install QT Creator (https://doc.qt.io/qtcreator/creator-how-to-install.html)
- make a new project
- add Main.qml and main.cpp
- Deal with CMAKE if necesary
- Click the preview or run button

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
- This application does not simulate multiple-lens systems.

## Validation and Errors
All Devices:
- Object distance cannot be equal to focal length
- Object distance must be greater than zero
- Focal length cannot equal zero
  
Diverging lens and mirror:
- Focal length must be negative
  
Converging lens and mirror:
- Focal length must be positive
 
Some errors will prevent the canvas from updating, but most will change the background of the text fields red, even though an image will still form.
The red background indicated an incorrect image.

## Examples:
Converging Mirror, $$f=100$$, $$p=150$$

![image](https://github.com/user-attachments/assets/0202f42a-7a67-49fd-acd4-84c5dff8e02f)

Converging Mirror, $$f=100$$, $$p=50$$

![image](https://github.com/user-attachments/assets/75b463c3-2b8c-4074-978e-5faf4e8021c5)

Diverging Mirror, $$f=-100$$, $$p=150$$

![image](https://github.com/user-attachments/assets/89785fb5-9170-4bf6-84d0-7b45f5e397f4)

Converging Lens, $$f=100$$, $$p=150$$

![image](https://github.com/user-attachments/assets/2f689cf0-205c-47a3-b9d9-96e5f528310e)

Converging Lens, $$f=100$$, $$p=50$$

![image](https://github.com/user-attachments/assets/28d704ad-174a-40f3-b2d1-fec7b8cf64f3)


Diverging Lens, $$f=-100$$, $$p=150$$

![image](https://github.com/user-attachments/assets/744194b7-79be-412b-b540-4bf9db8108f5)
