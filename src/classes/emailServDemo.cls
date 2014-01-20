global class emailServDemo implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          
          system.debug(email.plainTextBody);
          account a = new account();
          a.name= email.plainTextBody;
          insert a;
          
          return result;
      }
  }