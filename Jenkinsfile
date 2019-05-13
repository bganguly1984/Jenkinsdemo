import groovyx.net.http.HTTPBuilder
import groovyx.net.http.HttpResponseException
import static groovyx.net.http.ContentType.URLENC
import static groovyx.net.http.Method.POST
import static groovyx.net.http.Method.GET
import static groovyx.net.http.ContentType.JSON

@Grapes(
  @Grab(group='org.codehaus.groovy.modules.http-builder', module='http-builder', version='0.6')
)

def sf_login_domain = 'https://login.salesforce.com/'
def instance_domain
def access_token = ''
def consumer_key = '3MVG9xOCXq4ID1uHgHyftKXbMPvrbqnT7q5EgZvKZo5wzclEZE54KUZ_7K8tRGiRsdVS1TRvOl8wNNvUT2Xkk'
def consumer_secret	= '1E8C9F7D96541CC63659DD141E1F34F28C1A9C5B536A01C70D5D689B25DEDE49'
def auth_username = 'bhaskar@ganguly.dev'
def auth_password = 'Oct@2018'
def auth_security_token = 'securityToken'

/*
curl https://test.salesforce.com/services/oauth2/token -d "grant_type=password" -d "client_id=consumer_key" -d "client_secret=consumer_secret" -d "username=username@domain.com" -d "password=passwordSecurityToken" 
curl https://cs4.salesforce.com/services/data/v28.0/ -H "Authorization: Bearer adfdf00123\!AQsAQasdasd"
*/

//Request Access_token and instance domain for work	
def http = new HTTPBuilder(sf_login_domain)
def postBody = [
		grant_type: 'password',
		client_id: consumer_key,
		client_secret: consumer_secret,
		username: auth_username,
		password: auth_password+auth_security_token
		]
try{ 

    http.post( path : 'services/oauth2/token',
              body : postBody,
              requestContentType: URLENC) { resp, json ->
    				access_token = json.access_token
    				instance_domain = json.instance_url +"/"
    			}

}catch(HttpResponseException e){
    println "Error code: ${e.statusCode}"
    println "Post form: $postBody"
}


println "Access Token $access_token"
println "Instance domain $instance_domain \n"


println "List API Resources \n"
http = new HTTPBuilder(instance_domain)
http.request(GET,JSON) { req ->
  uri.path = 'services/data/v28.0/' 
  headers['Authorization'] = "Bearer $access_token"
 
  response.success = { resp, json  ->
    assert resp.status == 200
    json.each{ key,value ->
		println "$key : $value"
	}
  }
 
  response.failure = { resp, json ->
    println resp.status
    println json.errorCode
    println json.message
  }
}

println "List Case Resources \n"
http.request(GET,JSON) { req ->
  uri.path = 'services/data/v28.0/sobjects/Case/' 
  headers['Authorization'] = "Bearer $access_token"
 
  response.success = { resp, json  ->
    assert resp.status == 200
    
    json.each{ key,value ->
  		println "$key : $value"
  	}
      json.objectDescribe.each{ key,value ->
  		println "$key : $value"
  	}
    
  	println "Recent Items: $json.recentItems \n"
  }
 
  response.failure = { resp, json ->
    println resp.status
    println json.errorCode
    println json.message
  }
}

println "List Case CASE_ID \n"
http.request(GET,JSON) { req ->
  uri.path = 'services/data/v28.0/sobjects/Case/CASE_ID' 
  headers['Authorization'] = "Bearer $access_token"
 
  response.success = { resp, json  ->
    assert resp.status == 200
    json.each{ key,value ->
  		println "$key : $value"
  	}
  }
 
  response.failure = { resp, json ->
    println resp.status
    println json.errorCode
    println json.message
  }
}


println "Insert Case \n"

def postBodyForNewCase = [
    'Status'                      : 'New',
    'Origin'                      : 'Web',
		'Type'                        : 'Feedback',
		'Language'                    : 'ES',
		'email'                       : 'username@domain.com',
		subject                       : "subject for new case",
		description                   : "Desc for new case"
		]

http.request(POST,JSON) { req ->
  uri.path = 'services/data/v28.0/sobjects/Case/'
  headers['Authorization'] = "Bearer $access_token"
  body = postBodyForNewCase
  requestContentType = URLENC
  
  response.success = { resp, json  ->
    json.each{ key,value ->
  		println "$key : $value"
  	}
  }
 
  response.failure = { resp, json ->
    println resp.status
    println json.errorCode
    println json.message
  }
}
