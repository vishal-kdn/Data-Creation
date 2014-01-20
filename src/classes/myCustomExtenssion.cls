public class myCustomExtenssion
{
    private final Account acct;

    public myCustomExtenssion(ApexPages.StandardController stdController)
    {
        system.debug('Inside constructor...');
        this.acct=(Account)stdController.getRecord();
        system.debug('account:-->' + this.acct);
    }
    public String getGreeting()
    {
        system.debug('Inside getGreeeting()...');
        return ' Hello ' + acct.name + '( ' + acct.id +' ) ';
    }
}