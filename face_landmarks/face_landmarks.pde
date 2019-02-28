// Copyright (C) 2018 Runway AI Examples
// 
// This file is part of Runway AI Examples.
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
// along with Runway AI Examples.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAY
// www.runwayapp.ai

// Face Landmarks Demo:
// Receive HTTP Data from Runway
// Running Face Landmarks model
// Made by Joel Matthys @jwmatthys


final String httpDataRoute = "http://localhost:8004/data"; // set to the Runway HTTP route
int w, h;

void setup() {
  size (600, 400);
  JSONObject json = loadJSONObject(httpDataRoute);
  JSONObject size = json.getJSONObject("size");
  println(size);
  w = size.getInt("width");
  h = size.getInt("height");
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
  JSONArray landmarks = json.getJSONArray("landmarks");
  if (landmarks != null)
  {
    int num_people = landmarks.size();
    for (int i = 0; i < num_people; i++)
    {
      JSONObject person = landmarks.getJSONObject(i);
      plotPoints( person.getJSONArray("bottom_lip"));
      plotPoints( person.getJSONArray("top_lip"));
      plotPoints( person.getJSONArray("chin"));
      plotPoints( person.getJSONArray("left_eye"));
      plotPoints( person.getJSONArray("left_eyebrow"));
      plotPoints( person.getJSONArray("right_eye"));
      plotPoints( person.getJSONArray("right_eyebrow"));
      plotPoints( person.getJSONArray("nose_tip"));
      plotPoints( person.getJSONArray("nose_bridge"));
    }
  }
}

void plotPoints(JSONArray feature)
{
  beginShape();
  for (int i = 0; i < feature.size(); i++)
  {
    JSONArray p = feature.getJSONArray(i);
    float x = map(p.getInt(0), 0, w, width, 0);
    float y = map(p.getInt(1), 0, h, 0, height);
    vertex (x, y);
  }
  endShape();
}
