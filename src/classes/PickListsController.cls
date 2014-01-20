public with sharing class PickListsController {

   public String selected1 {get; set;}
   public String selected2 {get; set;}
   public String selected3 {get; set;}
   
   
   public List<SelectOption> getList1SelectOptions()
   {
      List<SelectOption> options=new List<SelectOption>();
      options.add(new SelectOption('1 - First', '1 - First'));
      options.add(new SelectOption('1 - Second', '1 - Second'));
      return options;
   }
   
   public List<SelectOption> getList2SelectOptions()
   {
      List<SelectOption> options=new List<SelectOption>();
      if (null!=selected1)
      {
      options.add(new SelectOption('2 - First', '2 - First'));
      options.add(new SelectOption('2 - Second', '2 - Second'));
      }
      return options;
   }
   
   public List<SelectOption> getList3SelectOptions()
   {
      List<SelectOption> options=new List<SelectOption>();
      if (null!=selected2)
      {
      options.add(new SelectOption('3 - First', '3 - First'));
      options.add(new SelectOption('3 - Second', '3 - Second'));
      }
      return options;
   }
}