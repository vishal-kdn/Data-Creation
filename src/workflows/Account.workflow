<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Sample_test_WF_email</fullName>
        <description>Sample test WF email</description>
        <protected>false</protected>
        <recipients>
            <recipient>vishal@abc.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/SalesNewCustomerEmail</template>
    </alerts>
    <fieldUpdates>
        <fullName>test</fullName>
        <field>Name</field>
        <formula>( PRIORVALUE( Name ) &amp; &apos;+3&apos;)</formula>
        <name>test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Stage Update Wf test</fullName>
        <actions>
            <name>Sample_test_WF_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>System Administrator</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>testing</fullName>
        <actions>
            <name>test</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNEW( ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
