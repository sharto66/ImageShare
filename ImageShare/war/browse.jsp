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
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.jdo.Query" %> 
<%@ page import="ie.dit.hartnett.sean.ImageStore" %>
<%@ page import="ie.dit.hartnett.sean.PMF" %>
<%@ page import="ie.dit.hartnett.sean.DBInfo" %>
<%@ page import="javax.jdo.PersistenceManager" %> 
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
		
		<%PersistenceManager pm = PMF.get().getPersistenceManager();  
		  Query query = pm.newQuery("select from " + ImageStore.class.getName());  
		  List<ImageStore> images = (List<ImageStore>) query.execute();
		  Query dbinf = pm.newQuery("select from " + DBInfo.class.getName());  
 		  List<DBInfo> dbInfo = (List<DBInfo>) dbinf.execute();  %>
		  
		  <div id="imgframe">
		  <%for(ImageStore i : images)
		    {%>
			  <img id="img" src="<%= "/serve?blob-key=" + i.imgKey %>"/></br>
			  Uploaded by: <%out.println(i.user); %></br>
			  Date: <%out.println(i.date); %></br></br>
		   <%}%>
		   </div>
</body>
</html>