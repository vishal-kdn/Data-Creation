global class EmailServDemoCase implements Messaging.InboundEmailHandler {
      
       global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.Inboundenvelope envelope) 
        {
         Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
          system.debug(email.plainTextBody);
          Case c = new Case();
          System.debug('----Executed---');
          if(envelope.fromAddress.contains('vishal.singh@makepositive.com')){
              Account a=[Select id from Account where id='0019000000ibllK'];
              System.debug('----into if---');
              c.Account=a;
              c.Status='New';
              c.Priority='Medium';
              c.Description= email.plainTextBody;
              try{
                  insert c;
              }
              catch (Exception e){
                result.success = false;
                result.message = 'Oops, I failed.';
              }
      
        
     }
      return result;
  }
  }