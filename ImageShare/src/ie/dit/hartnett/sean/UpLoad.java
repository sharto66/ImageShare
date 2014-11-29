package ie.dit.hartnett.sean;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Map;

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
	
	public static ArrayList<ImageStore> images = new ArrayList<ImageStore>();

private static final
long serialVersionUID = 1L;
private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	@SuppressWarnings("deprecation")
	Map<String, BlobKey> blobs = blobstoreService.getUploadedBlobs(req);
	HttpSession session = req.getSession();
	session.setAttribute("images", blobs);
	UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    Date date = new Date();
	BlobKey blobKey = blobs.get("myFile");
	if (blobKey == null)
	{
		res.sendRedirect("/");
	}
	else
	{
		System.out.println("Uploaded a file with blobKey:"+blobKey.getKeyString());
		//res.sendRedirect("/serve?blob-key=" + blobKey.getKeyString());
		res.sendRedirect("/browse.jsp?blob-key=" + blobKey.getKeyString());
	}
}
}