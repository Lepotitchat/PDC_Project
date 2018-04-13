/*
 * generated by Xtext 2.12.0
 */
package org.xtext.example.mydsl.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import ecoreModelProject.Restaurant
import ecoreModelProject.Specification
import ecoreModelProject.Search

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MyDslGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		fsa.generateFile('EmbededJettyMain.java', '''
		package com.javacodegeeks.snippets.enterprise.embedded_jetty_example;
		
		import org.eclipse.jetty.server.Server;
		import org.eclipse.jetty.servlet.ServletContextHandler;
		import com.javacodegeeks.snippets.enterprise.embeddedjetty.servlet.ExampleServlet;
		
		public class EmbeddedJettyMain {
			public static void main(String[] args) throws Exception {
				Server server = new Server(7071);
				ServletContextHandler handler = new ServletContextHandler(server, "/example");
				handler.addServlet(ExampleServlet.class, "/");
				server.start();
			}
		}
		''')
		
		fsa.generateFile('pom.xml', '''
		<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
			xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
			<modelVersion>4.0.0</modelVersion>
		
			<groupId>com.javacodegeeks.snippets.enterprise</groupId>
			<artifactId>embedded-jetty-example</artifactId>
			<version>0.0.1-SNAPSHOT</version>
			<packaging>jar</packaging>
		
			<name>embedded-jetty-example</name>
			<url>http://maven.apache.org</url>
		
			<properties>
				<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
			</properties>
		
			<dependencies>
				<!--Jetty dependencies start here -->
				<dependency>
					<groupId>org.eclipse.jetty</groupId>
					<artifactId>jetty-server</artifactId>
					<version>9.2.11.v20150529</version>
				</dependency>
				<dependency>
					<groupId>org.eclipse.jetty</groupId>
					<artifactId>jetty-servlet</artifactId>
					<version>9.2.11.v20150529</version>
				</dependency>
				<!--Jetty dependencies end here -->
				<!--Json dependencies end here -->
				<dependency>
		            <groupId>com.googlecode.json-simple</groupId>
		            <artifactId>json-simple</artifactId>
		            <version>1.1.1</version>
		        </dependency>
		
			</dependencies>
		</project>

		''')
		
		fsa.generateFile('ExampleServlet.java', '''
		package com.javacodegeeks.snippets.enterprise.embeddedjetty.servlet;
		
		import java.io.IOException;
		import java.io.InputStream;
		import java.net.URL;
		import java.net.URLConnection;
		import java.net.URLEncoder;
		import java.util.ArrayList;
		import java.util.Scanner;
		
		import javax.servlet.ServletException;
		import javax.servlet.http.HttpServlet;
		import javax.servlet.http.HttpServletRequest;
		import javax.servlet.http.HttpServletResponse;
		
		import org.eclipse.jetty.http.HttpStatus;
		import org.json.simple.JSONArray;
		import org.json.simple.JSONObject;
		import org.json.simple.parser.JSONParser;
		import org.json.simple.parser.ParseException;
		
		public class ExempleServlet extends HttpServlet {
			JSONArray quartiers;
			ArrayList<String> locations;
			@Override
			protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
				// creer array json contenant des objets json representant les quartier 
				quartiers = new JSONArray();
				locations = new ArrayList<>();
				locations.add("43.602374,1.441593");
				locations.add("43.596903,1.448801");
				locations.add("43.597738,1.435150");
				locations.add("43.619868,1.433661");
				locations.add("43.610050,1.449912");
				locations.add("43.619700,1.455617");
				locations.add("43.626131,1.469313");
				locations.add("43.593949,1.469960");
				locations.add("43.570059,1.494183");
				locations.add("43.581951,1.449018");
				locations.add("43.579400,1.423856");
				locations.add("43.557700,1.380513");
				locations.add("43.646058,1.411502");
				locations.add("43.640628,1.458539");
				locations.add("43.641988,1.457152");
				locations.add("43.582633,1.410490");
				locations.add("43.577931,1.401934");
		
				//
				
				restaurantRequest();
		
				resp.setStatus(HttpStatus.OK_200);
				resp.getWriter().println(quartiers);
			}
			
			public void restaurantRequest() throws IOException {
				String url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
				String charset = java.nio.charset.StandardCharsets.UTF_8.name();
				String radius = "1000";
				String types = "restaurant";
				String name = "Toulouse";
				String key = "AIzaSyAdSiwtDnpum6aPNFZH7APTTYn-8WAalzA";
				// ...
				for (String location : locations) {
					String query = String.format("location=%s&radius=%s&types=%s&name=%s&key=%s", location,
							URLEncoder.encode(radius, charset), URLEncoder.encode(types, charset),
							URLEncoder.encode(name, charset), URLEncoder.encode(key, charset));
					URLConnection connection = new URL(url + "?" + query).openConnection();
					connection.setRequestProperty("Accept-Charset", charset);
					InputStream response = connection.getInputStream();
					// Recupere la note de chaque resto et la compare avec la note voulue
					try (Scanner scanner = new Scanner(response)) {
						String responseBody = scanner.useDelimiter("\\A").next();
						JSONParser parser = new JSONParser();
						try {
							JSONObject reponse = (JSONObject) parser.parse(responseBody);
							JSONArray results = (JSONArray) reponse.get("results");
							//resp.getWriter().println("BWAYAYAYAYA");
							float wanted = (float) �(resource.contents.get(0) as Search).specifications.get(0).arguments�;
							int numberOk = 0;
							for (int k = 0; k < results.size(); k++) {
								JSONObject resto = (JSONObject) results.get(k);
								float note =  Float.parseFloat(resto.get("rating").toString());
								if(note >= wanted) {
									numberOk++;
								}
							}
							JSONObject quartier = new JSONObject();
							quartier.put("numberRestaurant", numberOk);
							quartiers.add(quartier);
							//resp.getWriter().println(quartier);
						} catch (ParseException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}
			}
		}


		''')
	
	fsa.generateFile('Serveur.java', '''
		
		public class Serveur{
			static public void main(String args[]){
				
			}
			
			public void run(){
���				�FOR s : (resource.contents.get(0) as Search).specifications
���					switch s.type{
���						case spec.isType("Restaurant") : "methode restaurant"
���						default : ""
���					}
���				�
���				
���				�ENDFOR�
			}
			
			
		}
		
	''')
		resource.contents.get(0)
//			resource.allContents
//				.filter(Greeting)
//				.map[name]
//				.join(', '))
	}
}
