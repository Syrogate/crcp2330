/*Assembler class includes main*/
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;


void setup() {
  int counter=0;
  int nextRam = 16;
  String compT, destT, jumpT; // temp's

  //Assemble(SymTable, Mapping, Parse) {}

  String name = args[counter].substring(counter, args[counter].indexOf('.'));  //copies name of existing file without the file type

  String outFileName = name+".hack";  //out file name

  SymbolTable st = new SymbolTable(); //init's symbol table

  Code mp = new Code();  //init's code tables

  Parser newParser = new Parser(args[0]);  //new parse objemp

  File out = new File(outFileName);  //output, .hack file

  FileWriter fw = null;
  try {
    fw = new FileWriter(out.getAbsoluteFile());
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
  BufferedWriter bw = new BufferedWriter(fw); // Ready to write on file

  //first pass
  while (newParser.hasMoreCommand()) {  
    if (newParser.commandType()== newParser.commandType().L_COMMAND) { 
      st.addEntry(newParser.symbol(), Integer.toString(counter)) ; //adds new symbol to symbol table
    } else counter++; //next line
    newParser.advance();  // next command
  }
  newParser.lineCount =0;   // resets counter for starts from first line

  //second pass
  while (newParser.hasMoreCommand())
  {
    if (newParser.commandType()== newParser.commandType().A_COMMAND) //@xxx
    {
      if (newParser.sFileArr[newParser.lineCount].startsWith("@"))
      {
        String tmp  = newParser.symbol(); //returns xxx
        if (newParser.isNum(tmp))  //checks if xxx is number
        {
          int xxx = Integer.parseInt(tmp);
          tmp = newParser.dexToBin(xxx);  // return bin value of xxx
          tmp = newParser.addZero(tmp);
          try {
            bw.write(tmp + '\n');//write to hack
          } 
          catch (IOException e) {
            e.printStackTrace();
          }
        } else  //if not number
        {
          if (!st.containKey(tmp))  // not exists in Symbol Table
          {
            st.addEntry(tmp, Integer.toString(nextRam));  //Adds to Symbol Table
            nextRam++;
          }
          if (st.containKey(tmp)) // already exists in Symbol Table
          {
            String tmp2 = st.getValue(tmp);
            int xxx = Integer.parseInt(tmp2);
            tmp2 = newParser.dexToBin(xxx);
            tmp2 = newParser.addZero(tmp2);
            try {
              bw.write(tmp2+'\n');  //write to hack
            } 
            catch (IOException e) {
              e.printStackTrace();
            }
          }
        }
      }
    }//if command type A_COMMAND 
    if (newParser.commandType()== newParser.commandType().C_COMMAND)
    {
      if (newParser.sFileArr[newParser.lineCount].contains("="))//dest=comp
      {
        destT = mp.getDest(newParser.dest());
        compT = mp.getComp(newParser.comp());
        jumpT = mp.getJump("NULL");  //no need jump
        try {
          bw.write("111" + compT + destT + jumpT +'\n');
        } 
        catch (IOException e) {
          e.printStackTrace();
        }
      } else if (newParser.sFileArr[newParser.lineCount].contains(";")) //jump
      {
        destT = mp.getDest("NULL"); // no need dest
        compT = mp.getComp(newParser.comp());
        jumpT = mp.getJump(newParser.jump());

        try {
          bw.write("111" + compT + destT + jumpT +'\n');
        } 
        catch (IOException e) {
          e.printStackTrace();
        }
      }
    }//if command type C_COMMAND 
    newParser.advance();
  }//end while

  try {
    bw.close();
  } 
  catch (IOException e) {
    e.printStackTrace();
  }
}