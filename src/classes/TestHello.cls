@isTest
 private class TestHello
  { 
  static testMethod void testHelloWorld()
   { Account a = new Account(name='Kamal');
    insert a;
     a = [SELECT name FROM account WHERE Id = :a.id];
      System.assert(a.name.equals('Kamal'));
       //System.assertEquals('Kamal', a.name);
        //checking for equality
         }
   }