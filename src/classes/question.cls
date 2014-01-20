public class question
{
    private  list<Opportunity> oppz;
    private contact cnt;
    public question(ApexPages.StandardController stdController)
    {
          this.cnt=(Contact)stdController.getRecord();
    }
    public List<opportunity> getGive()
    {
         Contact con = [Select id, Account.id FROM Contact where id = :cnt.id];
        if (con.Account == null)
         return null;
        oppz = [Select id, Name, Account.Name, CloseDate,probability, Amount, Type from Opportunity where Account.id = :con.Account.id];
        return oppz;
    }
}