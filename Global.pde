class GLOBAL {
  IntDict TranslationXeng; 
  String[] TranslationXnum;
  
  GLOBAL() {
    TranslationXeng = new IntDict(); 
    TranslationXeng.set("a", 0); 
    TranslationXeng.set("b", 1);
    TranslationXeng.set("c", 2); 
    TranslationXeng.set("d", 3); 
    TranslationXeng.set("e", 4); 
    TranslationXeng.set("f", 5); 
    TranslationXeng.set("g", 6); 
    TranslationXeng.set("h", 7);
    
    TranslationXnum = TranslationXeng.keyArray(); 
  }
}
