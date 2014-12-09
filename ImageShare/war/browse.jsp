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
				Logged in as <%= "<b>" + username + "</b>" %>&nbsp;&nbsp;
				<a id="links" href="<%= userService.createLoginURL(URL).toString() %>"><b>&nbsp;Login&nbsp;</b></a>&nbsp;&nbsp;
				<a id="links" href="<%= userService.createLogoutURL(URL).toString() %>"><b>&nbsp;Logout&nbsp;</b></a>
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
		</br></br></br></br></br></br></br></br>
<!-- 		code below gets the database and loads its ImageStore table into a list -->
		<%
		  PersistenceManager pm = PMF.get().getPersistenceManager();  
		  Query query = pm.newQuery("select from " + ImageStore.class.getName());  
		  List<ImageStore> images = (List<ImageStore>) query.execute();
		  //the datastore holds all the uploaded blobkeys as Strings and the above puts them in a list
 		  %>
		  <%String iterator = null;
		  int it = 0;//code below gets value of results parameter from URL, including error checking
		  try//the value from the results parameter is used to go to display 5 images per page and then a link to the next 5
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
<%-- 		  <%for(ImageStore i : images)//this for loop iterates through the stored images --%>
		  	<%for(count = it - num; count < it; count++)
		    {%>
		      <%if(userService.isUserLoggedIn() || !images.get(count).privateImg)
		        {//above if statement is to stop private images been shown to Guests %>
		<a href="<%= "/serve?blob-key=" + images.get(count).imgKey %>"><img id="img" src="<%= "/serve?blob-key=" + images.get(count).imgKey %>"/></a></br>
				  <% if(username != "Guest")
				  	 {
				  		 if(userService.isUserAdmin() ||  username.equals(images.get(count).user))
					     {//the delete button only shows up if user owns the image or is an admin%>
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
				<%}
				  /* else it++; */%><!-- if picture is private this increases result set so 5 images per page will be shown to guests -->
		   <%}//end for loop%>
		   </br>
		   <% if(nextPage){ //the links below add or subtract the num(results per page) to see the next set of desired results%>
		   <a id="links" href="/browse.jsp?results=<%= it + num %>">&nbsp;<b>Next Page</b>&nbsp;</a>
		   <%} if(it > num /* && it - num > 0 */){//The previous button shows up on the first page of results for guest if this preceding comment is left in, but correct num of results are diaplayed per page%>
		   <a id="links" href="/browse.jsp?results=<%= it - num %>">&nbsp;<b>Previous Page</b>&nbsp;</a>
		   <%} %>
		   </br></br></br>
		   </div>
</body>
</html>