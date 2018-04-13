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

// OpenPose Demo:
// Receive OSC messages from Runway
// running the OpenPose model

// Cristóbal Valenzuela
// March 2018
// cv965@nyu.edu


// Import OSC
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

// This array will hold all the humans detected
JSONArray humans;

// This are the pair of body connections we want to form. 
// Try creating new ones!
String[][] connections = {
  {"Nose", "Left_Eye"},
  {"Left_Eye", "Left_Ear"},
  {"Nose", "Right_Eye"},
  {"Right_Eye", "Right_Ear"},
  {"Nose", "Neck"},
  {"Neck", "Right_Shoulder"},
  {"Neck", "Left_Shoulder"},
  {"Right_Shoulder", "Right_Elbow"},
  {"Right_Elbow", "Right_Wrist"},
  {"Left_Shoulder", "Left_Elbow"},
  {"Left_Elbow", "Left_Wrist"},
  {"Neck", "Right_Hip"},
  {"Right_Hip", "Right_Knee"},
  {"Right_Knee", "Right_Ankle"},
  {"Neck", "Left_Hip"},
  {"Left_Hip", "Left_Knee"},
  {"Left_Knee", "Left_Ankle"}
};

void setup() {
  size(500, 500);
  frameRate(25);
  // Use the localhost and the port 57200 that we define in Runway
  oscP5 = new OscP5(this, 57200);
  fill(255);
  stroke(255);
}

void draw() {
  background(0);
  // Choose between drawing just an ellipse
  // over the body parts or drawing connections
  // between them. or both!
  drawParts();
  drawConnections();
}

// A function to draw humans body parts as circles
void drawParts() {
  // Only if there are any humans detected
  if (humans != null) {
    for(int h = 0; h < humans.size(); h++) {
      JSONArray human = humans.getJSONArray(h);
      // Now that we have one human, let's draw its body parts
      for (int b = 0; b < human.size(); b++) {
        JSONArray body_part = human.getJSONArray(b);
        // Body parts are relative to width and weight of the input
        float x = body_part.getFloat(1);
        float y = body_part.getFloat(2);
        ellipse(x*width, y*height, 10, 10);
      }
    }
  }
}

// A function to draw connection between body parts
void drawConnections() {
  // Only if there are any humans detected
  if (humans != null) {
    for(int h = 0; h < humans.size(); h++) {
      JSONArray human = humans.getJSONArray(h);
      // Now that we have a human, let's draw its body 
      // connections start by looping through all body
      // connections and matching only the ones we need.
      for(int c = 0; c < connections.length; c++){
        JSONArray start = new JSONArray();
        JSONArray end = new JSONArray();
        // Check if we have a pair in the current body parts
        for(int b = 0; b < human.size(); b++) {
          JSONArray body_part = human.getJSONArray(b);
          String name = body_part.getString(0);
          if (name.equals(connections[c][0])){
            start = body_part;
          } else if (name.equals(connections[c][1])){
            end = body_part;
          }
        }
        if (start.size() > 0 && end.size() > 0){
          float x1 = start.getFloat(1)*width;
          float y1 = start.getFloat(2)*height;
          float x2 = end.getFloat(1)*width;
          float y2 = end.getFloat(2)*height;
          line(x1, y1, x2, y2);
        }
      }
    }
  }
}

// OSC Event: listens to data coming from Runway
void oscEvent(OscMessage theOscMessage) {
  // The data is in a JSON string, so first we get the string value
  String data = theOscMessage.get(0).stringValue();
  // We then parse it as a JSONObject
  JSONObject json = parseJSONObject(data);
  // From the JSONObject we want the key with the results
  JSONObject results = json.getJSONObject("results");
  // results holds an array of humans
  humans = results.getJSONArray("humans");
}