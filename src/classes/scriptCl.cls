public with sharing class scriptCl{

        public Integer scriptRun;
        public integer iNoOfUsers;
        public integer iNoOfGroupspu;
        public integer iNoOfGroupspr;
        public integer iNoOfES;
        public integer userchatterfree;
        public boolean createForExistingUsers = false;
        public boolean ensubs = false;
        public boolean creategrp = false;
        public boolean putuseringrp = false;
        public boolean createfeed = false;
        public boolean createfeedcomment = false;
        public boolean createfeedlike = false;
        public boolean createtopic =false;
        public boolean createtopicassign= false;
        public boolean passcomment =false;
    
        public scriptCl(Integer scriptRun, integer iNoOfUsers, integer userchatterfree, integer iNoOfGroupspu, integer iNoOfGroupspr, integer iNoOfES){
        
         this.scriptRun=scriptRun;
         this.iNoOfUsers=iNoOfUsers;
         this.iNoOfGroupspu=iNoOfGroupspu;
         this.iNoOfGroupspr=iNoOfGroupspr;
         this.iNoOfES=iNoOfES;
         this.userchatterfree=userchatterfree;
        
        }
        
        public void createData(boolean createForExistingUsers, boolean ensubs, boolean creategrp, boolean putuseringrp, boolean createfeed, boolean createfeedcomment, boolean createfeedlike, boolean passcomment, boolean createtopic, boolean createtopicassign){
                /**
                        Set the parameters
                        1. Scriptrun
                        2. noofuser
                        3. noofgroups
                        4. Flags
                        
                        Inset static resource min = 4
                        
                        //Feeditem
                            // user * [(4 other + 3 self) attachment+(20 other + 10 self)]
                            // Grp(pub) mem *10
                        
                        // feedcmt=user * FeedItem
                        // feedlike user * feed item
                        //Topic = no of user
                        //Topic Assignment =feeditem * topic
                    */

                    /*Integer scriptRun =1; // need to change only the current number of the script run if used within 1 org
                                           // no other script modifications required
                    integer iNoOfUsers = 21;
                    integer iNoOfGroupspu = 15;
                    integer iNoOfGroupspr = 5;
                    integer iNoOfES = 5;
                    integer userchatterfree=20;
                    boolean createForExistingUsers = false;
                    boolean ensubs = false;
                    boolean creategrp = false;
                    boolean putuseringrp = false;
                    boolean createfeed = false;
                    boolean createfeedcomment = false;
                    boolean createfeedlike = false;
                    boolean createtopic =true;
                    boolean createtopicassign= true;
                    */
                    
                    this.createForExistingUsers = createForExistingUsers ;
                    this.ensubs = ensubs ;
                    this.creategrp = creategrp ;
                    this.putuseringrp = putuseringrp ;
                    this.createfeed = createfeed ;
                    this.createfeedcomment = createfeedcomment ;
                    this.createfeedlike = createfeedlike ;
                    this.createtopic =createtopic ;
                    this.createtopicassign= createtopicassign;
                    this.passcomment= passcomment;
                    //----------------

                    Long runTime = System.currentTimeMillis();

                    String org = 'Org' + System.currentTimeMillis(); 
                    //**************                                  
                    //Step 1&2
                    //**************
                    Profile prof = [SELECT Id FROM Profile WHERE Name LIKE 'Chatter Free User'];
                    Profile profSF = [SELECT Id FROM Profile WHERE Name LIKE 'Standard Platform User'];
                    List<User> users = new List<User>();

                    if(createForExistingUsers==true){
                        for(integer i = 1; i<=iNoOfUsers; i++){

                            if(i<=userchatterfree)
                            {
                            User u = new User(firstName = 'TEST '+ i, lastName = 'Run ' + scriptRun, email = 'testuser' + i + '@passporttest' + scriptRun + '.' + org + '.com', Username = 'testuser' + i + '@passporttest' + scriptRun + '.' + org + '.com', Alias = 'U'+i+'R'+scriptRun, CommunityNickname = 'Test User '+i+' Run ' + scriptRun, EmailEncodingKey='ISO-8859-1', TimeZoneSidKey='Europe/London', LanguageLocaleKey='en_US', LocaleSidKey = 'en_US', ProfileId = prof.Id);
                            users.add(u);
                            }
                            else
                            {
                            User u = new User(firstName = 'TEST '+ i, lastName = 'Run ' + scriptRun, email = 'testuser' + i + '@passporttest' + scriptRun + '.' + org + '.com', Username = 'testuser' + i + '@passporttest' + scriptRun + '.' + org + '.com', Alias = 'U'+i+'R'+scriptRun, CommunityNickname = 'Test User '+i+' Run ' + scriptRun, EmailEncodingKey='ISO-8859-1', TimeZoneSidKey='Europe/London', LanguageLocaleKey='en_US', LocaleSidKey = 'en_US', ProfileId = profSF.Id);
                            users.add(u);
                            }
                        }
                        insert users; //This line will create iNoOfUsers Users with Chatter Free license and 
                    }
                    else
                    {
                    string xyz = '%passporttest' + scriptRun + '.%';
                        users = [select id, firstName, lastName, email, Username, ProfileId from user where IsActive = true AND email like :xyz ORDER BY email ASC LIMIT : iNoOfUsers];
                    }

                    //*************************
                    //Step  3
                    // Makes every user from iNoOfUsers list follow 5 other users
                    //***************************
                    if (users.size() == iNoOfUsers)
                    {
                        List<EntitySubscription> esList = new List<EntitySubscription>();
                        if(ensubs == true)
                        {
                            
                            for(Integer i = 0; i < users.size(); i++){
                                Integer j = 0;
                                while(++j <= iNoOfES){
                                    EntitySubscription e = new EntitySubscription(ParentId = users[i].Id, SubscriberId = users[math.mod((i+j),users.size())].Id);
                                    esList.add(e);
                                }
                            }

                            Database.insert(esList, false);// Every user follows 5 other user
                        }
                        else
                        {
                            esList=[select id, ParentId, SubscriberId from EntitySubscription where ParentId in :users];
                        }
                        
                        //************************************
                        //Step 4
                        // Creating iNoOfGroups public and iNoOfGroups private groups
                        // mod 5 will be an archived group
                        //**********************************************
                        List<CollaborationGroup> chatter_group_list_pu = new List<CollaborationGroup>();
                        List<CollaborationGroup> chatter_group_list_pr = new List<CollaborationGroup>();
                        //--------------------------------
                        List<CollaborationGroup> chatter_group_list_puArch = new List<CollaborationGroup>();
                        List<CollaborationGroup> chatter_group_list_prArch = new List<CollaborationGroup>();
                        if(creategrp == true)
                        {
                            // Multiple of 5 is an archived group
                            for(integer i = 0; i < iNoOfGroupspu; i++){
                                if(math.mod(i,5)==0)
                                {
                                CollaborationGroup g = new CollaborationGroup(Name = 'P-Stress-Public-'+i+'run'+scriptRun, CollaborationType = 'Public', OwnerId = users[i].Id, isArchived =true);
                                chatter_group_list_puArch.add(g);
                                }
                                else
                                {
                                CollaborationGroup g = new CollaborationGroup(Name = 'P-Stress-Public-'+i+'run'+scriptRun, CollaborationType = 'Public', OwnerId = users[i].Id, isArchived =false);
                                chatter_group_list_pu.add(g);
                                }
                            }
                            for(integer i = 0; i < iNoOfGroupspr; i++){
                                if(math.mod(i,5)==0)
                                {
                                CollaborationGroup g2 = new CollaborationGroup(Name = 'P-Stress-Private-'+i+'run'+scriptRun, CollaborationType = 'Private', OwnerId = users[i].Id, isArchived =true);
                                chatter_group_list_prArch.add(g2);
                                }
                                else
                                {
                                CollaborationGroup g2 = new CollaborationGroup(Name = 'P-Stress-Private-'+i+'run'+scriptRun, CollaborationType = 'Private', OwnerId = users[i].Id, isArchived =false);
                                chatter_group_list_pr.add(g2);
                                }
                            }
                            // one more public group
                            //CollaborationGroup g = new CollaborationGroup(Name = 'P-Stress-Public-'+ iNoOfUsers/2 +'run'+scriptRun, CollaborationType = 'Public', OwnerId = users[iNoOfUsers/2].Id);
                            //chatter_group_list_pu.add(g);
                            insert chatter_group_list_pr; //This line will create 5 public chatter groups
                            insert chatter_group_list_pu; //This line will create 5 private chatter groups
                            //---------------------------
                            insert chatter_group_list_prArch; //This line will create Archived public chatter groups
                            insert chatter_group_list_puArch; //This line will create Archived private chatter groups

                            //=============================================Uptill groups complete
                        }
                        else
                        {
                            chatter_group_list_pr=[Select id, Name, CollaborationType, OwnerId, isArchived from CollaborationGroup where Name like '%P-Stress-Private-%'];
                            chatter_group_list_pu=[Select id, Name, CollaborationType, OwnerId, isArchived from CollaborationGroup where Name like '%P-Stress-Public-%'];
                        }
                        List<CollaborationGroupMember> chatter_group_membership_list_pu = new List<CollaborationGroupMember>();
                        if(putuseringrp == true)
                        {
                            //******************************************
                            //Step 5
                            // Filling Up public groups with 50 users each
                            //******************************************
                            List<CollaborationGroupMember> chatter_group_membership_list_pr = new List<CollaborationGroupMember>();

                            for(integer i =0; i < chatter_group_list_pr.size(); i++){
                                for(integer j = 5+i*5; j<=10+i*5 && j < iNoOfUsers; j++){
                                    CollaborationGroupMember mem = new CollaborationGroupMember(CollaborationGroupId = chatter_group_list_pr[i].id, MemberId = users[j].Id);
                                    chatter_group_membership_list_pr.add(mem);
                                }
                            }

                            insert chatter_group_membership_list_pr; //Adds  users in 5 private chatter groups

                            for(integer i = 1; i < chatter_group_list_pu.size(); i++){
                                for(integer j = 5+i*3; j<=10+i*3 && j < iNoOfUsers; j++){
                                    CollaborationGroupMember mem = new CollaborationGroupMember(CollaborationGroupId = chatter_group_list_pu[i].id, MemberId = users[j].Id);
                                    chatter_group_membership_list_pu.add(mem);
                                }
                            }

                            insert chatter_group_membership_list_pu; //Adds  users in 5 public chatter groups

                            //***************************************
                            // Step 6
                            // Put all users in one public group
                            //**************************************
                            List<CollaborationGroupMember> chatter_group_membership_list_all = new List<CollaborationGroupMember>();

                            // skipping first user as it is creator
                            for(integer j = 1; j<iNoOfUsers; j++){
                                CollaborationGroupMember mem = new CollaborationGroupMember(CollaborationGroupId = chatter_group_list_pu[0].id, MemberId = users[j].Id);
                                chatter_group_membership_list_all.add(mem);//Adds all users in 1 public chatter group
                            }
                            //insert chatter_group_membership_list_all;
                            database.insert(chatter_group_membership_list_all, false);
                        }
                        else
                        {
                            chatter_group_membership_list_pu=[Select id, CollaborationGroupId,MemberId from CollaborationGroupMember];
                        }
                            
                        System.debug('Time taken: ' + ((System.currentTimeMillis() - runTime) / 1000) + 's');
                        //****************************
                        //Step 7 Create feed item
                        // user * [(4 other + 3 self) attachment+(20 other + 10 self)]
                        // Grp(pub) mem *10
                        //**********************

                        //Creating 3000 feed items
                        FeedItem[] fis = new List<FeedItem>();
                        list<StaticResource> res=[Select Name, ContentType, Body From StaticResource];
                        //-------------With attachments
                        
                        if(createfeed == true)
                        {
                            for(Integer i = 0; i < users.size(); i++) {
                                for(integer l=0;l<4;l++){
                                Blob body=res[l].body;
                                // other dude
                                Integer randnum=math.round((math.random()*users.size())-1);
                                randnum=randnum>0?randnum:(math.round(users.size()/2));
                                fis.add(new FeedItem(Body='Hello message from ' + users[i].LastName, parentId=users[randnum].Id, createdbyid=users[i].Id, ContentData = body, ContentFileName = 'sample.png'));
                                }
                                for(integer l=0;l<3;l++){
                                Blob body=res[l].body;
                                // self
                                fis.add(new FeedItem(Body='Self message from ' + users[i].LastName, parentId=users[i].Id, createdbyid=users[i].Id, ContentData = body, ContentFileName = 'sample.png'));
                                }
                            }


                            //----------------------------
                            for(Integer i = 0; i < users.size(); i++) {
                                for(integer l=0;l<20;l++){
                                
                                // other dude
                                Integer randnum=math.round((math.random()*users.size())-1);
                                randnum=randnum>0?randnum:(math.round(users.size()/2));
                                fis.add(new FeedItem(Body='Hello message from ' + users[i].LastName, parentId=users[randnum].Id, createdbyid=users[i].Id));
                                }
                                for(integer l=0;l<10;l++){

                                // self
                                fis.add(new FeedItem(Body='Self message from ' + users[i].LastName, parentId=users[i].Id, createdbyid=users[i].Id));
                                }
                            }

                            //inserting 1000 group feed
                            for(CollaborationGroupMember m : chatter_group_membership_list_pu) {
                                for(integer l=0;l<10;l++){
                              fis.add(new FeedItem(Body='Insane message from ' + m.MemberId, parentId=m.CollaborationGroupId, createdbyid=m.MemberId));
                              }
                            }
                            insert fis;
                        }
                        else
                        {
                            fis=[Select id,Body,parentId, createdbyid from FeedItem where insertedbyid=:UserInfo.getUserID()];
                        }
                        //**************************
                        //Step 8 inset feed comment
                        // user * FeedItem
                        //*************************
                        FeedComment[] fcs = new List<FeedComment>();
                        if(createfeedcomment ==true)
                        {
                            for(Integer i = 0; i < users.size(); i=i+3) {
                                for(FeedItem fi : fis) {
                                    fcs.add(new FeedComment(CommentBody='Awesome comment :) from ' + users[i].Lastname, FeedItemId = fi.Id, createdbyid=users[i].Id));
                                }
                            }
                            insert fcs;
                        }
                        else
                        {
                            fcs=[Select CommentBody, FeedItemId, createdbyid from FeedComment where insertedbyid=:UserInfo.getUserID()];
                        }
                        
                        // ***************************
                        //Step 9 insert feed likes
                        // user * feed item
                        //************************
                        FeedLike[] fls = new List<FeedLike>();
                        if(createfeedlike ==true)
                        {
                            System.debug('\n\nfis---'+fis);
                            for(Integer i = 1; i < users.size(); i=i+4) {
                            
                                for(FeedItem fi : fis) {
                                    
                                    fls.add(new FeedLike(FeedItemId = fi.Id, CreatedById = users[i].Id));
                                }
                            }
                            insert fls;
                        }
                        else
                        {
                            /*fls=[Select FeedItemId,CreatedById from FeedLike where CreatedById in :users];*/
                        }
                        
                        //*************************************Passport chatter profile
                        
                        if(passcomment==true)
                        {
                        	List<profile> pp=[select id from profile where name like 'Passport Chatter Profile'];
							List<feeditem> feedit=[SELECT CreatedById,CreatedDate,Id,ParentId FROM FeedItem where createdbyid in (select id from user where profileid in :pp) limit 4];
							//System.debug('\n\n\n------'+ff.size());
                        	
                        	//**************************
	                        //Step 8 inset feed comment
	                        // user * FeedItem
	                        //*************************
	                        FeedComment[] fcsp = new List<FeedComment>();
	                        //if(createfeedcomment ==true)
	                        //{
	                            for(Integer i = 0; i < users.size(); i=i+3) {
	                                for(FeedItem fi : feedit) {
	                                    fcsp.add(new FeedComment(CommentBody='Awesome comment on passport chatter user feed :) from ' + users[i].Lastname, FeedItemId = fi.Id, createdbyid=users[i].Id));
	                                }
	                            }
	                            insert fcsp;
	                        //}
	                        /*else
	                        {
	                            fcsp=[Select CommentBody, FeedItemId, createdbyid from FeedComment where insertedbyid=:UserInfo.getUserID()];
	                        }*/
	                        
	                        // ***************************
	                        //Step 9 insert feed likes
	                        // user * feed item
	                        //************************
	                        Database.DMLOptions dmo = new database.DMLOptions();
							// Roll back all records if one ore more  
    
							// causes errors during insertion. 
    
							dmo.optAllOrNone = false;
	                        FeedLike[] flsp = new List<FeedLike>();
	                        //if(createfeedlike ==true)
	                        //{
	                            System.debug('\n\nfeedit---'+feedit);
	                            for(Integer i = 1; i < users.size(); i=i+4) {
	                            
	                                for(FeedItem fi : feedit) {
	                                    
	                                    flsp.add(new FeedLike(FeedItemId = fi.Id, CreatedById = users[i].Id));
	                                }
	                            }
	                            Database.insert(flsp, dmo);
	                            //insert flsp;
	                        //}
	                        /*else
	                        {
	                            /*flsp=[Select FeedItemId,CreatedById from FeedLike where CreatedById in :users];
	                        }*/
	                        
	                        //Commenting this use case
	                        /*
	                        // ***************************
	                        //Step 9 insert feed comment  likes
	                        // user * feed item
	                        //************************
	                        FeedLike[] flspc = new List<FeedLike>();
	                        //if(createfeedlike ==true)
	                        //{
	                            System.debug('\n\nfeedit---'+feedit);
	                            for(Integer i = 1; i < users.size(); i=i+4) {
	                            
	                                for(FeedComment fi : fcsp) {
	                                    
	                                    flspc.add(new FeedLike(FeedEntityId = fi.Id, CreatedById = users[i].Id));
	                                }
	                            }
	                            insert flspc;
	                        //}
	                        //else
	                        //{
	                            /*flsp=[Select FeedItemId,CreatedById from FeedLike where CreatedById in :users];*/
	                        //}
	                        
	                        
                        }
                        //*****************************
                       
                        
                        //**************************
                        //Step 10 insert topics and topic assignment
                        // Topics in number equal to users
                        //**************************
                        Topic[] topc = new List<Topic>();
                        if(createtopic ==true)
                        {
                            
                            for(Integer i = 1; i < users.size(); i++) {
                            
                                topc.add(new Topic(Description = 'New Year'+i, Name  = 'Good topic'+i ));
                                }
                            
                            insert topc;
                        }
                        else
                        {
                            topc=[SELECT CreatedById,Description,Id,Name FROM Topic where Name like '%Good topic%'];
                        }
                        
                        //Topic Assignment =feeditem * topic
                         
                        TopicAssignment[] tassign = new List<TopicAssignment>();
                        if(createtopicassign ==true)
                        {
                            
                            for(Integer i = 1; i < fis.size(); i=i+10) {
                                FeedItem fi=fis[i];
                                for(Integer j = 1; j < topc.size(); j=j+6) {
                                Topic top = topc[j];
                                        
                                        tassign.add(new TopicAssignment(EntityId = fi.Id,TopicId=top.id));
                                }
                                
                            }
                            insert tassign;
                        }
                        else
                        {
                            tassign=[SELECT CreatedById,EntityId,Id,IsDeleted,TopicId FROM TopicAssignment where EntityId in :fis];
                        }
                        // summary
                        // users: 21
                        // cg: 10
                        // cgm: 60 (10 comes with CG)
                        // cgmr: 25
                        // fi: 67
                        // fc: 737 com
                        // fl: 670 fl
                        // topic :
                        //Topic assignment :


                        System.debug('Time taken: ' + ((System.currentTimeMillis() - runTime) / 1000) + 's');
                    }
                    else
                    { 
                        System.debug('Users not appropriate--------------\n\n\n---Total users---'+users.size());
                    }
                    String result = '\n';

                    Integer cLike = 0;
                    for(FeedItem fi : [Select f.LikeCount From FeedItem f where f.LikeCount > 0]) {
                        cLike += fi.LikeCount;
                    }

                    result += '\nFeedItem: ' + [select count() from FeedItem];
                    result += '\nFeedComment: ' + [select count() from FeedComment];
                    result += '\nES: ' + [select count() from EntitySubscription];
                    result += '\nGroup: ' + [select count() from CollaborationGroup];
                    result += '\nRequest: ' + [select count() from CollaborationGroupMemberRequest];
                    result += '\nMember: ' + [select count() from CollaborationGroupMember];
                    result += '\nLikes: ' + cLike;
                    result += '\nUser: ' + [select count() from User where IsActive=true];
                    result += '\nTopic: ' + [SELECT count() FROM Topic];
                    result += '\nTopicAssignment: ' + [SELECT count() FROM TopicAssignment];

                    system.debug('result: ' + result);

        }
    }