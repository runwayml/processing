// Copyright (C) 2019 RunwayML Examples
// 
// This file is part of RunwayML Examples.
// 
// Runway-Examples is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// Runway-Examples is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with RunwayML.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAYML
// www.runwayml.com

// PoseNet Demo:
// Receive OSC messages from Runway
// Running PoseNet model

// Import OSC
import oscP5.*;
import netP5.*;

// Runway Host
String runwayHost = "127.0.0.1";

// Runway Port
int runwayPort = 57100;

int width = 400;
int height = 350;

OscP5 oscP5;
NetAddress myBroadcastLocation;

// This array will hold all the humans detected
JSONObject data;
JSONArray humans;

// This are the pair of body connections we want to form. 
// Try creating new ones!
String[][] connections = {
  {"nose", "leftEye"},
  {"leftEye", "leftEar"},
  {"nose", "rightEye"},
  {"rightEye", "rightEar"},
  {"rightShoulder", "rightElbow"},
  {"rightElbow", "rightWrist"},
  {"leftShoulder", "leftElbow"},
  {"leftElbow", "leftWrist"}, 
  {"rightHip", "rightKnee"},
  {"rightKnee", "rightAnkle"},
  {"leftHip", "leftKnee"},
  {"leftKnee", "leftAnkle"}
};

void setup() {
  size(400, 350);
  frameRate(25);

  OscProperties properties = new OscProperties();
  properties.setRemoteAddress("127.0.0.1", 57200);
  properties.setListeningPort(57200);
  properties.setDatagramSize(99999999);
  properties.setSRSP(OscProperties.ON);
  oscP5 = new OscP5(this, properties);

  // Use the localhost and the port 57100 that we define in Runway
  myBroadcastLocation = new NetAddress(runwayHost, runwayPort);

  connect();

  fill(255);
  stroke(255);
}

void draw() {
  background(0);
  // Choose between drawing just an ellipse
  // over the body parts or drawing connections
  // between them. or both!
  drawParts();
}


// A function to draw humans body parts as circles
void drawParts() {
  // Only if there are any humans detected
  if (data != null) {
    humans = data.getJSONArray("poses");
    for(int h = 0; h < humans.size(); h++) {
      JSONArray keypoints = humans.getJSONArray(h);
      // Now that we have one human, let's draw its body parts
      for (int k = 0; k < keypoints.size(); k++) {
        // Body parts are relative to width and weight of the input
        JSONArray point = keypoints.getJSONArray(k);
        float x = point.getFloat(0);
        float y = point.getFloat(1);
        ellipse(x * width, y * height, 10, 10);
      }
    }
  }
}

void connect() {
  OscMessage m = new OscMessage("/server/connect");
  oscP5.send(m, myBroadcastLocation);
}

void disconnect() {
  OscMessage m = new OscMessage("/server/disconnect");
  oscP5.send(m, myBroadcastLocation);
}

void keyPressed() {
  switch(key) {
    case('c'):
      /* connect to Runway */
      connect();
      break;
    case('d'):
      /* disconnect from Runway */
      disconnect();
      break;

  }
}

// OSC Event: listens to data coming from Runway
void oscEvent(OscMessage theOscMessage) {
  if (!theOscMessage.addrPattern().equals("/data")) return;
  // The data is in a JSON string, so first we get the string value
  String dataString = theOscMessage.get(0).stringValue();

  // We then parse it as a JSONObject
  data = parseJSONObject(dataString);
}
