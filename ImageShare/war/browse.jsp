<%@ page contentType="text/html;charset=UTF-8" session="true" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="java.util.*" %>
<%@ page import="com.google.appengine.api.blobstore.BlobKey" %>
<%BlobstoreService blobstoreService =BlobstoreServiceFactory.getBlobstoreService();%>

<%-- //[END imports]--%>
<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<title>Browse</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
	<h1 id="title"><b>IMAGESHARE</b></h1></br>
		<div id="upload">
			<form action="<%= blobstoreService.createUploadUrl("/upload") %>"method="post" enctype="multipart/form-data">
			<input type="file" accept="image/*" name="myFile"></br>
			<input type="submit" value="Submit"></form></br>
		</div>
		<div id="login">
			
		</div>
		</br>
		<%String blob = request.getParameter("blob-key");%>
<%-- 		<img id="img" src="<%="/serve?blob-key=" + blob %>"/> --%>
		
		<%Map<String, BlobKey> blobs = new HashMap<String, BlobKey>(); %>
		<% try
		   {
				blobs = blobstoreService.getUploadedBlobs(request);
				out.println("Test");
			}
		   catch(IllegalStateException e){out.println("Error" + "</br>");}%>
		   <%out.println("other test" + "</br>");%>
		   <% blobs = (Map<String, BlobKey>)(request.getSession().getAttribute("images"));%>
 		   <%for(BlobKey b : blobs.values())
 			{
 			   out.println("Test");%>
 					<img id="img" src="<%="/serve?blob-key=" + b.getKeyString() %>"/></br>
 					Hello</br>
 		   <%}%>
		   
<%-- 		<%for(BlobKey b : blobs.values()) --%>
<%-- 		  {%> --%>
<%-- 			<img id="img" src="<%="/serve?blob-key=" + b.getKeyString() %>"/> --%>
<!-- 			image test</br> -->
<%-- 		  <%}%> --%>
<%-- 	  	<img id="img" src="<%="/serve?blob-key=" + blob %>"/> --%>
</body>
</html>