package com.orbitz.svg;

import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.orbitz.svg.model.SearchData;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	@RequestMapping(value = "/heatmap.do", method = RequestMethod.GET)
	public String heatmap(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		return "heatmap";
	}	
	/*
    @RequestMapping(value = "/getdata.do", produces = {"text/csv"})
    @ResponseStatus(HttpStatus.OK)
    public Model getData(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
    	response.setContentType("text/csv;charset=utf-8"); 
    	response.setHeader("Content-Disposition","attachment; filename=priceData.csv");
    	OutputStream resOs= response.getOutputStream();  
        OutputStream buffOs= new BufferedOutputStream(resOs);   
        OutputStreamWriter outputwriter = new OutputStreamWriter(buffOs);      	
        CsvWriter writer = new CsvWriter(outputwriter, '\u0009');  
        
        return model.addAttribute("persons", getSearchData());
    }	*/
    
    private List<SearchData> getSearchData(){
    	
    	List<SearchData> sd = new ArrayList<SearchData>();
    	sd.add(new SearchData("2013-01-01","90.8"));
    	sd.add(new SearchData("2013-02-01","120.8"));
    	sd.add(new SearchData("2013-03-01","160.8"));
    	sd.add(new SearchData("2013-04-01","55.8"));
    	sd.add(new SearchData("2013-05-01","100.3"));
    	sd.add(new SearchData("2013-06-01","93.5"));
    	sd.add(new SearchData("2013-07-01","90.8"));
    	
    	return sd;
    }
	
}
