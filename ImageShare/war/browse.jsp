<%@ page contentType="text/html;charset=UTF-8" session="true" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.security.Principal" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="javax.jdo.Query" %> 
<%@ page import="ie.dit.hartnett.sean.ImageStore" %>
<%@ page import="ie.dit.hartnett.sean.PMF" %>
<%@ page import="ie.dit.hartnett.sean.DBInfo" %>
<%@ page import="javax.jdo.PersistenceManager" %> 
<%@ page import="com.google.appengine.api.blobstore.BlobKey" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();%>
<%UserService userService = UserServiceFactory.getUserService();
  String URL = request.getRequestURI();
  Principal princ = request.getUserPrincipal();%>
<!DOCTYPE html>
<html>
<head>
<title>ImageShare</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
	<h1 id="title"><b>IMAGESHARE</b></h1></br>
		
		<div id="login">
				<% String username = null; %>
				<%try
				  {
					username = princ.getName();
				  }
				  catch(NullPointerException e)
				  {
					username = "Guest";
				  }%>
				Logged in as <%= "<b>" + username + "</b>" %></br>
				<a href="<%= userService.createLoginURL(URL).toString() %>"><b>Login</b></a></br>
		</div>
		
		<div id="upload">
			<% if(username != "Guest")
 			   {%>	<%--This form uploads a blob, then sends a callback to the upload servlet --%>
					<form action="<%= blobstoreService.createUploadUrl("/upload") %>"method="post" enctype="multipart/form-data">
					<input type="file" accept="image/*" name="myFile"></br>
					Private Image <input type="checkbox" name="Private" value="private"
									<%if(userService.isUserAdmin()) out.println("checked"); %>></br>
					<input type="submit" value="Upload"></form>
			 <%}%>
		</div>
		</br>
		</br>
<!-- 		code below gets the database and loads its ImageStore table into a list -->
		<%
		  PersistenceManager pm = PMF.get().getPersistenceManager();  
		  Query query = pm.newQuery("select from " + ImageStore.class.getName());  
		  List<ImageStore> images = (List<ImageStore>) query.execute();
		  Query dbinf = pm.newQuery("select from " + DBInfo.class.getName());  
		  List<DBInfo> dbInfo = (List<DBInfo>) dbinf.execute();
 		  %>
		  </br></br>
		  <div id="imgframe">
		  <%for(ImageStore i : images)//this for loop iterates through all the stored images
		    {%>
		      <%if(userService.isUserLoggedIn() || !i.privateImg)
		        {%>
				  <a href="<%= "/serve?blob-key=" + i.imgKey %>"><img id="img" src="<%= "/serve?blob-key=" + i.imgKey %>"/></a></br>
				  <% if(username != "Guest")
				  	 {
				  		if(userService.isUserAdmin() ||  username.equals(i.user))
					     {%>
					     	<a href="<%=response.encodeURL("/delete?deleteKey=" + i.imgKey)%>">Delete</a></br>
					   <%}
					 }%>
				  Uploaded by: <%out.println("<b>" + i.user + "</b>"); %></br>
				  Date: <%SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");out.println(dateFormat.format(i.date)); %></br>
				  <%if(!i.privateImg)
					{
						out.println("<b>Public</b>");
					}
					else
					{
						out.println("<b>Private</b>");
					}%></br></br>
				  
				<%}%>
		   <%}%>
		   </div>
</body>
</html>