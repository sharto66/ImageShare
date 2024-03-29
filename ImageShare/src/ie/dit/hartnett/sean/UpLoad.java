package ie.dit.hartnett.sean;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Map;

import javax.jdo.PersistenceManager;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

/**
 * @author Sean
 * This servlet is sent a call back when a blob is uploaded.
 * It gets the blob key as a string and puts its in a DataSore
 * along with other information like the current date and the 
 * username of the uploader. It also reads in a parameter "Private"
 * which is a checkbox on the upload form. It uses try catch blocks
 * to see if theis parameter is present. If it is, a boolean "privateImg"
 * is put as true in the datastore, othrewise it is false. A user must
 * be logged in to use the UpLoad servlet 
 *
 */
public class UpLoad extends HttpServlet {

private static final
long serialVersionUID = 1L;
private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	UserService userService = UserServiceFactory.getUserService();
	if(userService.isUserLoggedIn())
	{
		@SuppressWarnings("deprecation")
		Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(req);
	    User user = userService.getCurrentUser();
	    Date date = new Date();
	    boolean privateImg = false;
		BlobKey blobKey = blobs.get("myFile");
		if (blobKey == null)
		{
			res.sendRedirect("/");
		}
		else
		{
			String pri = null;
			try
			{
				pri = req.getParameter("Private");
			}
			catch(NullPointerException e)
			{
				pri = "not";
			}
			System.out.println("Image = " + pri);
			if(pri==String.valueOf("private"))
			{
				privateImg = true;
				System.out.println("Private");
			}
			System.out.println("Before Persist");
			PersistenceManager persist = PMF.get().getPersistenceManager();
			ImageStore img = new ImageStore(user.getEmail().toString(), date, blobKey.getKeyString(), privateImg);
			try
			{
				persist.makePersistent(img);
			}  
		    finally
		    {
		    	persist.close();
		    }  
			System.out.println("Uploaded a file with blobKey:"+blobKey.getKeyString());
			res.sendRedirect("/");
		}
	}
	else
	{
		res.sendRedirect("/");
	}
}
}