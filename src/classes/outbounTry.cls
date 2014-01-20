public class outbounTry {
	
	public String subject{get; set;}
	public String body{get; set;}
	
	public Account acct{get; set;}
	
	public outbounTry()
	{
		acct=[Select name,(Select Contact.name, Contact.email from Account.Contacts) from account where id=:ApexPages.currentPage().getParameters().get('id')];
		
	}
	
	public pageReference send()
	{
		//Define the mail
		Messaging.Singleemailmessage email=new messaging.Singleemailmessage();
		
		String addresses;
    if (acct.Contacts[0].Email != null)
    {
        addresses = acct.Contacts[0].Email;
        // Loop through the whole list of contacts and their emails
        for (Integer i = 1; i < acct.Contacts.size(); i++) 
        {
            if (acct.Contacts[i].Email != null)
            {
                addresses += ':' + acct.Contacts[i].Email;
            }
        }
    }

		String[] toAddresses = addresses.split(':', 0);

		// Sets the paramaters of the email
		email.setSubject( subject );
		email.setToAddresses( toAddresses );
		email.setPlainTextBody( body );
    
		// Sends the email
		Messaging.SendEmailResult [] r = 
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
		
		return null;
	}
}