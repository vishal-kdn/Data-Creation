public class cusController
{
    private final Account account;
    public cusController()
    {
    account=[select id,name,site FROM Account where id=:ApexPages.currentPage().getParameters().get('id')];
    }
    public Account getAccount()
    {
    return account;
    }
    public PageReference save()
    {
    update account;
    return new PageReference('http://www.google.com');
    }
}