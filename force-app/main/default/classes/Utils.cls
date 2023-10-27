public with sharing class Utils {

    public Boolean ValidaCNPJ(String accDocument){
        if(accDocument.length() == 14){
            return true;
        }
        return false;
    }

    public Boolean ValidaCPF(String accDocument){
        if(accDocument.length() == 11){
            return true;
        }
        return false;        
    }    

}