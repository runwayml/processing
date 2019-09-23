// Copyright (C) 2019 Runway ML Examples
// 
// This file is part of Runway ML Examples.
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
// along with Runway.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAYML
// www.runwayml.com

// Face Landmarks Demo:
// Receive HTTP Data from Runway
// Running Face Landmarks model
// Made by Joel Matthys @jwmatthys


final String httpDataRoute = "http://localhost:8000/data"; // set to the Runway HTTP route

void setup() {
  size (600, 400);
  noFill();
  stroke(0);
}

void draw ()
{      
  if (false) background(255); // change false to true if you don't want trails
  else {
    fill(255, 15);
    rect(0, 0, width, height);
    noFill();
  }
  JSONObject json = loadJSONObject(httpDataRoute);
  JSONArray landmarks = json.getJSONArray("points");
  if (landmarks != null)
  {
    for (int k = 0; k < landmarks.size(); k++) {
      // Body parts are relative to width and weight of the input
      JSONArray point = landmarks.getJSONArray(k);
      float x = point.getFloat(0);
      float y = point.getFloat(1);
      ellipse(x * width, y * height, 10, 10);
    }
  }
}
