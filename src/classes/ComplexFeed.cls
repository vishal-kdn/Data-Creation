public with sharing class ComplexFeed {

	public static Blob getBase64EncodeBlob(string header, Blob body, string footer) 
	{
		  // no trailing padding on header by adding ' ' before the last "\n\n" characters
		  String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\n\n')); 
		  //this ensures no trailing "=" padding
		  while(headerEncoded.endsWith('='))
		  {
		   header+=' '; 
		   headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\n\n')); 
		  }
		  //base64 encoded body
		  String bodyEncoded = body != null? EncodingUtil.base64Encode(body) : '';
		  //base64 encoded footer
		  String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
		   
		  Blob bodyBlob = null;
		  //last encoded body bytes
		  if (bodyEncoded.length() > 4)
		  {
			  String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
			  //if the last 4 bytes encoded base64 ends with the padding character (= or ==) then re-encode those bytes with the footer
			  //to ensure the padding is added only at the end of the body
			  if(last4Bytes.endsWith('='))
			  {
			   Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
			   HttpRequest tmp = new HttpRequest();
			   tmp.setBodyAsBlob(decoded4Bytes);
			   String last4BytesFooter = tmp.getBody() + footer;   
			   bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded.substring(0, bodyEncoded.length() - 4) + EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
			  }
			  else
			  {
			   bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);
			  }
		  }
		  else
		  {
		   bodyBlob = EncodingUtil.base64Decode(headerEncoded + bodyEncoded + footerEncoded);
		  }
		  
		  return bodyBlob;
	}
	
	public static boolean IsValidBase64EncodedData(blob fileBodyBlob)
	{
		string bodyEncoded = '';
		  
		bodyEncoded = EncodingUtil.base64Encode(fileBodyBlob);
		
		if (bodyEncoded.length() > 4)
		{
		  String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());
		  //if the last 4 bytes encoded base64 ends with the padding character (= or ==) then re-encode those bytes with the footer
		  //to ensure the padding is added only at the end of the body
	
		  System.debug('\n\nIsValidBase64EncodedData - last4Bytes: ' + last4Bytes);
		  if(last4Bytes.endsWith('='))
		  {
		  	return false;
		  }
	    }
  		return true;
	} 

	public static HTTPResponse processMentionAttachmentPost(String sesid,list<user> lsuser,String addvar)
