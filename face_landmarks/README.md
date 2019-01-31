<p align="center">
  <img src="https://runway.nyc3.digitaloceanspaces.com/assets/github/cover_runway_processing_github.jpg">
</p>

# Tracking Face Landmarks with Runway and Processing

This tutorial demonstrates how to track facial features in a Processing sketch by making http requests in real-time with Runway running the Face Landmarks model.

### Requirements

* Runway Beta
* Processing

## Step 1

In this tutorial, we will use Face Landmarks, part of Davis E. King's dlib library. First, open Runway and select the Face Landmarks model. Download it and add it to a new Workspace.

## Step 2

In the Choose Input Source section, click on Input and choose Camera. This will activate your webcam.

## Step 3

In the Choose Output section, click on Output and choose HTTP. This will tell Runway to direct the output to a local webpage which Processing will query to get the data.

Take note of the address listed in the Routes box. You'll need this for Steps 6 and 8. It will probably be something like ```http://localhost:8001/data```.

## Step 4

With the Input and Output now selected, click Run Face Landmarks in the bottom right hand side of the Runway app.

## Step 5

You should see a running stream of data in the JSON section of the Runway app, as well as a pulsing progress bar at the bottom of the camera image. These indicate that the Face Landmarks model is running in Runway, and it should be sending its data to the address listed in the Routes box in step 3.

## Step 6 (optional)

To see that the data is being transferred to a webpage, open your browser and navigate to the http address from step 3. You'll need the full address, including the number after the colon and the ```/data``` part.

When you enter that address into your browser you should see a JSON object listing all of the data being sent. The data will change if you click the refresh button on your browser.

You may go ahead and close your browser.

## Step 7

Open Processing. Since JSON decoding and RESTful http queries are built into Processing, you do not need to install any external libraries.

In Processing, go to File->Open, navigate to the Runway+Processing directory and open ```face_landmarks.pde```.

## Step 8

The first two lines of the Processing code set up the http address of the data in a string, and the width and height of the webcam image in int variables.

```
final String httpDataRoute = "http://localhost:8001/data";
int w, h;
```

In line 1 of the Processing code, change the string to match the http route from step 3. You probably only have to change the port number.

The setup function creates a 600x400 pixel canvas and queries the http server for the width and height of the Runway camera data. It also sets some basic drawing parameters.

```java
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
```

The first part of the draw code clears the screen. If you change the ```false``` to ```true```, it will execute the simple ```background(255);``` every frame. Otherwise it will draw a rectangle with slight transparency, creating the effect of trails.

```java
if (false) background(255); // change false to true if you don't want trails
else {
  fill(255, 15);
  rect(0, 0, width, height);
  noFill();
}
```

#### JSON Objects and Arrays

Runway's output data is encoded into a series of JSONObjects and JSONArrays.

JSONObjects are enclosed in curly brackets and indexed with keys in quotes:

```
{"height":400,"width":600}
```

JSONArrays are enclosed in square brackets and make up a comma-separated list which are indexed by number (starting at 0).

```
[25,200,16.3,3.14159265]
```

JSONObjects and JSONArrays are often nested within other JSONObjects or JSONArrays.

The data from Face Landmarks has the following JSON structure:

```java
{"data":
  {"landmarks":
    [
      {"bottom_lip":
        [
          [x,y] pairs for each bottom_lip point
        ]
      }
    ],
    [ (landmark data from additional people, if any)
    ], etc.
  }
  {"size":
    {
      "height":
      "width":
    }
  }
}
```

The following Processing code extracts the landmarks into a JSONArray:

```
JSONObject json = loadJSONObject(httpDataRoute);
JSONObject data = json.getJSONObject("data");
JSONArray landmarks = data.getJSONArray("landmarks");
```

Since the number of people in the frame may vary, we check to see how many people there are (ie how long the landmarks array is) and iterate over the landmarks array.

```java
if (landmarks != null)
{
  int num_people = landmarks.size();
  for (int i = 0; i < num_people; i++)
  {
    JSONObject person = landmarks.getJSONObject(i);
```

Let's skip to the end for a moment. Each facial feature consists of an array of [x,y] points. For this example, we'll draw them all the same way, so let's create a plotPoints() function to handle this.

```
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
```

Now back in the draw() function we can call the plotPoints() function on each feature:

```java
plotPoints( person.getJSONArray("bottom_lip"));
plotPoints( person.getJSONArray("top_lip"));
plotPoints( person.getJSONArray("chin"));
plotPoints( person.getJSONArray("left_eye"));
plotPoints( person.getJSONArray("left_eyebrow"));
plotPoints( person.getJSONArray("right_eye"));
plotPoints( person.getJSONArray("right_eyebrow"));
plotPoints( person.getJSONArray("nose_tip"));
plotPoints( person.getJSONArray("nose_bridge"));
```

## Step 9

In Processing, press the Run button. Processing will now draw an outline of your face from the data sent by Runway.

Now go make it your own! Try changing the plotPoints() function, or implement some interaction between the different parts of the face.

## Summary

This tutorial shows how to use JSON http queries in Processing to receive and visualize live data from the Face Landmarks model in Runway Beta.
