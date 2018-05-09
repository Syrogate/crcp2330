/*Assembler class includes main*/
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

class Assemble {
  public int counter=0;
  public int nextRam = 16;
  public String compT, destT, jumpT; // temp's
  public void main(String[] args) {
   
    Assemble(SymTable, Mapping, Parse) {}
    
    String name = args[0].substring(0, args[0].indexOf('.'));  //copies name of existing file without the file type

    String outFileName = name+".hack";  //out file name
    
    SymTable st = new SymTable(); //init's symbol table

    Mapping mp = new Mapping();  //init's code tables

    Parse newParse = new Parse(args[0]);  //new parse objemp

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
    while (newParse.hasMoreCommand()) {  
      if (newParse.commandType()== newParse.commandType.L_COMMAND) { 

        st.addEntry(newParse.symbol(), Integer.toString(counter)) ; //adds new symbol to symbol table
      } else counter++; //next line

      newParse.advance();  // next command
    }
    newParse.lineCount =0;   // resets counter for starts from first line

    //second pass
    while (newParse.hasMoreCommand())
    {
      if (newParse.commandType()== newParse.commandType.A_COMMAND) //@xxx
      {
        if (newParse.strFileArr[newParse.lineCount].startsWith("@"))
        {
          String tmp  = newParse.symbol(); //returns xxx
          if (newParse.isNum(tmp))  //checks if xxx is number
          {
            int xxx = Integer.parseInt(tmp);
            tmp = newParse.dexToBin(xxx);  // return bin value of xxx
            tmp = newParse.addZero(tmp);
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
              tmp2 = newParse.dexToBin(xxx);
              tmp2 = newParse.addZero(tmp2);
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
      if (newParse.commandType()== newParse.commandType.C_COMMAND)
      {
        if (newParse.strFileArr[newParse.lineCount].contains("="))//dest=comp
        {


          destT = mp.getDest(newParse.dest());
          compT = mp.getComp(newParse.comp());
          jumpT = mp.getJump("NULL");  //no need jump
          try {
            bw.write("111" + compT + destT + jumpT +'\n');
          } 
          catch (IOException e) {
            e.printStackTrace();
          }
        } else if (newParse.strFileArr[newParse.lineCount].contains(";")) //jump
        {
          destT = mp.getDest("NULL"); // no need dest
          compT = mp.getComp(newParse.comp());
          jumpT = mp.getJump(newParse.jump());

          try {
            bw.write("111" + compT + destT + jumpT +'\n');
          } 
          catch (IOException e) {
            e.printStackTrace();
          }
        }
      }//if command type C_COMMAND 
      newParse.advance();
    }//end while

    try {
      bw.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
}
