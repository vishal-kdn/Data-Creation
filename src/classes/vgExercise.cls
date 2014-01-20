public class vgExercise {

    public PageReference next() {
        return null;
    }


    public PageReference previous() {
        return null;
    }


    public vgExercise() {

    }
  
    public vgExercise(ApexPages.StandardController controller)
     {
         contb=false;
      }
      
    public account accto{get; set;}
    public list<account> s=new list<account>();
    public string accts{get; set;}
    public list<Contact> cont{get;set;}
    public list<Opportunity> opp{get;set;}
    public boolean contb{get; set;}
    
    public list<SelectOption> getlistacct()
     {
          list<SelectOption> lst=new list<Selectoption>();
          s=[Select name from Account limit 10];
          lst.add(new SelectOption('--None--','--None--'));
          for(account a:s)
              {  lst.add(new SelectOption(a.Id,a.name));}
          System.debug('ouuuutput in func.....'+lst);
          return lst;
      }
    
    public PageReference call(){
        System.debug('aaaacctoo'+accto);
        
        System.debug('popopopopopopp' + accto);
        
         this.cont=[select lastname,mailingcity,phone from contact where account.id=:accts];
        this.opp=[Select name,closeDate,Stagename from opportunity where account.id=:accts];
        contb=true;
        return null;
        }
   
    
}