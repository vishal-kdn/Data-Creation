/*** Controller ***/
public class exampleCon1 {
    
    
    //constructor
    /*public exampleCon1(){
        state = 'noooooo';
    }*/
    
    String uname;

    public String getUsername() {
        return uname;
    }
            
    public PageReference sayHello() {
        uname = UserInfo.getName();
        return null;
    }
            
    public void setState(String n) {
        state = n;
    }
            
    public String getState() {
        return state;
    }
    public string s{get;set;}
            
    public void methodOne() {
        state=s;
        system.debug('==='+ s);
      // return null;
    }
            
    public String state='no';
}