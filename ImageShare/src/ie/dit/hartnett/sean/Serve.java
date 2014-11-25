package ie.dit.hartnett.sean;

import java.io.IOException;
import javax.servlet.http.*;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.blobstore.BlobstoreServicePb.BlobstoreService;

public class Serve extends HttpServlet {
private com.google.appengine.api.blobstore.BlobstoreService blobstoreService =BlobstoreServiceFactory.getBlobstoreService();
public void doGet(HttpServletRequest req, HttpServletResponse res)
throws IOException {
		BlobKey blobKey = new BlobKey(req.getParameter("blob-key"));
		blobstoreService.serve(blobKey, res);
	}
}
