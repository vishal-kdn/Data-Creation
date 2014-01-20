public class validatecontact{

    public validatecontact(ApexPages.StandardController controller) {

    }

    public PageReference pageLoad()    //Function called on load page
    {
        String portal = ApexPages.currentPage().getParameters().get('validate');
        String id= ApexPages.currentPage().getParameters().get('id');        
        List<Contact> con=[select id,Unique_validation__c from contact where id=:id];
         system.debug('----into func----');
        if(con[0].Unique_validation__c == portal)
            {
            system.debug('----into if----');
            PageReference pg=new PageReference('http://www.google.com');
            return pg;
            
            }
         else
         {
         system.debug('----into else----');
         PageReference pg1=new PageReference('www.yahoo.com');
         return null;
         }
        
         }
}