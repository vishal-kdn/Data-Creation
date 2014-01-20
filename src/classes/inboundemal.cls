global with sharing class inboundemal implements messaging.Inboundemailhandler{
	
	global messaging.Inboundemailresult handleinboundemail(messaging.inboundemail email,messaging.Inboundenvelope env)
	{
		messaging.Inboundemailresult result=new messaging.Inboundemailresult();
		list<Contact> lscont=new list<Contact>();
		list<lead> lslead=new list<lead>();
		
		string mysubject=email.subject.toLowerCase();
		
		string s='unsubscribe';
		Boolean unsubme;
		unsubme=mysubject.contains(s);
		
		if(unsubme==true)
		{
			try
			{
				//look up all matching contacts with matching email address
				for(Contact c: [Select id,name,email,hasoptedoutofemail from Contact where Email=:env.fromAddress and hasoptedoutofemail=false limit 100])
				{
					//add all matching contact to list
					c.hasoptedoutofemail=true;
					lscont.add(c);
				}
				//update all of the contact
				update lscont;
			}
			catch(Exception e)
			{
				System.debug('Contact Query issue'+e);
			}
			 try {
            // Look up all leads matching the email address.
            for (Lead l : [SELECT Id, Name, Email, HasOptedOutOfEmail
                     FROM Lead
                     WHERE Email = :env.fromAddress
                     AND isConverted = false
                     AND hasOptedOutOfEmail = false
                     LIMIT 100]) {
                // Add all the leads to the list.       
                l.hasOptedOutOfEmail = true;
                lslead.add(l);
                   
                System.debug('Lead Object: ' + l);   
            } 
            // Update all lead records in the query.
            update lslead;
        }
        
        catch (System.QueryException e) {
            System.debug('Lead Query Issue: ' + e);
        }   
        
        System.debug('Found the unsubscribe word in the subject line.');
         } 
         else {
            System.debug('No Unsuscribe word found in the subject line.' );
         }
        // Return True and exit.
        // True confirms program is complete and no emails 
        // should be sent to the sender of the unsubscribe request. 
        result.success = true;
        return result;
    }   
}