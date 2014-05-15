// Running Texts
// Created by Ryan Tseng
// http://gogoprivateryan.blogspot.com

import processing.serial.*;
import spacebrew.*;

Serial myPort;  // Create object from Serial class
PFont f;

String server="sandbox.spacebrew.cc";
String name="GoGoPrivateRyan- Running Texts";
String description ="Listen from publisher to show running texts on LED matrix.";

String typing = ""; // Variable to store text currently being typed
String saved = ""; // Variable to store saved text when return is hit

// Keep track of our current place in the range
String remote_string = "";
String last_string = "";

Spacebrew sb;

void setup() 
{
  size(300,200);
  String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 9600);

  // instantiate the spacebrewConnection variable
  sb = new Spacebrew(this);
  // declare your subscribers
  sb.addSubscribe("input_strings", "string" );
  sb.addSubscribe("stock_strings", "boolean");
  // connect!
  sb.connect(server, name, description);
  
  f = createFont("Arial", 16, true);
}

void draw() 
{
  background(255);
  int indent = 10;
  
  // Set the font and fill for text
  textFont(f);
  fill(0);
  
  // draw instruction text
  text("Listen from publisher to show running \ntexts on LED matrix.", indent, 20);
  
  // draw latest received message
  text("\nMessage Received: ", indent, 70);  
  text(remote_string, 50, 130);  
}

void onStringMessage(String name, String value)
{
  println("got string message " + name + " : " + value);
  remote_string = value + " ";
  
  for (int i=0; i<remote_string.length(); i++)
    myPort.write(remote_string.charAt(i));    
}

void onBooleanMessage(String name, boolean value )
{
  println("got bool message " + name + " : " + value); 
  if (value)
    remote_string = "http://gogoprivateryan.blogspot.com ";
  else
    remote_string = "Hello, World. ";
    
  for (int i=0; i<remote_string.length(); i++)
    myPort.write(remote_string.charAt(i));    
}

void keyPressed() 
{
  // If the return key is pressed, save the String and clear it
  if (key == '\n' ) 
  {
    saved = typing;
    // A String can be cleared by setting it equal to ""
    typing = ""; 
    
    for (int i=0; i<saved.length(); i++)
      myPort.write(saved.charAt(i));    
  } 
  else 
  {
    // Otherwise, concatenate the String
    // Each character typed by the user is added to the end of the String variable.
    typing = typing + key; 
  }
}
