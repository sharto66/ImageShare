package ie.dit.hartnett.sean;

import java.io.IOException;
import javax.servlet.http.*;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.blobstore.BlobstoreServicePb.BlobstoreService;


/**
 * @author Sean
 *This servlet has the simple function of serving up blobs to the client.
 *Usually as the src of a HTML img. eg. <img src="/serve?blob-key=43h44ugb4ugbakwq3d"/>
 */
public class Serve extends HttpServlet {
private com.google.appengine.api.blobstore.BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
public void doGet(HttpServletRequest req, HttpServletResponse res)
throws IOException {
		BlobKey blobKey = new BlobKey(req.getParameter("blob-key"));
		blobstoreService.serve(blobKey, res);
	}
}
