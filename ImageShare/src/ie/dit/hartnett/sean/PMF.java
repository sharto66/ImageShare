package ie.dit.hartnett.sean;

import javax.jdo.JDOHelper;  
import javax.jdo.PersistenceManagerFactory;  



/**
 * @author Sean
 *	This class has been taken from: http://jeftechjava.blogspot.ie/2011/05/how-to-create-listview-in-android.html
 */
public final class PMF   
{  
    private static final PersistenceManagerFactory pmfInstance =  
        JDOHelper.getPersistenceManagerFactory("transactions-optional");  
  
    private PMF() {}  
  
    public static PersistenceManagerFactory get()   
    {  
        return pmfInstance;  
    }  
}  
