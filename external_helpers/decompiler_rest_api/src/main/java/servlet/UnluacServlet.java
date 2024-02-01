package servlet;

import org.apache.commons.compress.utils.FileNameUtils;
import org.apache.tomcat.util.http.fileupload.FileUploadException;
import org.apache.tomcat.util.http.fileupload.disk.DiskFileItemFactory;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URISyntaxException;
import java.util.List;
import java.util.concurrent.TimeUnit;

import java.util.logging.Logger;
import java.util.stream.Collectors;
import java.util.logging.Level;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

/**
 * Servlet implementation class UnluacServlet
 */
@WebServlet("")
@MultipartConfig(maxFileSize = 2500000)
public class UnluacServlet extends HttpServlet {

	private static final long serialVersionUID = -259811092051390105L;
	
	// From 'https://github.com/HansWessels/unluac'
	private String unluacJarPath;
	private static final String SCRIPTTEMPLATE = "java -jar %s %s > %s";
	
	private final String os = System.getProperty("os.name").toLowerCase();
	private final boolean isWindows = os.contains("windows");
		
	private final transient Logger logger = Logger.getLogger("GCW_UnluacServlet");
	
	public UnluacServlet() {
		super();
	}
	
	/**
	 * @throws IOException 
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
		logger.setLevel(Level.ALL);
		
		try {
			// Set paths
			final String servletCtxPath = this.getServletContext().getRealPath("");
			final String uploadPath = servletCtxPath + "Uploads" + File.separator;
			final String outputPath = servletCtxPath + "Output" + File.separator;
			
			unluacJarPath = getUnluacJarPath(res);
							
			DiskFileItemFactory factory = new DiskFileItemFactory();
			// Write all to disk
			factory.setSizeThreshold(0);
			// Write to temp directory
			factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
			
			// Parse request
			List<Part> parts = getFileParts(req, res);
			
			// Should only be one file, so only consider first in list
			Part part = parts.get(0);
			
			// Check if upload directory exists
			checkForDir(uploadPath);
			
			// Set fileName
			String uploadFileName = String.valueOf(System.currentTimeMillis()) + ".luac";
			String uploadFilePath = uploadPath.concat(uploadFileName);
			File uploadedFile = new File(uploadFilePath);
						
			// Save .luac file
			writeFile(part, uploadFilePath, res);
			
			// Decompile .luac and send response
			handleFile(uploadedFile, outputPath, res);
				
		} catch (IOException e) {
			logger.severe("IOException 'detail_response':: " + e);
			throw new IOException("wherigo_http_code_500_detail_response");
		} catch (AbortControlFlowException e) {
			logger.info("Control flow was aborted");
		}
	}

	/**
	 * Checks if directory exists and creates it if necessary
	 * @param path
	 */
	private void checkForDir(final String path) {
		File dir = new File(path);
		if (!dir.exists()) dir.mkdir();
	}
	
	/**
	 * Return path to 'unluac.jar' resource
	 * @param res
	 * @return path
	 * @throws IOException
	 */
	private String getUnluacJarPath(HttpServletResponse res) throws IOException {
		try {
			return getClass().getClassLoader().getResource("unluac.jar").toURI().getPath().substring(1);
		} catch (URISyntaxException e) {
			logger.severe("URISyntaxException:: " + e.getMessage());
			buildErrorResponse("wherigo_http_code_500_detail_access", 500, res);
			throw new AbortControlFlowException();
		}
	}
	
	/**
	 * Parse the request and return a list of contained files
	 * @param upload
	 * @param req
	 * @param res
	 * @return a list of files from the request
	 * @throws IOException
	 */
	private List<Part> getFileParts(HttpServletRequest req, HttpServletResponse res) throws IOException {
		try {
			return req.getParts().stream().collect(Collectors.toList());
		} catch (IllegalStateException e) {
			logger.severe("SizeLimitExceededException::" + e.getMessage());
			buildErrorResponse("wherigo_http_code_413_detail_size", 413, res);
			throw new AbortControlFlowException();
		} catch (FileUploadException e) {
			logger.severe("FileUploadException::" + e.getMessage());
			buildErrorResponse("wherigo_http_code_400_detail_extract", 400, res);
			throw new AbortControlFlowException();
		} catch (ServletException e) {
			logger.severe("Not a multipart request");
			buildErrorResponse("wherigo_http_code_400_detail_multipart", 400, res);
			throw new AbortControlFlowException();
		}
	}
	
