<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory" %>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService" %>
<%BlobstoreService blobstoreService =BlobstoreServiceFactory.getBlobstoreService();%>
<html>
<head>
<title>Upload Test</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>
	<form action="<%= blobstoreService.createUploadUrl("/upload") %>"method="post" enctype="multipart/form-data">
		<input type="file" accept="image/*" name="myFile">
		<input type="submit" value="Submit">
	</form>
</body>
</html>