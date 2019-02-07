package SpegniServer;
import java.io.IOException;


public class ShutdownServer {

	public static void shutdown() throws RuntimeException, IOException {
	    String shutdownCommand = "shutdown -h now";
	    Runtime.getRuntime().exec(shutdownCommand);
	    System.exit(0);
	    
	    
	    
	}

}
