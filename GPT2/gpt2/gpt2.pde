// Copyright (C) 2018 Runway ML Examples
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
// along with Runway AI Examples.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================
// RUNWAY
// www.ruwnayml.com

// import controlp5
import controlP5.*;
//create controlP5 instance
ControlP5 cp5;

//import oscP5
import oscP5.*;
import netP5.*;

//create oscP5 instance
OscP5 oscP5;

String textValue = "";
String text_output;
JSONObject data;
JSONObject json_message;
String json_output;

// Runway Host
String runwayHost = "127.0.0.1";

// Runway Port
int runwayPort = 57100;

//set the network location
NetAddress myBroadcastLocation;
  

void setup() {
  //create canvas
  size(900,700);
  
  //define OSC properties
  OscProperties properties = new OscProperties();
  //define remote port. We'll be recieving OSC on this port
  properties.setRemoteAddress("127.0.0.1", 57200);
  properties.setListeningPort(57200);
  properties.setDatagramSize(99999999);
  properties.setSRSP(OscProperties.ON);
  oscP5 = new OscP5(this, properties);

  // Use the localhost and the port 57100 that we define in Runway
  myBroadcastLocation = new NetAddress(runwayHost, runwayPort);
  
  //create a font
  PFont font = createFont("arial",20);
  
  connect();
  
  cp5 = new ControlP5(this);
  //definetextField
  cp5.addTextfield("input")
     .setPosition(20,40)
     .setSize(200,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(0,255,0))
     ;
                  
     
  textFont(font);
}

void draw() {
  //create black background
  background(0);
  fill(255);
  
  //display the text we are writing to the screen
  text(cp5.get(Textfield.class,"input").getText(), 20,180);
  
  //get the returned results and display them on the interface
  text(textValue, 20,80);
   if(text_output != null){
    fill(255);
    stroke(255);
    textSize(12);
    text(text_output, 320, 10, 400, height);
   }
}


//connect to Runway via OSC
void connect() {
  OscMessage m = new OscMessage("/server/connect");
  oscP5.send(m, myBroadcastLocation);
}

//disconnect from Runway via OSC
void disconnect() {
  OscMessage m = new OscMessage("/server/disconnect");
  oscP5.send(m, myBroadcastLocation);
}

//clear the text field after input
void clear() {
  cp5.get(Textfield.class,"textValue").clear();
}

//send the text from ou interface to RunwayML
void input(String theText) {
  //ensure the message is sent to "query" channel
  OscMessage myMessage = new OscMessage("/query");
  //create json object
  json_message = new JSONObject();
  
  //add the text from the textfield and seed
  json_message.setString("prompt", theText);
  json_message.setInt("seed", 1);
  print(json_message);
  json_output = json_message.toString();

  myMessage.add(json_output);
  
  //send the message to RunwayML
  oscP5.send(myMessage, myBroadcastLocation); 
}


//recieve the message from RunwayML
void oscEvent(OscMessage theOscMessage) {  
  //ensure the message is coming from the "data" channel
  if(theOscMessage.checkAddrPattern("/data")==true) {
    String dataString = theOscMessage.get(0).stringValue();
     print(dataString);
     
    //parse the json 
    data = parseJSONObject(dataString);
    //get the value of the "text" key
    text_output = data.getString("text");
    return;
  } 
  println("### received an osc message. with address pattern "+theOscMessage.addrPattern());
}
