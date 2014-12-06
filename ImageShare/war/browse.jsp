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
  Principal princ = request.getUserPrincipal();
  final int num = 5;// this int determines the amount of images per page%>
<!DOCTYPE html>
<html>
<head>
<title>ImageShare</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
	<div id=navbar>
	<h1 id="title"><b>IMAGESHARE</b></h1>
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
				Logged in as <%= "<b>" + username + "</b>" %>
				<a href="<%= userService.createLoginURL(URL).toString() %>"><b>Login</b></a>
				<a href="<%= userService.createLogoutURL(URL).toString() %>"><b>Logout</b></a>
		</div>
		
		<div id="upload">
			<% if(username != "Guest")
 			   {%>	<%--This form uploads a blob, then sends a callback to the upload servlet --%>
					<form action="<%= blobstoreService.createUploadUrl("/upload") %>"method="post" enctype="multipart/form-data">
					<input type="file" accept="image/*" name="myFile">
					Private Image <input type="checkbox" name="Private" value="private"
									<%if(userService.isUserAdmin()) out.println("checked"); %>>
					&nbsp;&nbsp;&nbsp;
					<input type="submit" value="Upload"></form>
			 <%}%>
		</div>
		</div> <!-- end navbar div -->
		</br></br></br></br></br></br>
<!-- 		code below gets the database and loads its ImageStore table into a list -->
		<%
		  PersistenceManager pm = PMF.get().getPersistenceManager();  
		  Query query = pm.newQuery("select from " + ImageStore.class.getName());  
		  List<ImageStore> images = (List<ImageStore>) query.execute();
// 		  Query dbinf = pm.newQuery("select from " + DBInfo.class.getName());  
// 		  List<DBInfo> dbInfo = (List<DBInfo>) dbinf.execute();
// 		  System.out.println(images.size());
 		  %>
		  <%String iterator = null;
		  int it = 0;
		  try
			{
				iterator = request.getParameter("results");
			}
			catch(NullPointerException e)
			{
				iterator = String.valueOf(num);
			}
			finally
			{
				try
				{
					it = Integer.parseInt(iterator);
				}
				catch(NumberFormatException e)
				{
					it = num;
				}
			}
		  int count = 0;
		  boolean nextPage = true;
			%>
		  <div id="imgframe">
<%-- 		  <%for(ImageStore i : images)//this for loop iterates through all the stored images --%>
		  	<%for(count = it - num; count < it; count++)
		    {%>
		      <%if(userService.isUserLoggedIn() || !images.get(count).privateImg)
		        {%>
		<a href="<%= "/serve?blob-key=" + images.get(count).imgKey %>"><img id="img" src="<%= "/serve?blob-key=" + images.get(count).imgKey %>"/></a></br>
				  <% if(username != "Guest")
				  	 {
				  		 if(userService.isUserAdmin() ||  username.equals(images.get(count).user))
					     {%>
					     	<a href="<%=response.encodeURL("/delete?deleteKey=" + images.get(count).imgKey)%>">Delete</a></br>
					   <%}
					 }%>
				  Uploaded by: <%out.println("<b>" + images.get(count).user + "</b>"); %></br>
				  Date: <%SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy, hh:mm:ss");out.println(dateFormat.format(images.get(count).date)); %></br>
				  <%if(!images.get(count).privateImg)
					{
						out.println("<b>Public</b>");
					}
					else
					{
						out.println("<b>Private</b>");
					}%></br></br>
					<%if(count == images.size()-1)
					   {
						nextPage = false;
						break; 
					   }%>
				<%}%>
		   <%}//end for loop%>
		   </br>
		   <% if(nextPage){ %>
		   <a href="/browse.jsp?results=<%= it + num %>">Next Page</a>
		   <%} if(it > num){%>
		   <a href="/browse.jsp?results=<%= it - num %>">Previous Page</a>
		   <%} %>
		   </br></br></br>
		   </div>
</body>
</html>