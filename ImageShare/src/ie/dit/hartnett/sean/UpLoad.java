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

public class UpLoad extends HttpServlet {

private static final
long serialVersionUID = 1L;
private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	@SuppressWarnings("deprecation")
	Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(req);
	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    Date date = new Date();
    boolean privateImg;
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
		else
		{
			privateImg = false;
			System.out.println("Not Private");
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
		//res.sendRedirect("/serve?blob-key=" + blobKey.getKeyString());
		res.sendRedirect("/");
	}
}
}