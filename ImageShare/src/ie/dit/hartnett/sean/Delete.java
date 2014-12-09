package ie.dit.hartnett.sean;

import java.io.IOException;
import javax.jdo.PersistenceManager;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.jdo.Query;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
//import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

/**
 * @author Sean
 *This servlet deletes blobs from the blobstore and deletes entries from
 *the datastore. It reads in the blobkey as a parameter from the URL and
 *calls blobstoreService delete method using the blobkey as a parameter.
 *The PersistnaceManager is used to query the datastore to get all entries
 *where imgKey equals the blobkey parameter read in, and then deletes it.
 *User must be logged in to be able to access delete servlet
 */
public class Delete extends HttpServlet
{
	private static final long serialVersionUID = 1L;
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		UserService userService = UserServiceFactory.getUserService();
		if(userService.isUserLoggedIn())
		{
			BlobKey blobKey = new BlobKey(req.getParameter("deleteKey"));
			System.out.println("before method call");
			blobstoreService.delete(blobKey);
			PersistenceManager pm = PMF.get().getPersistenceManager();  
			Query query = pm.newQuery("select from " + ImageStore.class.getName());
			query.setFilter("imgKey == '" + (String)req.getParameter("deleteKey") + "'");
			query.deletePersistentAll();
			res.sendRedirect("/");
		}
	}
}
