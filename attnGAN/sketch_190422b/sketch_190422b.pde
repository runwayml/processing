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
// along with RunwayML.  If not, see <http://www.gnu.org/licenses/>.
// 
// ===========================================================================

// RUNWAY
// www.runwayapp.ai

// AttnGAN Demo
// Send OSC text messages to Runway and generate images

// Import OSC
import oscP5.*;
import netP5.*;

// The caption to send
String data = "{ \"caption\": \"a blue ocean\"}";

// Runway Host
String runwayHost = "127.0.0.1";

// Runway Port
int runwayPort = 57111;

OscP5 oscP5;
NetAddress myBroadcastLocation;

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
}

void draw() {
  background(0);
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
      println("Connect to Runway");
      connect();
      break;
    case('d'):
      /* disconnect from Runway */
      println("Disconnect from Runway");
      disconnect();
      break;
    case('s'):
      println("Sending Data");
      OscMessage myMessage = new OscMessage("/query");
      myMessage.add(data);
      oscP5.send(myMessage, myBroadcastLocation);
      break;
  }
}
