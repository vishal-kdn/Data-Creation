public class pract25
{
    public Account acct {get;set;}
    public Contact cont {get;set;}
    private String s;
    public pract25()
    {    
        acct=new account();
        cont=new contact();
    }
    public string cal()
    {
        //this.cont=[Select id from contacts where lastname=this.lastname];
        return (String)cont.id;
    }
    
    public PageReference save()
    {
        //cont.account=acct;
        try
        {
            insert acct;
            cont.AccountId = acct.Id;
            insert cont;
        
        //s=cal();
        }catch(Exception ex)
        {
          System.debug('Output error'+ex);
          
        }
        return new PageReference('/' + cont.Id);
        
    }
    
}