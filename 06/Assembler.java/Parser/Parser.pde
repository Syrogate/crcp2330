/*Pareser class*/

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.NumberFormat;
import java.text.ParsePosition;

class Parse {
  private String sFile;  //reading line by line from file
  public String sFileArr[];  //string array
  public static String currComm;//line in string array
  public int lineCount; //line counter
  public BufferedReader bReader; //import reader library
  public static commandType comType;  //A,C,L Command
  public static int symbolValue  = 16; //symbol value


  //Opens the input file and gets ready to parse it 
  Parse(String exFileName) {
    lineCount = 0;//init's line count
    //file IO fstream logic
    FileInputStream fstream = null; 
    try {
      fstream = new FileInputStream(exFileName); //writes the input 
    } 
    catch (FileNotFoundException ex) {
      ex.printStackTrace(); //outputs to screen
    }
    //converts to string
    int data;
    try {
      while ((data = fstream.read()) != -1) {
        sFile += (char) data;   // convert to char and display it
      }
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
    // Get the object of DataInputStream
    DataInputStream in = new DataInputStream(fstream);
    //load input stream reader into buffered reader IO 
    bReader = new BufferedReader(new InputStreamReader(in));
    //clears excess file data
    //sFile = removeComments(sFile);
    //copies string to string array
    sFileArr = sFile.split("\n");
    //trim unnecessary lines 
    for (int i=0; i < sFileArr.length; i++) {
      sFileArr[i] =  sFileArr[i].trim();
    }
  }

  //handles longer commands
  public boolean hasMoreCommand() {
    if (lineCount != sFileArr.length) return true; //logic loop to find if line has more data
    return false;
  }

  //reads next command
  public void advance()
  {
    lineCount++;
  }

  //Returns type of current command
  public commandType commandType()
  {
    if (sFileArr[lineCount].startsWith("(")) //logic check for L command
    {
      return comType = commandType.L_COMMAND;
    } else if (sFileArr[lineCount].startsWith("@")) //logic check for A command
    {
      return comType = commandType.A_COMMAND;
    }
    return commandType.C_COMMAND; //logic check for C command
  }
  
  //command type, enums
  enum commandType {
    A_COMMAND, L_COMMAND, C_COMMAND
  }
  
  //symbol class
  public String symbol()
  {
    String retLable = "";
    //logic loop for A instructions
    if (sFileArr[lineCount].startsWith("@"))
    {
      retLable = sFileArr[lineCount]; //linecounter in the file array generating data
      retLable = retLable.replaceAll("@", ""); //replace the A instruction w/ memory address
    } else 
    if (sFileArr[lineCount].startsWith("(")) //format syntax
    {
      retLable = sFileArr[lineCount]; //linecounter again
      retLable = retLable.replaceAll("\\((.*?)\\)", "$1"); //ignore white space in text file
    }
    return retLable;
  }

  //comp class
  public String comp() {
    String retComp = sFileArr[lineCount]; //count digits used for comp combinations
    if (sFileArr[lineCount].contains("=")) //delmits the index 
    {
      int endIndex = retComp.lastIndexOf("="); //check comop index
      retComp =  retComp.substring(endIndex+1, retComp.length()); //check index and next bit
    } else if (sFileArr[lineCount].contains(";")) //delimit the index
    {
      int endIndex = retComp.lastIndexOf(";"); //delimit the index
      retComp =  retComp.substring(0, endIndex); //reset substring to the end of comp index
    }
    return retComp;
  }
  //dest class
  public String dest() {
    if (sFileArr[lineCount].contains("=")) {
      String retDest = sFileArr[lineCount]; //count digits used for dest combinations
      int endIndex = retDest.lastIndexOf("="); //check dest index
      retDest =  retDest.substring(0, endIndex); //reset substring to the end of dest index
      return retDest;
    }
    return null;
  }
  //jump class
  public String jump() {
    if (sFileArr[lineCount].contains(";")) //delimits the class
    {
      String retJump = sFileArr[lineCount]; //count digits used for jump combinations
      int endIndex = retJump.lastIndexOf(";"); //check jump index
      return retJump.substring(endIndex+1, retJump.length()); //output 
    }
    return null;
  }

}
