package ie.dit.hartnett.sean;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

import java.io.IOException;
import java.util.Date;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class Store extends HttpServlet {
	  @Override
	  public void doGet(HttpServletRequest req, HttpServletResponse resp)
	      throws IOException {
	    UserService userService = UserServiceFactory.getUserService();
	    User user = userService.getCurrentUser();

	    String blobKey = req.getParameter("blob-key");
	    Key ImageKey = KeyFactory.createKey("ImageKey", blobKey);
	    Date date = new Date();
	    Entity image = new Entity("Image", ImageKey);
	    image.setProperty("user", user);
	    image.setProperty("date", date);
	    image.setProperty("content", blobKey);

	    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	    datastore.put(image);

	    resp.sendRedirect("/browse.jsp?blobKey=" + blobKey);
	  }
}
