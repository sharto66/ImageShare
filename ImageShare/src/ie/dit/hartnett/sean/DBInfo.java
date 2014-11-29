package ie.dit.hartnett.sean;

import java.util.Date;  

import javax.jdo.annotations.IdGeneratorStrategy;  
import javax.jdo.annotations.PersistenceCapable;  
import javax.jdo.annotations.Persistent;  
import javax.jdo.annotations.PrimaryKey;  
  
import com.google.appengine.api.datastore.Key;  
  
@PersistenceCapable  
public class DBInfo  
{  
    @PrimaryKey  
    @Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)  
    private Key key;  
    @Persistent  
    private long version;  
    @Persistent  
    private String blobKey;  
      
 public DBInfo()  
    {  
     Date date = new Date();  
     this.version = date.getTime();  
     this.blobKey = "";  
    }  
 public Key getKey()  
 {  
  return this.key;  
 }  
    public void setVersion()  
    {  
     this.version = new Date().getTime();  
    }  
    public void setXMLBlob(String newBlobKey)  
    {  
     this.blobKey = newBlobKey;  
    }  
    public String getXMLBlob()  
    {  
     return this.blobKey;  
    }  
    public long getVersion()  
    {  
     return this.version;  
    }  
    public String toString()  
    {  
     return String.valueOf(version);  
    }  
}  
