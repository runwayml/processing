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

// YOLO Demo:
// Receive OSC messages from Runway
// running the YOLO model

// Gene Kogan
// April 2018
// genekogan.com


// Import OSC
import oscP5.*;
import netP5.*;
import processing.video.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
Capture cam;

// This will store detected objects coming from Runway
ArrayList<DetectedObject> objects;
int camWidth, camHeight;

void setup() {
  size(640, 480);
  frameRate(25);
  
  // for scaling object bounding boxes
  camWidth = 640;
  camHeight = 480;  
  
  // Use the localhost and the port 57200 that we define in Runway
  oscP5 = new OscP5(this, 57200);
  
  // instantiate object list  
  objects = new ArrayList<DetectedObject>();

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
  image(cam, 0, 0);

  // Draw the captions
  for (DetectedObject o : objects) {
    o.draw();
  }
  
}

// Helper class for storing objects
class DetectedObject 
{
  String category;
  float score;
  float x, y, w, h;
  
  DetectedObject(String category, float score, float x, float y, float w, float h) {
    this.category = category;
    this.score = score;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void draw() {
    pushMatrix();
    pushStyle();
    
    translate(camWidth*x, camHeight*y);
    noFill();
    stroke(255);
    strokeWeight(3);
    rect(0, 0, camWidth*w, camHeight*h);
    
    fill(0, 150);
    noStroke();
    rect(0, 0, 100, 20);
    fill(255);    
    textSize(16);
    text(category, 2, 17);
    
    popStyle();
    popMatrix();
  }
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
  JSONArray results = json.getJSONArray("results");
  
  // We create a new ArrayList of objects instead of overwriting the current one, to avoid modifying it while it's being drawn
  ArrayList newObjects = new ArrayList<DetectedObject>();
  
  // Get each of the objects
  for (int i=0; i<results.size(); i++) {
    JSONObject obj = results.getJSONObject(i);
    
    // Get category and score
    String category = obj.getString("cat");
    float score = obj.getFloat("score");

    // Get bounding box (normalized between 0 and 1
    JSONArray bounds = obj.getJSONArray("bounds");
    float x = bounds.getFloat(0);
    float y = bounds.getFloat(1);
    float w = bounds.getFloat(2);
    float h = bounds.getFloat(3);
    
    DetectedObject object = new DetectedObject(category, score, x, y, w, h);
    newObjects.add(object);
  }
  
  // overwrite the list
  objects = newObjects;
}

 