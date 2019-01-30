final String httpDataRoute = "http://localhost:8000/data"; // set to the Runway HTTP route
int w, h;

void setup() {
  size (600, 400);
  JSONObject json = loadJSONObject(httpDataRoute);
  JSONObject data = json.getJSONObject("data");
  JSONObject size = data.getJSONObject("size");
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
  JSONObject data = json.getJSONObject("data");
  JSONArray landmarks = data.getJSONArray("landmarks");
  if (landmarks != null)
  {
    int num_people = landmarks.size();
    JSONObject person[] = new JSONObject[landmarks.size()];
    for (int i = 0; i < num_people; i++)
    {
      person[i] = landmarks.getJSONObject(i);
      plotPoints( person[ i ].getJSONArray("bottom_lip"));
      plotPoints( person[ i ].getJSONArray("top_lip"));
      plotPoints( person[ i ].getJSONArray("chin"));
      plotPoints( person[ i ].getJSONArray("left_eye"));
      plotPoints( person[ i ].getJSONArray("left_eyebrow"));
      plotPoints( person[ i ].getJSONArray("right_eye"));
      plotPoints( person[ i ].getJSONArray("right_eyebrow"));
      plotPoints( person[ i ].getJSONArray("nose_tip"));
      plotPoints( person[ i ].getJSONArray("nose_bridge"));
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