//(ConnectApi.FeedItem fi, Map<String, Mapping__c> mapping, SFDCStub.Org sfdcOrg, String mappingField, String replicaCreatedById)
	{
		//LogUtils.log('\n\nFeedItem: ' + fi, LogType.DEBUG);
		Boolean containsAttachment = false;
		
		//String parentId = ((ConnectApi.ActorWithId)fi.parent).id; 
		//string mappingKey = MappingManager.getMappingKey(parentId, sfdcOrg.orgId);
				
		//ConnectApi.FeedBody bdy = fi.body;
		//LIST<ConnectApi.MessageSegment> segList =  bdy.messageSegments;

		//if(segList!=null && segList.size() > 0)
 		//{   
		
		
			String sessionid =sesid;
 			string fileName = '';
	        //string packageName = PassportService.getPackageNameForField();
 			string packageName = 'Demo Dummy ';
			//mappingField = packageName + mappingField;
 			//String salesforceHost = sfdcOrg.url;
			String salesforceHost = System.Url.getSalesforceBaseURL().toExternalForm();
 			//string recordId = (string)mapping.get(mappingKey).get(mappingField);
			string recordId = lsuser[0].id;
			/*if (testInLocalOrg)
				recordId = parentId;
				*/
			String url =  salesforceHost + '/services/data/v29.0/chatter/feeds/record/' + recordId + '/feed-items';				            
			HttpRequest req = new HttpRequest();			            
			req.setMethod('POST');
			req.setEndpoint(url);
			req.setHeader('Accept', '*/*');
			req.setHeader('Authorization', 'OAuth ' + sessionid);
			req.setHeader('x-chatter-entity-encoding', 'false');
	
			// Attachment Type = content
			// Attachment Type = link
			
			String jsonBody = '';
			String jsonBodyContent = '';
			String jsonBodyFooter = '}';
			
			//string feedItemId = fi.Id;

			boolean addComma = false;
			boolean privateGroup = false;
			boolean mentionFeed = false;
			boolean validBase64EncodedData = true;
			Blob fileBodyBlob;
			String encodedContent = '';
			string targetContentDocumentId = '';
			string targetContentVersionId = '';
			ContentVersion targetCV;
			//string targetOrgId = sfdcOrg.OrgId;
			string groupId;

			if (recordId.startsWith('0F9')) groupId = recordId; //0f9 is a collaboration group
			
			jsonBody += '{ "body" : { "messageSegments" : [ ';				

			//for(ConnectApi.MessageSegment seg: segList)
			//{
			
			if(addvar == 'mention')
			{
				if(addComma)
					jsonBody = jsonBody + ' ,';
					
				//if(seg instanceof ConnectApi.MentionSegment)
				//{
					//LogUtils.log('\n\nMAPPFLD: ' + mappingField, LogType.DEBUG_FINEST);
					/*
					ConnectApi.UserSummary userSum = ((ConnectApi.MentionSegment)seg).user;
					LogUtils.log('\n\nUSERSUM: ' + userSum.id, LogType.DEBUG);
					mappingKey = MappingManager.getMappingKey(userSum.id, sfdcOrg.orgId);
					*/
					
						//ConnectApi.ActorWithId actorSum = ((ConnectApi.MentionSegment)seg).record;
					//LogUtils.log('\n\nactorSum: ' + actorSum.id, LogType.DEBUG);
					//mappingKey = MappingManager.getMappingKey(actorSum.id, sfdcOrg.orgId);

					// If mapping found replace the id else add as text					
					//if (mapping.get(mappingKey) != null)
					//{
						mentionFeed = true;
						jsonBody = jsonBody + '{ "type": "mention", "id" : "' + lsuser[0].id + '"}';
					//}
					//else
						//jsonBody = jsonBody  + '{ "type": "text",  "text" : "' + ' ' + escapeFeedText(((ConnectApi.MentionSegment)seg).name) +  '" }';	
				//} 
				/*else
					jsonBody = jsonBody  + '{ "type": "text",  "text" : "' + ' ' + escapeFeedText(seg.text) +  '" }';	*/
				addComma = true;
			}
			
			jsonBody = jsonBody  + '{ "type": "text",  "text" : "Hello it is a feeditem..." }';
			jsonBody = jsonBody + '] } ';	// Closing the mention segments
			
			
				//ConnectApi.FeedItemAttachment attachment = fi.attachment;
				// Link
				//if (attachment instanceof ConnectApi.LinkAttachment)
				//{
				if(addvar =='link')
				{
					//ConnectApi.LinkAttachment linkAtt = (ConnectApi.LinkAttachment)attachment;
					string title = 'Demo link attachment';
					//linkAtt.title != null? linkAtt.title : '';

					jsonBody += ', "attachment": { ';
					jsonBody += '"attachmentType":"Link", ';
					jsonBody += '"url":"' + 'www.google.com' + '", ';
					jsonBody += '"urlName":"' + title + '" '; 
					jsonBody += '} ';
				}	
				
				//Poll
				if (addvar == 'poll')
				{
					//ConnectApi.FeedPoll feedPoll = (ConnectApi.FeedPoll)attachment;
					//List<ConnectApi.FeedPollChoice> lstChoices = feedPoll.choices;
					string choices = '"option 1" , "option 2" , "option 3"';
					
					//for (ConnectApi.FeedPollChoice choice : lstChoices) choices += choices == ''? ('"' + choice.text + '"') : (', "' + choice.text + '"');
					
					jsonBody += ', "attachment": { ';
					jsonBody += '"attachmentType":"Poll", ';
					jsonBody += '"pollChoices":[' + choices + '] '; 
					jsonBody += '} ';
				}	
				
				//Content
				if (addvar == 'content')
				{
					containsAttachment  = true;
					//ConnectApi.ContentAttachment contentAtt = (ConnectApi.ContentAttachment)attachment;
					list<StaticResource> res=[Select Name, ContentType, Body From StaticResource where name='image1'];
					fileBodyBlob=res[0].body;
					System.debug('\n\n\n\n-------Size of static resource--------'+fileBodyBlob.size());
					string title =' Demo content attachmewnt';
					string description = 'It is a sample attachment';
					//string contentDocumentId = contentAtt.id;
					//string PathOnClient = title + '.' + contentAtt.fileExtension;
					fileName = 'Download.jpg';
					string createdById = '';
					
					//ConnectApi.UserSummary userSum = (ConnectApi.UserSummary)fi.actor;
					//LogUtils.log('\n\nUSERSUM: ' + userSum.id, LogType.DEBUG);
					//createdById = userSum.id;

					validBase64EncodedData = IsValidBase64EncodedData(fileBodyBlob);

					if (validBase64EncodedData)
					{
						jsonBodyContent += ', "attachment": { ';
						jsonBodyContent += '"attachmentType":"NewFile", ';
						jsonBodyContent += '"description":"' + description + '", ';
						jsonBodyContent += '"title":"' + title + '" ';
						jsonBodyContent += '} ';
					}
					else
					{
					System.debug('---------------not uploaded-----------------');
					
					}
					
			}

			String body = '';
			
			if (containsAttachment)
			{
		        String boundary = String.valueOf(DateTime.Now(). GetTime()); 
				String header = '\n\n--' + boundary + '\n';
	            String footer = '\n--' + boundary + '--';
		        String jsonHeader = header + 'Content-Disposition: form-data; name="json"\n' ;
		        jsonHeader += 'Content-Type: application/json; charset=UTF-8\n\n' ;

		        String attachmentBody = header + 'Content-Disposition: form-data; name="feedItemFileUpload"; filename="' + fileName + '"\n';
		        attachmentBody += 'Content-Type: application/octet-stream;\n' ;

				if (validBase64EncodedData)
				{
					//if (Logutils.loggingThreshold >= LogType.DEBUG) 
					System.debug('\n\nAttachment PARTS: jsonHeader:\n' + jsonHeader + '\n\n jsonBody\n' + jsonBody + '\n\n jsonBodyFooter:\n' + jsonBodyFooter + '\n\n jsonBodyContent: ' + jsonBodyContent + '\n\n attachmentBody: ' + attachmentBody);
					body = jsonHeader + jsonBody + jsonBodyContent + jsonBodyFooter + attachmentBody; 
					//if (Logutils.loggingThreshold >= LogType.DEBUG)
					System.debug('\n\nRequest: body:\n' + body);

					Blob attachmentPart = getBase64EncodeBlob(body, fileBodyBlob, footer); 
	
					System.debug('\n\nAttachment part: \n\njsonBody:\n' + jsonBody + '\n\nattachmentBody\n' + attachmentBody + '\n\nfileBodyBlob:\n' + fileBodyBlob + '\n\nfooter: ' + footer);
					System.debug('\n\nREQUEST: ' + req + '\n\nBlob REQUEST BODY: ' + attachmentPart);
	
					if (attachmentPart.size() < 3000000)
					{
				        req.setHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
						req.setBodyAsBlob(attachmentPart);
			            req.setHeader('Content-Length', String.valueof(req.getBodyAsBlob().size())); 
					}
					else
					{
						body = jsonBody + jsonBodyFooter;
				        req.setHeader('Content-Type', 'application/json');
			        	req.setCompressed(true); 
						req.setBody(body);
			            
						System.debug('\n\nREQUEST: ' + req + '\n\nREQUEST BODY: ' + body);
					}
				}
				
			}
			else
			{
				body = jsonBody + jsonBodyFooter;
		        req.setHeader('Content-Type', 'application/json');
	        	req.setCompressed(true); 
				req.setBody(body);
	            
				System.debug('\n\nREQUEST: ' + req + '\n\nREQUEST BODY: ' + body);
			}
			
			Http http = new Http();				  
			HTTPResponse res = http.send(req);
			System.debug('\n\nRESPONSE: ' + res + '\n\nRESPONSEBODY: ' + res.getBody());
			
			return res;
 		//}
 		//else
 			//return null;     	
	}
	
	
	private static string escapeFeedText(string text)
	{
		string s = JSON.Serialize(text);
		return s.removeStart('"').removeEnd('"');
	}
	
}