	/**
	 * Write file to disk
	 * @param item
	 * @param target
	 * @param res
	 * @throws IOException
	 */
	private void writeFile(Part item, String target, HttpServletResponse res) throws IOException {
		try {
			item.write(target);
		} catch (Exception e) {
			logger.severe("Exception:: " + e.getMessage() + "\nCould not write LUA Bytecode to disk");
			buildErrorResponse("wherigo_http_code_500_detail_write", 500, res);
			throw new AbortControlFlowException();
		}
	}
	
	/**
	 * Decompiles the .luac file and sends the result back
	 * @param uploadedFile
	 * @param outputPath
	 * @param res
	 * @throws IOException
	 */
	private void handleFile(File uploadedFile, String outputPath, HttpServletResponse res) throws IOException {
		File result = null;
		BufferedReader reader = null;
		try {
			final String fileName = FileNameUtils.getBaseName(uploadedFile.getName());
			
			// Check if output directory exists
			checkForDir(outputPath);

			// Generate output file path
			final String resultPath = outputPath + fileName + ".txt";
			
			// Try to execute unluac.jar with received file
			executeScript(uploadedFile, resultPath, res);
								
			result = new File(resultPath);
			reader = new BufferedReader(new FileReader(result));
			PrintWriter w = res.getWriter();
			String line = reader.readLine();
			
			// Check if result file is empty
			if (line == null) {
				logger.severe("LUA Sourcecode is empty");
				buildErrorResponse("wherigo_http_code_500_detail_empty", 500, res);
				return;
			}
			
			// Write result file content to response body
			while (line != null) {
				w.append(line + "\n");
				line = reader.readLine();
			}		

			//Send response
			res.setStatus(200);
			res.setContentType("text/plain");
			res.flushBuffer();
		} finally {
			// Cleanup
			reader.close();
			if (result != null) {
				result.delete();
			}
			uploadedFile.delete();
		}
	}
	
	/**
	 * Builds and sends error response body
	 * @param message - to be sent back to client
	 * @param status - http status code
	 * @throws IOException 
	 */
	private static void buildErrorResponse(String message, int status, HttpServletResponse res) throws IOException {
		PrintWriter w = res.getWriter();
		w.append(message + "\n");
		res.setStatus(status);
		res.flushBuffer();
	}
	
	/**
	 * Executes unluac.jar to decompile a .luac file and save it to disk
	 * 
	 * @param file - .luac file
	 * @throws IOException
	 * @throws InterruptedException
	 */
	private void executeScript(File file, String resultPath, HttpServletResponse res) throws IOException {		
		try {
			// Create process to execute script
			ProcessBuilder pb = new ProcessBuilder();
					
			final String script = String.format(SCRIPTTEMPLATE,
					"\"" + unluacJarPath +"\"", "\"" + file.getAbsolutePath() + "\"", "\"" + resultPath + "\"");
			
			if (isWindows) {
				pb.command("cmd.exe", "/c", script);
			} else {
				pb.command("/bin/bash", "-c", script);
			}
			Process p = pb.start();
			p.waitFor(120, TimeUnit.SECONDS);
			p.destroy();
		} catch (IOException e) {
			logger.severe("IOException:: " + e.getMessage());
			buildErrorResponse("wherigo_http_code_500_detail_process", 500, res);
			throw new AbortControlFlowException();
		} catch (InterruptedException e) {
			logger.severe("InterruptedException:: " + e.getMessage());
			buildErrorResponse("wherigo_http_code_500_detail_interrupt", 500, res);
			Thread.currentThread().interrupt();
			throw new AbortControlFlowException();
		}
	}
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
		logger.setLevel(Level.ALL);
		try {
			res.sendRedirect("https://gcwizard.net/#/");
		} catch (IOException e) {
			logger.severe("IOException:: " + e.getMessage());
			buildErrorResponse("Could not redirect to 'https://gcwizard.net/#/", 500, res);
		}
	}
	
	@Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse res) throws IOException {
		doGet(req, res);
	}
	
	@Override
	protected void doPut(HttpServletRequest req, HttpServletResponse res) throws IOException {
		doGet(req, res);
	}
	
	@Override
	protected void doHead(HttpServletRequest req, HttpServletResponse res) throws IOException {
		doGet(req, res);
	}
	
	@Override
	protected void doOptions(HttpServletRequest req, HttpServletResponse res) throws IOException {
		doGet(req, res);
	}
	
	@Override
	protected void doTrace(HttpServletRequest req, HttpServletResponse res) throws IOException {
		doGet(req, res);
	}
	
	private class AbortControlFlowException extends RuntimeException {
		private static final long serialVersionUID = -8630126674490936951L;

		public AbortControlFlowException() {
			super();
		}
	}
}
