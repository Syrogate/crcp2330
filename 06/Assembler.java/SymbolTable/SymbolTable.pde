/*  Symbol table class */
import java.util.Map;
import java.util.TreeMap;

class SymTable {

  private Map<String, String> symbol;
   
  public SymTable() {
      symbol = new TreeMap<String,String>();
     
      //Symbol Table filled in
      symbol.put("R0", "0");
      symbol.put("R1", "1");
      symbol.put("R2", "2");
      symbol.put("R3", "3");
      symbol.put("R4", "4");
      symbol.put("R5", "5");
      symbol.put("R6", "6");
      symbol.put("R7", "7");
      symbol.put("R8", "8");
      symbol.put("R9", "9");
      symbol.put("R10", "10");
      symbol.put("R11", "11");
      symbol.put("R12", "12");
      symbol.put("R13", "13");
      symbol.put("R14", "14");
      symbol.put("R15", "15");
      symbol.put("SCREEN", "16384");
      symbol.put("KBD", "24576");
      symbol.put("SP", "0");
      symbol.put("LCL", "1");
      symbol.put("ARG", "2");
      symbol.put("THIS", "3");
      symbol.put("THAT", "4");
   }
  
  //add's entry to symbol table
  public void addEntry(String key, String value) {
    symbol.put(key, value);  
  }
  
  //checks if symbol exists
  public boolean containKey(String key){
    return symbol.containsKey(key);
  }
  
  public String getValue(String val)
  {
    return  symbol.get(val);  
  }
  
}
