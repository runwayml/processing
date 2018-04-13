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

// im2txt Demo:
// Receive OSC messages from Runway
// running the im2text model

// Cristóbal Valenzuela
// March 2018
// cv965@nyu.edu


// Import OSC
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

// This will hold the caption coming from Runway
String caption = "";

void setup() {
  size(400, 400);
  frameRate(25);
  // Use the localhost and the port 57200 that we define in Runway
  oscP5 = new OscP5(this, 57200);
  // Some congifurations for the output text
  textSize(20);
}

void draw() {
  background(0);
  // Show the best result
  text(caption, 100, 150, 200, 400); 
}

// OSC Event: listens to data coming from Runway
void oscEvent(OscMessage theOscMessage) {
  // The data is in a JSON string, so first we get the string value
  String data = theOscMessage.get(0).stringValue();
  // We then parse it as a JSONObject
  JSONObject json = parseJSONObject(data);
  // From the JSONObject we want the key with the results
  JSONArray results = json.getJSONArray("results");
  // And from the array of captions (3) we want the first one
  JSONObject bestMatch = results.getJSONObject(0);
  // So we assign that caption to our global caption variable
  caption = bestMatch.getString("caption");
}

 