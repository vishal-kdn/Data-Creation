public with sharing class Derived 
{
    public Integer age {get; set;}
    Base base;
    public Derived(Base base) 
    {
        age = 15;
        this.base = base;
    }
    //No meaning of overloading constructor.
    public Derived() 
    {
    }
    public PageReference callDerived() 
    {
    age = age + 10;
    base.phone = 2222222;
    return null;
    }
}