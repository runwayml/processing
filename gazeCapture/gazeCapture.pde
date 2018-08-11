// Copyright (C) 2018 Cristobal Valenzuela
// 
// This file is part of RunwayML.
// 
// RunwayML is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// RunwayML is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with RunwayML.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAY
// www.runwayml.com

// GazeCapture Demo:
// Receive OSC messages from Runway
// running the GazeCapture model

// Gene Kogan
// August 2018
// genekogan.com


// Import OSC
import oscP5.*;
import netP5.*;
import processing.video.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Capture cam;

// This will store detected objects coming from Runway
int camWidth, camHeight;
PVector gaze;

void setup() {
  size(640, 480);
  frameRate(25);
  
  // for scaling object bounding boxes
  camWidth = 640;
  camHeight = 480;  
  
  // vector to hold gaze
  gaze = new PVector(0, 0);
  
  // Use the localhost and the port 57200 that we define in Runway
  oscP5 = new OscP5(this, 57200);
  
  // Get all cameras
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
   } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
   }
  // The camera can be initialized directly using an 
  // element from the array returned by list():
  cam = new Capture(this, camWidth, camHeight);
  cam.start();
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  
  // Draw the camera
  fill(255);
  image(cam, 0, 0);

  // draw gaze point. note (0,0) is the center of the screen
  fill(0, 255, 0);
  ellipse(width/2 + 20 * gaze.x, height/2 - 20 * gaze.y, 30, 30);
}

// OSC Event: listens to data coming from Runway
void oscEvent(OscMessage theOscMessage) {
  // The data is in a JSON string, so first we get the string value
  String data = theOscMessage.get(0).stringValue();
  // We then parse it as a JSONObject
  JSONObject json = parseJSONObject(data);

  // From the JSONObject we want the key with the results
  if (!json.hasKey("results")) {
    return;
  }
  JSONObject results = json.getJSONObject("results");
  JSONArray gazes = results.getJSONArray("estimated_gazes");
  for (int i=0; i<gazes.size(); i++) {
    JSONArray g = gazes.getJSONArray(0);
    float x = g.getFloat(0);
    float y = g.getFloat(1);
    gaze.set(x, y);
  }
  
}