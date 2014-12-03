package ie.dit.hartnett.sean;

import java.util.Date;  

import javax.jdo.annotations.IdGeneratorStrategy;  
import javax.jdo.annotations.PersistenceCapable;  
import javax.jdo.annotations.Persistent;  
import javax.jdo.annotations.PrimaryKey;  
  
import com.google.appengine.api.datastore.Key;  

@PersistenceCapable  
public class ImageStore
{
	@PrimaryKey  
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)  
    private Key key;
	@Persistent
	public String user;
	@Persistent
	public Date date;
	@Persistent
	public String imgKey;
	@Persistent
	public boolean privateImg;
	
	public ImageStore()
	{
		this.user = "";
		this.date = new Date();
		this.imgKey = "";
		this.privateImg = false;
	}
	
	public ImageStore(String user, Date date, String imgKey, boolean privateImg)
	{
		this.user = user;
		this.date = date;
		this.imgKey = imgKey;
		this.privateImg = privateImg;
	}
}
