package ie.dit.hartnett.sean;

import java.util.Date;

public class ImageStore
{
	String user;
	Date date;
	String key;
	
	public ImageStore()
	{
		this.user = "";
		this.date = new Date();
		this.key = "";
	}
	
	public ImageStore(String user, Date date, String key)
	{
		this.user = user;
		this.date = date;
		this.key = key;
	}
}
