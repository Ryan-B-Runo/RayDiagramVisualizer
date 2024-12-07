import QtQuick
import QtQuick.Controls
pragma ComponentBehavior: Bound

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Ray Diagram Visualizer")

    id: window

    property var device;

    property var objectDistance;
    property var imageDistance;
    property var f;

    property var solve;

    property color bg: "white";

    Row{
        id: deviceSelector
        anchors{
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: 10
        }
        spacing: 5
        Repeater{
            id: r
            model: ["Converging Lens", "Diverging Lens", "Converging Mirror", "Diverging Mirror"]
            Rectangle{
                width: 150
                height: 40

                border.color: "black"
                border.width: 1.5

                required property string modelData;

                Text{
                    text: parent.modelData

                    font.bold: true
                    anchors{
                        fill: parent
                    }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        deviceLabel.text = parent.modelData;
                        window.device = parent.modelData;
                        canvas.requestPaint();
                    }
                }
            }
        }
    }
    Row{
        id: solveFor;
        anchors{
            top: deviceSelector.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 5
            bottomMargin: 5
        }
        Repeater{
            model: ["Solve for f", "Solve for p", "Solve for q"];
            Rectangle{
                width: 150
                height: 40

                border.color: "black"
                border.width: 1.5

                required property string modelData;

                Text{
                    text: parent.modelData

                    font.bold: true
                    anchors{
                        fill: parent
                    }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        solveLabel.text = parent.modelData;
                        window.solve = parent.modelData;
                        canvas.requestPaint;
                    }
                }
            }
        }
    }
    Text{
        id: deviceLabel
        anchors{
            top: solveFor.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 5
            bottomMargin: 5
        }
        text: ""
        font.bold: true
    }

    Text{
        id: solveLabel
        anchors{
            top: deviceLabel.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: 5
            bottomMargin: 5
        }
        text: ""
        font.bold: true
    }

    Canvas{
        id: canvas
        anchors{
            top: solveLabel.bottom
            bottom: parameters.top
            left: parent.left
            right: parent.right
        }

        function arrowTo(startX, startY, endX, endY, arrowColor){
            var ctx = getContext('2d');
            ctx.strokeStyle = arrowColor;
            var head = 10;//length of arrow head.
            var angle = Math.atan2(endY-startY, endX-startX);

            //draw the line part of the arrow
            ctx.beginPath();
            ctx.moveTo(startX, startY);
            ctx.lineTo(endX, endY);
            ctx.stroke();

            //draw the tips
            ctx.beginPath();
            ctx.moveTo(endX - head * Math.cos(angle - Math.PI/12), endY - head * Math.sin(angle - Math.PI/12))
            ctx.lineTo(endX, endY);
            ctx.lineTo(endX - head * Math.cos(angle + Math.PI/12), endY - head * Math.sin(angle + Math.PI/12))
            ctx.stroke();
        }
        function drawLine(startX, startY, endX, endY, color, opactity){
            var ctx = getContext('2d');
            ctx.strokeStyle = color;
            ctx.globalAlpha = opactity;
            ctx.beginPath();
            ctx.moveTo(startX, startY);
            ctx.lineTo(endX, endY);
            ctx.stroke();
            ctx.globalAlpha = 1;
        }

        onPaint: {
            var ctx = getContext('2d')
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.lineWidth = 3

            var objectHeight;
            var imageHeight;
            objectHeight = (height/6);
            imageHeight = -(window.imageDistance/window.objectDistance)*objectHeight;


            if((window.device == "Diverging Lens" && parseInt(window.f) >= 0) || (window.device == "Diverging Mirror" && parseInt(window.f) >= 0) || (window.device == "Converging Lens" && parseInt(window.f) <= 0) || (window.device == "Converging Mirror" && parseInt(window.f) <= 0)){
                window.bg = "red";
            }

            //start by drawing principal axis and vertical line
            canvas.drawLine(width/2, height/2, (width/2)-(width/2)+10, height/2, 1);
            canvas.drawLine(width/2, height/2, (width/2)+(width/2)-10, height/2, 1);
            canvas.drawLine(width/2, height/2, (width/2), (height/2)+(height/2), 1);
            canvas.drawLine(width/2, height/2, (width/2), (height/2)-(height/2), 1);

            if(window.solve == "Solve for f"){
                if(window.device == "Diverging Lens" || window.device == "Diverging Mirror"){
                    window.f = 1/((1/window.objectDistance)+(1/-window.imageDistance));
                    inputF.text = window.f;
                    canvas.requestPaint();
                }else if(window.device == "Converging Lens" || window.device == "Converging Mirror"){
                    window.f = 1/((1/window.objectDistance)+(1/window.imageDistance));
                    inputF.text = window.f;
                    canvas.requestPaint();
                }
            }else if(window.solve == "Solve for q"){
                if(window.device == "Converging Lens" || window.device == "Converging Mirror"){
                    window.imageDistance = 1/((1/window.f)-(1/window.objectDistance));
                }else{
                    window.imageDistance = -1/((1/window.f)-(1/window.objectDistance));
                }

                inputQ.text = window.imageDistance;
                canvas.requestPaint();
            }else if(window.solve == "Solve for p"){
                window.objectDistance = 1/((1/window.f)-(1/window.imageDistance));
                inputP.text = window.objectDistance;
                canvas.requestPaint();
            }

            //focal point lines - Same result if f is positive or negative
            ctx.lineWidth = 2;
            canvas.drawLine((width/2)-parseInt(window.f), (height/2)-5, (width/2)-parseInt(window.f), (height/2)+5);
            canvas.drawLine((width/2)+parseInt(window.f), (height/2)-5, (width/2)+parseInt(window.f), (height/2)+5);

            if(window.device == "Diverging Lens"){
                //image distance must be less

                //object
                canvas.arrowTo((width/2)-window.objectDistance, (height/2), (width/2)-window.objectDistance, (height/2)-objectHeight, "red");
                //image
                ctx.globalAlpha = 0.5;//0.5 opacity signifies virtual image
                canvas.arrowTo((width/2)-window.imageDistance, (height/2), (width/2)-window.imageDistance, (height/2)+imageHeight, "red");
                ctx.globalAlpha = 1;

                //P-ray
                canvas.drawLine((width/2)-window.objectDistance, (height/2)-objectHeight, width/2, (height/2)-objectHeight, "blue", 1);
                canvas.drawLine((width/2)+parseInt(window.f), (height/2), (width/2), (height/2)-objectHeight, "blue", 0.25);
                canvas.drawLine((width/2), (height/2)-objectHeight, (width/2)-((window.f)), ((height/2)-objectHeight-(((height/2)-objectHeight-objectHeight))), "blue", 1);

                //C-ray
                canvas.drawLine((width/2)-window.objectDistance, (height/2)-objectHeight, (width/2)+parseInt(window.objectDistance), (height/2)+objectHeight, "green", 1);

                //F-ray
                canvas.drawLine((width/2)-window.objectDistance, (height/2)-objectHeight, width/2, (((objectHeight/(window.objectDistance-window.f)))*window.f)+(height/2), "purple", 1);
                canvas.drawLine(width/2, (((objectHeight/(window.objectDistance-window.f)))*window.f)+(height/2), (width/2)+(width/4), (((objectHeight/(window.objectDistance-window.f)))*window.f)+(height/2), "purple", 1);
                canvas.drawLine(width/2, (((objectHeight/(window.objectDistance-window.f)))*window.f)+(height/2), (width/2)-(width/4), (((objectHeight/(window.objectDistance-window.f)))*window.f)+(height/2), "purple", 0.25);

                ctx.strokeStyle = "black";
                ctx.globalAlpha = 1;
            }else if(window.device == "Converging Lens"){
                //object
                canvas.arrowTo((width/2)-window.objectDistance, (height/2), (width/2)-window.objectDistance, (height/2)-objectHeight, "red");

                if(window.imageDistance < 0){//object is in front of focal point, virtual image behind it
                    if(!(window.imageDistance > -(window.objectDistance))){//no real images in front of object
                        ctx.globalAlpha = 0.5;
                        canvas.arrowTo((width/2)+parseInt(window.imageDistance), (height/2), (width/2)+parseInt(window.imageDistance), (height/2)-imageHeight, "red");
                        ctx.globalAlpha = 1;
                    }
                }else if(window.imageDistance > 0){//real image inverted
                    canvas.arrowTo((width/2)+parseInt(window.imageDistance), (height/2), (width/2)+parseInt(window.imageDistance), (height/2)-imageHeight, "red");
                }//will not draw anything if they are equal

                //P-ray - same for before and after focal point
                canvas.drawLine((width/2)-parseInt(window.objectDistance), (height/2)-objectHeight, width/2, (height/2)-objectHeight, "blue", 1);

                //C-ray - Same for before and after focal point
                canvas.drawLine((width/2)-parseInt(window.objectDistance), (height/2)-objectHeight, (width/2)+3*parseInt(window.objectDistance), (height/2)+3*objectHeight, "green", 1);

                if(parseInt(window.imageDistance) < 0){//F-ray depends on position relative to focal point. Also add the virtual rays******************************************************
                    //Virtual part of C-ray:
                    canvas.drawLine((width/2)-parseInt(window.objectDistance), (height/2)-objectHeight, (width/2)-2*(window.objectDistance), (height/2)-2*(objectHeight), "green", 0.25);

                    //Virtual part of P-ray:
                    canvas.drawLine(width/2, (height/2)-objectHeight, (width/2)+parseInt(window.imageDistance), (height/2)-imageHeight, "blue", 0.25);
                    canvas.drawLine(width/2, (height/2)-objectHeight, (width/2)+parseInt(window.f), (height/2), "blue", 1);

                    //F-ray
                    canvas.drawLine((width/2)-parseInt(window.objectDistance), (height/2)-objectHeight, (width/2)-window.f, (height/2), "purple", 0.25);
                    canvas.drawLine((width/2)-parseInt(window.objectDistance), (height/2)-objectHeight, width/2, (height/2)-imageHeight, "purple", 1);
                    canvas.drawLine((width/2), (height/2)-imageHeight, (width/2)+parseInt(window.f), (height/2)-imageHeight, "purple", 1);
                    canvas.drawLine(width/2, (height/2)-imageHeight, (width/2)+parseInt(window.imageDistance), (height/2)-imageHeight, "purple", 0.25);
                }else{
                    //F-ray when farther from focal point
                    canvas.drawLine((width/2)-window.objectDistance, (height/2)-objectHeight, (width/2), (height/2)-imageHeight, "purple", 1);
                    canvas.drawLine((width/2), (height/2)-imageHeight, (width/2)+1.5*parseInt(window.imageDistance), (height/2)-imageHeight, "purple", 1);

                    //P-ray
                    canvas.drawLine(width/2, (height/2)-objectHeight, (width/2)+(window.imageDistance), (height/2)+2*objectHeight, "blue", 1);
                }
            }else if(window.device == "Diverging Mirror"){
                if(parseInt(window.objectDistance) > parseInt(window.imageDistance)){
                    //object
                    canvas.arrowTo((width/2)-window.objectDistance, (height/2), (width/2)-window.objectDistance, (height/2)-objectHeight, "red");
                    //image
                    ctx.globalAlpha = 0.5;
                    canvas.arrowTo((width/2)+parseInt(window.imageDistance), (height/2), (width/2)+parseInt(window.imageDistance), (height/2)+imageHeight, "red");
                    ctx.globalAlpha = 1;

                    //P-ray
                    canvas.drawLine((width/2)-window.objectDistance, (height/2)-objectHeight, width/2, (height/2)-objectHeight, "blue", 1);
                    //F-ray
                    canvas.drawLine((width/2)-window.objectDistance, (height/2)-objectHeight, (width/2), (height/2)+imageHeight, "purple", 1);
                    //C-ray
                    canvas.drawLine((width/2)-window.objectDistance, (height/2)-objectHeight, (width/2), (height/2), "green", 1);
                    if(parseInt(window.imageDistance) < 0){
                        //P-Ray
                        canvas.drawLine(width/2, (height/2)-objectHeight, (width/2)-2*window.f, (height/2)+objectHeight, "blue", 1);
                        canvas.drawLine(width/2, (height/2)-objectHeight, (width/2)+window.f, (height/2)-2*objectHeight, "blue", 0.25);

                        //F-ray
                        canvas.drawLine((width/2), (height/2)+imageHeight, (width/2)+2*parseInt(window.imageDistance), (height/2)+imageHeight, "purple", 1);
                        canvas.drawLine((width/2), (height/2)+imageHeight, (width/2)-2*parseInt(window.imageDistance), (height/2)+imageHeight, "purple", 0.25);

                        //C-ray
                        canvas.drawLine((width/2), (height/2), (width/2)+2*parseInt(window.imageDistance), (height/2)+2*imageHeight, "green", 1);
                        canvas.drawLine((width/2), (height/2), (width/2)-2*parseInt(window.imageDistance), (height/2)-2*imageHeight, "green", 0.25);
                    }else if(parseInt(window.imageDistance) > 0){
                        //P-Ray
                        canvas.drawLine(width/2, (height/2)-objectHeight, (width/2)-2*window.f, (height/2)+objectHeight, "blue", 0.25);
                        canvas.drawLine(width/2, (height/2)-objectHeight, (width/2)+window.f, (height/2)-2*objectHeight, "blue", 1);
                        //F-ray
                        canvas.drawLine((width/2), (height/2)+imageHeight, (width/2)+2*parseInt(window.imageDistance), (height/2)+imageHeight, "purple", 0.25);
                        canvas.drawLine((width/2), (height/2)+imageHeight, (width/2)-2*parseInt(window.imageDistance), (height/2)+imageHeight, "purple", 1);
                        //C-ray
                        canvas.drawLine((width/2), (height/2), (width/2)+2*parseInt(window.imageDistance), (height/2)+2*imageHeight, "green", 0.25);
                        canvas.drawLine((width/2), (height/2), (width/2)-2*parseInt(window.imageDistance), (height/2)-2*imageHeight, "green", 1);
                    }
                }
            }else if(window.device == "Converging Mirror"){
                //object
                canvas.arrowTo((width/2)-window.objectDistance, (height/2), (width/2)-window.objectDistance, (height/2)-objectHeight, "red");

                //image
                if(parseInt(window.imageDistance) < 0){
                        ctx.globalAlpha = 0.5;
                        canvas.arrowTo((width/2)-parseInt(window.imageDistance), (height/2), (width/2)-parseInt(window.imageDistance), (height/2)-imageHeight, "red");
                        ctx.globalAlpha = 1;
                }else if(parseInt(window.imageDistance) > 0){
                    ctx.globalAlpha = 0.5;
                    canvas.arrowTo((width/2)-parseInt(window.imageDistance), (height/2), (width/2)-parseInt(window.imageDistance), (height/2)-imageHeight, "red");
                    ctx.globalAlpha = 1;
                }

                //main part of C-ray
                canvas.drawLine((width/2)-window.objectDistance, (height/2)-objectHeight, (width/2), (height/2), "green", 1);
                //main part of P-Ray
                canvas.drawLine((width/2)-window.objectDistance, (height/2)-objectHeight, width/2, (height/2)-objectHeight, "blue", 1);
                //main part of F-ray
                canvas.drawLine((width/2)-window.objectDistance, (height/2)-objectHeight, (width/2), (height/2)-imageHeight, "purple", 1);
                if(parseInt(window.imageDistance) > 0){
                    //C-ray
                    canvas.drawLine((width/2), (height/2), (width/2)+2*parseInt(window.imageDistance), (height/2)+2*imageHeight, "green", 0.25);
                    canvas.drawLine((width/2), (height/2), (width/2)-2*parseInt(window.imageDistance), (height/2)-2*imageHeight, "green", 1);

                    //P-ray
                    canvas.drawLine(width/2, (height/2)-objectHeight, (width/2)-parseInt(window.imageDistance), (height/2)-imageHeight, "blue", 1);

                    //F-ray
                    canvas.drawLine((width/2), (height/2)-imageHeight, (width/2)-parseInt(window.imageDistance), (height/2)-imageHeight, "purple", 1);
                }else if(parseInt(window.imageDistance) < 0){
                    //C-ray
                    canvas.drawLine((width/2), (height/2), (width/2)+2*parseInt(window.imageDistance), (height/2)+2*imageHeight, "green", 1);
                    canvas.drawLine((width/2), (height/2), (width/2)-2*parseInt(window.imageDistance), (height/2)-2*imageHeight, "green", 0.25);

                    //P-ray
                    canvas.drawLine(width/2, (height/2)-objectHeight, (width/2)-parseInt(window.imageDistance), (height/2)-imageHeight, "blue", 0.25);
                    canvas.drawLine((width/2), (height/2)-objectHeight, (width/2)-window.f, (height/2), "blue", 1);

                    //F-ray
                    canvas.drawLine((width/2), (height/2)-imageHeight, (width/2)-parseInt(window.imageDistance), (height/2)-imageHeight, "purple", 0.25);
                    canvas.drawLine((width/2), (height/2)-imageHeight, (width/2)+parseInt(window.imageDistance), (height/2)-imageHeight, "purple", 1);
                }
            }

            ctx.strokeStyle = "black";
        }
        MouseArea{
            anchors.fill: parent
            onPressed: {
                canvas.requestPaint();
            }
        }
    }
    Row{
        id: parameters;
        anchors{
            bottom: parent.bottom;
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 20
        }

        Column{
            Text{
                text: "Object Distance (p)"

                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            TextField{
                id: inputP
                width: 200
                inputMethodHints: Qt.ImhDigitsOnly

                background: Rectangle{
                    color: window.bg;
                    border.color: "black";
                }

                onTextChanged: {
                    if(window.solve != "Solve for p"){
                        if(parseInt(text) == parseInt(window.f) || parseInt(text) <= 0){//object distance cannot equal the focal point or there will be no image and it can't be <= 0
                            window.bg = "red";
                        }else{
                            window.bg = "white";
                            window.objectDistance = text;
                            timer.start();
                        }
                    }
                }
            }
        }
        Column{
            Text{
                text: "Image Distance (q)"

                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            TextField{
                id: inputQ
                width: 200
                inputMethodHints: Qt.ImhDigitsOnly

                background: Rectangle{
                    color: "white";
                    border.color: "black";
                }

                onTextChanged: {
                    if(window.solve != "Solve for q"){
                        window.imageDistance = text;
                    }
                    timer.start();
                }
            }
        }
        Column{
            Text{
                text: "Focal Point (f)"

                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            TextField{
                id: inputF
                width: 200
                inputMethodHints: Qt.ImhDigitsOnly

                background: Rectangle{
                    color: window.bg;
                    border.color: "black";
                }

                onTextChanged: {
                    if(window.solve != "Solve for f"){
                        if(parseInt(text) == parseInt(window.objectDistance) || parseInt(text) == 0){//object distance cannot equal the focal point or there will be no image adn it can't be 0
                            window.bg = "red";
                        }else{
                            window.bg = "white";
                            window.f = text;
                            timer.start();
                        }
                    }
                }
            }
        }
    }
    Timer{
        id: timer
        interval: 10
        repeat: false
        onTriggered: {
            canvas.requestPaint();
        }
    }
}
